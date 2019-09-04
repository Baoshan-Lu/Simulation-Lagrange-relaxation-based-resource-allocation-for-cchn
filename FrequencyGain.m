function FrequencyGain(SystemCoefficient)
%各个链路的频率特性矩阵

% % load('V2Icoord.mat');
% % load('V2Vcoord.mat');
load([SystemCoefficient.VariablePath '\V2Icoord.mat'],'V2Icoord');
load([SystemCoefficient.VariablePath '\V2Vcoord.mat'],'V2Vcoord');


V2Inum=size(V2Icoord,2);
V2Vnum=size(V2Vcoord,2);
RBnum=V2Inum;

% V2I_min_Rate=zeros(V2Inum,RBnum);

Fg_V2V_BS=zeros(V2Vnum,RBnum);
Fg_V2V_mat=zeros(V2Vnum,RBnum);
Fg_V2I_mat=zeros(V2Inum,RBnum);

Fg_V2V_V2I_mat=zeros(V2Inum,V2Vnum,RBnum);
Fg_V2V_V2V_mat=zeros(V2Vnum,V2Vnum,RBnum);

for i=1:V2Vnum
    for r=1:RBnum
        Fg_V2V_mat(i,r)=rand;
        Fg_V2V_BS(i,r)=rand;
    end
end
for i=1:V2Inum
    
    for r=1:RBnum
        Fg_V2I_mat(i,r)=rand;
%         V2I_min_Rate(i,r)=rand*30000;

    end
end


for i=1:V2Inum
    for j=1:V2Vnum
        for r=1:RBnum
            Fg_V2V_V2I_mat(i,j,r)=rand;
        end
    end
end
for j=1:V2Vnum
    for k=1:V2Vnum
        for r=1:RBnum
            Fg_V2V_V2V_mat(j,k,r)=rand;
        end
    end
end
% save V2I_min_Rate.mat V2I_min_Rate
% save Fg_V2V_BS.mat Fg_V2V_BS
% save Fg_V2V_mat.mat Fg_V2V_mat
% save Fg_V2I_mat.mat Fg_V2I_mat
% save Fg_V2V_V2I_mat.mat Fg_V2V_V2I_mat
% save Fg_V2V_V2V_mat.mat Fg_V2V_V2V_mat

RBnum=V2Inum;
V2I_min_Rate=zeros(V2Inum,RBnum);
for i=1:V2Inum
    for r=1:RBnum
        V2I_min_Rate(i,r)=SystemCoefficient.MRQ+rand*SystemCoefficient.Range;
    end
end

save([SystemCoefficient.VariablePath 'V2I_min_Rate'], 'V2I_min_Rate')
save([SystemCoefficient.VariablePath  'Fg_V2V_BS'], 'Fg_V2V_BS')
save([SystemCoefficient.VariablePath 'Fg_V2V_mat'], 'Fg_V2V_mat')
save([SystemCoefficient.VariablePath 'Fg_V2I_mat'], 'Fg_V2I_mat')
save([SystemCoefficient.VariablePath 'Fg_V2V_V2I_mat'], 'Fg_V2V_V2I_mat')
save([SystemCoefficient.VariablePath 'Fg_V2V_V2V_mat'], 'Fg_V2V_V2V_mat')

% load([SystemCoefficient.VariablePath '\LR_SumRate.mat'],'Lag_COST');
% load([SystemCoefficient.VariablePath '\LR_Runtime.mat'],'Lag_TIME');
% load([SystemCoefficient.VariablePath '\ES_SumRate.mat'],'Nume_COST');
% load([SystemCoefficient.VariablePath '\ES_Runtime.mat'],'Nume_TIME');
% load([SystemCoefficient.VariablePath '\Xlabel_LR_ES.mat'],'Xlabel');
