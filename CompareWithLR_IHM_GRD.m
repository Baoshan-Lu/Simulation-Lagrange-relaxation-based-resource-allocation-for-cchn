function [LRrate,IHMrate,GRDrate]=CompareWithLR_IHM_GRD(SystemCoefficient,V2Inum,V2Vnum)
SumRateMat=CalculateSumRate(SystemCoefficient,V2Inum,V2Vnum);
%LRMÀ„∑®
[~,LRrate,LRTIME]=ThreeD_LagrangianRelaxation(SumRateMat);
%IHMÀ„∑®
[IHMrate,TIME1]=IterHungarinAlgo(SumRateMat);
%GRDÀ„∑®
GRDrate=GreedyResourceAllocation(SumRateMat);