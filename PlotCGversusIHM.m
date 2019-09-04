function PlotCGversusIHM()


loop=8;
V2Ista=8,V2Iend=10
V2Vsta=20,V2Vend=30

CGsumrate=zeros(1,loop);
IHMsumrate=zeros(1,loop);
RDsumrate=zeros(1,loop);
GDsumrate=zeros(1,loop);


Xlabel=zeros(1,loop);
MaxIter=50;
MaxFailNum=100;
h=waitbar(0,'CG与IHM性能对比，请稍后！');
tic
V2Inum=randint(1,1,[V2Ista,V2Iend]);
V2Vnum=randint(1,1,[V2Vsta,V2Vend]);
for NetSize=1:loop
    % 随机网络0
    NetSize
    Xlabel(1,NetSize)=V2Vnum+NetSize;
    
    [SumRateMat]=CalculateSumRate(V2Inum,V2Vnum+NetSize);
    maxV = max(max(max(SumRateMat)));%转化为最小优化
    RateOverNetSizeMat=maxV-SumRateMat;
   
    %使用CG
%     [OptSolu,t1]=CoorperativeGameforV2V(V2Inum,V2Vnum,MaxFailNum);
     [~,~,LRrate_new,~,~,~]=ThreeD_LagrangianRelaxation(RateOverNetSizeMat,200);
    CGsumrate(1,NetSize)=V2Inum*maxV-LRrate_new;

    %使用IHM

    [COST,TIME1]=IterHungarinAlgo(RateOverNetSizeMat,MaxIter);
    IHMsumrate(1,NetSize)=V2Inum*maxV-COST;
    
    %Greedy
    GDrate=GreedyResourceAllocation(SumRateMat);
    GDsumrate(1,NetSize)=GDrate;
    %使用RD
    
     RandomSumrate=RandomV2V_V2I_RB_allocate(V2Inum,V2Vnum);
     RDsumrate(1,NetSize)=RandomSumrate;
     
    str=['CG与IHM性能对比...',num2str(100*NetSize/(loop)),'%'];
    waitbar(NetSize/(loop),h,str);
    
end
toc

save CGsumrate1.mat CGsumrate
save IHMsumrate1.mat IHMsumrate
save RDsumrate.mat RDsumrate
save Xlabel.mat Xlabel
save GDsumrate.mat GDsumrate

load GDsumrate.mat GDsumrate

load Xlabel.mat Xlabel
load CGsumrate1.mat CGsumrate
load IHMsumrate1.mat IHMsumrate
load RDsumrate.mat RDsumrate

% load CGsumrate.mat CGsumrate
% load IHMsumrate.mat IHMsumrate
figure
plot(Xlabel,CGsumrate,'-or','linewidth',1.5,'MarkerSize',10);
hold on;
plot(Xlabel,IHMsumrate,'-<g','linewidth',1.5,'MarkerSize',10);
hold on;
plot(Xlabel,GDsumrate,'-s','linewidth',1.5,'MarkerSize',10);
hold on;
plot(Xlabel,RDsumrate,'->k','linewidth',1.5,'MarkerSize',10);

xlabel({'The number of V2V links'},'FontName','Times New Roman','FontSize',13);
ylabel({'Maximum sum-rate (nat/s)'},'FontName','Times New Roman','FontSize',13);
s2=legend('LR','IHM','GD','RD',0);
set(s2,'FontName','Times New Roman','FontSize',12);
grid on

