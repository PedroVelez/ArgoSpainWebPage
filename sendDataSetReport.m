clear all
%This script send by email the report of the updated webpage

%% Read options
configWebPage

[DayNumber,DayName] = weekday(now);

% Read partial reports
R1=load(strcat(PaginaWebDir,'/data/reportcreateRegionGeoJSON.mat'));
R2=load(strcat(PaginaWebDir,'/data/reportcreateDataSetMapLLet.mat'));
R3=load(strcat(PaginaWebDir,'/data/reportArgoSpainStatus'));
R4=load(strcat(PaginaWebDir,'/data/reportArgoInterestStatus'));

%Write to a txt file
fid=fopen('./data/argoesreport.txt','w');
fprintf(fid,'<b>Argo Report</b>\n%s\n\n%s\n\n%s\n\n%s\n\n%s\n\n%s \n',datestr(now),R1.Informe,R2.Informe,R3.Informe,R4.Informe,domainName);
fclose(fid);

fprintf('     > Uploading  report  \n')
ftpobj=FtpArgoespana;
var=cd(ftpobj,ftp_dir_html);
outftp=mput(ftpobj,'./data/argoesreport.txt');

% Send by email
if sendEmail==1
try
EnviaCorreoArgo('pvelezbelchi@gmail.com',sprintf('Web actualizada %s',datestr(now)),sprintf('%s\n\n%s\n\n%s\n\n%s\n\n%s',R1.Informe,R2.Informe,R3.Informe,R4.Informe,domainName))
EnviaCorreoArgo('alberto.gonzalez@ieo.csic.es',sprintf('Web actualizada %s',datestr(now)),sprintf('%s\n\n%s\n\n%s\n\n%s\n\n%s',R1.Informe,R2.Informe,R3.Informe,R4.Informe,domainName))
catch ME
    MensajeError=sprintf('Error al enviar el informe tras actuaizar la web el %s',datestr(now)),sprintf('EnviaInforme - %s line %d',ME.message,ME.stack(1).line,datestr(now));
    EnviaCorreoArgo('pedro.velez@ieo.csic.es',MensajeError)
end
end
keyboard



