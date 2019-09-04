function GDsumrate= GreedyAllocateRate(V2Inum,V2Vnum)

%贪心算法，V2I选定好RB，V2V再去选V2I簇

% V2Inum=3,V2Vnum=5

RBnum=V2Inum;
A=zeros(V2Inum,RBnum);
for i=1:V2Inum
    ithV2I=i;
    for r=1:RBnum
        fthRB=r;
        A(i,r)=CalculateRateV2I_RB(ithV2I,fthRB);
    end
end
[RBvec,~]=MaxHungarian(A);

V2Vvec=randperm(numel(1:V2Vnum));
ClusterMat=zeros(V2Inum,V2Vnum);
kthClusterNum=zeros(1,V2Inum);
Allposs=zeros(1,V2Inum);

for i=1:V2Vnum
    ithV2V=V2Vvec(1,i);
    ClusterMat1=ClusterMat;
    kthClusterNum1=kthClusterNum;
    for j=1:V2Inum
        jthV2I=j;
        %将V2V放进簇中
        ClusterMat1(jthV2I,kthClusterNum1(1,jthV2I)+1)=ithV2V;
        kthClusterNum1(1,jthV2I)=kthClusterNum1(1,jthV2I)+1;
        [Rifk]=CalculateWeightofV2I_RB_VLC(jthV2I,RBvec(1,jthV2I),jthV2I,ClusterMat1,kthClusterNum1);
        Allposs(1,j)=Rifk;
    end
    [~,VLCselected]=max(Allposs);
    ClusterMat(VLCselected,kthClusterNum(1,VLCselected)+1)=ithV2V;
    kthClusterNum(1,VLCselected)=kthClusterNum(1,VLCselected)+1;
end

%算总速率
GDsumrate=0;
for i=1:V2Inum
    GDsumrate=GDsumrate+CalculateWeightofV2I_RB_VLC(i,RBvec(1,i),i,ClusterMat,kthClusterNum);
end


