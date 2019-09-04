function CompareThreeDassignforV2I_RB_VLC()
load('SumRateMat.mat')
maxV = max(max(max(SumRateMat)));%转化为最小优化
RateMat=maxV-SumRateMat;

loop=7;
Lag_COST=zeros(1,loop);
Lag_TIME=zeros(1,loop);

Nume_COST=zeros(1,loop);


Nume_TIME=zeros(1,loop);

Game_COST=zeros(1,loop);
Game_TIME=zeros(1,loop);
%lag iterative number
MaxIter=100;
%Game balance number
MaxBalance=100;
for NetSize=1:loop
    RateOverNetSizeMat=RateMat(1:NetSize,1:NetSize,1:NetSize);
    %使用Lagrangrian relaxation
    [H_fina,L_fina,OptSolu,iter,PariSolu,TIME2]=ThreeD_LagrangianRelaxation(RateOverNetSizeMat,MaxIter);
    Lag_COST(1,NetSize)=NetSize*maxV-OptSolu;
    Lag_TIME(1,NetSize)=TIME2;
    
    %使用穷搜索
    [MATCHING1,COST,TIME1]=ThreeD_NumericalSearch(RateOverNetSizeMat);
    Nume_COST(1,NetSize)=NetSize*maxV-COST;
    Nume_TIME(1,NetSize)=TIME1;
    
    %使用博弈算法
    [MATCHING2,COST1,TIME2]=ThreeD__GameAsignment(RateOverNetSizeMat,MaxBalance);
    Game_COST(1,NetSize)=NetSize*maxV-COST1;
    Game_TIME(1,NetSize)=TIME2;
    
end
PariSolu
MATCHING1
MATCHING2
figure
plot(1:loop,Lag_COST,'-or','linewidth',1.5,'MarkerSize',11);
hold on;
plot(1:loop,Nume_COST,'-<k','linewidth',1.5,'MarkerSize',10);
hold on;
plot(1:loop,Game_COST,'->g','linewidth',1.5,'MarkerSize',10);
% hold on;
% plot(1:loop,COST1_Numer,'-*','linewidth',1.5,'MarkerSize',10);
xlabel({'The number of V2I links'},'FontSize',15);
ylabel({'Maximum sum-rate (Nat/s)'},'FontSize',15);
s2=legend('LagRelax algorithm','Numerical Search','Gamefor3D',2);
set(s2，'FontSize',13);

figure
plot(1:loop,Lag_TIME,'-or','linewidth',1.5,'MarkerSize',11);
hold on;
plot(1:loop,Nume_TIME,'-<k','linewidth',1.5,'MarkerSize',10);
hold on;
plot(1:loop,Game_TIME,'->g','linewidth',1.5,'MarkerSize',10);
% hold on;
% plot(1:loop,TIME1_Numer,'-*','linewidth',1.5,'MarkerSize',10);
xlabel({'The number of V2I links'},'FontSize',15);
ylabel({'Running time(s)'},'FontSize',15);
s1=legend('LagRelax algorithm','Numerical Search','Gamefor3D',2);
set(s1, 'FontSize',13);

