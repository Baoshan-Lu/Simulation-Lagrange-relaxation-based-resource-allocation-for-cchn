function [ClusterMat,kthClusterNum]=EsCluster(V2Inum,V2Vnum,C)
%V2V 排队序列
% V2Inum=3
% V2Vnum=4
% C=[1 3 2 1]
ClusterMat=zeros(V2Inum,V2Vnum);
kthClusterNum=zeros(1,V2Inum);
for i=1:V2Inum
    for j=1:V2Vnum
       if C(1,j)==i
           ClusterMat(i,kthClusterNum(1,i)+1)=j;%将V2V存入该簇
           kthClusterNum(1,i)=kthClusterNum(1,i)+1;%簇中的V2V数目增加
           C(1,j)=nan;
       end;
    end
end

