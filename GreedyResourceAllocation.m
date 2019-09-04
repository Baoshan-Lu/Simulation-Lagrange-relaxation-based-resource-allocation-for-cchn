function sumrate=GreedyResourceAllocation(RateMat)
[M,R,K]=size(RateMat);
mVec=1:min(M,R);
rVec=1:min(M,R);
kVec=1:min(M,R);

% rVec=randperm(numel(1:min(M,R)));
% kVec=randperm(numel(1:min(M,R)));
sumrate=0;
rVec1=rVec;
kVec1=kVec;
for m=1:M
    

    mthMaxRate=0;
    maxR=1;
    maxK=1;
    for r=1:size(rVec1,2)
        for k=1:size(kVec1,2)
%             W=RateMat(mVec(1,m),rVec1(1,r),kVec1(1,k))
            if RateMat(mVec(1,m),rVec1(1,r),kVec1(1,k))>mthMaxRate
                mthMaxRate=RateMat(mVec(1,m),rVec1(1,r),kVec1(1,k));
                maxR=r;
                maxK=k;
            end
        end
    end
    %                     maxR
    %                 maxK
    sumrate=sumrate+ mthMaxRate;
    if m<M
        rVec(:,maxR)=[];
        kVec(:,maxK)=[];
    end
    
rVec1=rVec;
kVec1=kVec;    
    
end