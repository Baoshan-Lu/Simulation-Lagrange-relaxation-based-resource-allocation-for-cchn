function VehicularNetworksModel_SpeedVari(SystemCoefficient,VehicleSpeed)
% 高速公路双向8车道一般路基宽：0.75m(土路肩)+3.0m(硬路肩)+4×3.75m(行车道)
% +4.5m(中间带)+4×3.75m(行车道)+3.0m(硬路肩)+0.75m(土路肩)=42.0m。V2Vnum,
%BidirectionalEightLane
% V2Inum=10;
% V2Vnum=30;minV2Vdistan,maxV2Vdistan,

% 每小时经过1000辆车
VehicleFlow=2000;

VehicleDensity=VehicleFlow/VehicleSpeed;

VehicleDensity=round(VehicleDensity/4);
V2Inum=round(VehicleDensity*(2/10));
V2Vnum=round(VehicleDensity*(8/10));
% AverageInterVehicle=VehicleSpeed *0.2777778

minV2Vdistan=10;
maxV2Vdistan=100;

Bs2Road=47;
% VehicleVolume=70;
BS_x=500;BS_y=500;
Radius=500;
% SingleLaneWidth=3.75*4;
SingleLaneWidth=4*3;

IntermediateBand=4;

HighwayWidth=SingleLaneWidth+IntermediateBand;
[A1,B1,M1]=SpacialPoissonPointRectangle(BS_x-HighwayWidth/2,BS_x-IntermediateBand/2,60,990,VehicleDensity);
[A2,B2,M2]=SpacialPoissonPointRectangle(BS_x+IntermediateBand/2,BS_x+SingleLaneWidth,60,990,VehicleDensity);
[A3,B3,M3]=SpacialPoissonPointRectangle(57,1037,BS_x-HighwayWidth/2,BS_x-IntermediateBand/2,VehicleDensity);
[A4,B4,M4]=SpacialPoissonPointRectangle(57,1037,BS_x+IntermediateBand/2,BS_x+SingleLaneWidth,VehicleDensity);

% M1
% M2
% M3
% M4
% [A1,B1,M1]=SpacialPoissonPointRectangle(450,550,20,980,40);
% [A2,B2,M2]=SpacialPoissonPointRectangle(20,980,450,550,40);
% hold on
% plot(A1,B1,'v','MarkerSize',5);
% hold on
% plot(A2,B2,'k^','MarkerSize',5);
% hold on
% plot(A3,B3,'k>','MarkerSize',5);
% hold on
% plot(A4,B4,'<','MarkerSize',5);

NorthSouthLaneX=[A1 A2];NorthSouthLaneY=[B1 B2];
EastWestLaneX=[A3 A4];EastWestLaneY=[B3 B4];
SumPointX=[NorthSouthLaneX  EastWestLaneX];
SumPointY=[NorthSouthLaneY  EastWestLaneY];
[~,PointNum]=size(SumPointX);

% PointNum
%V2I user  从生成的泊松点中，随机抽取V2I
[RandomVector]=GenerateRandintVector(PointNum);
V2I_vec=RandomVector(1,1:V2Inum);
V2Icoord=zeros(2,V2Inum);
for i=1:V2Inum %randomly generate V2V
    V2Icoord(1,i)=SumPointX(V2I_vec(1,i));
    V2Icoord(2,i)=SumPointY(V2I_vec(1,i));
end


%V2V user坐标中选取距离较短的链路作为V2V链路
%从剩余的链路中构建V2V链路

V2V_vec1=RandomVector(1,V2Inum+1:PointNum);

V2V_vec=V2V_vec1;

V2Vcoord=zeros(4,V2Vnum);

count=1;
for k=1:size(V2V_vec,2)
    if count==0
        break;
    else
        %发射机
        TransX=SumPointX(V2V_vec(1,k));
        TransY=SumPointY(V2V_vec(1,k));
        
        V2V_vec_temp=V2V_vec;
        V2V_vec_temp(:,k)=[];
        
        for  m=1:size(V2V_vec_temp,2)
            
            
            %接收机
            Recx=SumPointX(V2V_vec1(1,m));%pick up one point
            Recy=SumPointY(V2V_vec1(1,m));
            dis=sqrt((Recx-TransX)^2+(Recy-TransY)^2);
            if(dis>=minV2Vdistan&&dis<=maxV2Vdistan)%distance should be in the range[mindis,maxdis]
                
                V2Vcoord(1,count)=TransX;
                V2Vcoord(2,count)=TransY;
                V2Vcoord(3,count)=Recx;
                V2Vcoord(4,count)=Recy;
                
                %             V2V_vec(:,k)=[];
                %
                %             V2V_vec(:,m)=[];
                
                count=count+1;
                if count>V2Vnum
                    count=0;
                    break;
                end
                
                break;
            end
            
        end
    end
    
    
