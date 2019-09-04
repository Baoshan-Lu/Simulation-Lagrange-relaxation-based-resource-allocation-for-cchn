function [Rifk]=CalculateWeightofV2I_RB_VLC(SystemCoefficient,ithV2I,fthRB,kthV2Vcluster,V2VCluster,kthClusterNum)
%calculate the V2I-RB-VLC weight
%system cooefficient
Bandwith=SystemCoefficient.Bandwith;
P_Noise=SystemCoefficient.P_Noise;
PtrV2V=SystemCoefficient.PtrV2V;
PtrV2I=SystemCoefficient.PtrV2I;

BS_x=SystemCoefficient.BS_x;
BS_y=SystemCoefficient.BS_y;


%minimum rate requiremnt
% R0=2.6e+03; %最小速率要求
% R0=0;
%RB carrier
% fc=2.5+fthRB*0.1/2;


load([SystemCoefficient.VariablePath '\Fg_V2V_BS.mat'],'Fg_V2V_BS');
load([SystemCoefficient.VariablePath '\Fg_V2V_mat.mat'],'Fg_V2V_mat');

load([SystemCoefficient.VariablePath '\Fg_V2I_mat.mat'],'Fg_V2I_mat');
load([SystemCoefficient.VariablePath '\Fg_V2V_V2I_mat.mat'],'Fg_V2V_V2I_mat');

load([SystemCoefficient.VariablePath '\Fg_V2V_V2V_mat.mat'],'Fg_V2V_V2V_mat');
load([SystemCoefficient.VariablePath '\V2I_min_Rate.mat'],'V2I_min_Rate');
% load Fg_V2V_BS.mat Fg_V2V_BS
% load Fg_V2V_mat.mat Fg_V2V_mat
% 
% load Fg_V2I_mat.mat Fg_V2I_mat
% load Fg_V2V_V2I_mat.mat Fg_V2V_V2I_mat
% load Fg_V2V_V2V_mat.mat Fg_V2V_V2V_mat
% 
% load V2I_min_Rate.mat V2I_min_Rate

% load V2I_min_Rate_Vari.mat V2I_min_Rate_Vari

% load('V2Icoord.mat');
% load('V2Vcoord.mat');
load([SystemCoefficient.VariablePath '\V2Icoord.mat'],'V2Icoord');
load([SystemCoefficient.VariablePath '\V2Vcoord.mat'],'V2Vcoord');



%计算簇内V2V速率和，V2I的速率
Rj=0;
Pj_BS_rec=0;
%第i个V2I在BS出的功率
% Pi_rec=PtrV2I*ChannelGain(V2Icoord(1,ithV2I),V2Icoord(2,ithV2I),500,500,fc,1);
NonV2I=0;
if ithV2I~=0  %非空V2I
    Pi_rec=PtrV2I*Fg_V2I_mat(ithV2I,fthRB)*Pathloss(V2Icoord(1,ithV2I),V2Icoord(2,ithV2I), BS_x,BS_y);
    
else
    Pi_rec=0;
    NonV2I=1;
end

%如果簇k为空,速率直接为0
if kthClusterNum(1,kthV2Vcluster)==0
    Rifk=0;
    
else%簇k不为空
    
    for j=1:kthClusterNum(1,kthV2Vcluster) %一个V2V的速率
        kthVLC=V2VCluster(kthV2Vcluster,:);%取出第K簇的V2V
        
        jthV2V=kthVLC(1,j);
        %j发射端
        jthV2Vtransmitter_x=V2Vcoord(1,kthVLC(1,j));
        jthV2Vtransmitter_y=V2Vcoord(2,kthVLC(1,j));
        %j接收端
        jthV2Vreceiver_x=V2Vcoord(3,kthVLC(1,j));
        jthV2Vreceiver_y=V2Vcoord(4,kthVLC(1,j));
        %第j个V2V接收端的功率
        %         Pj_rec=PtrV2V*ChannelGain(jthV2Vtransmitter_x,jthV2Vtransmitter_y,...
        %             jthV2Vreceiver_x,jthV2Vreceiver_y,fc,2);
        
        Pj_rec=PtrV2V*Fg_V2V_mat(jthV2V,fthRB)*Pathloss(jthV2Vtransmitter_x,jthV2Vtransmitter_y,...
            jthV2Vreceiver_x,jthV2Vreceiver_y);
        
        %第j个V2V接收端受到V2I链路的干扰功率
        if NonV2I~=1
            PithV2I_jthV2V=PtrV2I*Fg_V2V_V2I_mat(ithV2I,jthV2V,fthRB)*Pathloss(V2Icoord(1,ithV2I),V2Icoord(2,ithV2I),...
                jthV2Vreceiver_x,jthV2Vreceiver_y);
        else
            PithV2I_jthV2V=0;
        end
        %         kthVLC
        
        kthVLC(kthVLC==kthVLC(1,j))=[];%删除掉第j个,剩余为干扰
        
        Pj1_rec=0;
        %除jth V2V外所有的簇内V2V干扰
        
        %         kthClusterNum(1,kthV2Vcluster)-1
        
        for L=1:kthClusterNum(1,kthV2Vcluster)-1
            %j1发射端
            j1thV2Vtransmitter_x=V2Vcoord(1,kthVLC(1,L));
            j1thV2Vtransmitter_y=V2Vcoord(2,kthVLC(1,L));
            j1thVLC=kthVLC(1,L);
            
            %其余簇内V2V对发射端j接收端的干扰功率
            %             Pj1_rec=Pj1_rec+PtrV2V*ChannelGain(j1thV2Vtransmitter_x,j1thV2Vtransmitter_y,...
            %                 jthV2Vreceiver_x,jthV2Vreceiver_y,fc,2);
            
            Pj1_rec=Pj1_rec+PtrV2V*Fg_V2V_V2V_mat(j1thVLC,jthV2V,fthRB)*...
                Pathloss(j1thV2Vtransmitter_x,j1thV2Vtransmitter_y,...
                jthV2Vreceiver_x,jthV2Vreceiver_y);
            
            %             %其余簇内V2V对ithV2I的干扰功率
            %             Pj1_BS=Pj1_BS+PtrV2V*Fg_V2V_BS(1,kthVLC(1,L))*...
            %                 Pathloss(j1thV2Vtransmitter_x,j1thV2Vtransmitter_y,...
            %                 BS_x,BS_y);
            
            
        end
        %第j个V2V的速率,所有速率的
        Rj=Rj+Bandwith*log(1+Pj_rec/(P_Noise+PithV2I_jthV2V+Pj1_rec)); %噪声，V2I干扰，V2V簇内干扰
        
        %V2V簇所有V2V对基站（V2I）的干扰功率
        Pj_BS_rec=Pj_BS_rec+PtrV2V*Fg_V2V_BS(jthV2V,fthRB)*...
            Pathloss(jthV2Vtransmitter_x,jthV2Vtransmitter_y,...
            BS_x,BS_y);
    end
    
    %V2I的速率
    RateV2I=Bandwith*log(1+Pi_rec/(P_Noise+Pj_BS_rec));%噪声，V2V对BS的所有干扰
    
    if NonV2I~=1%非空V2I
          R0=V2I_min_Rate(ithV2I,1);%V2I速率要求
%         R0=0;
        if RateV2I>=R0 %不满足最低速率,为0
            Rifk=Rj;
        else
            Rifk=0;
        end
    else
        
        Rifk=Rj;
    end
    
end