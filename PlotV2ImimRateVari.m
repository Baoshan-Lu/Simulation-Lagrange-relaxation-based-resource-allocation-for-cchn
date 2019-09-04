function PlotV2ImimRateVari(SystemCoefficient,V2Inum,V2Vnum,RminSta,loop)

%改变V2I最低速率要求
SumRateMat_CG_IG_MAD_RD_MRQ=zeros(5,loop);

if strcmp(SystemCoefficient.SimMode,'Calculate')==1 %如果是重新计算模式
    
    for co=1:loop
        Rmin=(co-1)*power(10,5)+RminSta;Range=0;
        
        Change_V2I_min_Rate(SystemCoefficient,V2Inum,Rmin,Range)
        
        SumRateMat_CG_IG_MAD_RD_MRQ(5,co)=Rmin;
        
        
        Infor=['Rmin=',num2str(Rmin), '  V2I链路数=',num2str(V2Inum), '  V2V链路数=',num2str(V2Vnum)]
        
        [SumRateMat_CG_IG_MAD_RD_MRQ(1,co),SumRateMat_CG_IG_MAD_RD_MRQ(2,co),SumRateMat_CG_IG_MAD_RD_MRQ(3,co),SumRateMat_CG_IG_MAD_RD_MRQ(4,co)]...
            =SumrateCalculatebyCG_InGRA_MAD_RD(SystemCoefficient,V2Inum,V2Vnum);
        
    end
    save([SystemCoefficient.VariablePath  'SumRateMat_CG_IG_MAD_RD_MRQ'], 'SumRateMat_CG_IG_MAD_RD_MRQ')
    
end
load([SystemCoefficient.VariablePath '\SumRateMat_CG_IG_MAD_RD_MRQ.mat'],'SumRateMat_CG_IG_MAD_RD_MRQ');
SumRateMat_CG_IG_MAD_RD_MRQ(5,:)
figure
plot(SumRateMat_CG_IG_MAD_RD_MRQ(5,:),SumRateMat_CG_IG_MAD_RD_MRQ(1,:),'-or','linewidth',1.5,'MarkerSize',10);
hold on
plot(SumRateMat_CG_IG_MAD_RD_MRQ(5,:),SumRateMat_CG_IG_MAD_RD_MRQ(2,:),'-^','linewidth',1.5,'MarkerSize',10);
hold on
plot(SumRateMat_CG_IG_MAD_RD_MRQ(5,:),SumRateMat_CG_IG_MAD_RD_MRQ(3,:),'-sg','linewidth',1.5,'MarkerSize',10);
hold on
plot(SumRateMat_CG_IG_MAD_RD_MRQ(5,:),SumRateMat_CG_IG_MAD_RD_MRQ(4,:),'-<k','linewidth',1.5,'MarkerSize',10);

xlabel({'Different MRQ of CS links (nat/s)'},'FontName','Times New Roman','FontSize',13);
ylabel({'Sum-rate (nat/s)'},'FontName','Times New Roman','FontSize',13);
s1=legend('CG','InGRA','MAD','RD',0);
set(s1, 'FontName','Times New Roman','FontSize',13);
grid on
FileName='CG_InGRA_MAD_RD V2I link MRQ';
% time=datestr(now,'yyyy-mm-dd HH:MM:SS') ;
saveas(gcf,[SystemCoefficient.FigurePath FileName  SystemCoefficient.FigFormat]);

