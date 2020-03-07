function [D]=ReadArgoMetaFile(file)
ncid=netcdf.open(file,'nc_nowrite');
D=struct('PLATFORM_NUMBER',{{}});

D.PLATFORM_NUMBER=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PLATFORM_NUMBER'))');

%% V2.1
try D.DEPLOY_MISSION=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'DEPLOY_MISSION'))'); catch ME; D.DEPLOY_MISSION=''; end
try D.PLATFORM_MODEL=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PLATFORM_MODEL')))';end
try D.FLOAT_SERIAL_NO=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'INST_REFERENCE'))');end
try
    D.PARKING_PRESSURE=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PARKING_PRESSURE'));
catch ME
    D.PARKING_PRESSURE='';
end
try
    D.DEEPEST_PRESSURE=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'DEEPEST_PRESSURE'));
catch ME
    D.DEEPEST_PRESSURE='';
end

%% V3.1
D.DATA_CENTRE=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'DATA_CENTRE'))');
D.PROJECT_NAME=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PROJECT_NAME'))');
try D.PI_NAME=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PI_NAME'))');catch ME; D.PI_NAME='';end
try D.FLOAT_OWNER=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'FLOAT_OWNER'))'); catch ME; D.FLOAT_OWNER=''; end
try D.DEPLOYMENT_CRUISE_ID=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'DEPLOYMENT_CRUISE_ID'))');catch ME;D.DEPLOYMENT_CRUISE_ID='';end
try D.DEPLOYMENT_PLATFORM=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'DEPLOYMENT_PLATFORM'))');catch ME;D.DEPLOYMENT_PLATFORM='';end


try D.HANDBOOK_VERSION=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'HANDBOOK_VERSION'))';catch ME; D.HANDBOOK_VERSION='';end
try D.FORMAT_VERSION=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'FORMAT_VERSION'))'; catch ME; D.FORMAT_VERSION=''; end

try D.FLOAT_SERIAL_NO=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'FLOAT_SERIAL_NO'))'); catch; D.FLOAT_SERIAL_NO='';end
try D.PLATFORM_FAMILY=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PLATFORM_FAMILY')))';end
try D.PLATFORM_MARKER=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PLATFORM_MAKER')))';end
try D.PLATFORM_TYPE=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PLATFORM_TYPE')))';end
try D.FIRMWARE_VERSION=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'FIRMWARE_VERSION')))'; catch; D.FIRMWARE_VERSION='';end
try D.BATTERY_TYPE=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'BATTERY_TYPE')))';end
try D.CONTROLLER_BOARD_TYPE_PRIMARY=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'CONTROLLER_BOARD_TYPE_PRIMARY')))';catch D.CONTROLLER_BOARD_TYPE_PRIMARY=''; end
try D.CONTROLLER_BOARD_SERIAL_NO_PRIMARY=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'CONTROLLER_BOARD_SERIAL_NO_PRIMARY')))';catch D.CONTROLLER_BOARD_SERIAL_NO_PRIMARY='';end


D.TRANS_SYSTEM=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'TRANS_SYSTEM'))');
try D.TRANS_SYSTEM_ID=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'TRANS_SYSTEM_ID'))');catch ME;D.TRANS_SYSTEM_ID='';end
D.PTT=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PTT'))'); %Transmission identifier

daynumr=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'START_DATE'))';
D.START_DATE=datenum(str2double(daynumr(1:4)),str2double(daynumr(5:6)),str2double(daynumr(7:8)));
D.LAUNCH_LATITUDE=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'LAUNCH_LATITUDE'));
D.LAUNCH_LONGITUDE=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'LAUNCH_LONGITUDE'));


try  D.LAUNCH_CONFIG_PARAMETER_NAME=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'LAUNCH_CONFIG_PARAMETER_NAME'))');end
try  D.LAUNCH_CONFIG_PARAMETER_VALUE=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'LAUNCH_CONFIG_PARAMETER_VALUE'));end

try D.CONFIG_PARAMETER_NAME=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'CONFIG_PARAMETER_NAME'))'); catch ME; D.CONFIG_PARAMETER_NAME='';end
try D.CONFIG_PARAMETER_VALUE=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'CONFIG_PARAMETER_VALUE'))';catch ME; D.CONFIG_PARAMETER_VALUE='';end

try D.PLATFORM_TYPE=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PLATFORM_TYPE'))');catch ME;D.PLATFORM_TYPE='';end
D.WMO_INST_TYPE=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'WMO_INST_TYPE'))');
D.SENSOR=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'SENSOR'))');
D.SENSOR_MAKER=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'SENSOR_MAKER'))');
D.SENSOR_MODEL=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'SENSOR_MODEL'))');
D.SENSOR_SERIAL_NO=strtrim(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'SENSOR_SERIAL_NO'))');

D.END_MISSION_STATUS=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'END_MISSION_STATUS'))';
daynumr=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'END_MISSION_DATE'))';
D.END_MISSION_DATE=datenum(str2double(daynumr(1:4)),str2double(daynumr(5:6)),str2double(daynumr(7:8)));
return
