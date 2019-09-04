function [ClusterMat, kthClusterNum]=EstablishingClustersBasedonIntentionTables(UserVec,IntentionTable)
[Usernum,RBnum]=size(IntentionTable);
List=(IntentionTable(:,1))';
% for i=1:Usernum
%     [~,List(1,i)]=max(SNRmatTemp(i,:));%自己最满意的簇
% end
ClusterMat=zeros(RBnum,Usernum);
kthClusterNum=zeros(1,RBnum);

for i=1:Usernum  %建立分簇
    ithVLC=List(1,i);
    ClusterMat(ithVLC,kthClusterNum(1,ithVLC)+1)=UserVec(1,i);
    kthClusterNum(1,ithVLC)=kthClusterNum(1,ithVLC)+1;
end