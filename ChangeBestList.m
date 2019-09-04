function [ClusterMat, kthClusterNum]=ChangeBestList(UserVec,RBnum,V2Ista, UnableLink, uablefthRB)

% function  ChangeBestList()
% 
% % V2Inum=3;
% % UserVec=[1,2,3,4,7,8];V2Ista=7; [ClusterMat, kthClusterNum]=
% 
% UserVec=[1,2,3,4,7,8],RBnum=3,V2Ista=8, UnableLink=3, fthRB=3

load V2Icoord.mat V2Icoord;
load V2Vcoord.mat V2Vcoord;
load Fg_V2V_BS.mat Fg_V2V_BS
load Fg_V2V_mat.mat Fg_V2V_mat
load Fg_V2I_mat.mat Fg_V2I_mat
load Fg_V2V_V2I_mat.mat Fg_V2V_V2I_mat
load Fg_V2V_V2V_mat.mat Fg_V2V_V2V_mat

BS_x=547;
BS_y=547;

% RBnum=V2Inum;
%按照SNR选择最佳的RB，建立各个Link的列表

b=(UserVec~=0);
Usernum=sum(b(:));

SNRmat=zeros(Usernum,RBnum);

for i=1:Usernum
    if UserVec(1,i)==UnableLink
        UnableLink=i
        break;
    end
    
end


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
save SNRmat.mat SNRmat



load SNRmat.mat SNRmat

% for i=1:Usernum
%     SNRmatChan(1,i)=SNRmat(UserVec(1,i),:);
% end

SNRmat(UnableLink,uablefthRB)=-2
% 
% SNRmat=SNRmatChan;
% 
% save SNRmat.mat SNRmat
% load SNRmat.mat SNRmat

SNRmatTemp=SNRmat

List=zeros(1,Usernum);

%将不能使用的资源配对设为不可用

% SNRmatTemp(UnableLink,fthRB)=22

SNRmatTemp

for i=1:Usernum
    [~,List(1,i)]=max(SNRmatTemp(i,:));%自己最满意的簇
end
ClusterMat=zeros(RBnum,Usernum);
kthClusterNum=zeros(1,RBnum);

for i=1:Usernum  %建立分簇
    ithVLC=List(1,i);
    ClusterMat(ithVLC,kthClusterNum(1,ithVLC)+1)=UserVec(1,i);
    kthClusterNum(1,ithVLC)=kthClusterNum(1,ithVLC)+1;
end

