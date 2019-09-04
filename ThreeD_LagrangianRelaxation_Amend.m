function  [OptSolu,TIME]=ThreeD_LagrangianRelaxation_Amend(CoeMat,MaxIter)
%Input & Output
%CoeMat:original 3D matrix
%MaxIter:maxmum itertions
%H_fina:Up bound-feasible solution
%L_fina:Bottom bound-relax solution
%OptSolu:optimal solution
%iter:maxmum itertions for problem

% str=['开始运行LR算法...']

tic
M=CoeMat;
[i1,i2,i3]=size(M);

DualMat=zeros(i1,i2);%dual mat
u=zeros(1,1,i3);%lag Multiplier


H_fina=inf;
L_fina=0;

DualVec=zeros(3,i1);
FinaVec=zeros(3,i1);

L_init1=zeros(1,MaxIter);
H_init1=zeros(1,MaxIter);
Gap_init=zeros(1,MaxIter);

DualVec(1,:)=1:i1; %VLC序号
FinaVec(1,:)=1:i1;
count=0;
B=2;
H=ones(i3,i3);
for l=1:MaxIter
    
    %% 降维
    for i=1:i1
        for j=1:i2
            DualMat(i,j)=min(M(i,j,:)-u(1,1,:));
        end
    end
    %     DualMat=DualMat+;
    %         DualMat
    %
    %% 求松弛解
    [DualVec(2,:),~]=HungarianforLR(DualMat);
    %     L=L+sum(u)
    
    
    %     [DualVec(2,:), ~] = ...
    %     assignmentProblemAuctionAlgorithm(DualMat, 0.4, 0.3)
    
    FinaVec(2,:)=DualVec(2,:);
    
    %     L=L+sum(u);
    
    %% 建立可行解矩阵
    FeasMatrix=zeros(i1,i3);
    for i=1:i1
        for j=1:i3
            FeasMatrix(i,j)=M(DualVec(1,i),DualVec(2,i),j);
        end
    end
    %     FeasMatrix
    %% 可行解
    [FinaVec(3,:),H]=HungarianforLR(FeasMatrix);
    
    
    %% 统计i3的重复次数
    g=zeros(1,1,i3);
    for i=1:i3
        k=find(FeasMatrix(i,:)==min(FeasMatrix(i,:)))
        
        DualVec(3,i)=k(1);
        for j=1:i1
            n=find(FeasMatrix(j,:)==min(FeasMatrix(j,:)));
            if i==n(1)%find(DualAssiMat(i,:)==min(DualAssiMat(i,:)));
                g(1,1,i)=g(1,1,i)+1;
            end
        end
    end
    
    g=1-g; %次梯度
    
    %% 原矩阵计算对偶解
    L=0;
    for i=1:i3
        L=L+CoeMat(DualVec(1,i),DualVec(2,i),DualVec(3,i));
    end
    
    
    
    %% 解的更新  max(L_fina,);
    H_fina=min(H_fina,H);
    
    if  L>L_fina  %对偶解上升
        count=0;
        %          Btnew=Bt;
    else
        count=count+1;
        
        if count>10
            
            B=  max(B/2,1);
            count=0;
        end
    end
 
    L_fina=max(L,L_fina);

    Gap=H_fina-L_fina;
    
    H_init1(1,l)=H_fina;
    L_init1(1,l)=L_fina;
    Gap_init(1,l)=Gap;
    
    
    Gap1=Gap/L_fina
    
    DualVec
    
    %     G=There2one(g)
    G=zeros(1,size(g,3));
    for i=1:size(g,3)
        G(1,i)=g(1,1,i);
    end
    G
    
    a=0.2;b=1.2;
    Qa=(1+(l/(B^b)))*L_fina
    P=H*G
    
    if l>i3
        H=ones(i3,i3)
    else
        H=H+(1-(a^(-2)))*(P*P')./(G'*P)
    end
    Increa=((a+1)/a)*((Qa-H_fina)/sum(g.^2))*P
    
    V=zeros(1,1,i3);
    for xc=1:i3
        V(1,1,xc)=Increa(1,xc);
    end
    u=u+0.00001*V
    
    
    %     u=u+((a+1)/a)*((Qa-H_fina)/sum(g.^2))*P
    
    
    %% 乘子更新
    %     LearningRate=0.5
    %     Theada=(Gap/(sum(g.^2)))*Btnew;
    %     u=max((u+Theada*g), 0);
    
    
    %     LearningRate*((H_fina-L_fina)/(sum(g.^2)))*g;
    %     U=There2one(u)
    
    %============================================================================================================================================
    
    %% 结束条件
    if (sqrt(sum(g.^2)))<1 || Gap1<0.01
        break;
    end
    
%     LRM_Infor=['H=',num2str(H),', L=',num2str(L),'， 更新后，H_fina=',num2str(H_fina),...
%         ', L_fina=',num2str(L_fina),', Gap=',num2str(Gap),]
    
end

OptSolu=H_fina;
len=l;
TIME=toc;

figure
plot(1:len,H_init1(1,1:len),'-ro','linewidth',1.5,'MarkerSize',10)
hold on
plot(1:len,L_init1(1,1:len),'-v','linewidth',1.5,'MarkerSize',10)
hold on
plot(1:len,Gap_init(1,1:len),'-k*','linewidth',1.5,'MarkerSize',10)
legend('FeasiSolu','DualSolu','Gap',0); %4,Lower right corner
title('The curve of the system SumRate under the different SINR threshold mode');
xlabel('Iterations');
ylabel('Solution');
fprintf(1,'=============================================================================');


