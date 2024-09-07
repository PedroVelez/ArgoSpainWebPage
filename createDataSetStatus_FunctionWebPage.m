function  FileOutFHtml=createDataSetStatus_FunctionWebPage(WMO,GlobalDS)

if nargin==1
    GlobalDS.DirOutGraph='./html/floats';
    GlobalDS.DirArgoData='/Users/pvb/Data/Argo';
end

fprintf('web page, ')

%% Read Metada data
MD=createDataSetStatus_FunctionMetadata(WMO,GlobalDS.DirArgoData);

%% Escribe pagina web
FileOutFHtml=sprintf('%s/%07d.html',GlobalDS.DirOutGraph,WMO);
fid = fopen(FileOutFHtml,'w');
fprintf(fid,'<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">\n');
fprintf(fid,'<html>\n');
fprintf(fid,'<head>\n');
fprintf(fid,'<title>Argo Espa&ntilde;a %07d</title> \n',MD.WMOFloat);
fprintf(fid,'<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">\n');
fprintf(fid,'<style type="text/css">\n');
fprintf(fid,'<!--.style8 {font-size: 10px; font-weight: normal;font-family: Georgia, Arial, Helvetica, sans-serif; }-->\n');
fprintf(fid,'<!--.style9 {font-size: 10px; font-weight: bold; font-family: Goergia, Arial, Helvetica, sans-serif; }-->\n');
fprintf(fid,'</style>\n');
fprintf(fid,'</head>\n');
fprintf(fid,'<body>\n');

fprintf(fid,'<table width="900"  border="0" align="center" cellpadding="1" cellspacing="1" bordercolor="#999999">\n');
fprintf(fid,'<tr bordercolor="#999999">\n');
fprintf(fid,'<th width="403"><div align="left"><a href="https://www.argoespana.es/"><img src="https://www.argoespana.es/imagenes/logoargoes.png" border="0"></div></th>\n');
fprintf(fid,'<th width="325"><div align="right"><a href="http://www.ieo.es"><img src="https://www.argoespana.es/imagenes/logoieo.png" border="0"></a><a href="http://www.socib.es"><img src="https://www.argoespana.es/imagenes/logosocib.png" border="0"></a></div></th>\n');
fprintf(fid,'</tr>\n');
fprintf(fid,'</table>\n');

fprintf(fid,'<h2><strong><div align="center">&nbsp;&nbsp;Profiler WMO %7d</strong></h2></div>\n',MD.WMOFloat);

%informe de lanzamientofileReport
fileReport=fullfile(GlobalDS.DirArgoData,'Floats','Informes',strcat(num2str(WMO),'InformeLanzamiento.pdf'));
if exist(fileReport,'file')==2
    fprintf(fid,'<h3><div align="center"><a href="https://www.argoespana.es/Informes/%7dInformeLanzamiento.pdf">Informe de despliegue</a></h3></div>\n',MD.WMOFloat);
end

%informe de DMQC
fileReport=fullfile(GlobalDS.DirArgoData,'Floats','Informes',strcat(num2str(WMO),'InformeDMQC.pdf'));
if exist(fileReport,'file')==2
    fprintf(fid,'<h3><div align="center"><a href="https://www.argoespana.es/Informes/%7dInformeDMQC.pdf">Informe de Delayed Mode Quality Control</a></h3></div>\n',MD.WMOFloat);
end


%Acceso a los datosfprintf
%fprintf(fid,'<h3><div align="center"><a href="http://www.ifremer.fr/co-argoFloats/float?ptfCode=%7d">Acceso a los datos</a></h3></div>\n',MD.WMOFloat);

%EuroArgo at sea monitoring
fprintf(fid,'<h3><div align="center"><a href=" https://fleetmonitoring.euro-argo.eu/float/%7d">Acceso a los datos</a></h3></div>\n',MD.WMOFloat);


%Tabla con informacion
fprintf(fid,'<table width="900"  border="0" align="center" cellpadding="0" cellspacing="3">\n');
fprintf(fid,'<tr bordercolor="#333333" bgcolor="#FFFFFF">\n');
fprintf(fid,'<th width="25%%">&nbsp;</th>\n');
fprintf(fid,'<th width="25%%">&nbsp;</th>\n');
fprintf(fid,'<th width="25%%">&nbsp;</th>\n');
fprintf(fid,'<th width="25%%">&nbsp;</th>\n');
fprintf(fid,'</tr>\n');

