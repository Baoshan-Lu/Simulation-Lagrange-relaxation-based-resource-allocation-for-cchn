function [pathloss]=Pathloss(aCoordx,aCoordy,bCoordx,bCoordy)
DIS=sqrt((aCoordx-bCoordx)^2+(aCoordy-bCoordy)^2);
pathloss=DIS^(-4);