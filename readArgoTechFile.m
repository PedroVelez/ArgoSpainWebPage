function D=ReadArgoTechFile(file)
    ncid=netcdf.open(file,'nc_nowrite');
    D=struct('PLATFORM_NUMBER',{{}},'PLATFORM_MODEL',{{}});
    D.HANDBOOK_VERSION=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'HANDBOOK_VERSION'))';
    D.FORMAT_VERSION=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'FORMAT_VERSION'))';
    D.DATA_CENTRE=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'DATA_CENTRE'))';
    D.DATE_CREATION=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'DATE_CREATION'))';
    D.DATE_UPDATE=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'DATE_UPDATE'))';
    D.PLATFORM_NUMBER=deblank(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PLATFORM_NUMBER'))');
    TECHNICAL_PARAMETER_NAME=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'TECHNICAL_PARAMETER_NAME'))';
    TECHNICAL_PARAMETER_VALUE=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'TECHNICAL_PARAMETER_VALUE'))';
    CYCLE_NUMBER=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'CYCLE_NUMBER'))';
    
    % if InstType==841 %Provor, Seabird conductivity sensor
    % elseif InstType==829 %Webb Research, Seabird sensor
    
    t(1).s=    'VOLTAGE_BatteryParkEnd_VOLTS';k(1)=0;
    t(end+1).s='VOLTAGE_BatterySBEParkEnd_VOLTS';k(end+1)=0;
    t(end+1).s='VOLTAGE_BatteryPumpStartProfile_volts';k(end+1)=0; %Deep Arvor
    t(end+1).s='PRES_SurfaceOffsetBeforeReset_1cBarResolution_dbar';k(end+1)=0; %Deep Arvor
    t(end+1).s='PRES_SurfaceOffsetTruncatedplus5dBar_dBAR';k(end+1)=0; %Apex APF<=8
    t(end+1).s='PRES_SurfaceOffsetNotTruncated_dBAR';k(end+1)=0;%Apex APF>8
    t(end+1).s='PRES_SurfaceOffsetCorrectedNotResetNegative_1cBarResolution_dbar';k(end+1)=0;% Deep Arvor
    t(end+1).s='SENSO_PRESS_OFFSET';k(end+1)=0;%Provor
    t(end+1).s='PRESSURE_InternalVacuum_COUNT';k(end+1)=0;
    t(end+1).s='CURRENT_BatteryPark_mAMPS';k(end+1)=0;%;
    t(end+1).s='PRES_ParkEnd_dBAR';k(end+1)=0;
    t(end+1).s='PRES_ParkMinimum_dBAR';k(end+1)=0;
    t(end+1).s='PSA_ParkEnd_PSU';k(end+1)=0;
    t(end+1).s='TEMP_ParkEnd_DegC';k(end+1)=0;
    
    t(end+1).s='PRES_SurfaceOffsetCorrectedNotResetNegative_1cBarResolution_dbar';k(end+1)=0;% Deep Arvor
    t(end+1).s='PRES_LastAscentPumpedRawSample_dbar';k(end+1)=0;% Deep Arvor

    t(end+1).s='FLAG_RemoteControlMessageOK_COUNT';k(end+1)=0;% Deep Arvor
    

    
    for it=1:size(t,2)
        lv=length(t(it).s);
        if lv>(namelengthmax-5)
            t(it).s=t(it).s(1:namelengthmax-5);
            t(it).c=strcat(t(it).s,'Cycle');
        else
            t(it).c=strcat(t(it).s,'Cycle');
        end
        
    end
    
    for i=1:size(TECHNICAL_PARAMETER_NAME,1)
        for it=1:size(t,2)
            if strncmpi(TECHNICAL_PARAMETER_NAME(i,:),t(it).s,length(t(it).s))
                k(it)=k(it)+1;
                D.(t(it).s)(k(it))=str2num(TECHNICAL_PARAMETER_VALUE(i,:));
                D.(t(it).c)(k(it))=CYCLE_NUMBER(i);
            end
        end
    end
