function MD=ArgoEsStatus_FunctionMetadata(WMO,DirArgoData)
%     TransmisionSystem: 'ARGOS'
%     PlatformID: '4797'
%     PlatformModel: ' APEX APF9A 6609'
%     Sensors: ' SBE41CP SBE41CP SBE41CP'
%     SensorsID: ' n/a n/a n/a'
%     ParkingDepth: '1000'
%     LaunchDate: '27-Oct-2010 00:00:00'
%     TransmissionID: '51983 2685'
%     ProfileDepth: '2000'
%     NumberOfProfiles: '106'
%     Age: ' 2.9'
%     StatusT: 'Inactive'
%     LaunchPosition: 'Lat 29.16 Lon -15.49'
%     LastSurfacingDate: '12-Sep-2013 14:06:52'
%     LastSurfacingPosition: 'Lat 32.29 Lon -13.42'
%     DataCentre: 'IF (3.1)'
%     ProjectName: 'ARGO SPAIN (RAPROCAN)'
%     FloatOwner: ''
%     PIName: 'Pedro Joaquin VELEZ BELCHI'
%     Voltage: '12.344'
%     VoltageT: 'VOLTAGE_BatteryParkEnd_VOLTS'
%     SurfacePressure: '0.1'
%     SurfacePressureT: 'PRES_SurfaceOffsetNotTruncated_dBAR'
%     InternalVacum: ''
%     InternalVacumT: ''
fprintf('metadata, ')

Data=load(fullfile(DirArgoData,'Floats',num2str(WMO)));

%AE=load('/Users/pvb/Dropbox/Oceanografia/LibreriasMatlab/Programas/Argo/PaginaWebArgoEs/Data/DataArgoEs');
%WMO=[6900772];

