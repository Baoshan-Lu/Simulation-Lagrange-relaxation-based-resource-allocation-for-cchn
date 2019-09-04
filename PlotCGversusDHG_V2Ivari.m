function PlotCGversusDHG_V2Ivari(SystemCoefficient,V2Ista,V2Vnum,loop)

SumRateMat_CG_IG_MAD_RD_V2I=zeros(5,loop);
if strcmp(SystemCoefficient.SimMode,'Calculate')==1 %如果是重新计算模式
    for i=1:loop
        
        V2Inum=i+V2Ista-1;
        SumRateMat_CG_IG_MAD_RD_V2I(5,i)=V2Inum;
        [SumRateMat_CG_IG_MAD_RD_V2I(1,i),SumRateMat_CG_IG_MAD_RD_V2I(2,i),SumRateMat_CG_IG_MAD_RD_V2I(3,i),SumRateMat_CG_IG_MAD_RD_V2I(4,i)]...
            =SumrateCalculatebyCG_InGRA_MAD_RD(SystemCoefficient,V2Inum,V2Vnum);
    end
    save([SystemCoefficient.VariablePath  'SumRateMat_CG_IG_MAD_RD_V2I'], 'SumRateMat_CG_IG_MAD_RD_V2I')
    
end
load([SystemCoefficient.VariablePath '\SumRateMat_CG_IG_MAD_RD_V2I.mat'],'SumRateMat_CG_IG_MAD_RD_V2I');

figure
plot(SumRateMat_CG_IG_MAD_RD_V2I(5,:),SumRateMat_CG_IG_MAD_RD_V2I(1,:),'-or','linewidth',1.5,'MarkerSize',10);
hold on
plot(SumRateMat_CG_IG_MAD_RD_V2I(5,:),SumRateMat_CG_IG_MAD_RD_V2I(2,:),'-^','linewidth',1.5,'MarkerSize',10);

hold on
plot(SumRateMat_CG_IG_MAD_RD_V2I(5,:),SumRateMat_CG_IG_MAD_RD_V2I(3,:),'-sg','linewidth',1.5,'MarkerSize',10);
hold on
plot(SumRateMat_CG_IG_MAD_RD_V2I(5,:),SumRateMat_CG_IG_MAD_RD_V2I(4,:),'-<k','linewidth',1.5,'MarkerSize',10);

xlabel({'The number of CS links'},'FontName','Times New Roman','FontSize',13);
ylabel({'Sum-rate (nat/s)'},'FontName','Times New Roman','FontSize',13);
s1=legend('CG','InGRA','MAD','RD',2);
set(s1, 'FontName','Times New Roman','FontSize',13);
grid on
FileName='CG_InGRA_MAD_RD V2I link Sum_rate';
saveas(gcf,[SystemCoefficient.FigurePath FileName SystemCoefficient.FigFormat]);

