function InterGraghAlgo()
%考虑速率和干扰

V2Inum=3;V2Vnum=5;V2Ista=5;

RBnum=V2Inum;
Usernum=V2Inum+V2Vnum;

%按照SNR选择最佳的RB，建立各个Link的列表

UserVec=1:Usernum;

[IntentionTable]=CreatBestList(UserVec,RBnum,V2Ista)
[ClusterMat, kthClusterNum]=EstablishingClustersBasedonIntentionTables(UserVec,IntentionTable)


ClusterMat_Fin=zeros(RBnum,Usernum);
kthClusterNum_Fin=zeros(1,RBnum);



Nonempty=sum(kthClusterNum)

fthRB=1;

UnableLinkVec=zeros(1,Usernum);

while Nonempty>0  &&  fthRB<RBnum+1 %子集非空，继续分randint(1,1,[1,RBnum])
    
    if kthClusterNum(1,fthRB)==0 %如果虚拟簇中无用户
        fthRB=fthRB+1
        
    else
        
        
        Rifk=zeros(1,kthClusterNum(1,fthRB));
        
        %% 选择k簇中最好的链路
        if kthClusterNum_Fin(1,fthRB)==0 %簇中还没用户占用
            for i=1:kthClusterNum(1,fthRB)
                Rifk(1,i)=RateofSingleCluster(ClusterMat(fthRB,:),V2Ista,fthRB);
            end
            Rifk
            [~,s]=max(Rifk);%选择速率最大的用户进簇
            LinkSelected=ClusterMat(fthRB,s);
            
            EmptyFlag=1;
            
        else
            EmptyFlag=0;
            
            %% 如果不是，那就要选择簇内干扰小的Link
            InterferList=zeros(1,kthClusterNum(1,fthRB));
            
            %取出原簇中的成员
            
            %试探添加新成员
            for i=1:kthClusterNum(1,fthRB)
                
                kthCluUserVec=zeros(1,kthClusterNum_Fin(1,fthRB));
                for k=1:kthClusterNum_Fin(1,fthRB)
                    kthCluUserVec(1,i)=ClusterMat_Fin(fthRB,k);
                end
                kthCluUserVec
                
                %InterferOld=LinkInterCluster(kthCluUserVec,V2Ista,fthRB)
                
                %试着将 虚拟簇ClusterMat(fthRB,i)的用户i放进去
                SelectedVirLink=ClusterMat(fthRB,i)
                kthCluUserVec=[kthCluUserVec SelectedVirLink]
                
                %计算新速率
                InterferNew=LinkInterCluster(kthCluUserVec,V2Ista,fthRB)
                
                %             if InterferNew<InterferOld %加入后干扰变小
                %                 LinkSelected=SelectedVirLink
                %             end
                InterferList(1,i)=InterferNew
            end
            [MinInterfer,s]=min(InterferList);%选择速率最大的用户进簇
            
            if MinInterfer==inf %如果最小的都是inf
                UnableLink=ClusterMat(fthRB,s)
                %更新喜好列表
                
                UnableLinkVec(UnableLink)
                
                UnableLink
                fthRB
                [ClusterMat, kthClusterNum]=ChangeBestList(UserVec,RBnum,V2Ista, UnableLink, fthRB)
                
            else %否则，将较小干扰的用户选出
                LinkSelected=ClusterMat(fthRB,s)
            end
        end
        
        
        LinkSelected
        
        ClusterMat_Fin
        
        % 原簇速率
        kthCluUserVec2=zeros(1,kthClusterNum_Fin(1,fthRB));
        
        if kthClusterNum_Fin(1,fthRB)==0 %簇中无用户
            kthCluUserVec2=0;
        else
            for k=1:kthClusterNum_Fin(1,fthRB)
                kthCluUserVec2(1,i)=ClusterMat_Fin(fthRB,k);
            end
        end
        
        
        VLCrate_old=RateofSingleCluster(kthCluUserVec2,V2Ista,fthRB)
        
        % 将选中的链路放进，计算速率提升的情况
        if kthClusterNum_Fin(1,fthRB)==0
            kthCluUserVec2=LinkSelected
        else
            kthCluUserVec2=[kthCluUserVec2 LinkSelected]
            
        end
        VLCrate_new=RateofSingleCluster(kthCluUserVec2,V2Ista,fthRB)
        
        if VLCrate_new>VLCrate_old%有性能提升
            
            % 将用户放进簇中
            ClusterMat_Fin(fthRB,kthClusterNum_Fin(1,fthRB)+1)=LinkSelected
            kthClusterNum_Fin(1,fthRB)=kthClusterNum_Fin(1,fthRB)+1
            
            % 删除 LinkSelected,
            
            for i=1:Usernum
                if UserVec(1,i)==LinkSelected
                    DeletLink=i
                    break;
                end
                
            end
            
            UserVec(:,DeletLink)=[]
            
            % 更新意向表
            [ClusterMat, kthClusterNum]=CreatBestList(UserVec,RBnum,V2Vnum)
            
        else %若不能提升，则重新更新
            UnableLink=LinkSelected
            [ClusterMat, kthClusterNum]=ChangeBestList(UserVec,RBnum,V2Ista, UnableLink, fthRB)
            
        end
        
    end
end

