function  PlotCompareLR_IHM_GRD_V2Inum(SystemCoefficient,V2InumSta,V2VnumRange,loop)
%% 随着V2I变化
Times=1;

LRrate_V2I=zeros(Times,loop);
IHMrate_V2I=zeros(Times,loop);
GRDrate_V2I=zeros(Times,loop);
Xlabel_V2I=zeros(1,loop);

if strcmp(SystemCoefficient.SimMode,'Calculate')==1 %如果是重新计算模式
    % V2Vnum=25;
    for h=1:Times
        for i=1:loop
            V2Inum=V2InumSta+(i-1)*1;
            Xlabel_V2I(1,i)= V2Inum;
            
            V2Vnum=randint(1,1,V2VnumRange)
            [LRrate_V2I(h,i),IHMrate_V2I(h,i),GRDrate_V2I(h,i)]=CompareWithLR_IHM_GRD(SystemCoefficient,V2Inum,V2Vnum);
            
        end
        
    end
    save([SystemCoefficient.VariablePath  'LRrate_V2I'], 'LRrate_V2I')
    save([SystemCoefficient.VariablePath  'IHMrate_V2I'], 'IHMrate_V2I')
    save([SystemCoefficient.VariablePath  'GRDrate_V2I'], 'GRDrate_V2I')
    save([SystemCoefficient.VariablePath  'Xlabel_V2I'], 'Xlabel_V2I')
    
end

load([SystemCoefficient.VariablePath '\LRrate_V2I.mat'],'LRrate_V2I');
load([SystemCoefficient.VariablePath '\IHMrate_V2I.mat'],'IHMrate_V2I');
load([SystemCoefficient.VariablePath '\GRDrate_V2I.mat'],'GRDrate_V2I');
load([SystemCoefficient.VariablePath '\Xlabel_V2I.mat'],'Xlabel_V2I');

LRrate1_V2I=zeros(1,loop);
IHMrate1_V2I=zeros(1,loop);
GRDrate1_V2I=zeros(1,loop);

for p=1:loop
    LRrate1_V2I(1,p)=max(LRrate_V2I(:,p));
    %     IHMrate1(1,p)=min(IHMrate(:,p));
    IHMrate1_V2I(1,p)=min(IHMrate_V2I(:,p));
    GRDrate1_V2I(1,p)=min(GRDrate_V2I(:,p));
end


figure
plot(Xlabel_V2I,LRrate1_V2I,'-or','linewidth',1.5,'MarkerSize',10);
hold on;
plot(Xlabel_V2I,IHMrate1_V2I,'-<','linewidth',1.5,'MarkerSize',10);
hold on;
plot(Xlabel_V2I,GRDrate1_V2I,'-sg','linewidth',1.5,'MarkerSize',10);
xlabel({'The number of CS links'},'FontName','Times New Roman','FontSize',13);
ylabel({'Sum-rate (nat/s)'},'FontName','Times New Roman','FontSize',13);
s2=legend('LRM','IHM','GRD',0);
set(s2,'FontName','Times New Roman','FontSize',12);
grid on
FileName='LR IHM GRD V2I link';
saveas(gcf,[SystemCoefficient.FigurePath FileName SystemCoefficient.FigFormat]);

