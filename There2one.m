function U=There2one(u)
U=zeros(1,size(u,3));
for i=1:size(u,3)
    U(1,i)=u(1,1,i);
end