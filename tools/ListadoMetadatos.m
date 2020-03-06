%Este script lee los daots de las boyas del programa ArgoEspana
clear all;close all;load Globales
clc

%General directory with argo data
DirArgoData='/Users/pvb/Data/Argo';
PaginaWebDir='/Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebArgoEs';

%Directory with the geographical data and the floats
DataDirFloats=fullfile(DirArgoData,'Floats');

%% Inicio
AE=load('../Data/DataArgoEs.mat','WMO');
WMO=AE.WMO;
[Y,I]=sort(WMO,'ascend');

fid=fopen('ArgoSpainMetadata.csv','w');
S=sprintf(    'PLATFORM_NUMBER,FIRST SURFACING,LAST SURFACING,FORMAT_VERSION,PROJECT_NAME,PI_NAME,FLOAT_OWNER,PERATING_INSTITUTION,DEPLOYMENT_CRUISE_ID,DEPLOYMENT_PLATFORM,PLATFORM_MARKER,PLATFORM_TYPE,FLOAT_SERIAL_NO,CONTROLLER_BOARD_SERIAL_NO_PRIMARY,FIRMWARE_VERSION,CONTROLLER_BOARD_TYPE_PRIMARY,TRANS_SYSTEM,PTT,SENSORS,SENSORS_SERIAL,BATTERY_TYPE,CONFIG_PARAMETER_NAME,CONFIG_PARAMETER_NAME_VALUE\n')
fprintf(    '%s',S);fprintf(fid,'%s',S);

for ifloat=I
    FloatData=load(sprintf('%s/%7d',DataDirFloats,WMO(ifloat)));
    
    FloatData.MTDf.SENSOR_text=[];
    for i1=1:size(FloatData.MTDf.SENSOR,1)
        FloatData.MTDf.SENSOR_text=[FloatData.MTDf.SENSOR_text '/ '  FloatData.MTDf.SENSOR(i1,:)];
    end
    
    FloatData.MTDf.SENSOR_SERIAL_NO_text=[];
    if isempty(FloatData.MTDf.SENSOR_SERIAL_NO)
        FloatData.MTDf.SENSOR_SERIAL_NO_text='na';
    else
        for i1=1:size(FloatData.MTDf.SENSOR_SERIAL_NO,1)
            FloatData.MTDf.SENSOR_SERIAL_NO_text=[FloatData.MTDf.SENSOR_SERIAL_NO_text '/ '  FloatData.MTDf.SENSOR_SERIAL_NO(i1,:)];
        end
    end
    
    if isfield(FloatData.MTDf,'CONFIG_PARAMETER_NAME')==1
        FloatData.MTDf.CONFIG_PARAMETER_NAME_text='';
        FloatData.MTDf.CONFIG_PARAMETER_VALUE_text='';
        for i1=1:size(FloatData.MTDf.CONFIG_PARAMETER_NAME,1)
            FloatData.MTDf.CONFIG_PARAMETER_NAME_text=[FloatData.MTDf.CONFIG_PARAMETER_NAME_text '/ '   strtrim(FloatData.MTDf.CONFIG_PARAMETER_NAME(i1,:))];
        end
        for i2=1:size(FloatData.MTDf.CONFIG_PARAMETER_VALUE,1)
            FloatData.MTDf.CONFIG_PARAMETER_VALUE_text=[FloatData.MTDf.CONFIG_PARAMETER_VALUE_text '/ '  num2str(FloatData.MTDf.CONFIG_PARAMETER_VALUE(i2,:))];
        end
    else
        FloatData.MTDf.CONFIG_PARAMETER_NAME_text='na';
        FloatData.MTDf.CONFIG_PARAMETER_VALUE_text='na';
    end
    
    if isfield(FloatData.MTDf,'CONFIG_PARAMETER_NAME')==1
        FloatData.MTDf.CONFIG_PARAMETER_NAME_VALUE_text='';
        for iparav=1:size(FloatData.MTDf.CONFIG_PARAMETER_VALUE,1)
            for iparan=1:size(FloatData.MTDf.CONFIG_PARAMETER_NAME,1)
                if iparan==1; sep1=sprintf(' [Mission%02d] ',iparav); else; sep1='/ ';end
                FloatData.MTDf.CONFIG_PARAMETER_NAME_VALUE_text=[FloatData.MTDf.CONFIG_PARAMETER_NAME_VALUE_text sep1 strtrim(FloatData.MTDf.CONFIG_PARAMETER_NAME(iparan,:)) ':' num2str(FloatData.MTDf.CONFIG_PARAMETER_VALUE(iparav,iparan))];
            end
        end
    else
        FloatData.MTDf.Prueba='na';
    end
    
    if ~isfield(FloatData.MTDf,'BATTERY_TYPE')
        FloatData.MTDf.BATTERY_TYPE='na';
    end
    if ~isfield(FloatData.MTDf,'OPERATING_INSTITUTION')
        FloatData.MTDf.OPERATING_INSTITUTION='na';
    end
    
    S=sprintf(    '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s \n', ...
        strtrim(FloatData.MTDf.PLATFORM_NUMBER), ...
        datestr(FloatData.HIDf.julds(1),1), ...)
        datestr(FloatData.HIDf.julds(end),1), ...)
        strtrim(FloatData.MTDf.FORMAT_VERSION), ...
        strtrim(FloatData.MTDf.PROJECT_NAME), ...
        strtrim(FloatData.MTDf.PI_NAME), ...
        strtrim(FloatData.MTDf.FLOAT_OWNER), ...
        strtrim(FloatData.MTDf.OPERATING_INSTITUTION), ...
        strtrim(FloatData.MTDf.DEPLOYMENT_CRUISE_ID), ...
        strtrim(FloatData.MTDf.DEPLOYMENT_PLATFORM), ...
        strtrim(FloatData.MTDf.PLATFORM_MARKER), ...
        strtrim(FloatData.MTDf.PLATFORM_TYPE), ...
        strtrim(FloatData.MTDf.FLOAT_SERIAL_NO), ...
        strtrim(FloatData.MTDf.CONTROLLER_BOARD_SERIAL_NO_PRIMARY), ...
        strtrim(FloatData.MTDf.FIRMWARE_VERSION), ...
        strtrim(FloatData.MTDf.CONTROLLER_BOARD_TYPE_PRIMARY), ...
        strtrim(FloatData.MTDf.TRANS_SYSTEM), ...
        strtrim(FloatData.MTDf.PTT), ...
        strtrim(FloatData.MTDf.SENSOR_text), ...
        strtrim(FloatData.MTDf.SENSOR_SERIAL_NO_text), ...
        strtrim(FloatData.MTDf.BATTERY_TYPE), ...
        strtrim(FloatData.MTDf.CONFIG_PARAMETER_NAME_VALUE_text));
    
    fprintf(    '%s',S);fprintf(fid,'%s',S);
end
fclose('all');

nper=0;
for i1=I
    nper=[nper size(FloatData.HIDf.tems,2)];
end