function [ClusterMat,kthClusterNum]=RandV2VClustering(ClusterNum,V2Vnum)
ClusterMat=zeros(ClusterNum,V2Vnum);
kthClusterNum=zeros(1,ClusterNum);

for i=1:V2Vnum
    %随机选择一个簇
    VLCselect=randint(1,1,[1,ClusterNum]);
    ClusterMat(VLCselect,kthClusterNum(1,VLCselect)+1)=i;%将i放入簇VLCselect
    kthClusterNum(1,VLCselect)=kthClusterNum(1,VLCselect)+1;%簇VLCselect,计数
end
