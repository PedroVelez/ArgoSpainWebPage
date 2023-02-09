%Surface Pressure
if isfield(FloatData.TEDf,'PRES_SurfaceOffsetTruncatedplus5dBar_dBAR')==1 && length(FloatData.TEDf.PRES_SurfaceOffsetTruncatedplus5dBar_dBAR)>1
    hC1=axes('position',[0.05 0.69 0.90 0.26]);
    plot(FloatData.TEDf.PRES_SurfaceOffsetTruncatedplus5dBar_dBARCycle,FloatData.TEDf.PRES_SurfaceOffsetTruncatedplus5dBar_dBAR)
    maxSO=nanmax(FloatData.TEDf.PRES_SurfaceOffsetTruncatedplus5dBar_dBAR);
    minSO=nanmin(FloatData.TEDf.PRES_SurfaceOffsetTruncatedplus5dBar_dBAR);
    if maxSO>20;maxSO=20;end
    if minSO<-20;minSO=-20;end
    if maxSO~=minSO
        axis([-inf inf minSO maxSO])
    end
    grid on
    hC1.FontSize=7;
    hC1.TitleFontWeight='normal';
    hC1.XColor=[0.5 0.5 0.5];
    hC1.YColor=[0.5 0.5 0.5];
    title('PRES SurfaceOffsetTruncatedplus5dBar dBAR')
elseif isfield(FloatData.TEDf,'PRES_SurfaceOffsetNotTruncated_dBAR')==1
    hC1=axes('position',[0.05 0.69 0.90 0.26]);
    plot(FloatData.TEDf.PRES_SurfaceOffsetNotTruncated_dBARCycle,FloatData.TEDf.PRES_SurfaceOffsetNotTruncated_dBAR);hold on
    maxSO=nanmax(FloatData.TEDf.PRES_SurfaceOffsetNotTruncated_dBAR);
    minSO=nanmin(FloatData.TEDf.PRES_SurfaceOffsetNotTruncated_dBAR);
    if maxSO>20;maxSO=20;end
    if minSO<-20;minSO=-20;end
    if maxSO~=minSO
        axis([-inf inf minSO maxSO])
    end
    grid on
    hC1.FontSize=7;
    hC1.TitleFontWeight='normal';
    hC1.XColor=[0.5 0.5 0.5];
    hC1.YColor=[0.5 0.5 0.5];
    title('PRES SurfaceOffsetNotTruncated dBAR')
end
%Voltage
if isfield(FloatData.TEDf,'VOLTAGE_BatteryParkEnd_VOLTS')==1
    hC2=axes('position',[0.05 0.36 0.90 0.26]);
    plot(FloatData.TEDf.VOLTAGE_BatteryParkEnd_VOLTSCycle,FloatData.TEDf.VOLTAGE_BatteryParkEnd_VOLTS)
    set(hC2,'fontsize',8)
    title('VOLTAGE BatteryParkEnd VOLTS')
    grid on
    hC2.FontSize=7;
    hC2.TitleFontWeight='normal';
    hC2.XColor=[0.5 0.5 0.5];
    hC2.YColor=[0.5 0.5 0.5];
elseif isfield(FloatData.TEDf,'VOLTAGE_BatteryPumpStartProfile_volts')==1
    hC2=axes('position',[0.05 0.36 0.90 0.26]);
    plot(FloatData.TEDf.VOLTAGE_BatteryPumpStartProfile_voltsCycle,FloatData.TEDf.VOLTAGE_BatteryPumpStartProfile_volts)
    set(hC2,'fontsize',8)
    title('VOLTAGE BatteryPumpStartProfile volts')
    grid on
    hC2.FontSize=7;
    hC2.TitleFontWeight='normal';
    hC2.XColor=[0.5 0.5 0.5];
    hC2.YColor=[0.5 0.5 0.5];
end
%Presion interna
if isfield(FloatData.TEDf,'PRESSURE_InternalVacuum_COUNT')==1
    hC3=axes('position',[0.05 0.05 0.90 0.26]);
    plot(FloatData.TEDf.PRESSURE_InternalVacuum_COUNTCycle,FloatData.TEDf.PRESSURE_InternalVacuum_COUNT)
    set(hC3,'fontsize',8)
    title('PRESSURE InternalVacuum COUNT')
    grid on
    hC3.FontSize=7;
    hC3.TitleFontWeight='normal';
    hC3.XColor=[0.5 0.5 0.5];
    hC3.YColor=[0.5 0.5 0.5];
elseif isfield(FloatData.TEDf,'PRES_SurfaceOffsetBeforeReset_1cBarResolution_dbar')==1
    hC3=axes('position',[0.05 0.05 0.90 0.26]);
    plot(FloatData.TEDf.PRES_SurfaceOffsetBeforeReset_1cBarResolution_dbarCycle,FloatData.TEDf.PRES_SurfaceOffsetBeforeReset_1cBarResolution_dbar)
    set(hC3,'fontsize',8)
    title('PRES SurfaceOffsetBeforeReset 1cBarResolution_dbar')
    grid on
    hC3.FontSize=7;
    hC3.TitleFontWeight='normal';
    hC3.XColor=[0.5 0.5 0.5];
    hC3.YColor=[0.5 0.5 0.5];
    
end