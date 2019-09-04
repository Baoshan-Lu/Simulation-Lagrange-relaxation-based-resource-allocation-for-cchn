function[MATCHING,COST,TIME]=ThreeD_NumericalSearch(A)
t0=cputime;
maxV = max(max(max(A)));%转化为最小优化
A=maxV-A;


[CUnumb,D2Dnumb,RSnumb]=size(A);
CU=1:CUnumb;
D2D=perms(1:D2Dnumb);
RS=perms(1:RSnumb);
[x1,~]=size(D2D);
[x2,~]=size(RS);
OnceD2D=zeros(x1,x2);
for i=1:x1 %穷D2D
    for j=1:x2%穷RS
        R=0;
        for k=1:CUnumb%计算值
             R=A(CU(1,k),D2D(i,k),RS(j,k))+R; 
        end
        OnceD2D(i,j)=R;
    end
end
[~,y3]=min(OnceD2D);
[~,y]=min(min(OnceD2D));
COST=OnceD2D(y3(1,y),y);
MATCHING(1,:)=CU;
MATCHING(2,:)=D2D(y3(1,y),:);
MATCHING(3,:)=RS(y,:);
TIME=cputime-t0;

COST=maxV*CUnumb-COST;


