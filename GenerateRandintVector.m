function [ranvec]=GenerateRandintVector(N)
ya=zeros(1,N);
xa=zeros(1,N);
for i=1:N
   ya(i)=i;   %记录数组的原始位置
end
for i=1:N
    m= randint(1,1,[1,N-i+1]);   
    xa(i)=ya(m);
    for j=m:N-i
        ya(j)=ya(j+1);
    end
end
ranvec=xa;

% [CUranvec]=GenerateRandomCaseForDifferentSINRmode(50)
% [D2Dranvec]=GenerateRandomCaseForDifferentSINRmode(50)
% save D2D_Random_Position.mat CUranvec;
% save CU_Random_Position.mat D2Dranvec;