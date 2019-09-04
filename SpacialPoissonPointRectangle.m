function [A,B,N]=SpacialPoissonPointRectangle(x1,x2,y1,y2,Lambda)
%随机抽样出来的样本点在范围内服从均匀分布，样本点之间的距离服从指数分布
%%% Part1 %%
% Lambda-代表了一定范围内的车辆密度，
%参考文献：Pasupathy R . Generating Homogeneous Poisson Processes[M]// Wiley 
%Encyclopedia of Operations Research and Management Science. John Wiley & Sons, Inc. 2014.
u = unifrnd(0,1);
M = 0;
while u >= exp(-Lambda)%判定条件
    u = u*unifrnd(0,1);
    M=M+1;
end
N=M;
%取点个数
% R = poissrnd(Lambda,1,M)

%%% Part2 %%%
% x1 = 0; c = 0;
% b = 100; d =100;
% e = 0; f = 100;     %取[0,100]*[0,100]的布点区域；
Nall = M;
A = [];
B = [];
while M > 0         %scatter in the [0,100]*[0,100]
    M = M-1;
    u1 = unifrnd(0,1);
    A(Nall-M) = (x2-x1)*u1+x1;
    u2 = unifrnd(0,1);
    B(Nall-M) = (y2-y1)*u2+y1;
    %     u3 = unifrnd(0,1);
    %     C(Nall-M) = (f-e)*u3;
    %     figure(2)    %base stations 分布图
    % plot3(A(Nall-M),B(Nall-M),C(Nall-M),'r^');
    %     hold on;
    %     plot(A(Nall-M),B(Nall-M),'b.')
    %     hold on
end
% grid on