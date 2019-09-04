

function PlotVehicleSpeedVariCompare(SystemCoefficient,loop)

%随着车速变化
SumRateMat_CG_IG_MAD_RD_VehicleSpeed=zeros(5,loop);

if strcmp(SystemCoefficient.SimMode,'Calculate')==1 %如果是重新计算模式
    
    for co=1:loop
        
        VehicleSpeed=20+5*(co-1); %密度变化
        
        SumRateMat_CG_IG_MAD_RD_VehicleSpeed(5,co)=VehicleSpeed;
        
        VehicularNetworksModel_SpeedVari(SystemCoefficient,VehicleSpeed);
        
        load([SystemCoefficient.VariablePath '\V2Icoord.mat'],'V2Icoord');
        load([SystemCoefficient.VariablePath '\V2Vcoord.mat'],'V2Vcoord');
        V2Inum=size(V2Icoord,2);
        V2Vnum=size(V2Vcoord,2);
        
        Infor=['车速=',num2str(VehicleSpeed), '  V2I链路数=',num2str(V2Inum), '  V2V链路数=',num2str(V2Vnum)]
        
        [SumRateMat_CG_IG_MAD_RD_VehicleSpeed(1,co),SumRateMat_CG_IG_MAD_RD_VehicleSpeed(2,co),SumRateMat_CG_IG_MAD_RD_VehicleSpeed(3,co),SumRateMat_CG_IG_MAD_RD_VehicleSpeed(4,co)]...
            =SumrateCalculatebyCG_InGRA_MAD_RD(SystemCoefficient,V2Inum,V2Vnum);
        
    end
    save([SystemCoefficient.VariablePath  'SumRateMat_CG_IG_MAD_RD_VehicleSpeed'], 'SumRateMat_CG_IG_MAD_RD_VehicleSpeed')
    
end
load([SystemCoefficient.VariablePath '\SumRateMat_CG_IG_MAD_RD_VehicleSpeed.mat'],'SumRateMat_CG_IG_MAD_RD_VehicleSpeed');

figure
plot(SumRateMat_CG_IG_MAD_RD_VehicleSpeed(5,:),SumRateMat_CG_IG_MAD_RD_VehicleSpeed(1,:),'-or','linewidth',1.5,'MarkerSize',10);
hold on
plot(SumRateMat_CG_IG_MAD_RD_VehicleSpeed(5,:),SumRateMat_CG_IG_MAD_RD_VehicleSpeed(2,:),'-^','linewidth',1.5,'MarkerSize',10);
hold on
plot(SumRateMat_CG_IG_MAD_RD_VehicleSpeed(5,:),SumRateMat_CG_IG_MAD_RD_VehicleSpeed(3,:),'-sg','linewidth',1.5,'MarkerSize',10);
hold on
plot(SumRateMat_CG_IG_MAD_RD_VehicleSpeed(5,:),SumRateMat_CG_IG_MAD_RD_VehicleSpeed(4,:),'-<k','linewidth',1.5,'MarkerSize',10);

xlabel({'The speed of vehicles (km/h)'},'FontName','Times New Roman','FontSize',13);
ylabel({'Sum-rate of V2V links (nat/s)'},'FontName','Times New Roman','FontSize',13);
s1=legend('CG','InGRA','MAD','RD',2);
set(s1, 'FontName','Times New Roman','FontSize',13);
grid on
FileName='CG_InGRA_MAD_RD V2I link Sum_rate';
saveas(gcf,[SystemCoefficient.FigurePath FileName SystemCoefficient.FigFormat]);

