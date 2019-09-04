function  [H_fina,L_fina,OptSolu,iter,PariSolu,TIME]=LagrangianRelaxation1210(CoeMat,MaxIter)
%Input & Output %CoeMat:original 3D matrix
%MaxIter:maxmum itertions  %H_fina:Up bound-feasible solution  %L_fina:Bottom bound-relax solution
%OptSolu:optimal solution   %iter:maxmum itertions for problem
t0=cputime;

M=CoeMat;
[i1,i2,i3]=size(M);

A=zeros(i1,i2);%dual mat
u=zeros(1,1,i3);%lag Multiplier
H_fina=inf;
L_fina=-inf;

DualMatching=zeros(i1,3);
FinaMatching=zeros(i1,3);

L_init1=zeros(1,MaxIter);
H_init1=zeros(1,MaxIter);
Gap_init=zeros(1,MaxIter);

count=0;
for iter=1:MaxIter
    %% 降为2D
    %     u
    for i=1:i1
        for j=1:i2
            A(i,j)=min(M(i,j,:)-u(1,1,:));%求最小i3
        end
    end
    %     A
    %% 求松弛解
    [DualMat,L]=Hungarian(A);
    L=L+sum(u)
    
    %% D2D-CU 最佳匹配
    for i=1:i1
        DualMatching(i,1)=i; %D2D
        DualMatching(i,2)=find(DualMat(i,:)==1);%CU
    end
    %     DualMatching
    
    %% 构造可行解矩阵
    B=zeros(i1,i3);
    for i=1:i1
        for j=1:i3
            B(i,j)=CoeMat(DualMatching(i,1),DualMatching(i,2),j);%反推
        end
    end
    %     B
    %% 可行解
    [FeaMat,H]=Hungarian(B);
    %     H=H+sum(u)
    
    IU=zeros(i3,1);
    for i=1:i1
        IU(i,1)=find(FeaMat(i,:)==1);
    end
    %% 计算违反规则次数
    g=ones(1,1,i3);
    for i=1:i3
        k=find(B(i,:)==min(B(i,:)));
        DualMatching(i,3)=k(1);
        for j=1:i1
            n=find(B(j,:)==min(B(j,:)));
            if i==n(1)%find(DualAssiMat(i,:)==min(DualAssiMat(i,:)));%统计i3的重复次数
                g(1,1,i)=g(1,1,i)-1;
            end
        end
    end
    
    %     g
    
    %% 最佳匹配
    FinaMatching(:,1)=DualMatching(:,1);
    FinaMatching(:,2)=DualMatching(:,2);
    FinaMatching(:,3)=IU(:,1);
    
    %     FinaMatching
    
    
    H_fina=min(H_fina,H);
    L_fina=max(L_fina,L);
    Gap=H_fina-L_fina;
    
    L_init1(1,iter)=L_fina;
    H_init1(1,iter)=H_fina;
    Gap_init(1,iter)=Gap;
    
    
    if  any(g)==0
        break;
    end
    %% 乘子更新
    u=u+((Gap)/(sum(g.^2)))*g;

%     if L>L_fina
%         u=u+((Gap)/(sum(g.^2)))*g;
%         count=0;
%     else
%         count=count+1;
%         if count>20
%             break;
%         end
%         
%     end
    
    %% 结束条件
    if Gap<0||(H_fina==L_fina)||((H_fina-L_fina)/abs(H_fina))<0.001
        break;
    end
    
end
PariSolu=FinaMatching;
% OptSolu=12;
OptSolu=H_fina;
TIME=cputime-t0;

figure(2)
clf
% OptSolu=H_test;
len=iter;
plot(1:len,H_init1(1,1:len),'-ro','linewidth',1.5,'MarkerSize',5)
hold on
plot(1:len,L_init1(1,1:len),'-v','linewidth',1.5,'MarkerSize',5)
hold on
% plot(1:len,Gap_init(1,1:len),'-k*','linewidth',1.5,'MarkerSize',10)
% hold on
legend('Feasible Solution','Dual Solution',0); %4,Lower right corner,'Gap'
% title('The curve of the system SumRate under the different SINR threshold mode');
xlabel('Iterations');
ylabel('Solution');
fprintf(1,'=============================================================================');








% figure(2)
% clf
% % OptSolu=H_test;
% len=iter;
% plot(1:len,H_init1(1,1:len),'-ro','linewidth',1.5,'MarkerSize',10)
% hold on
% plot(1:len,L_init1(1,1:len),'-v','linewidth',1.5,'MarkerSize',10)
% hold on
% plot(1:len,Gap_init(1,1:len),'-k*','linewidth',1.5,'MarkerSize',10)
% hold on
% legend('Feasible Solution','Dual Solution','Gap',0); %4,Lower right corner
% % title('The curve of the system SumRate under the different SINR threshold mode');
% xlabel('Iterations');
% ylabel('Solution');
% fprintf(1,'=============================================================================');
%


