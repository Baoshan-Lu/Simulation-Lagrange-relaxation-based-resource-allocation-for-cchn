function LearningRateAdaptive()

times=5
% LearingRate=0.0000036315224812454;
load LearingRate.mat LearingRate

maxProbility=0;
figure
for j=1:50
    if rand>0.5
        LearingRate1= LearingRate-0.00000000022531*rand;
    else
        LearingRate1= LearingRate+0.00000000022351*rand;
    end
    cout=0;
    LearingRate=LearingRate1
    for i=1:times
        loop=5;
        V2Ista=2;V2Iend=6;
        V2Vsta=20;V2Vend=30;
        count=PlotLRversusES(V2Ista,V2Iend,V2Vsta,V2Vend,loop,LearingRate)
        cout=count+cout;
        
        Probility=cout/(times*loop)
    end
    if Probility>maxProbility
        maxProbility=Probility
        save LearingRate.mat LearingRate
    end
    
    plot(j,Probility,'-o')
    hold on
end
