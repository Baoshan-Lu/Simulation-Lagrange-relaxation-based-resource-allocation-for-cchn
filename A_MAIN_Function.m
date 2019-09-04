clc;
clear;
PtrV2I= 0.1995;%功率
PtrV2V= 0.1995;
P_Noise=3.9811e-15;%噪声功率 -174dbm/Hz
Bandwith=10*10^6; %带宽 10M
R0=2.6e+03;     %最小速率要求
BS_x=0;BS_y=0;   %基站位置
Radius=1000;    %基站覆盖范围
SingleLaneWidth=4*3;    %单边车道宽
IntermediateBand=4;    %中心带

V2Inum=30;V2Vnum=100;
minV2Vdistan=10; %V2V之间的距离
maxV2Vdistan=60;
MRQ=power(10,3);Range=0;%MRQ需求，以及随机波动
%工作路径
formatOut = 'yy_mm_dd';
SimuTimeHistory=datestr(now,formatOut);
FigurePath=['仿真图片\Experiment_20' SimuTimeHistory '\'];
VariablePath=['仿真数据\Experiment_20' SimuTimeHistory '\'];
if  ~exist(FigurePath)
    mkdir(FigurePath);%%%检测不到路径，则新建
end
if  ~exist(VariablePath)
    mkdir(VariablePath);%%%检测不到路径，则新建
end

FigFormat='.fig';%保存图片格式

%% =================================================================
%% ---------------------------工作方式-------------------------------
%% =================================================================
SimMode='Calculate';
% SimMode='Plot';'Calculate';
NewModel=0; %使用旧模型
%公用参数
SystemCoefficient=struct('FigurePath',FigurePath,'FigFormat',FigFormat,...
    'VariablePath',VariablePath,'SimMode',SimMode,'NewModel',NewModel,...
    'PtrV2I',PtrV2I,'PtrV2V',PtrV2V,'P_Noise',P_Noise,'Bandwith',Bandwith...
    ,'V2Inum',V2Inum,'V2Vnum',V2Vnum,'Radius',Radius,'BS_x',BS_x,'BS_y',BS_y,...
    'minV2Vdistan',minV2Vdistan,'maxV2Vdistan',maxV2Vdistan,'MRQ',MRQ,'Range',Range)


%% 模型
if NewModel==1
    VehicularNetworksModel(SystemCoefficient) 
    %% 计算增益
    FrequencyGain(SystemCoefficient)
end
%% =================================================================
%% --------------拉格朗日算法(LR)的性能---------------------
%% =================================================================

%% LR算法验证

V2Inum=5,V2Vnum=20,loop=20,LearingRate=0.1
VariLR(SystemCoefficient,V2Inum,V2Vnum,loop,LearingRate)

%% LR与ES的性能对比

% V2Ista=2;V2VnumRange=[20,30];loop=8;
% PlotLRversusES(SystemCoefficient,V2Ista,V2VnumRange,loop)


%% LR,IHM,GRD算法对比

%%　随着V2I个数
% V2InumSta=2,V2VnumRange=[20,20],loop=8
% PlotCompareLR_IHM_GRD_V2Inum(SystemCoefficient,V2InumSta,V2VnumRange,loop)

%%　随着V2V个数
% V2InumRange=[9,9]; V2VnumSta=20; loop=8;
% PlotCompareLR_IHM_GRD(SystemCoefficient,V2InumRange,V2VnumSta,loop)

%% =================================================================
%% --------------博弈算法(CG)的性能---------------------
%% =================================================================

%% CG与ES性能对比

% % % %随着V2V个数变化
% V2Inum=4,V2Vsta=2,loop=8
% PlotCGversusES(SystemCoefficient,V2Inum,V2Vsta,loop)


%% CG与InGRA,MAD,RD性能对比

% % %%随着V2I变化
% V2Vnum=15;V2Ista=2;loop=8;
% PlotCGversusDHG_V2Ivari(SystemCoefficient,V2Ista,V2Vnum,loop)
% % 
% % % %%随着V2V变化
% V2Inum=6;V2Vsta=20; loop=8;
% PlotCGversusDHG(SystemCoefficient,V2Inum,V2Vsta,loop)

%%% 随着最小速率要求变化
% V2Inum=7;V2Vnum=20;RminSta=power(10,5);loop=8;
% PlotV2ImimRateVari(SystemCoefficient,V2Inum,V2Vnum,RminSta,loop)


%%% 随着车辆密度变化
% loop=8;SpeedSta=15;
% PlotVehicleSpeedVariCompare(SystemCoefficient,SpeedSta,loop)