% WMO Number
MD.WMOFloat=WMO;
% Transmision system
MD.TransmisionSystem=Data.MTDf.TRANS_SYSTEM;
% FloatID
MD.PlatformID=Data.MTDf.FLOAT_SERIAL_NO;
% Platform Model
MD.PlatformModel='';
if isfield(Data.MTDf','PLATFORM_MODEL')
    MD.PlatformModel=strtrim(Data.MTDf.PLATFORM_MODEL);
end
if isfield(Data.MTDf','PLATFORM_TYPE')
    if ~isempty(Data.MTDf.PLATFORM_TYPE)
        MD.PlatformModel=sprintf('%s %s',MD.PlatformModel,strtrim(Data.MTDf.PLATFORM_TYPE));
    end
end
if isfield(Data.MTDf','CONTROLLER_BOARD_TYPE_PRIMARY')
    if ~isempty(Data.MTDf.CONTROLLER_BOARD_TYPE_PRIMARY)
        MD.PlatformModel=sprintf('%s %s',MD.PlatformModel,strtrim(Data.MTDf.CONTROLLER_BOARD_TYPE_PRIMARY));
    end
end
if isfield(Data.MTDf','CONTROLLER_BOARD_SERIAL_NO_PRIMARY')
    if ~isempty(Data.MTDf.CONTROLLER_BOARD_SERIAL_NO_PRIMARY)
        MD.PlatformModel=sprintf('%s %s',MD.PlatformModel,strtrim(Data.MTDf.CONTROLLER_BOARD_SERIAL_NO_PRIMARY));
    end
end

% Sensors
MD.Sensors='';
if isfield(Data.MTDf','SENSOR_MODEL')
    if ~isempty(Data.MTDf.SENSOR_MODEL)
        for iS=1:size(Data.MTDf.SENSOR_MODEL)
            MD.Sensors=sprintf('%s %s',MD.Sensors,strtrim(Data.MTDf.SENSOR_MODEL(iS,:)));
        end
    end
end

% SensorsID
MD.SensorsID='';
if isfield(Data.MTDf','SENSOR_SERIAL_NO')
    if ~isempty(Data.MTDf.SENSOR_SERIAL_NO)
        for iS=1:size(Data.MTDf.SENSOR_SERIAL_NO)
            MD.SensorsID=sprintf('%s %s',MD.SensorsID,strtrim(Data.MTDf.SENSOR_SERIAL_NO(iS,:)));
        end
    end
end

% Parking Depth
MD.ParkingDepth='';
if size(Data.MTDf.DEEPEST_PRESSURE,1)>1
    MD.ParkingDepth=sprintf('%d (%d)',Data.MTDf.PARKING_PRESSURE(1),Data.MTDf.PARKING_PRESSURE(2));
elseif size(Data.MTDf.DEEPEST_PRESSURE,1)>1
    MD.ParkingDepth=num2str(Data.MTDf.PARKING_PRESSURE);
end
if isfield(Data.MTDf,'LAUNCH_CONFIG_PARAMETER_NAME')
    for iP=1:1:size(Data.MTDf.LAUNCH_CONFIG_PARAMETER_NAME,1)
        if strcmp(strtrim(Data.MTDf.LAUNCH_CONFIG_PARAMETER_NAME(iP,:)),'CONFIG_ParkPressure_dbar')==1
            MD.ParkingDepth=num2str(Data.MTDf.LAUNCH_CONFIG_PARAMETER_VALUE(iP)');
        end
    end
end
if isfield(Data.MTDf,'CONFIG_PARAMETER_NAME')
    for iP=1:1:size(Data.MTDf.CONFIG_PARAMETER_NAME,1)
        if strcmp(strtrim(Data.MTDf.CONFIG_PARAMETER_NAME(iP,:)),'CONFIG_ParkPressure_dbar')==1
            MD.ParkingDepth=sprintf('%s (%s)',MD.ParkingDepth,sprintf('%04d ',Data.MTDf.CONFIG_PARAMETER_VALUE(:,iP)'));
        end
    end
end

% LaunchDate
if isnan(Data.MTDf.START_DATE)
    MD.LaunchDate=0;
else
    MD.LaunchDate=datestr(Data.MTDf.START_DATE,0);
end

% TransmissionID
MD.TransmissionID=sprintf('%s %s',Data.MTDf.PTT,Data.MTDf.TRANS_SYSTEM_ID);

% ProfileDepth
% CONFIG_CycleTime_hours
MD.ProfileDepth='';
if  size(Data.MTDf.DEEPEST_PRESSURE,1)>1
    MD.ProfileDepth=sprintf('%d (%d)',Data.MTDf.DEEPEST_PRESSURE(end-1),Data.MTDf.DEEPEST_PRESSURE(end-1));
elseif size(Data.MTDf.DEEPEST_PRESSURE,1)==1
    MD.ProfileDepth=num2str(Data.MTDf.DEEPEST_PRESSURE);
end
if isfield(Data.MTDf,'LAUNCH_CONFIG_PARAMETER_NAME')
    for iP=1:1:size(Data.MTDf.LAUNCH_CONFIG_PARAMETER_NAME,1)
        if strcmp(strtrim(Data.MTDf.LAUNCH_CONFIG_PARAMETER_NAME(iP,:)),'CONFIG_ProfilePressure_dbar')==1
            MD.ProfileDepth=num2str(Data.MTDf.LAUNCH_CONFIG_PARAMETER_VALUE(iP)');
        end
    end
end
if isfield(Data.MTDf,'CONFIG_PARAMETER_NAME')
    for iP=1:1:size(Data.MTDf.CONFIG_PARAMETER_NAME,1)
        if strcmp(strtrim(Data.MTDf.CONFIG_PARAMETER_NAME(iP,:)),'CONFIG_ProfilePressure_dbar')==1
            MD.ProfileDepth=sprintf('%s (%s)',MD.ProfileDepth,sprintf('%04d ',Data.MTDf.CONFIG_PARAMETER_VALUE(:,iP)'));
        end
    end
end

% Number of profiles
MD.NumberOfProfiles=sprintf('%3d',Data.HIDf.cycle(end));

% Age (Yr)
MD.Age=sprintf('%4.1f',(max(Data.HIDf.julds)-min(Data.HIDf.julds))/365);

% Status
if now-Data.HIDf.julds(end)<30
    MD.StatusT='Active';
else
    MD.StatusT='Inactive';
end

% LaunchPosition
MD.LaunchPosition=sprintf('Lat %4.2f Lon %4.2f',Data.MTDf.LAUNCH_LATITUDE,Data.MTDf.LAUNCH_LONGITUDE);

% LastSurfacingDate
MD.LastSurfacingDate=datestr(max(Data.HIDf.julds),0);

% Last postion
MD.LastSurfacingPosition=sprintf('Lat %4.2f Lon %4.2f',Data.HIDf.lats(end),Data.HIDf.lons(end));

% DataCentre
MD.DataCentre=sprintf('%s (%s)',Data.MTDf.DATA_CENTRE,strtrim(Data.MTDf.FORMAT_VERSION));

% Project name (DEPLOY_MISSION) PI_NAME DEPLOYMENT_CRUISE_ID
MD.ProjectName='';
if isfield(Data.MTDf,'PROJECT_NAME')
    MD.ProjectName=Data.MTDf.PROJECT_NAME;
end
if isfield(Data.MTDf,'DEPLOY_MISSION') %V2.1
    if ~isempty(strfind(Data.MTDf.DEPLOY_MISSION,'?'))
        Data.MTDf.DEPLOY_MISSION(strfind(Data.MTDf.DEPLOY_MISSION,'?'))='n';
    end
    if ~isempty(Data.MTDf.DEPLOY_MISSION)
        MD.ProjectName=sprintf('%s (%s)',MD.ProjectName,Data.MTDf.DEPLOY_MISSION);
    end
end
if isfield(Data.MTDf,'DEPLOYMENT_CRUISE_ID')
    if ~isempty(Data.MTDf.DEPLOYMENT_CRUISE_ID)
        MD.ProjectName=sprintf('%s (%s)',MD.ProjectName,Data.MTDf.DEPLOYMENT_CRUISE_ID);
    end
end
% Float Owner
MD.FloatOwner='';
if isfield(Data.MTDf,'FLOAT_OWNER')
    MD.FloatOwner=Data.MTDf.FLOAT_OWNER;
end
% PI Name
MD.PIName='';
if isfield(Data.MTDf,'PI_NAME')
    MD.PIName=Data.MTDf.PI_NAME;
end

% Voltage
if isfield(Data.TEDf,'VOLTAGE_BatteryParkEnd_VOLTS')==1
    MD.Voltage=num2str(Data.TEDf.VOLTAGE_BatteryParkEnd_VOLTS(end));
    MD.VoltageT='VOLTAGE_BatteryParkEnd_VOLTS';
elseif isfield(Data.TEDf,'VOLTAGE_BatteryPumpStartProfile_volts')==1
    MD.Voltage=num2str(Data.TEDf.VOLTAGE_BatteryPumpStartProfile_volts(end));
    MD.VoltageT='VOLTAGE_BatteryPumpStartProfile_volts';
else
    MD.Voltage='';
    MD.VoltageT='';
end

% SurfacePressure
if isfield(Data.TEDf,'PRES_SurfaceOffsetTruncatedplus5dBar_dBAR')==1
    MD.SurfacePressure=num2str(Data.TEDf.PRES_SurfaceOffsetTruncatedplus5dBar_dBAR(end));
    MD.SurfacePressureT='PRES_SurfaceOffsetTruncatedplus5dBar_dBAR';
elseif isfield(Data.TEDf,'PRES_SurfaceOffsetNotTruncated_dBAR')==1
    MD.SurfacePressure=num2str(Data.TEDf.PRES_SurfaceOffsetNotTruncated_dBAR(end));
    MD.SurfacePressureT='PRES_SurfaceOffsetNotTruncated_dBAR';
elseif isfield(Data.TEDf,'PRES_SurfaceOffsetBeforeReset_1cBarResolution_dbar')==1
    MD.SurfacePressure=num2str(Data.TEDf.PRES_SurfaceOffsetBeforeReset_1cBarResolution_dbar(end));
    MD.SurfacePressureT='PRES_SurfaceOffsetBeforeReset_1cBarResolution_dbar';
else
    MD.SurfacePressure='';
    MD.SurfacePressureT='';
end

% InternalVacum
if isfield(Data.TEDf,'PRESSURE_InternalVacuum_COUNT')==1
    MD.InternalVacum=num2str(Data.TEDf.PRESSURE_InternalVacuum_COUNT(end));
    MD.InternalVacumT='PRESSURE_InternalVacuum_COUNT';
else
    MD.InternalVacum='';
    MD.InternalVacumT='';
end
end
