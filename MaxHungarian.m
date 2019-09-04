function [MATCH,Cost]=MaxHungarian(A)
Perf=-A;
[Matching,~] = Hungarian(Perf);
Cost=sum(sum(Matching.*A));
MATCH=zeros(1,size(A,1));
for i=1:size(A,1)
    MATCH(1,i)=find(Matching(i,:)==1);
end