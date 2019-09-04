function [DIS]=Distan_a_b(aCoordx,aCoordy,bCoordx,bCoordy)
%calculate the channel gain under fth RB
%V2I---Lfs=32.44+20lgd(km)+20lgf(MHz)
%V2V---Lfs=22.7log10(d1[m])+41+20log10(f[GHz])
% Gain=struct('g_i_BS',g_i_BS,'g_j_BS',g_j_BS,'g_j',g_j,'g_i_j',g_i_j,'g_j1_j',g_j1_j);
% ShadowingV2I=8;
% ShadowingV2V=3;
% BSAntennaGain=8;
% VehicleAntennaGain=3;
DIS=sqrt((aCoordx-bCoordx)^2+(aCoordy-bCoordy)^2);
% % d=DIS^(-4)
% if mode==1%V2I
%      g_a_b_f=32.44+20*log10(DIS*f)+ShadowingV2I-BSAntennaGain-VehicleAntennaGain;
% %     g_a_b_f=22.7*log10 (DIS) + 41 + 20*log10(f)+ShadowingV2I;
% %     g_a_b_f=128.1 + 37.6*log10(DIS/1000)+20*log10(f/1000)+ShadowingV2I;
% %     g_a_b_f=32.45+20*log(DIS*f/1000000)+ShadowingV2I;
% else
%     g_a_b_f=22.7*log10 (DIS) + 41 + 20*log10(f/5)+ShadowingV2V-VehicleAntennaGain;
% end
% % P=10*log10(0.0316)
% % G=P-g_a_b_f
% % P=10^(G/10)