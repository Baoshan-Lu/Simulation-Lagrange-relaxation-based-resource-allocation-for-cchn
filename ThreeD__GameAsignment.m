function [MATCHING,COST,TIME]=ThreeD__GameAsignment(A,MaxBalance)
t0=cputime;
[CUnumb,D2Dnumb,RSnumb]=size(A);
CU=1:CUnumb;
[D2D]=GenerateRandintVector(D2Dnumb);%随机D2D序号
[RS]=GenerateRandintVector(RSnumb);%随机RS序号
R=0;
for i=1:CUnumb%计算能耗
    R=A(CU(1,i),D2D(1,i),RS(1,i))+R;
end
count=0;
R2=zeros(1,3);
loop=5*MaxBalance;
R5=zeros(1,loop);

    MATCHING(1,:)=CU;
    MATCHING(2,:)=D2D;
    MATCHING(3,:)=RS;
    TIME=cputime-t0;
    COST=R;
% if  CUnumb==1 %如果只是一个，直接返回结果
%     MATCHING(1,:)=CU;
%     MATCHING(2,:)=D2D;
%     MATCHING(3,:)=RS;
%     TIME=cputime-t0;
%     COST=R;
% else
%     for i=1:loop
%         Goup=GenerateRandintVector(CUnumb);
%         R1=A(CU(1,Goup(1,1)),D2D(1,Goup(1,1)),RS(1,Goup(1,1)))+...%初始两组的和
%             A(CU(1,Goup(1,2)),D2D(1,Goup(1,2)),RS(1,Goup(1,2)));
%         R2(1,1)=A(CU(1,Goup(1,1)),D2D(1,Goup(1,2)),RS(1,Goup(1,1)))+...%D2D交换
%             A(CU(1,Goup(1,2)),D2D(1,Goup(1,1)),RS(1,Goup(1,2)));
%         R2(1,2)=A(CU(1,Goup(1,1)),D2D(1,Goup(1,1)),RS(1,Goup(1,2)))+...%RS交换
%             A(CU(1,Goup(1,2)),D2D(1,Goup(1,2)),RS(1,Goup(1,1)));
%         R2(1,3)=A(CU(1,Goup(1,1)),D2D(1,Goup(1,2)),RS(1,Goup(1,2)))+...%D2D,RS同时交换
%             A(CU(1,Goup(1,2)),D2D(1,Goup(1,1)),RS(1,Goup(1,1)));
%         
%         [x,y]=min(R2);%取最小值
%         
%         if x<R1
%             switch(y)
%                 case 1
%                     Temp=D2D(1,Goup(1,1));
%                     D2D(1,Goup(1,1))=D2D(1,Goup(1,2));
%                     D2D(1,Goup(1,2))=Temp;
%                 case 2
%                     Temp=RS(1,Goup(1,1));
%                     RS(1,Goup(1,1))=RS(1,Goup(1,2));
%                     RS(1,Goup(1,2))=Temp;
%                 otherwise
%                     Temp=D2D(1,Goup(1,1));
%                     D2D(1,Goup(1,1))=D2D(1,Goup(1,2));
%                     D2D(1,Goup(1,2))=Temp;
%                     Temp=RS(1,Goup(1,1));
%                     RS(1,Goup(1,1))=RS(1,Goup(1,2));
%                     RS(1,Goup(1,2))=Temp;
%             end
%             
%             R=R-(R1-x);%计算新总和
%             count=0;
%             
%         else
%             count=count+1;
%         end
%         R5(1,i)=R;
%         k=i;
%         if(count>MaxBalance)%超过最大平衡数，则认为达到纳什均衡
%             break;
%         end
%         
%     end
%     MATCHING(1,:)=CU;
%     MATCHING(2,:)=D2D;
%     MATCHING(3,:)=RS;
%     TIME=cputime-t0;
%     COST=R;
% end

%  plot(1:k,R5(1,1:k),'-*','linewidth',1.5,'MarkerSize',5);