fprintf(fid,'<tr bordercolor="#333333">\n');
fprintf(fid,'<th bgcolor="#33FFFF"><div align="left"><span class="style9">&nbsp;&nbsp;Transmission system</span></div></th>\n');
fprintf(fid,'<th><div align="left"><span class="style8">&nbsp;&nbsp;%s</span></div></th>\n',MD.TransmisionSystem);
fprintf(fid,'<th bgcolor="#33FFFF"><div align="left"><span class="style9">&nbsp;&nbsp;Transmission ID</span></div></th>\n');
fprintf(fid,'<th><div align="left"><span class="style8">&nbsp;&nbsp;%s</span></div></th>\n',MD.TransmissionID);
fprintf(fid,'</tr>\n');

fprintf(fid,'<tr bordercolor="#333333">\n');
fprintf(fid,'<th bgcolor="#33FFFF"><div align="left"><span class="style9">&nbsp;&nbsp;Platform model</span></div></th>\n');
fprintf(fid,'<th><div align="left"><span class="style8">&nbsp;&nbsp;%s</span></div></th>\n',MD.PlatformModel);
fprintf(fid,'<th bgcolor="#33FFFF"><div align="left"><span class="style9">&nbsp;&nbsp;Platform ID</span></div></th>\n');
fprintf(fid,'<th><div align="left"><span class="style8">&nbsp;&nbsp;%s</span></div></th>\n',MD.PlatformID);
fprintf(fid,'</tr>\n');

fprintf(fid,'<tr bordercolor="#333333">\n');
fprintf(fid,'<th bgcolor="#33FFFF"><div align="left"><span class="style9">&nbsp;&nbsp;Sensors</span></div></th>\n');
fprintf(fid,'<th><div align="left"><span class="style8">&nbsp;&nbsp;%s</span></div></th>\n',MD.Sensors);
fprintf(fid,'<th bgcolor="#33FFFF"><div align="left"><span class="style9">&nbsp;&nbsp;Sensores s/n</span></div></th>\n');
fprintf(fid,'<th><div align="left"><span class="style8">&nbsp;&nbsp;%s</span></div></th>\n',MD.SensorsID);
fprintf(fid,'</tr>\n');

fprintf(fid,'<th bgcolor="#33FFFF"><div align="left"><span class="style9">&nbsp;&nbsp;Data Centre (Format version)</span></div></th>\n');
fprintf(fid,'<th><div align="left"><span class="style8">&nbsp;&nbsp;%s</span></div></th>\n',MD.DataCentre);
fprintf(fid,'<th bgcolor="#33FFFF"><div align="left"><span class="style9">&nbsp;&nbsp;Project name</span></div></th>\n');
fprintf(fid,'<th><div align="left"><span class="style8">&nbsp;&nbsp;%s</span></div></th>\n',MD.ProjectName);
fprintf(fid,'</tr>\n');

fprintf(fid,'<th bgcolor="#33FFFF"><div align="left"><span class="style9">&nbsp;&nbsp;Float Owner</span></div></th>\n');
fprintf(fid,'<th><div align="left"><span class="style8">&nbsp;&nbsp;%s</span></div></th>\n',MD.FloatOwner);
fprintf(fid,'<th bgcolor="#33FFFF"><div align="left"><span class="style9">&nbsp;&nbsp;PI Name</span></div></th>\n');
fprintf(fid,'<th><div align="left"><span class="style8">&nbsp;&nbsp;%s</span></div></th>\n',MD.PIName);
fprintf(fid,'</tr>\n');

fprintf(fid,'<tr bordercolor="#333333">\n');
fprintf(fid,'<th bgcolor="#33FFFF"><div align="left"><span class="style9">&nbsp;&nbsp;Parking depth (dbar)</span></div></th>\n');
fprintf(fid,'<th><div align="left"><span class="style8">&nbsp;&nbsp;%s</span></div></th>\n',MD.ParkingDepth);
fprintf(fid,'<th bgcolor="#33FFFF"><div align="left"><span class="style9">&nbsp;&nbsp;Profile depth (dbar)</span></div></th>\n');
fprintf(fid,'<th><div align="left"><span class="style8">&nbsp;&nbsp;%s</span></div></th>\n',MD.ProfileDepth);
fprintf(fid,'</tr>\n');

fprintf(fid,'<tr bordercolor="#333333">\n');
fprintf(fid,'<th bgcolor="#33FFFF"><div align="left"><span class="style9">&nbsp;&nbsp;Number of profiles</span></div></th>\n');
fprintf(fid,'<th><div align="left"><span class="style8">&nbsp;&nbsp;%s</span></div></th>\n',MD.NumberOfProfiles);
fprintf(fid,'<th bgcolor="#33FFFF"><div align="left"><span class="style9">&nbsp;&nbsp;Status</span></div></th>\n');
fprintf(fid,'<th><div align="left"><span class="style8">&nbsp;&nbsp;%s</span></div></th>\n',MD.StatusT);
fprintf(fid,'</tr>\n');
fprintf(fid,'<tr bordercolor="#333333">\n');
fprintf(fid,'<th bgcolor="#33FFFF"><div align="left"><span class="style9">&nbsp;&nbsp;Deployment date</span></div></th>\n');
fprintf(fid,'<th><div align="left"><span class="style8">&nbsp;&nbsp;%s</span></div></th>\n',MD.LaunchDate);
fprintf(fid,'<th bgcolor="#33FFFF"><div align="left"><span class="style9">&nbsp;&nbsp;Deployed position</span></div></th>\n');
fprintf(fid,'<th><div align="left"><span class="style8">&nbsp;&nbsp;%s</span></div></th>\n',MD.LaunchPosition);
fprintf(fid,'</tr>\n');

