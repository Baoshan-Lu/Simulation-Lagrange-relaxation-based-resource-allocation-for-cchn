function TotalInterfer=LinkInterCluster(SystemCoefficient,UserVec,V2Ista,fthRB)
% 计算簇内干扰
% UserVec,RBnum,V2Ista,fthRB

% UserVec=[2,1,5,6],RBnum=1,V2Ista=6,fthRB=1

% load V2Icoord.mat V2Icoord;
% load V2Vcoord.mat V2Vcoord;
% load Fg_V2V_BS.mat Fg_V2V_BS
% load Fg_V2V_mat.mat Fg_V2V_mat
% load Fg_V2I_mat.mat Fg_V2I_mat
% load Fg_V2V_V2I_mat.mat Fg_V2V_V2I_mat
% load Fg_V2V_V2V_mat.mat Fg_V2V_V2V_mat

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
% V2Ivec=0;
% V2Vvec=0;
% V2Vnum=0;
% for i=1:Usernum
%     if UserVec(1,i)>=V2Ista %是V2I
%         if V2Ivec==0
%             V2Ivec=UserVec(1,i);
%         else
%             V2Ivec=[V2Ivec UserVec(1,i)];%将V2I分类出来
%         end
%     else
%         if V2Vvec==0
%             V2Vvec=UserVec(1,i);
%         else
%             V2Vvec=[V2Vvec UserVec(1,i)];%将V2V分类出来
%         end
%         V2Vnum=V2Vnum+1;
%     end
% end

%簇内两两计算干扰
PtrV2I= 0.1995;%功率
PtrV2V= 0.1995;

TotalInterfer=0;%总干扰

for i=1:Usernum
    ithLink=UserVec(1,i);
    if ithLink>=V2Ista %V2I链路
        ithLinkTransX=V2Icoord(1,ithLink-V2Ista+1);
        ithLinkTransY=V2Icoord(2,ithLink-V2Ista+1);
        ithLinkRecX=BS_x;
        ithLinkRecXY=BS_y;
        
        Link1V2I=1;
        
    else %V2V链路
        ithLinkTransX=V2Vcoord(1,ithLink);
        ithLinkTransY=V2Vcoord(2,ithLink);
        ithLinkRecX=V2Vcoord(3,ithLink);
        ithLinkRecXY=V2Vcoord(4,ithLink);
        Link1V2I=0;
    end
    
    UserVecTemp=UserVec;
    UserVecTemp(:,i)=[];
    
    TotalInterfer1=0;
    
    for j=1:Usernum-1
        jthLink=UserVecTemp(1,j);
        if jthLink>=V2Ista %V2I链路
            jthLinkTransX=V2Icoord(1,jthLink-V2Ista+1);
            jthLinkTransY=V2Icoord(2,jthLink-V2Ista+1);
            jthLinkRecX=BS_x;
            jthLinkRecXY=BS_y;
            Link2V2I=1;
        else %V2V链路
            jthLinkTransX=V2Vcoord(1,jthLink);
            jthLinkTransY=V2Vcoord(2,jthLink);
            jthLinkRecX=V2Vcoord(3,jthLink);
            jthLinkRecXY=V2Vcoord(4,jthLink);
            Link2V2I=0;
        end
        
        % 计算干扰
        if Link1V2I==1 && Link2V2I==1 %两个V2I干扰,无穷
            Interfer=inf;
            
        elseif Link1V2I==1 && Link2V2I==0 %第一个链路为V2I
            
            Interfer1=PtrV2I*Fg_V2V_V2I_mat(ithLink-V2Ista+1,jthLink,fthRB)*...
                (Distan_a_b(ithLinkTransX,ithLinkTransY,jthLinkRecX,jthLinkRecXY))^(-4);
            
            Interfer2=PtrV2I*Fg_V2V_V2I_mat(jthLink,ithLink-V2Ista+1,fthRB)*...
                (Distan_a_b(jthLinkTransX,jthLinkTransY,ithLinkRecX,ithLinkRecXY))^(-4);
            
            Interfer=Interfer1+Interfer2;
            
            
        elseif Link1V2I==0 && Link2V2I==1 %第er个链路为V2I
            Interfer1=PtrV2I*Fg_V2V_V2I_mat(ithLink,jthLink-V2Ista+1,fthRB)*...
                (Distan_a_b(ithLinkTransX,ithLinkTransY,jthLinkRecX,jthLinkRecXY))^(-4);
            
            Interfer2=PtrV2V*Fg_V2V_V2I_mat(jthLink-V2Ista+1,ithLink,fthRB)*...
                (Distan_a_b(jthLinkTransX,jthLinkTransY,ithLinkRecX,ithLinkRecXY))^(-4);
            
            Interfer=Interfer1+Interfer2;
            
            
        elseif Link1V2I==0 && Link2V2I==0 %第一个链路为V2V
            Interfer1=PtrV2V*Fg_V2V_V2V_mat(ithLink,jthLink,fthRB)*...
                (Distan_a_b(ithLinkTransX,ithLinkTransY,jthLinkRecX,jthLinkRecXY))^(-4);
            
            Interfer2=PtrV2V*Fg_V2V_V2V_mat(jthLink,ithLink,fthRB)*...
                (Distan_a_b(jthLinkTransX,jthLinkTransY,ithLinkRecX,ithLinkRecXY))^(-4);
            
            Interfer=Interfer1+Interfer2;

        end
        
        TotalInterfer1=TotalInterfer1+Interfer;
    end
    
    TotalInterfer=TotalInterfer+TotalInterfer1;
    
    
end
