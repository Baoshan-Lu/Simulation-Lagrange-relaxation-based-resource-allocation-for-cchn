function [CGrate_old,t]=CoorperativeGameforV2V(SystemCoefficient,V2VCluster,kthClusterNum)
%博弈论优化速率
V2Inum=size(V2VCluster,1);
RBnum=V2Inum;
ClusterNum=V2Inum;
SumRateMat=zeros(V2Inum,RBnum,ClusterNum);
MaxFailNum=15+(V2Inum+sum(kthClusterNum));
tic
%% 随机分配5*(V2Inum+sum(kthClusterNum))
ClusterNum=V2Inum;
% [V2VCluster,kthClusterNum]=RandV2VClustering(ClusterNum,V2Vnum);V2Inum,V2Vnum,


%% 计算速率矩阵

for i=1:V2Inum
    for f=1:RBnum
        for k=1:ClusterNum
            [Rifk]=CalculateWeightofV2I_RB_VLC(SystemCoefficient,i,f,k,V2VCluster,kthClusterNum);
            SumRateMat(i,f,k)=Rifk;
        end
    end
end

%% LR三维匹配

[LRMatching,CGrate_old,LRTIME]=ThreeD_LagrangianRelaxation(SumRateMat);

if V2Inum<2
    
    GameInfor=['Only one V2I link!']
else

    %% 博弈
    converg=0;
    % MaxFailNum=100;%失败次数
    BreakCount=0;
  
    % 最终份簇情况
    ClusterMat_Fin=V2VCluster;
    kthClusterNum_Fin=kthClusterNum;
    
    while (converg==0)
        
        %% 随机选一个簇
        %     RanClu=randint(1,1,[1,ClusterNum])
        [ranvec2]=GenerateRandintVector(ClusterNum);
        for i=1:ClusterNum
            if kthClusterNum(1,ranvec2(1,i))~=0
                RanClu1=ranvec2(1,i);
                ranvec2(:,i)=[];
                break;
            end
        end
        
        %选择另外一个簇
        
        ranvec3=GenerateRandintVector(ClusterNum-1);
        RanC=ranvec2(1,ranvec3(1,1));
        
        %随机选择RanClu1簇中的一个V2V
        
        RanV2V1=randint(1,1,[1,kthClusterNum(1,RanClu1)]);
        
        %补到随机选择的另外一个簇
        %另外一个簇
        RanClu2=RanC;
        V2VCluster(RanClu2,kthClusterNum(1,RanClu2)+1)=V2VCluster(RanClu1,RanV2V1);%补到RanClu2簇的后面
        
        %第一个簇：如果RanV2V1<kthClusterNum(1,RanClu1),需要移动,让所有V2V紧凑
        G=kthClusterNum(1,RanClu1)-RanV2V1;
        if RanV2V1<kthClusterNum(1,RanClu1)
            for i=1:G
                V2VCluster(RanClu1,RanV2V1)= V2VCluster(RanClu1,RanV2V1+i);
            end
        end
        V2VCluster(RanClu1,kthClusterNum(1,RanClu1))=0;
        kthClusterNum(1,RanClu1)=kthClusterNum(1,RanClu1)-1;
        
        %第二个簇：
        kthClusterNum(1,RanClu2)=kthClusterNum(1,RanClu2)+1;%增加V2V个数
        
        
        
        
        %% 计算矩阵
        for i=1:V2Inum
            for f=1:RBnum
                for k=1:ClusterNum
                    [Rifk]=CalculateWeightofV2I_RB_VLC(SystemCoefficient,i,f,k,V2VCluster,kthClusterNum);
                    SumRateMat(i,f,k)=Rifk;
                end
            end
        end
        %%  重新计算LR速率
        [LRMatching,LRrate_new,LRTIME]=ThreeD_LagrangianRelaxation(SumRateMat);
        
        if (LRrate_new>CGrate_old)%如果有改善
            CGrate_old=LRrate_new;
            
            %将最优的分簇放入最终分簇
            ClusterMat_Fin=V2VCluster;
            kthClusterNum_Fin=kthClusterNum;
            
            
            BreakCount=0;%从头计数
        else
            %不能改善，保持原来的分簇
            V2VCluster=ClusterMat_Fin;
            kthClusterNum=kthClusterNum_Fin;
            
            
            BreakCount=BreakCount+1;%无法改善，则计数
            if BreakCount>MaxFailNum
                converg=1;%算法结束
            end
            
        end
        GameInfor=['RanVLC1=',num2str(RanClu1),', RanVLC2=',num2str(RanClu2),',  CGrate_old=',num2str(CGrate_old),', CGrate_new=',num2str(LRrate_new),', BreakCount=',num2str(BreakCount)]
        
    end
end
t=toc;
% V2VCluster
% LRrate_old