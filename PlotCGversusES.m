function PlotCGversusES(SystemCoefficient,V2Inum,V2Vsta,loop)

% % %CG与ES的性能对比

% % V2Vnum=6;
% % V2Inum=4;

CGrateMat_V2I=zeros(1,loop);
CGtimeMat_V2I=zeros(1,loop);

ESrateMat_V2I=zeros(1,loop);
EStimeMat_V2I=zeros(1,loop);
CG_ES_Xlabel=zeros(1,loop);


if strcmp(SystemCoefficient.SimMode,'Calculate')==1 %如果是重新计算模式

for i=1:loop
    %     V2Inum=i+a;
    
    V2Vnum=i+V2Vsta-1;
    CG_ES_Xlabel(1,i)=V2Vnum;
    
    %CG
    % %      [V2VCluster,kthClusterNum]=RandV2VClustering(V2Inum,V2Vnum);
    [V2VCluster,kthClusterNum]=DistanceBasedSelection(SystemCoefficient,V2Inum,V2Vnum,2);
    [CGrate_old,t1]=CoorperativeGameforV2V(SystemCoefficient,V2VCluster,kthClusterNum);
    CGrateMat_V2I(1,i)=CGrate_old;
    CGtimeMat_V2I(1,i)=t1;
    
    %穷举法
    [MaxSumrate,t2]=ExhaustSearch(SystemCoefficient,V2Inum,V2Vnum)
    ESrateMat_V2I(1,i)=MaxSumrate;
    EStimeMat_V2I(1,i)=t2;
    
    
    
end

    save([SystemCoefficient.VariablePath  'CGrateMat_V2I'], 'CGrateMat_V2I')
    save([SystemCoefficient.VariablePath  'CGtimeMat_V2I'], 'CGtimeMat_V2I')
    save([SystemCoefficient.VariablePath  'ESrateMat_V2I'], 'ESrateMat_V2I')
    save([SystemCoefficient.VariablePath  'EStimeMat_V2I'], 'EStimeMat_V2I')
     save([SystemCoefficient.VariablePath  'CG_ES_Xlabel'], 'CG_ES_Xlabel')
   
end
load([SystemCoefficient.VariablePath '\CGrateMat_V2I.mat'],'CGrateMat_V2I');
load([SystemCoefficient.VariablePath '\CGtimeMat_V2I.mat'],'CGtimeMat_V2I');
load([SystemCoefficient.VariablePath '\ESrateMat_V2I.mat'],'ESrateMat_V2I');
load([SystemCoefficient.VariablePath '\EStimeMat_V2I.mat'],'EStimeMat_V2I');
load([SystemCoefficient.VariablePath '\CG_ES_Xlabel.mat'],'CG_ES_Xlabel');



figure
plot(CG_ES_Xlabel,CGrateMat_V2I,'-or','linewidth',1.5,'MarkerSize',10);
hold on
plot(CG_ES_Xlabel,ESrateMat_V2I,'->','linewidth',1.5,'MarkerSize',10);
xlabel({'The number of V2V links'},'FontName','Times New Roman','FontSize',12);
ylabel({'Sum-rate of V2V links (nat/s)'},'FontName','Times New Roman','FontSize',12);
s1=legend('CG','ES',0);
set(s1, 'FontName','Times New Roman','FontSize',12);
grid on
FileName='CG_ES V2V link SumRate';
saveas(gcf,[SystemCoefficient.FigurePath FileName SystemCoefficient.FigFormat]);


figure
plot(CG_ES_Xlabel,CGtimeMat_V2I,'-or','linewidth',1.5,'MarkerSize',10);hold on
plot(CG_ES_Xlabel,EStimeMat_V2I,'->','linewidth',1.5,'MarkerSize',10);
xlabel({'The number of IoT links'},'FontName','Times New Roman','FontSize',12);
ylabel({'Running time (s)'},'FontName','Times New Roman','FontSize',12);
s1=legend('CG','ES',0);
set(s1,'FontName','Times New Roman', 'FontSize',12);
grid on
FileName='CG_ES V2V link RnuningTime';
saveas(gcf,[SystemCoefficient.FigurePath FileName SystemCoefficient.FigFormat]);


