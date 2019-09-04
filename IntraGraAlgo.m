function IntraGraAlgo()

clc
clear

V2Vnum=10;V2Inum=5;V2Ista=V2Vnum+1;

RBnum=V2Inum;Usernum=V2Inum+V2Vnum;

UserVec=1:Usernum;

%按照SNR选择最佳的RB，建立各个Link的列表
[IntentionTable]=CreatBestList(UserVec,RBnum,V2Ista)
[ClusterMat, kthClusterNum]=EstablishingClustersBasedonIntentionTables(UserVec,IntentionTable)

ClusterMat_Fin=zeros(RBnum,Usernum);
kthClusterNum_Fin=zeros(1,RBnum);

Nonempty=sum(kthClusterNum);
%
% fthRB=1;
Finish=0;

while Nonempty>0  && Finish==0 %子集非空
    %% 从虚拟簇1开始遍历有没有用户
    for i=1:RBnum
        if  kthClusterNum(1,i)~=0
            fthRB=i
            Finish=0;
            break;
        else
            Finish=1;
        end
    end
    Finish
    
    
    %     if kthClusterNum(1,fthRB)==0 %如果虚拟簇中无用户
    %         fthRB=fthRB+1
    % else
    
    if  Finish==0
        %% 开始进入算法
        Conflict_Update=0;
        
        Rifk=zeros(1,kthClusterNum(1,fthRB));
        %% 选择k簇中最好的链路
        if kthClusterNum_Fin(1,fthRB)==0 %簇中还没用户占用
            for i=1:kthClusterNum(1,fthRB)
                Rifk(1,i)=RateofSingleCluster(ClusterMat(fthRB,:),V2Ista,fthRB);
            end
            [~,s]=max(Rifk);%选择速率最大的用户进簇
            LinkSelected=ClusterMat(fthRB,s)
            
        else
            %% 簇中已经有用户,选择使干扰最小的
            InterferList=zeros(1,kthClusterNum(1,fthRB));
            for i=1:kthClusterNum(1,fthRB)
                
                fthRB
                kthClusterNum_Fin
                kthCluUserVec=zeros(1,kthClusterNum_Fin(1,fthRB))
                
                for k=1:kthClusterNum_Fin(1,fthRB)
                    kthCluUserVec(1,k)=ClusterMat_Fin(fthRB,k) %要在原来的位置
                end
                
                %试着将 虚拟簇ClusterMat(fthRB,i)的用户i放进去
                SelectedVirLink=ClusterMat(fthRB,i)
                kthCluUserVec=[kthCluUserVec SelectedVirLink]
                
                %计算新速率
                InterferNew=LinkInterCluster(kthCluUserVec,V2Ista,fthRB);
                InterferList(1,i)=InterferNew
            end
            %% 选择速率最大的用户进簇
            [MinInterfer,s]=min(InterferList);
            if MinInterfer==inf %如果最小的都是inf，是V2I链路
                %两个V2I链路在同一个簇，冲突
                Conflict_Update=1
                %                 IntentionTable_new=AdjustIntenTablesBaseConditions(IntentionTable,UnableLink)
            else
                Conflict_Update=0
            end
            LinkSelected=ClusterMat(fthRB,s)
        end
        
        %%  根据选择的用户进行速率对比
        % 原簇速率
        kthCluUserVec2=zeros(1,kthClusterNum_Fin(1,fthRB));
        if kthClusterNum_Fin(1,fthRB)==0 %簇中无用户
            kthCluUserVec2=0;
        else  %存在用户，则提出用户
            for k=1:kthClusterNum_Fin(1,fthRB)
                kthCluUserVec2(1,k)=ClusterMat_Fin(fthRB,k);
            end
        end
        
        %计算总速率
        VLCrate_old=RateofSingleCluster(kthCluUserVec2,V2Ista,fthRB)
        
        % 将选中的链路放进，计算速率提升的情况
        if kthClusterNum_Fin(1,fthRB)==0
            kthCluUserVec2=LinkSelected
        else
            kthCluUserVec2=[kthCluUserVec2 LinkSelected]
        end
        
        %新的速率
        VLCrate_new=RateofSingleCluster(kthCluUserVec2,V2Ista,fthRB)
        
        if VLCrate_new>VLCrate_old && Conflict_Update==0 % 有性能提升,且不是冲突的V2I
            
            for i=1:Usernum
                if UserVec(1,i)==LinkSelected
                    DeletLink=i
                    break;
                end
                
            end
            % 将用户放进簇中
            ClusterMat_Fin(fthRB,kthClusterNum_Fin(1,fthRB)+1)=LinkSelected
            kthClusterNum_Fin(1,fthRB)=kthClusterNum_Fin(1,fthRB)+1
            
            
            % 删除 LinkSelected,更新意向表
            UserVec(:,DeletLink)=[]
            IntentionTable(DeletLink,:)=[]
            [ClusterMat, kthClusterNum]=EstablishingClustersBasedonIntentionTables(UserVec,IntentionTable)
            
            
            
        else %若不能提升，则删除其对应资源
            
            %更新喜好列表
            for i=1:Usernum  %检查其在用户集中的位置
                if UserVec(1,i)==LinkSelected
                    UnableLink=i
                    break;
                end
            end
            
            %但是只剩下最好一个资源块的时候，就直接给用了
            
            
            
            EmptyRB=IntentionTable(UnableLink,2:RBnum)
            
            %
            
            
            if (any(EmptyRB)==0  || size(IntentionTable,1)==1)    %已经无可用的资源块，则把最后的资源块给用户
                
                % 将用户放进簇中
                ClusterMat_Fin(fthRB,kthClusterNum_Fin(1,fthRB)+1)=LinkSelected
                kthClusterNum_Fin(1,fthRB)=kthClusterNum_Fin(1,fthRB)+1
                
                % 删除 LinkSelected,更新意向表
                UserVec(:,UnableLink)=[]
                IntentionTable(UnableLink,:)=[]
                [ClusterMat, kthClusterNum]=EstablishingClustersBasedonIntentionTables(UserVec,IntentionTable)
            else
                
                % 重新建立列表
                IntentionTable=AdjustIntenTablesBaseConditions(IntentionTable,UnableLink)
                [ClusterMat, kthClusterNum]=EstablishingClustersBasedonIntentionTables(UserVec,IntentionTable)
                
            end
            
        end
    end
    
end
ClusterMat_Fin
kthClusterNum_Fin