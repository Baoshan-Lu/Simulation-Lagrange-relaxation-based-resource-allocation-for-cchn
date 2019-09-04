%%temp值是遍历后的最小和，ans是匈牙利算法求出的最小和
clear;clc;
% M=4;
N=5;
A=1+round(10*rand(4,N));
%%随机生成M*N维矩阵，行代表D2D，列代表蜂窝用户
[z,ans]=Hungarian(A);
%%遍历
temp = Inf;
l=1;
for i1=1:1:N
    sum=0;
    sum=sum+A(1,i1);
    for i2=1:1:N
        if i2 ~= i1
            sum=sum+A(2,i2);
            for i3=1:1:N
                    if i3 ~= i1 && i3 ~=i2
                         sum=sum+A(3,i3);
                         for i4=1:1:N
                                  if i4 ~= i1 && i4 ~=i2 &&i4~=i3
                                          sum=sum+A(4,i4);
                                          if temp>sum
                                                 temp = sum;
                                          end
                                           sum=sum-A(4,i4);
                                  end         
                         end    
                          sum=sum-A(3,i3);
                  end
            end
               sum=sum-A(2,i2);
        end         
    end
end