function VehicularNetworksModel(SystemCoefficient)
% 高速公路双向8车道一般路基宽：0.75m(土路肩)+3.0m(硬路肩)+4×3.75m(行车道)
% +4.5m(中间带)+4×3.75m(行车道)+3.0m(硬路肩)+0.75m(土路肩)=42.0m。
%BidirectionalEightLane
% V2Inum=10;
% V2Vnum=30;
% minV2Vdistan=30;
% maxV2Vdistan=50;

minV2Vdistan=SystemCoefficient.minV2Vdistan;
maxV2Vdistan=SystemCoefficient.maxV2Vdistan;

V2Inum=SystemCoefficient.V2Inum;
V2Vnum=SystemCoefficient.V2Vnum;
Radius=SystemCoefficient.Radius;
BS_x=SystemCoefficient.BS_x;
BS_y=SystemCoefficient.BS_y;


% Radius=500;



if  SystemCoefficient.NewModel==1
    %% 基于泊松点到达过程的车联网模型
%     Bs2Road=47;
%     VehicleVolume=70;
%     BS_x=500;BS_y=500;
%     SingleLaneWidth=4*3;
%     IntermediateBand=4;
%     SingleLaneWidth=3.75*4;
%     HighwayWidth=SingleLaneWidth+IntermediateBand;

%     [A1,B1,M1]=SpacialPoissonPointRectangle(BS_x-HighwayWidth/2,BS_x-IntermediateBand/2,60,990,200-VehicleVolume);
%     [A2,B2,M2]=SpacialPoissonPointRectangle(BS_x+IntermediateBand/2,BS_x+SingleLaneWidth,60,990,200-VehicleVolume);
%     [A3,B3,M3]=SpacialPoissonPointRectangle(57,1037,BS_x-HighwayWidth/2,BS_x-IntermediateBand/2,200-VehicleVolume);
%     [A4,B4,M4]=SpacialPoissonPointRectangle(57,1037,BS_x+IntermediateBand/2,BS_x+SingleLaneWidth,200-VehicleVolume);
%     % [A1,B1,M1]=SpacialPoissonPointRectangle(450,550,20,980,40);
%     % [A2,B2,M2]=SpacialPoissonPointRectangle(20,980,450,550,40);
%     % hold on
%     % plot(A1,B1,'v','MarkerSize',5);
%     % hold on
%     % plot(A2,B2,'k^','MarkerSize',5);
%     % hold on
%     % plot(A3,B3,'k>','MarkerSize',5);
%     % hold on
%     % plot(A4,B4,'<','MarkerSize',5);
%     
%     NorthSouthLaneX=[A1 A2];NorthSouthLaneY=[B1 B2];
%     EastWestLaneX=[A3 A4];EastWestLaneY=[B3 B4];
%     SumPointX=[NorthSouthLaneX  EastWestLaneX];
%     SumPointY=[NorthSouthLaneY  EastWestLaneY];
%     [~,PointNum]=size(SumPointX);
%     %V2I user
%     [RandomVector]=GenerateRandintVector(PointNum);
%     V2I_vec=RandomVector(1:V2Inum);
%     V2Icoord=zeros(2,V2Inum);
%     for i=1:V2Inum %randomly generate V2V
%         V2Icoord(1,i)=SumPointX(V2I_vec(i));
%         V2Icoord(2,i)=SumPointY(V2I_vec(i));
%     end
%     %V2V user
%     V2V_vec=RandomVector(V2Inum+1:V2Inum+V2Vnum);
%     V2V_vec1=RandomVector(V2Inum+V2Vnum+1:PointNum);
%     V2Vcoord=zeros(4,V2Vnum);
%     
%     for i=1:V2Vnum %generate V2V transmitter
%         V2Vcoord(1,i)=SumPointX(V2V_vec(i));
%         V2Vcoord(2,i)=SumPointY(V2V_vec(i));
%         [~,RestNum]=size(V2V_vec1);
%         for j=1:RestNum %generate V2V receiver
%             x=SumPointX(V2V_vec1(j));%pick up one point
%             y=SumPointY(V2V_vec1(j));
%             dis=sqrt((x-V2Vcoord(1,i))^2+(y-V2Vcoord(2,i))^2);
%             if(dis>=minV2Vdistan&&dis<=maxV2Vdistan)%distance should be in the range[mindis,maxdis]
%                 V2Vcoord(3,i)=x;
%                 V2Vcoord(4,i)=y;
%                 V2V_vec1(V2V_vec1==V2V_vec1(j))=[];%delete paired point
%                 break;
%             end
%             j
%         end
%         i
%     end
    
    %% CCHN模型
    
    %生成CR-router坐标
    V2Icoord=zeros(2,V2Inum);
    R=unifrnd(20,Radius-150,V2Inum,1);
    K=unifrnd(0,2*pi,V2Inum,1);    
    for i=1:V2Inum
        V2Icoord(1,i)= R(i)*cos(K(i)); %极坐标转换
        V2Icoord(2,i)= R(i)*sin(K(i));
    end
    %生成IoT link 坐标
    V2Vcoord=zeros(4,V2Vnum);   
    R=unifrnd(20,Radius-80,V2Vnum,1);
    K=unifrnd(0,2*pi,V2Vnum,1);    
    for i=1:V2Vnum
        %IoT发射端坐标
        V2Vcoord(1,i)= R(i)*cos(K(i)); 
        V2Vcoord(2,i)= R(i)*sin(K(i));
        %IoT接收端坐标  
        R1=minV2Vdistan+(maxV2Vdistan-minV2Vdistan)*rand(1,1);% IoT link 距离
        K1=unifrnd(0,2*pi,1,1);    %任意角度
        V2Vcoord(3,i)=  V2Vcoord(1,i)+R1*cos(K1); 
        V2Vcoord(4,i)=  V2Vcoord(2,i)+R1*sin(K1);  
    end  
    
    
    %保存模型
    VariableName1='V2Icoord';
    VariableName2='V2Vcoord';
    save([SystemCoefficient.VariablePath VariableName1], VariableName1)
    save([SystemCoefficient.VariablePath  VariableName2], VariableName2)
    
end
load([SystemCoefficient.VariablePath '\V2Icoord.mat'],'V2Icoord');
load([SystemCoefficient.VariablePath '\V2Vcoord.mat'],'V2Vcoord');







figure
plot(BS_x+47,BS_y+47,'k.','MarkerSize',20);
hold on
plot( V2Icoord(1,:),V2Icoord(2,:),'or' ,'MarkerSize',6);
hold on
plot(V2Vcoord(1,:),V2Vcoord(2,:),'>','MarkerSize',8);
hold on
plot(V2Vcoord(3,:),V2Vcoord(4,:),'sg','MarkerSize',6);
hold on
s1=legend('Base Station','V2I links','V2V transmitter','V2V receiver',2);
set(s1,'FontName','Times New Roman', 'FontSize',10);

for i=1:V2Vnum
    line([V2Vcoord(1,i),V2Vcoord(3,i)],[V2Vcoord(2,i),V2Vcoord(4,i)])
    % annotation('arrow',[V2Vcoord(1,i),V2Vcoord(3,i)],[V2Vcoord(2,i),V2Vcoord(4,i)])
    hold on
end

plot1(BS_x+47,BS_y+47,Radius );%边框
hold on



