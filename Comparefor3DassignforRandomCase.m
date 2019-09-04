function Comparefor3DassignforRandomCase()
V2Inum=5;
V2Vnum=20;
loop=10;
Lag_COST=zeros(1,loop);
Lag_TIME=zeros(1,loop);
Game_COST=zeros(1,loop);
Game_TIME=zeros(1,loop);

Nume_COST=zeros(1,loop);
Nume_TIME=zeros(1,loop);

%lag iterative number
MaxIter=100;
%Game balance number
MaxBalance=100;

for i=1:loop
    SumRateMat=CalculateSumRate(V2Inum,V2Vnum);%生成随机的V2I,V2V
    maxV = max(max(max(SumRateMat)));%转化为最小优化
    RateOverNetSizeMat=maxV-SumRateMat;
    
    %使用Lagrangrian relaxation
%     LagrangianRelaxation1210
    [H_fina,L_fina,OptSolu,iter,PariSolu,TIME2]=ThreeD_LagrangianRelaxation(RateOverNetSizeMat,MaxIter);
    Lag_COST(1,i)=V2Inum*maxV-OptSolu;
    Lag_TIME(1,i)=TIME2;
    
    %使用穷搜索
    [MATCHING1,COST,TIME1]=ThreeD_NumericalSearch(RateOverNetSizeMat);
    Nume_COST(1,i)=V2Inum*maxV-COST;
    Nume_TIME(1,i)=TIME1;
    
    %使用博弈算法
    [MATCHING2,COST1,TIME2]=ThreeD__GameAsignment(RateOverNetSizeMat,MaxBalance);
    Game_COST(1,i)=V2Inum*maxV-COST1;
    Game_TIME(1,i)=TIME2;
    
end
% PariSolu
% MATCHING1
% MATCHING2
figure
plot(1:loop,Lag_COST,'-or','linewidth',1.5,'MarkerSize',11);
hold on;
plot(1:loop,Nume_COST,'-<k','linewidth',1.5,'MarkerSize',10);
hold on;
plot(1:loop,Game_COST,'->g','linewidth',1.5,'MarkerSize',10);
% hold on;
% plot(1:loop,COST1_Numer,'-*','linewidth',1.5,'MarkerSize',10);
xlabel({'Random case number'},'FontSize',15);
ylabel({'Maximum sum-rate (Nat/s)'},'FontSize',15);
% s2=legend('LagRelax algorithm','Numerical Search','Gamefor3D',2);
s2=legend('LagRelax algorithm','Numerical Search','Gamefor3D',2);

set(s2,...
    'FontSize',13);
grid on
% figure
% plot(1:loop,Lag_TIME,'-or','linewidth',1.5,'MarkerSize',11);
% hold on;
% plot(1:loop,Nume_TIME,'-<k','linewidth',1.5,'MarkerSize',10);
% hold on;
% plot(1:loop,Game_TIME,'->g','linewidth',1.5,'MarkerSize',10);
% % hold on;
% % plot(1:loop,TIME1_Numer,'-*','linewidth',1.5,'MarkerSize',10);
% xlabel({'Random case number'},'FontSize',15);
% ylabel({'Running time(s)'},'FontSize',15);
% s1=legend('LagRelax algorithm','Numerical Search','Gamefor3D',2);
% set(s1,...
%     'FontSize',13);






