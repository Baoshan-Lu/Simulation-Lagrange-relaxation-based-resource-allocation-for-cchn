% function [ClusterMat, kthClusterNum]=CreatBestList(UserVec,RBnum,V2Ista)
function [IntentionTable]=CreatBestList(SystemCoefficient,UserVec,RBnum,V2Ista)

% function CreatBestList()
% % V2Inum=3;
% UserVec=[1,2,3,4,7,8];V2Ista=7;RBnum=3

load([SystemCoefficient.VariablePath '\Fg_V2V_BS.mat'],'Fg_V2V_BS');
load([SystemCoefficient.VariablePath '\Fg_V2V_mat.mat'],'Fg_V2V_mat');

load([SystemCoefficient.VariablePath '\Fg_V2I_mat.mat'],'Fg_V2I_mat');
load([SystemCoefficient.VariablePath '\Fg_V2V_V2I_mat.mat'],'Fg_V2V_V2I_mat');

load([SystemCoefficient.VariablePath '\Fg_V2V_V2V_mat.mat'],'Fg_V2V_V2V_mat');
load([SystemCoefficient.VariablePath '\V2I_min_Rate.mat'],'V2I_min_Rate');
% load Fg_V2V_BS.mat Fg_V2V_BS
% load Fg_V2V_mat.mat Fg_V2V_mat
% 
% load Fg_V2I_mat.mat Fg_V2I_mat
% load Fg_V2V_V2I_mat.mat Fg_V2V_V2I_mat
% load Fg_V2V_V2V_mat.mat Fg_V2V_V2V_mat
% 
% load V2I_min_Rate.mat V2I_min_Rate

% load V2I_min_Rate_Vari.mat V2I_min_Rate_Vari

% load('V2Icoord.mat');
% load('V2Vcoord.mat');
load([SystemCoefficient.VariablePath '\V2Icoord.mat'],'V2Icoord');
load([SystemCoefficient.VariablePath '\V2Vcoord.mat'],'V2Vcoord');


BS_x=547;
BS_y=547;

% RBnum=V2Inum;
%按照SNR选择最佳的RB，建立各个Link的列表

b=(UserVec~=0);
Usernum=sum(b(:));

SNRmat=zeros(Usernum,RBnum);


%% 计算SNR矩阵
for i=1:Usernum
    %计算SNR
      ithLink=UserVec(1,i);
    for r=1:RBnum
        fthRB=r;%选择资源
        if  ithLink>=V2Ista %V2I 链路
            ithV2I=ithLink-V2Ista+1;
            SNRmat(i,r)=Fg_V2I_mat(ithV2I,fthRB)*(Distan_a_b(V2Icoord(1,ithV2I),V2Icoord(2,ithV2I),...
                BS_x,BS_y))^(-4);
        else
            ithV2V=ithLink;
            SNRmat(i,r)=Fg_V2V_mat(ithV2V,fthRB)*(Distan_a_b(V2Vcoord(1,ithV2V),V2Vcoord(2,ithV2V),...
                V2Vcoord(3,ithV2V),V2Vcoord(4,ithV2V)))^(-4);
        end
    end
end

%% 建立喜好表
SNRmatTemp=SNRmat*10000;
List=zeros(1,Usernum);




IntentionTable=zeros(Usernum,RBnum);

for i=1:Usernum
    
     [a,b]=sort(SNRmatTemp(i,:),'descend');
     IntentionTable(i,:)=b;
     
end
    
save SNRmat.mat SNRmat

% % List=(IntentionTable(:,1))';
% % 
% % 
% % 
% % 
% % save SNRmat.mat SNRmat
% % 
% % % for i=1:Usernum
% % %     [~,List(1,i)]=max(SNRmatTemp(i,:));%自己最满意的簇
% % % end
% % ClusterMat=zeros(RBnum,Usernum);
% % kthClusterNum=zeros(1,RBnum);
% % 
% % for i=1:Usernum  %建立分簇
% %     ithVLC=List(1,i);
% %     ClusterMat(ithVLC,kthClusterNum(1,ithVLC)+1)=UserVec(1,i);
% %     kthClusterNum(1,ithVLC)=kthClusterNum(1,ithVLC)+1;
% % end
% % % ClusterMat
% % % kthClusterNum