end
% V2Vcoord
if  size(V2Vcoord,2)>V2Vnum
    V2Vcoord(:,V2Vnum)=[];
end

%% 保存模型
VariableName1='V2Icoord';
VariableName2='V2Vcoord';

save([SystemCoefficient.VariablePath VariableName1], VariableName1)
save([SystemCoefficient.VariablePath  VariableName2], VariableName2)






% % % % % % % RestLink=PointNum-V2Inum;
% % % % % % %
% % % % % % % V2VtransNum=round(RestLink/2+V2Inum);
% % % % % % %
% % % % % % % V2V_vec=RandomVector(1,V2Inum+1:V2VtransNum);
% % % % % % % V2V_vec1=RandomVector(1,V2VtransNum+1:PointNum);
% % % % % % %
% % % % % % % % V2V_vec=RandomVector(V2Inum+1:V2Inum+V2Vnum);
% % % % % % % % V2V_vec1=RandomVector(V2Inum+V2Vnum+1:PointNum);
% % % % % % %
% % % % % % % A=size(V2V_vec,2);
% % % % % % % B=size(V2V_vec1,2);
% % % % % % %
% % % % % % % V2Vnum=min(A,B);
% % % % % % %
% % % % % % % V2Vcoord=zeros(4,V2Vnum);
% % % % % % % count=0;
% % % % % % % for i=1:V2Vnum %generate V2V transmitter
% % % % % % %     %     V2Vcoord(1,i)=SumPointX(V2V_vec(1,i));
% % % % % % %     %     V2Vcoord(2,i)=SumPointY(V2V_vec(1,i));
% % % % % % %
% % % % % % %     TransX=SumPointX(V2V_vec(1,i));
% % % % % % %     TransY=SumPointY(V2V_vec(1,i));
% % % % % % %
% % % % % % %     [~,RestNum]=size(V2V_vec1);
% % % % % % %     for j=1:RestNum %generate V2V receiver
% % % % % % %         x=SumPointX(V2V_vec1(1,j));%pick up one point
% % % % % % %         y=SumPointY(V2V_vec1(1,j));
% % % % % % %         dis=sqrt((x-TransX)^2+(y-TransY)^2);
% % % % % % %         if(dis>=minV2Vdistan&&dis<=maxV2Vdistan)%distance should be in the range[mindis,maxdis]
% % % % % % %             V2Vcoord(1,i)=TransX;
% % % % % % %             V2Vcoord(2,i)=TransY;
% % % % % % %
% % % % % % %             V2Vcoord(3,i)=x;
% % % % % % %             V2Vcoord(4,i)=y;
% % % % % % %
% % % % % % %             V2V_vec1(V2V_vec1==V2V_vec1(1,j))=[];%delete paired point
% % % % % % %             count=count+1;
% % % % % % %             break;
% % % % % % %         end
% % % % % % %     end
% % % % % % % end
% % % % % % %
% % % % % % % DeleteV2V=0;
% % % % % % % for k=1:V2Vnum
% % % % % % %
% % % % % % %     if sum(V2Vcoord(:,k))==0
% % % % % % %         if DeleteV2V==0
% % % % % % %             DeleteV2V=k;
% % % % % % %         else
% % % % % % %             DeleteV2V=[DeleteV2V k];
% % % % % % %         end
% % % % % % %     end
% % % % % % % end
% % % % % % %
% % % % % % % for m=1:size(DeleteV2V,2)
% % % % % % %
% % % % % % %     V2Vcoord(:,DeleteV2V(1,m))=[];%去除无法构成V2V的车辆
% % % % % % %     DeleteV2V(1,m+1:size(DeleteV2V,2))=DeleteV2V(1,m+1:size(DeleteV2V,2))-1;
% % % % % % % end







%% 绘图
% % % % figure
% % % % plot(BS_x+47,BS_y+47,'k.','MarkerSize',20);
% % % % hold on
% % % % plot( V2Icoord(1,:),V2Icoord(2,:),'or' ,'MarkerSize',6);
% % % % hold on
% % % % plot(V2Vcoord(1,:),V2Vcoord(2,:),'>','MarkerSize',8);
% % % % hold on
% % % % plot(V2Vcoord(3,:),V2Vcoord(4,:),'sg','MarkerSize',6);
% % % % hold on
% % % % s1=legend('Base Station','V2I links','V2V transmitter','V2V receiver',2);
% % % % set(s1,'FontName','Times New Roman', 'FontSize',10);

% for i=1:size(V2Vcoord,2)
%     line([V2Vcoord(1,i),V2Vcoord(3,i)],[V2Vcoord(2,i),V2Vcoord(4,i)])
%     % annotation('arrow',[V2Vcoord(1,i),V2Vcoord(3,i)],[V2Vcoord(2,i),V2Vcoord(4,i)])
%     hold on
% end
%
% plot1(BS_x+47,BS_y+47,Radius );%边框
% hold on


