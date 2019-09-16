%Read the data from the Argo Spaon data set
clear all;close all

%% Read configuration

DataDirFloats='.';
boyasDSt=3902126;

fileM=sprintf('%s/%07d/%07d_meta.nc',DataDirFloats,boyasDSt,boyasDSt);
fileT=sprintf('%s/%07d/%07d_Rtraj.nc',DataDirFloats,boyasDSt,boyasDSt);
fileTe=sprintf('%s/%07d/%07d_tech.nc',DataDirFloats,boyasDSt,boyasDSt);
fileHi=sprintf('%s/%07d/profiles/',DataDirFloats,boyasDSt);

MTD=ReadArgoMetaFile(fileM);
TED=ReadArgoTechFile(fileTe);
TRD=ReadArgoTrayectoryFile(fileT);
Profs=ReadArgoFloatProfilesDM(fileHi);

figure
plot(TED.PRES_LastAscentPumpedRawSample_dbarCycle,TED.PRES_LastAscentPumpedRawSample_dbar)
figure
plot(TED.VOLTAGE_BatteryPumpStartProfile_voltsCycle,TED.VOLTAGE_BatteryPumpStartProfile_volts)