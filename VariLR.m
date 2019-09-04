function VariLR(SystemCoefficient,V2Inum,V2Vnum,loop,LearingRate)
[SumRateMat]=CalculateSumRate(SystemCoefficient,V2Inum,V2Vnum);
save([SystemCoefficient.VariablePath  'SumRateMat'], 'SumRateMat')
load([SystemCoefficient.VariablePath '\SumRateMat.mat'],'SumRateMat');

LR_learningRate=zeros(2,loop)
[~,ESrate,~]=ThreeD_NumericalSearch(SumRateMat);

% for i=1:loop
%     LearingRate=0.028+10*i*power(10,-6)
%     [~,LRrate,~]=ThreeD_LagrangianRelaxation_LearingRate(SumRateMat,LearingRate);
%     LR_learningRate(1,i)=LearingRate;
%     LR_learningRate(2,i)=LRrate;
%     LR_learningRate(3,i)=ESrate;
% 
% end
% figure
% plot(LR_learningRate(1,:),LR_learningRate(2,:),'-o','linewidth',1.5,'MarkerSize',1)
% hold on
% plot(LR_learningRate(1,:),LR_learningRate(3,:),'-ro','linewidth',1.5,'MarkerSize',1)
% xlabel({'The learning rate'},'FontName','Times New Roman','FontSize',13);
% ylabel({'Sum-rate  (nat/s)'},'FontName','Times New Roman','FontSize',13);
% 
% s2=legend('LR','ES',0); %4,Lower right corner
% set(s2,'FontName','Times New Roman','FontSize',12);
% grid on



%% L
% LearingRate=0.0001
[~,LRrate,~,LR_perform]=ThreeD_LagrangianRelaxation_LearingRate(SumRateMat,LearingRate);
LR_perform(4,:)=ESrate;
figure
plot(LR_perform(1,:),LR_perform(2,:),'-go','linewidth',1.5,'MarkerSize',6)
hold on
plot(LR_perform(1,:),LR_perform(3,:),'-<','linewidth',1.5,'MarkerSize',6)
hold on
plot(LR_perform(1,:),LR_perform(4,:),'-ro','linewidth',1.5,'MarkerSize',6)

xlabel({'The number of iterations'},'FontName','Times New Roman','FontSize',13);
ylabel({'Sum-rate  (nat/s)'},'FontName','Times New Roman','FontSize',13);

s2=legend('R^{fea}','R^{dua}','R^{opt}',0); %4,Lower right corner
set(s2,'FontName','Times New Roman','FontSize',12);
grid on

formatOut = 'yy_mm_dd';
SimuTimeHistory=datestr(now,formatOut);
FigurePath=['·ÂÕæÍ¼Æ¬\Experiment_20' SimuTimeHistory '\'];
FigFormat='.fig';
FileName='LR_R_dua-R_fea';
saveas(gcf,[FigurePath FileName FigFormat]);




[IHMrate,~]=IterHungarinAlgo(SumRateMat);
% [~,ESrate,~]=ThreeD_NumericalSearch(SumRateMat);
Inform=['LRrate=',num2str(LRrate), '  IHMrate=',num2str(IHMrate),'  ESrate=',num2str(ESrate)]






