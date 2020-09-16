clear all;close all
%Crea la pagina argoesstatus.html con el google mapa de las posiciones de
%las boyas Argo-Es y las Argo-In

%% Read configuration
configArgoSpainWebpage


%CoberturaArgoGlobal
CoberturaArgoGlobal=4000;



%% Begin
fprintf('>>>>> %s\n',mfilename)

BoyasActivaArgoEs=25;

fid = fopen(FileTableArgoEsStatus,'w');
fprintf('     > Writting Google Earth file \n');
fprintf(fid,'<!DOCTYPE html> \n');
fprintf(fid,'<html> \n');
fprintf(fid,'<head> \n');
fprintf(fid,'<style> \n');
fprintf(fid,' \n');
fprintf(fid,'<link href=''https://fonts.googleapis.com/css?family=Poppins'' rel=''stylesheet''> \n');
fprintf(fid,'body { \n');
fprintf(fid,'    } \n');
fprintf(fid,'table { \n');
fprintf(fid,'  font-weight: bold; \n');
fprintf(fid,'  border-collapse: collapse; \n');
fprintf(fid,'  width: 100%;    font-family: ''Montserrat''; \n');
fprintf(fid,'} \n');

fprintf(fid,'td { \n');
fprintf(fid,'  border: 1px solid #00A2DD; \n');
fprintf(fid,'  font-weight: bold; \n');
fprintf(fid,'  color:#FFFFFF; \n');
fprintf(fid,'  font-weight: 800; \n');
fprintf(fid,'  font-size: 22px; \n');
fprintf(fid,'  text-align: center; \n');
fprintf(fid,'  padding: 8px; \n');
fprintf(fid,'  background-color: #00A2DD \n');
fprintf(fid,'} \n');
fprintf(fid,' \n');
fprintf(fid,'th { \n');
fprintf(fid,'  border: 1px solid #00A2DD; \n');
fprintf(fid,'  color:#FFFFFF; \n');
fprintf(fid,'  font-weight: 800; \n');
fprintf(fid,'  font-size: 52px; \n');
fprintf(fid,'  text-align: center; \n');
fprintf(fid,'  padding: 8px; \n');
fprintf(fid,'  background-color: #00A2DD \n');
fprintf(fid,'} \n');
fprintf(fid,' \n');
fprintf(fid,'tr:nth-child(even) { \n');
fprintf(fid,'  background-color: #00A2DD; \n');
fprintf(fid,'  text-align: center; \n');
fprintf(fid,'} \n');
fprintf(fid,' \n');
fprintf(fid,'</style> \n');
fprintf(fid,'</head> \n');
fprintf(fid,' \n');
fprintf(fid,'<body> \n');
fprintf(fid,'<center> \n');
fprintf(fid,'<table> \n');
fprintf(fid,'  <tr> \n');
fprintf(fid,'    <th>%d</th> \n',BoyasActivaArgoEs);
fprintf(fid,'    <th>10,993</th> \n');
fprintf(fid,'    <th>%3.1f%%</th> \n',BoyasActivaArgoEs/CoberturaArgoGlobal*100);
fprintf(fid,'  </tr> \n');
fprintf(fid,'  <tr> \n');
fprintf(fid,'    <td>PERFILADORES</td> \n');
fprintf(fid,'    <td>PERFILES OCEANOGR&Aacute;FICOS</td> \n');
fprintf(fid,'    <td>COBERTURA GLOBAL</td> \n');
fprintf(fid,'  </tr> \n');
fprintf(fid,'</table> \n');
fprintf(fid,'</center> \n');
fprintf(fid,'</body> \n');
fprintf(fid,'</html> \n');


fclose(fid);

%% Ftp the file
fprintf('     > Uploading  %s \n',FileTableArgoEsStatus);
ftpobj=FtpOceanografia;
cd(ftpobj,'/html/argo/html_files');
mput(ftpobj,FileTableArgoEsStatus);


fprintf('%s <<<<< \n',mfilename)
