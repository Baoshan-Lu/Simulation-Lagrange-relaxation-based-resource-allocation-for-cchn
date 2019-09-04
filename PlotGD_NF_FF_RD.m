function PlotGD_NF_FF_RD()

%LRCG与ES的性能对比

% V2Inum,V2Vsta,loop

V2Inum=10,V2Vsta=20,loop=8

% loop=3;
% V2Vnum=6;
% V2Inum=4;

MaxFailNum=200;

CGrateMat=zeros(1,loop);
NFrateMat=zeros(1,loop);
FFrateMat=zeros(1,loop);
RDrateMat=zeros(1,loop);


a=V2Vsta;

h=waitbar(0,'LR+CG与FF性对比计算中，请稍后！');

for i=1:loop
    i
    %     V2Inum=i+a;
    V2Vnum=i+a-1;
    
    %LR+CG
    GDsumrate= GreedyAllocateRate(V2Inum,V2Vnum)
%     [LRrate,t1]=CoorperativeGameforV2V(V2Inum,V2Vnum,MaxFailNum);
    CGrateMat(1,i)=GDsumrate;
    
    
    %最近分配
    DHrate1=DistaceVLCbasedHGrate(V2Inum,V2Vnum,1);
    NFrateMat(1,i)=DHrate1;
    
    %最远分配
    DHrate2=DistaceVLCbasedHGrate(V2Inum,V2Vnum,2);%距离最远
    FFrateMat(1,i)=DHrate2;
    
    %随机分配
    RandomSumrate=RandomV2V_V2I_RB_allocate(V2Inum,V2Vnum);
    RDrateMat(1,i)=RandomSumrate;
    
    str=['LR+CG与FF,NF,RD性对比计算中...',num2str(100*i/(loop)),'%'];
    waitbar(i/(loop),h,str);
end

% save CGrateMat.mat CGrateMat
% save NFrateMat.mat NFrateMat
% save FFrateMat.mat FFrateMat
% save RDrateMat.mat RDrateMat
% 
% load RDrateMat.mat RDrateMat
% load FFrateMat.mat FFrateMat
% load CGrateMat.mat CGrateMat
% load NFrateMat.mat NFrateMat


figure
plot((1:loop)+a,CGrateMat,'-or','linewidth',1.5,'MarkerSize',10);
hold on
plot((1:loop)+a,NFrateMat,'->','linewidth',1.5,'MarkerSize',10);
hold on
plot((1:loop)+a,FFrateMat,'-sg','linewidth',1.5,'MarkerSize',10);
hold on
plot((1:loop)+a,RDrateMat,'-<k','linewidth',1.5,'MarkerSize',10);

xlabel({'The number of V2V links'},'FontName','Times New Roman','FontSize',13);
ylabel({'Sum-rate (nat/s)'},'FontName','Times New Roman','FontSize',13);
s1=legend('GD','NF','FF','RD',2);
set(s1, 'FontName','Times New Roman','FontSize',13);
grid on

