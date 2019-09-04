function [SumRateMat]=EsCalculateSumRate(V2Inum,V2Vnum)

RBnum=V2Inum;
ClusterNum=V2Inum;
SumRateMat=zeros(V2Inum,RBnum,ClusterNum);

%第一步随机分簇
ClusterNum=V2Inum;
% [V2VCluster,kthClusterNum]=RandClustering(ClusterNum,V2Vnum);
% save V2VCluster.mat V2VCluster  %随机分配的簇内V2V个数
% save kthClusterNum.mat kthClusterNum  %簇内V2V
% 
% %使用随机分簇后的数据
% load V2VCluster.mat V2VCluster;
% load kthClusterNum.mat  kthClusterNum;
% %第二步计算权值，得出速率矩阵
count=0;
for i=1:V2Inum
    for f=1:RBnum
        for k=1:ClusterNum
          [Rifk]=CalculateWeightofV2I_RB_VLC(i,f,k,V2VCluster,kthClusterNum);
          SumRateMat(i,f,k)=Rifk;
          count=count+1
        end
    end
end
% SumRateMat
save('SumRateMat');