fprintf(fid,'<tr bordercolor="#333333">\n');
fprintf(fid,'<th bgcolor="#33FFFF"><div align="left"><span class="style9">&nbsp;&nbsp;Last surfacing date</span></div></th>\n');
fprintf(fid,'<th><div align="left"><span class="style8">&nbsp;&nbsp;%s</span></div></th>\n',MD.LastSurfacingDate);
fprintf(fid,'<th bgcolor="#33FFFF"><div align="left"><span class="style9">&nbsp;&nbsp;Last surfacing position</span></div></th>\n');
fprintf(fid,'<th><div align="left"><span class="style8">&nbsp;&nbsp;%s</span></div></th>\n',MD.LastSurfacingPosition);
fprintf(fid,'</tr>\n');

fprintf(fid,'<tr bordercolor="#333333">\n');
fprintf(fid,'<th bgcolor="#33FFFF"><div align="left"><span class="style9">&nbsp;&nbsp;Age (Yr)</span></div></th>\n');
fprintf(fid,'<th><div align="left"><span class="style8">&nbsp;&nbsp;%s</span></div></th>\n',MD.Age);
fprintf(fid,'<th bgcolor="#33FFFF"><div align="left"><span class="style9">&nbsp;&nbsp;%s</span></div></th>\n',MD.VoltageT);
fprintf(fid,'<th><div align="left"><span class="style8">&nbsp;&nbsp;%s</span></div></th>\n',MD.Voltage);
fprintf(fid,'</tr>\n');

fprintf(fid,'<tr bordercolor="#333333">\n');
fprintf(fid,'<th bgcolor="#33FFFF"><div align="left"><span class="style9">&nbsp;&nbsp;%s</span></div></th>\n',MD.SurfacePressureT);
fprintf(fid,'<th><div align="left"><span class="style8">&nbsp;&nbsp;%s</span></div></th>\n',MD.SurfacePressure);
fprintf(fid,'<th bgcolor="#33FFFF"><div align="left"><span class="style9">&nbsp;&nbsp;%s</span></div></th>\n',MD.InternalVacumT);
fprintf(fid,'<th><div align="left"><span class="style8">&nbsp;&nbsp;%s</span></div></th>\n',MD.InternalVacum);
fprintf(fid,'</tr>\n');

fprintf(fid,'<tr bordercolor="#333333" bgcolor="#FFFFFF">\n');
fprintf(fid,'<th>&nbsp;</th>\n');
fprintf(fid,'<th>&nbsp;</th>\n');
fprintf(fid,'<th>&nbsp;</th>\n');
fprintf(fid,'<th>&nbsp;</th>\n');
fprintf(fid,'</tr>\n');
fprintf(fid,'</table>\n');

fprintf(fid,'<table width="1000"  border="0" align="center">\n');
fprintf(fid,'<tr>\n');
fprintf(fid,'<td><div align="left"><a href="./%07dA_Zoom.png"><img src="./%07dA.png" width="934"></a></div></td>\n',MD.WMOFloat,MD.WMOFloat);
fprintf(fid,'</tr>\n');
fprintf(fid,'</table>\n');

fprintf(fid,'</table>\n');
fprintf(fid,'<table width="1000"  border="0" align="center">\n');
fprintf(fid,'<tr>\n');
fprintf(fid,'<td><div align="left"><img src="./%07dB.png" width="944"></div></td>\n',MD.WMOFloat);
fprintf(fid,'</tr>\n');
fprintf(fid,'</table>\n');

fprintf(fid,'</table>\n');
fprintf(fid,'<table width="1000"  border="0" align="center">\n');
fprintf(fid,'<tr>\n');
fprintf(fid,'<td><div align="left"><img src="./%07dC.png" width="979"></div></td>\n',MD.WMOFloat);

fprintf(fid,'</tr>\n');
fprintf(fid,'</table>\n');

fprintf(fid,'<p>&nbsp;</p>\n');
fprintf(fid,'</body>\n');
fprintf(fid,'</html>\n');
fclose(fid);
%end
