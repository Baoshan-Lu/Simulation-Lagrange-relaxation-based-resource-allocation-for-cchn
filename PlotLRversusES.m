function   count=PlotLRversusES(SystemCoefficient,V2Ista,V2VnumRange,loop)
% 随机分簇下的LR与NS对比

Lag_COST=zeros(1,loop);
Lag_TIME=zeros(1,loop);
Nume_COST=zeros(1,loop);
Nume_TIME=zeros(1,loop);

Xlabel=zeros(1,loop);

tic
count=0;
if strcmp(SystemCoefficient.SimMode,'Calculate')==1 %如果是重新计算模式
    for NetSize=1:loop
        % 随机网络
        V2Vnum=randint(1,1,V2VnumRange); %从V2V的范围中随机取V2V数目
        V2Inum=V2Ista+NetSize-1;
        Xlabel(1,NetSize)=V2Inum;
        
        [SumRateMat]=CalculateSumRate(SystemCoefficient,V2Inum,V2Vnum);
        
        
        %% LR
        [~,LRrate,LRTIME]=ThreeD_LagrangianRelaxation(SumRateMat);
        Lag_COST(1,NetSize)=LRrate;
        Nume_TIME(1,NetSize)=LRTIME;
        
        %     [IHMrate,TIME2]=IterHungarinAlgo(CoeMat,MaxIter);
        %     IHMrate=V2Inum*maxV-IHMrate
        
        %% ES method
        %     [ESrate,TIME1]=IterHungarinAlgo(SumRateMat)
        [~,ESrate,TIME1]=ThreeD_NumericalSearch(SumRateMat);
        Nume_COST(1,NetSize)=ESrate;
        Nume_TIME(1,NetSize)=TIME1;
        
        Inform=['V2Inum=',num2str(V2Inum), '  LRrate=',num2str(LRrate), '  ESrate=',num2str(ESrate)]
        
        if ESrate==LRrate
            count=count+1;
        end
        
    end
    toc

    save([SystemCoefficient.VariablePath 'LR_SumRate'], 'Lag_COST')
    save([SystemCoefficient.VariablePath  'LR_Runtime'], 'Lag_TIME')
    save([SystemCoefficient.VariablePath 'ES_SumRate'], 'Nume_COST')
    save([SystemCoefficient.VariablePath 'ES_Runtime'], 'Nume_TIME')
    save([SystemCoefficient.VariablePath 'Xlabel_LR_ES'], 'Xlabel')

%   save Lag_TIME2.mat Lag_TIME
%     save Lag_COST2.mat Lag_COST
%     save Nume_COST2.mat Nume_COST
%     save Nume_TIME2.mat Nume_TIME
%     save Xlabel2.mat Xlabel
end
load([SystemCoefficient.VariablePath '\LR_SumRate.mat'],'Lag_COST');
load([SystemCoefficient.VariablePath '\LR_Runtime.mat'],'Lag_TIME');
load([SystemCoefficient.VariablePath '\ES_SumRate.mat'],'Nume_COST');
load([SystemCoefficient.VariablePath '\ES_Runtime.mat'],'Nume_TIME');
load([SystemCoefficient.VariablePath '\Xlabel_LR_ES.mat'],'Xlabel');



figure
plot(Xlabel,Lag_COST,'-or','linewidth',1.5,'MarkerSize',10);
hold on;
plot(Xlabel,Nume_COST,'-<','linewidth',1.5,'MarkerSize',10);
xlabel({'The number of CS links'},'FontName','Times New Roman','FontSize',13);
ylabel({'Sum-rate  (nat/s)'},'FontName','Times New Roman','FontSize',13);
s2=legend('LR','ES',0);
set(s2,'FontName','Times New Roman','FontSize',12);
grid on
FileName='LR ES sum_rate';
saveas(gcf,[SystemCoefficient.FigurePath FileName SystemCoefficient.FigFormat]);

figure
plot(Xlabel,Lag_TIME,'-or','linewidth',1.5,'MarkerSize',10);
hold on;
plot(Xlabel,Nume_TIME,'-<','linewidth',1.5,'MarkerSize',10);
xlabel({'The number of CS links'},'FontName','Times New Roman','FontSize',13);
ylabel({'Running time (s)'},'FontName','Times New Roman','FontSize',13);
s1=legend('LR','ES',0);
set(s1, 'FontName','Times New Roman','FontSize',12);
grid on

FileName='LR ES running_time';
saveas(gcf,[SystemCoefficient.FigurePath FileName SystemCoefficient.FigFormat]);
