function  [LRMatching,LRrate,LRTIME]=ThreeD_LagrangianRelaxation_Amend2(CoeMat1)
%Input & Output
%CoeMat:original 3D matrix
%MaxIter:maxmum itertions
%H_fina:Up bound-feasible solution
%L_fina:Bottom bound-relax solution
%OptSolu:optimal solution
%iter:maxmum itertions for problem
t0=cputime;
maxV = max(max(max(CoeMat1)));%转化为最小优化
minV = min(min(min(CoeMat1)));%转化为最小优化

CoeMat=maxV-CoeMat1;

M=CoeMat;
[i1,i2,i3]=size(M);

%前进步长，关键因素
InitLearingRate=0.001*(maxV-minV)/(maxV*5);

LearingRate=0.001*(maxV-minV)/(maxV*5);
% % % LearingRate=0.000003732248;
% LearingRate=0.0000036315224812454;
% load LearingRate.mat LearingRate

MaxIter=20*i1^2;


A=zeros(i1,i2);%dual mat
u=zeros(1,1,i3);%lag Multiplier
LRrate=inf;
LRbound=-inf;
DualMatching=zeros(i1,3);
FinaMatching=zeros(i1,3);
L_init1=zeros(1,MaxIter);
H_init1=zeros(1,MaxIter);
Gap_init=zeros(1,MaxIter);

iter=0;
FailCount=0;
BreakCount=0;
Gap=100;



while (BreakCount<MaxIter)&&Gap>0.0005
    iter=iter+1;
    %     LearingRate
    %% 降为2D 求松弛解
    for i=1:i1
        for j=1:i2
            A(i,j)=min(M(i,j,:));
        end
    end
    
    [DualMat,L]=Hungarian(A);
    L=L+sum(u);
    %D2D-CU 最佳匹配
    for i=1:i1
        DualMatching(i,1)=i; %D2D
        FinaMatching(i,1)=i;
        DualMatching(i,2)=find(DualMat(i,:)==1);%CU
        FinaMatching(i,2)=find(DualMat(i,:)==1);
    end
    
    %% 统计i3的重复次数
    B=zeros(i1,i3);
    for i=1:i1
        for j=1:i3
            B(i,j)=M(DualMatching(i,1),DualMatching(i,2),j);
        end
    end
    g=ones(1,1,i3);
    for i=1:i3
        k=find(B(i,:)==min(B(i,:)));
        DualMatching(i,3)=k(1);
        for j=1:i1
            n=find(B(j,:)==min(B(j,:)));
            if i==n(1)%find(DualAssiMat(i,:)==min(DualAssiMat(i,:)));
                g(1,1,i)=g(1,1,i)-1;
            end
        end
    end
    
    %% 建立可行解矩阵，可行解
    C=zeros(i1,i3);
    for i=1:i1
        for j=1:i3
            C(i,j)=CoeMat(DualMatching(i,1),DualMatching(i,2),j);
        end
    end
    [FeaMat,H]=Hungarian(C);
    for i=1:i1
        FinaMatching(i,3)=find(FeaMat(i,:)==1);
    end
    
    %% 学习率适应器
    maxV1 = max(max(max(M)));%转化为最小优化
    minV1 = min(min(min(M)));%转化为最小优化
    if H< LRrate%解有降下来
        BestU=u;
        BestM=M;
        LRMatching=FinaMatching;
        LearingRate=LearingRate+0.000000005*(maxV1-minV1)/(maxV1*2);
        FailCount=0;
        BreakCount=0;
    else
        FailCount=FailCount+1;
        if FailCount>20 %当可行解没有下降，有可能过调节，调低学习率
            LearingRate=LearingRate+0.0000001*i3*(((BreakCount+5)/1000))*(maxV1-minV1)/(maxV1*2);
            FailCount=0;
            if FailCount>30
                u=BestU;
                M=BestM;
                maxV1 = max(max(max(M)));%转化为最小优化
                minV1 = min(min(min(M)));%转化为最小优化
                LearingRate=InitLearingRate+0.000000005*(maxV1-minV1)/(maxV1*2);
                
%                 BreakCount=BreakCount+1
            end
        end
                BreakCount=BreakCount+1;
    end
    %% 保留最优解
    LRrate=min(LRrate,H);
    LRbound=max(LRbound,L);
    
    Gap=(LRrate-LRbound)/LRbound;
    
    H_init1(1,iter)=LRrate;
    L_init1(1,iter)=LRbound;
    Gap_init(1,iter)=Gap;
    
    
    %% 乘子更新
    u=u+LearingRate*((LRrate-LRbound)/(sum(g.^2)))*g;
    
    %         u=u+max(LearingRate*((LRrate-LRbound)/(sum(g.^2)))*g,0);
    
    
    %% 惩罚矩阵更新
    for i=1:i3
        M(DualMatching(i,1),DualMatching(i,2),DualMatching(i,3))...
            =M(DualMatching(i,1),DualMatching(i,2),DualMatching(i,3))...
            -u(1,1,DualMatching(i,3));
    end
    
    
end
LRTIME=cputime-t0;
LRrate=i1*maxV-LRrate;

H_init1=i1*maxV-H_init1;
L_init1=i1*maxV-L_init1;
% % len=iter;
% % figure
% % plot(1:len,L_init1(1,1:len),'-ro','linewidth',1.5,'MarkerSize',10)
% % hold on
% % plot(1:len,H_init1(1,1:len),'-v','linewidth',1.5,'MarkerSize',10)
% % hold on
% % legend('q_{fea}','q_{dua}',0); %4,Lower right corner
% % xlabel('The number of iterations');
% % ylabel('Sum-rate of V2V links (nat/s)');

