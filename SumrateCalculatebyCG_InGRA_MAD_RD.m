function [CGrate,InGRArate,MADratr,RDrate]=SumrateCalculatebyCG_InGRA_MAD_RD(SystemCoefficient,V2Inum,V2Vnum)
%%IntraGRA算法
[InGRArate,~,ClusterMat_Fin,kthClusterNum_Fin]=IntraGraAlgoAvaible(SystemCoefficient,V2Inum,V2Vnum);
[CGrate,~]=CoorperativeGameforV2V(SystemCoefficient,ClusterMat_Fin,kthClusterNum_Fin);
%     % %     最近分配
%     DHrate1=DistaceVLCbasedHGrate(V2Inum,V2Vnum,1);

% %     %最远分配
MADratr=DistaceVLCbasedHGrate(SystemCoefficient,V2Inum,V2Vnum,2);%距离最远


% %     %随机分配
RDrate=RandomV2V_V2I_RB_allocate(SystemCoefficient,V2Inum,V2Vnum);



