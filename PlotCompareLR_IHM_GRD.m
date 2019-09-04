function PlotCompareLR_IHM_GRD(SystemCoefficient,V2InumRange,V2VnumSta,loop)

% loop=3;
Times=1;
LRrate_V2V=zeros(Times,loop);
IHMrate_V2V=zeros(Times,loop);
GRDrate_V2V=zeros(Times,loop);
Xlabel_V2V=zeros(1,loop);

if strcmp(SystemCoefficient.SimMode,'Calculate')==1 %如果是重新计算模式
    
    %% 随着V2V变化
    % V2Inum=5;
    for h=1:Times
        for i=1:loop
            V2Vnum=V2VnumSta+(i-1)*2;
            Xlabel_V2V(1,i)= V2Vnum;
            V2Inum=randint(1,1,V2InumRange);
            [LRrate_V2V(h,i),IHMrate_V2V(h,i),GRDrate_V2V(h,i)]=CompareWithLR_IHM_GRD(SystemCoefficient,V2Inum,V2Vnum);
            
        end
        
    end
    save([SystemCoefficient.VariablePath  'LRrate_V2V'], 'LRrate_V2V')
    save([SystemCoefficient.VariablePath  'IHMrate_V2V'], 'IHMrate_V2V')
    save([SystemCoefficient.VariablePath  'GRDrate_V2V'], 'GRDrate_V2V')
    save([SystemCoefficient.VariablePath  'Xlabel_V2V'], 'Xlabel_V2V')
    
end

load([SystemCoefficient.VariablePath '\LRrate_V2V.mat'],'LRrate_V2V');
load([SystemCoefficient.VariablePath '\IHMrate_V2V.mat'],'IHMrate_V2V');
load([SystemCoefficient.VariablePath '\GRDrate_V2V.mat'],'GRDrate_V2V');
load([SystemCoefficient.VariablePath '\Xlabel_V2V.mat'],'Xlabel_V2V');

LRrate1=zeros(1,loop);
IHMrate1=zeros(1,loop);
GRDrate1=zeros(1,loop);


for p=1:size(LRrate_V2V,2)
    LRrate1(1,p)=mean(LRrate_V2V(:,p));
    IHMrate1(1,p)=mean(IHMrate_V2V(:,p));
    
    GRDrate1(1,p)=mean(GRDrate_V2V(:,p));
end


figure
plot(Xlabel_V2V,LRrate1,'-or','linewidth',1.5,'MarkerSize',10);
hold on;
plot(Xlabel_V2V,IHMrate1,'-<','linewidth',1.5,'MarkerSize',10);
hold on;
plot(Xlabel_V2V,GRDrate1,'-sg','linewidth',1.5,'MarkerSize',10);
xlabel({'The number of IoT links'},'FontName','Times New Roman','FontSize',13);
ylabel({'Sum-rate (nat/s)'},'FontName','Times New Roman','FontSize',13);
s2=legend('LRM','IHM','GRD',0);
set(s2,'FontName','Times New Roman','FontSize',12);
grid on

FileName='LR IHM GRD V2V link';
saveas(gcf,[SystemCoefficient.FigurePath FileName SystemCoefficient.FigFormat]);

