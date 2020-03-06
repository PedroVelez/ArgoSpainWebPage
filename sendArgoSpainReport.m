clear all
%This script send by email the report of the updated webpage

%% Read options
sendArgoSpainReport.m

[DayNumber,DayName] = weekday(now);

%try
R1=load(strcat(PaginaWebDir,'/Data/reportcreateArgoRegionGMap'));
R2=load(strcat(PaginaWebDir,'/Data/reportcreateArgoSpainGMap'));
R3=load(strcat(PaginaWebDir,'/Data/reportArgoEsStatus'));
R4=load(strcat(PaginaWebDir,'/Data/reportArgoInStatus'));

%EnviaCorreoArgo('pedro.velez@ieo.es',sprintf('Web actualizada %s',datestr(now)),sprintf('%s\n\n%s\n\n%s\n\n%s\n\nhttp://www.argoespana.es',R1.Informe,R2.Informe,R3.Informe,R4.Informe))

%catch ME
%    MensajeError=sprintf('Error al enviar el informe tras actuaizar la web el %s',datestr(now)),sprintf('EnviaInforme - %s line %d',ME.message,ME.stack(1).line,datestr(now));
%    EnviaCorreoArgo('pedro.velez@ieo.es',MensajeError)
%end
