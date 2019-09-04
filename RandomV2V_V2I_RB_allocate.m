function [RandomSumrate,ClusterMat,kthClusterNum]=RandomV2V_V2I_RB_allocate(SystemCoefficient,V2Inum,V2Vnum)

[ClusterMat,kthClusterNum]=RandV2VClustering(V2Inum,V2Vnum);%随机分簇
V2Ivec=randperm(numel(1:V2Inum));%随机分配V2I
RBvec=randperm(numel(1:V2Inum));%随机分配V2V
RandomSumrate=0;
for i=1:V2Inum
    [Rifk]=CalculateWeightofV2I_RB_VLC(SystemCoefficient,V2Ivec(1,i),RBvec(1,i),i,ClusterMat,kthClusterNum);
    RandomSumrate=RandomSumrate+Rifk;
end
