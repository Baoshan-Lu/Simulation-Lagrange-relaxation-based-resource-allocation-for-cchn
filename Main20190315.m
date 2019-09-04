
clc
clear


MaxIter=50
V2Inum=5,V2Vnum=5

[SumRateMat]=CalculateSumRate(V2Inum,V2Vnum);
maxV = max(max(max(SumRateMat)));%转化为最小优化
RateOverNetSizeMat=maxV-SumRateMat;

%使用Lagrangrian relaxation
[H_fina,L_fina,LRrate,iter,PariSolu,TIME2]=ThreeD_LagrangianRelaxation(RateOverNetSizeMat,MaxIter);
%     [OptSolu,TIME2]=IterHungarinAlgo(RateOverNetSizeMat,MaxIter);
LRrate=V2Inum*maxV-LRrate;

%穷搜索
[MATCHING1,ESrate,TIME1]=ThreeD_NumericalSearch(RateOverNetSizeMat);
ESrate=V2Inum*maxV-ESrate;

%%IntraGRA算法
[InGRASumRate,t]=IntraGraAlgoAvaible(V2Inum,V2Vnum);

%%CG
MaxFailNum=30
[LRrate_old,t]=CoorperativeGameforV2V(V2Inum,V2Vnum,MaxFailNum)

str=['LR的速率为: ' num2str(LRrate),', InGRA的速率为: ',num2str(InGRASumRate),', ES的速率为: ',num2str(ESrate)...
    ,', CG的速率为: ',num2str(LRrate_old)]
