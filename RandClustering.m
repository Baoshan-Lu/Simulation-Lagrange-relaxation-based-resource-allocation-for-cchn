function [ClusterMat,kthClusterNum]=RandClustering(ClusterNum,V2Vnum2)
%randomly generate the V2V clusters
if V2Vnum2<ClusterNum %簇数比V2V还大，异常
    fprintf(1,'Warning:the Cluster number is more than that of V2V,Exit!!! ');
    ClusterMat=0;
    kthClusterNum=0;
else
    ClusterMat=zeros(ClusterNum,V2Vnum2);
% %     load('V2Vcoord.mat');
% %     [~,V2Vcoordnum]=size(V2Vcoord);
% %     [ranvec2]=GenerateRandintVector(V2Vcoordnum);
% %     V2Vranvec=ranvec2(1:V2Vnum2);%随机挑选出V2Vnum个 
    
    V2Vranvec=(1:V2Vnum2);%随机挑选出V2Vnum个 
    kthClusterNum=ones(1,ClusterNum);
    
    %随机分配一个V2V到每个簇，确保每个簇至少有一个
    ranvec1=V2Vranvec(1:ClusterNum);
    ClusterMat(:,1)=ranvec1';
   
    %如果数量超过簇，再分配一个V2V到随机簇
    Restranvec=V2Vranvec(1+ClusterNum:V2Vnum2);
    [~,restv2vNum]=size(Restranvec);
    for i=1:restv2vNum
        CluNum=randint(1,1,[1,ClusterNum]);%任意选出一簇
        for j=1:V2Vnum2
            if ClusterMat(CluNum,j)==0 %if ClusterMat(CluNum,j)is empty,insert new element
                ClusterMat(CluNum,j)=Restranvec(1,i);%在未分配的V2V，从第一个开始分配到随机的簇
                kthClusterNum(1,CluNum)=kthClusterNum(1,CluNum)+1;
                break;
            end
        end
    end
end



