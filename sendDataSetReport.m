clear all
%This script send by email the report of the updated webpage

%% Read options
configWebPage

[DayNumber,DayName] = weekday(now);

%try
R1=load(strcat(PaginaWebDir,'/data/reportcreateArgoRegionLLet'));
R2=load(strcat(PaginaWebDir,'/data/reportcreateArgoSpainLLet'));
R3=load(strcat(PaginaWebDir,'/data/reportArgoSpainStatus'));
R4=load(strcat(PaginaWebDir,'/data/reportArgoInterestStatus'));

if sendEmail==1
try
EnviaCorreoArgo('pvelezbelchi@gmail.com',sprintf('Web actualizada %s',datestr(now)),sprintf('%s\n\n%s\n\n%s\n\n%s\n\nhttps://www.argoespana.es',R1.Informe,R2.Informe,R3.Informe,R4.Informe))
catch ME
    MensajeError=sprintf('Error al enviar el informe tras actuaizar la web el %s',datestr(now)),sprintf('EnviaInforme - %s line %d',ME.message,ME.stack(1).line,datestr(now));
    EnviaCorreoArgo('pedro.velez@ieo.csic.es',MensajeError)
end
end

fid=fopen('./data/report.txt','w');
fprintf(fid,'<b>Argo Report</b>\n%s\n %s\n\n%s\n\n%s\n\n%s\n\nhttps://www.argoespana.es',datestr(now),R1.Informe,R2.Informe,R3.Informe,R4.Informe);
fclose(fid);
