function PlotCGversusDHG(SystemCoefficient,V2Inum,V2Vsta,loop)
SumRateMat_CG_IG_MAD_RD_V2V=zeros(5,loop);
if strcmp(SystemCoefficient.SimMode,'Calculate')==1 %如果是重新计算模式
    for i=1:loop
        V2Vnum=i+V2Vsta-1;
        NumInform=['V2Inum=',num2str(V2Inum),', V2Vnum=',num2str(V2Vnum)]
        
        SumRateMat_CG_IG_MAD_RD_V2V(5,i)=V2Vnum;
        [SumRateMat_CG_IG_MAD_RD_V2V(1,i),SumRateMat_CG_IG_MAD_RD_V2V(2,i),SumRateMat_CG_IG_MAD_RD_V2V(3,i),SumRateMat_CG_IG_MAD_RD_V2V(4,i)]...
            =SumrateCalculatebyCG_InGRA_MAD_RD(SystemCoefficient,V2Inum,V2Vnum);
    end
    save([SystemCoefficient.VariablePath  'SumRateMat_CG_IG_MAD_RD_V2V'], 'SumRateMat_CG_IG_MAD_RD_V2V')
    
end
load([SystemCoefficient.VariablePath '\SumRateMat_CG_IG_MAD_RD_V2V.mat'],'SumRateMat_CG_IG_MAD_RD_V2V');

figure
plot(SumRateMat_CG_IG_MAD_RD_V2V(5,:),SumRateMat_CG_IG_MAD_RD_V2V(1,:),'-or','linewidth',1.5,'MarkerSize',10);
hold on
plot(SumRateMat_CG_IG_MAD_RD_V2V(5,:),SumRateMat_CG_IG_MAD_RD_V2V(2,:),'-^','linewidth',1.5,'MarkerSize',10);

hold on
plot(SumRateMat_CG_IG_MAD_RD_V2V(5,:),SumRateMat_CG_IG_MAD_RD_V2V(3,:),'-sg','linewidth',1.5,'MarkerSize',10);
hold on
plot(SumRateMat_CG_IG_MAD_RD_V2V(5,:),SumRateMat_CG_IG_MAD_RD_V2V(4,:),'-<k','linewidth',1.5,'MarkerSize',10);

xlabel({'The number of IoT links'},'FontName','Times New Roman','FontSize',13);
ylabel({'Sum-rate (nat/s)'},'FontName','Times New Roman','FontSize',13);
s1=legend('CG','InGRA','MAD','RD',2);
set(s1, 'FontName','Times New Roman','FontSize',13);
grid on
FileName='CG_InGRA_MAD_RD V2V link Sum_rate';
saveas(gcf,[SystemCoefficient.FigurePath FileName SystemCoefficient.FigFormat]);

