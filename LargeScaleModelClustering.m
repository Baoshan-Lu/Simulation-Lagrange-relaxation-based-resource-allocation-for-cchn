function [ClusterMat,kthClusterNum]=LargeScaleModelClustering(V2Inum,V2Vnum)
% function LargeScaleModelClustering()
% V2Inum=8,V2Vnum=15

load V2Icoord.mat V2Icoord;
load V2Vcoord.mat V2Vcoord;


ClusterNum=V2Inum;
kthClusterNum=zeros(1,ClusterNum);
ClusterMat=zeros(ClusterNum,V2Vnum);

% V2Vvec=randperm(numel(1:V2Vnum));%随机V2V序列
V2Vvec=1:V2Vnum;
%% 初始化，每个簇有一个V2V
if V2Vnum<ClusterNum
    InitVLCnum=V2Vnum;
else
     InitVLCnum=ClusterNum;
end
for i=1:InitVLCnum
    ClusterMat(i,1)=V2Vvec(1,i);
    kthClusterNum(1,i)=1;
end

%% 剩余的V2V，根据距离选定
InterI2K=zeros(1,ClusterNum);
if ClusterNum<V2Vnum %若V2V远大于簇数，开始进行下一步的选取
    for i=ClusterNum+1:V2Vnum       
        ithV2V=V2Vvec(1,i);
        for j=1:ClusterNum %簇
            ClusterInter=0;
            for k=1:kthClusterNum(1,j) %簇内V2V个数
                %计算V2V i 与 簇内 V2V k的干扰
                i2k_Iter=Distan_a_b(V2Vcoord(1,ithV2V),V2Vcoord(2,ithV2V),...
                    V2Vcoord(3,ClusterMat(j,k)),V2Vcoord(4,ClusterMat(j,k)));
                k2i_Iter=Distan_a_b(V2Vcoord(1,ClusterMat(j,k)),V2Vcoord(2,ClusterMat(j,k)),...
                    V2Vcoord(3,ithV2V),V2Vcoord(4,ithV2V));
                ClusterInter=ClusterInter+i2k_Iter+k2i_Iter;               
            end
            Average=ClusterInter/(2*kthClusterNum(1,j));
            InterI2K(1,j)=Average/1000;
        end
        [~,VLC_selected]=max(InterI2K);%选出簇
        ClusterMat(VLC_selected,kthClusterNum(1,VLC_selected)+1)=ithV2V;%将iV2V放进簇中
        kthClusterNum(1,VLC_selected)=kthClusterNum(1,VLC_selected)+1;
    end
end
