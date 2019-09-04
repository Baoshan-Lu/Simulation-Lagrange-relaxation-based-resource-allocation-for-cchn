function Rifk=RateofSingleCluster(SystemCoefficient,UserVec,V2Ista,fthRB)

% UserVec=[1,2,3,7,5,6],V2Ista=8,fthRB=1
%  判别V2V和V2I链路

%判断总用户的个数
b=(UserVec~=0);
UserNum=sum(b(:));

if UserNum==0 %有用户
    Rifk=0;
else
    ithV2I=0;
    %判断是否有V2I
    for i=1:UserNum
        if UserVec(1,i)>=V2Ista
            ithV2I=UserVec(1,i)-V2Ista+1;
            V2IlinkNum=i;
            break;
        end
    end
    
    if ithV2I~=0 %有V2I链路
        UserVec(:,V2IlinkNum)=[];
        UserNum=UserNum-1;
    end
    if UserNum>0
        V2VCluster=UserVec;
        kthV2Vcluster=1;
        kthClusterNum=UserNum;
        %V2V,V2I的速率计算簇的速率
        [Rifk]=CalculateWeightofV2I_RB_VLC(SystemCoefficient,ithV2I,fthRB,kthV2Vcluster,V2VCluster,kthClusterNum);
        
    else %只有V2I的情况下
        
        [Rifk]=CalculateRateV2I_RB(SystemCoefficient,ithV2I,fthRB);
        
    end
end