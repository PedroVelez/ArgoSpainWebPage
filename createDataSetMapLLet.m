clear all;close all
%Crea la pagina argoesstatus.html con el mapa creado con Ladlet de las posiciones de
%las boyas Argo-Es y las Argo-In

%% Read configuration
configWebPage

% TrajectorySpanArgo=now-datenum(2005,1,1);
%% Map
% MCentroArgoEs=[30,-16];
% MZoomArgoEs=1;
% MTamanoArgoEs=[675,390];
%% Output file
% FileHtmlArgoEsStatus;

%% Inicio
fprintf('>>>>> %s\n',mfilename)

% Read Data
DataArgoEs=load(strcat(PaginaWebDir,'/data/dataArgoSpain.mat'),'activa','iactiva','iinactiva','inodesplegada','FechaUltimoPerfil','WMO','UltimoVoltaje','UltimoSurfaceOffset');
FileNameInforme=strcat(PaginaWebDir,'/data/report',mfilename,'.mat');
fHTML = fopen(FileHtmlArgoEsStatus,'w');
fTxt = fopen(strrep(FileHtmlArgoEsStatus,'.html','.txt'),'w');


% Cuento numero de perfiles
NTotalPerfiles=0;
for ifloat=1:size(DataArgoEs.WMO,2)
    if DataArgoEs.activa(ifloat)==1 %Active
        FloatData = load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
        NTotalPerfiles = [NTotalPerfiles nanmax(FloatData.HIDf.cycle)'];
    else
        FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
        NTotalPerfiles=[NTotalPerfiles nanmax(FloatData.HIDf.cycle)'];
    end
end


% Writting leaflet file
fprintf('     > Writting leaflet file \n');
fprintf(fHTML,'<!DOCTYPE html> \n');
fprintf(fHTML,'<html> \n');
fprintf(fHTML,'<head> \n');
fprintf(fHTML,'	<title>Argo Espa&ntilde;a</title> \n');
fprintf(fHTML,'	<meta charset="utf-8" /> \n');
fprintf(fHTML,'	<meta name="viewport" content="width=device-width, initial-scale=1.0"> \n');

%Estilo
fprintf(fHTML,'<style type="text/css">\n');
fprintf(fHTML,'<!--.style1 {font-size: 16px; font-weight: bold;font-family: verdana; color: #0c2046;}-->\n');
fprintf(fHTML,'<!--.style2 {font-size: 14px; font-weight: normal; font-family: verdana; color: #0c2046}-->\n');
fprintf(fHTML,'<!--.style3 {font-size: 12px; font-weight: normal; font-family: verdana; color: #0c2046}-->\n');
fprintf(fHTML,'</style>\n');


%Leaflet libraries
fprintf(fHTML,'    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.6.0/dist/leaflet.css" integrity="sha512-xwE/Az9zrjBIphAcBb3F6JVqxf46+CDLwfLMHloNu6KEQCAWi6HcDUbeOfBIptF7tcCzusKFjFw2yuvEpDL9wQ==" crossorigin=""/> \n');
fprintf(fHTML,'    <script src="https://unpkg.com/leaflet@1.6.0/dist/leaflet.js" integrity="sha512-gZwIG9x3wUXg2hdXF6+rVkLF/0Vi9U8D2Ntg4Ga5I5BZpVkVxlJWbSQtXPSiUTtC0TjtGOmxa1AJPuV0CPthew==" crossorigin=""></script> \n');
%Full screen control
fprintf(fHTML,'    <script src=''https://api.mapbox.com/mapbox.js/plugins/leaflet-fullscreen/v1.0.1/Leaflet.fullscreen.min.js''></script>\n');
fprintf(fHTML,'    <link href=''https://api.mapbox.com/mapbox.js/plugins/leaflet-fullscreen/v1.0.1/leaflet.fullscreen.css'' rel=''stylesheet'' />\n');
fprintf(fHTML,'</head> \n');
fprintf(fHTML,'<body> \n');
fprintf(fHTML,'<div align="center">\n');

%Add current status of tthe Argo Spain Contribution
fprintf(fHTML,'<br><span class="style2"><div align="center">\n');
fprintf(fHTML,'Cobertura del programa <b>Argo Espa&ntilde;a</b> el %s a las %s <br />\n',datestr(now,1),datestr(now,13));
fprintf(fHTML,'</span></div>\n');
fprintf(fHTML,'<br><span class="style2"><div align="center">\n');
fprintf(fHTML,'(%d) perfiladores Activos, (%d) No desplegados y (%d) Inactivos. Último dato recibido el %s <br />\n',DataArgoEs.iactiva,DataArgoEs.inodesplegada,DataArgoEs.iinactiva,datestr(max(DataArgoEs.FechaUltimoPerfil)) );
fprintf(fHTML,'</span></div>\n');
fprintf(fHTML,'<br><span class="style2"><div align="center">\n');
fprintf(fHTML,'Hasta la fecha %d perfiles han sido realizados por las boyas del programa <b>Argo Espa&ntilde;a</b>\n',sum(NTotalPerfiles));
fprintf(fHTML,'</span></div><br>\n');

%Add map
fprintf(fHTML,'<div id="mapid" style="width: %dpx; height: %dpx;"></div> \n',MTamanoArgoEs(1),MTamanoArgoEs(2));
fprintf(fHTML,'</div> \n');
fprintf(fHTML,'<script> \n');
fprintf(fHTML,'// Initialize the map and set up control \n');
fprintf(fHTML,'   var mymap = L.map(''mapid'',{scrollwheelzoom: false}).setView([%4.2f, %4.2f],  %d); \n', MCentroArgoEs(1),MCentroArgoEs(2),MZoomArgoEs);
fprintf(fHTML,'     mymap.addControl(new L.Control.Fullscreen());\n');
fprintf(fHTML,'//Tiles \n');
fprintf(fHTML,'   L.tileLayer(''https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'', { \n');
fprintf(fHTML,'       attribution: ''Tiles &copy ESRI''}).addTo(mymap); \n');
fprintf(fHTML,'//Defino iconos \n');
fprintf(fHTML,'   var buoyIcon = L.Icon.extend({ \n');
fprintf(fHTML,'       options: { \n');
fprintf(fHTML,'           iconSize:     [33, 30], \n');
fprintf(fHTML,'           iconAnchor:   [16, 20], \n');
fprintf(fHTML,'           popupAnchor:  [-3, -76] \n');
fprintf(fHTML,'       } \n');
fprintf(fHTML,'   }); \n');
fprintf(fHTML,'   var buoyred = new buoyIcon({iconUrl: ''https://www.argoespana.es/imagenes/boyaroja.png''}), \n');
fprintf(fHTML,'       buoywhite = new buoyIcon({iconUrl: ''https://www.argoespana.es/imagenes/boyablanca.png''}); \n');


%% Escribo las trajectorias de lasboyas activas
fprintf(fHTML,'// Trayectorias de las boyas ArgoEspana \n');
for ifloat=1:size(DataArgoEs.WMO,2)
    if DataArgoEs.activa(ifloat)==1
        FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
        lon=FloatData.HIDf.lons;
        lat=FloatData.HIDf.lats;
        julds=FloatData.HIDf.julds;
        ind=find((julds-(now-TrajectorySpanArgo))>0 & isnan(lon)==0 & isnan(lat)==0);
        lon=lon(ind);
        lat=lat(ind);
        if isempty(lon)==0
            fprintf(fHTML,'		var TrayectoriaCoordinates = [ \n');
            for ii=1:1:length(lon)
                fprintf(fHTML,'			[%7.4f,%7.4f], \n',lat(ii),lon(ii));
            end
            fprintf(fHTML,'	                 ]; \n');
            fprintf(fHTML,'		var polyline = L.polyline(TrayectoriaCoordinates,{color: ''#FFFAFA'',opacity: 0.6,weight: 2.00}).addTo(mymap) \n');
        end
    elseif DataArgoEs.activa(ifloat)==2
        FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
        lon=FloatData.HIDf.lons;
        lat=FloatData.HIDf.lats;
        julds=FloatData.HIDf.julds;
        ind=find((julds-(now-TrajectorySpanArgo))>0 & isnan(lon)==0 & isnan(lat)==0);
        lon=lon(ind);
        lat=lat(ind);
        if isempty(lon)==0
            fprintf(fHTML,'		var TrayectoriaCoordinates = [ \n');
            for ii=1:1:length(lon)
                fprintf(fHTML,'			[%7.4f,%7.4f], \n',lat(ii),lon(ii));
            end
            fprintf(fHTML,'	                 ]; \n');
            fprintf(fHTML,'		var polyline = L.polyline(TrayectoriaCoordinates,{color: ''#FFFAFA'',opacity: 0.6,weight: 2.00}).addTo(mymap) \n');
        end
    end
end

%% last position [Flag,Platform, lat, lon, project]
%number of profiles done
fprintf(fHTML,' //Datos de ultima poscion de las las boyas\n');
fprintf(fHTML,'   var perfiladores = [ \n');
for ifloat=1:size(DataArgoEs.WMO,2)
    if DataArgoEs.activa(ifloat)==1 %Active
        FloatData = load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
        lats=FloatData.HIDf.lats(end);
        lons=FloatData.HIDf.lons(end);
        ind=find(isnan(lats)==0 & isnan(lons)==0);
        lats=lats(ind);
        lons=lons(ind);
        if ~isempty(lons) && ~isempty(lats)
            fprintf(fHTML,'           [1,%s,%4.2f,%4.2f,''%s'',''%s''], \n',deblank(FloatData.HIDf.platform(end,:)),lats(end),lons(end),deblank(FloatData.MTDf.PROJECT_NAME),datestr(FloatData.HIDf.julds(end)));
        end
    else
        FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
        lats=FloatData.HIDf.lats(end);
        lons=FloatData.HIDf.lons(end);
        ind=find(isnan(lats)==0 & isnan(lons)==0);
        lats=lats(ind);
        lons=lons(ind);
        if ~isempty(lons) && ~isempty(lats)
            fprintf(fHTML,'           [0,%s,%4.2f,%4.2f,''%s'',''%s''], \n',deblank(FloatData.HIDf.platform(end,:)),lats(end),lons(end),deblank(FloatData.MTDf.PROJECT_NAME),datestr(FloatData.HIDf.julds(end)));
        end
    end
end
fprintf(fHTML,'		]; \n');

fprintf(fHTML,'// Marcador de posicion de las boyas\n');
fprintf(fHTML,'	for (var i = 0; i < perfiladores.length; i++) {\n');
fprintf(fHTML,'		var perfilador = perfiladores[i];\n');
fprintf(fHTML,'		if(perfilador[0] == 1){\n');
fprintf(fHTML,'			L.marker([perfilador[2], perfilador[3]],{\n');
fprintf(fHTML,'			icon: buoyred,\n');
fprintf(fHTML,'			title: perfilador[4]+'' WMO ''+perfilador[1]+'' ''+perfilador[5],\n');
fprintf(fHTML,'			}).addTo(mymap).bindPopup(''<center><p>Boya <b><a href="https://www.argoespana.es/float/''+perfilador[1]+''.html" target="_blank">''+perfilador[1]+''</a></b><br><b>''+perfilador[4]+''</b><br><br><b>Fecha ultimo dato&nbsp;</b>''+perfilador[5]+''</p></center>'');\n');
fprintf(fHTML,'		}else if (perfilador[0] == 0) {\n');
fprintf(fHTML,'			L.marker([perfilador[2], perfilador[3]],{\n');
fprintf(fHTML,'			icon: buoywhite,\n');
fprintf(fHTML,'			title: perfilador[4]+'' WMO ''+perfilador[1]+'' ''+perfilador[5],\n');
fprintf(fHTML,'			}).addTo(mymap).bindPopup(''<center><p>Boya <b><a href="https://www.argoespana.es/float/''+perfilador[1]+''.html" target="_blank">''+perfilador[1]+''</a></b><br><b>''+perfilador[4]+''</b><br><br><b>Fecha ultimo dato&nbsp;</b>''+perfilador[5]+''</p></center>'');\n');
fprintf(fHTML,'		}\n');
fprintf(fHTML,'	}// Marcador de posicion de las boyas\n');


fprintf(fHTML,'//Funcion para crear la leyenda\n');
fprintf(fHTML,'	var legend = L.control({position: ''bottomright''});\n');
fprintf(fHTML,'	legend.onAdd = function (map) {\n');
fprintf(fHTML,'	    var div = L.DomUtil.create(''div'', ''info legend'');\n');
fprintf(fHTML,'       		div.innerHTML = "<img src=https://www.argoespana.es/imagenes/LeyendaArgoEs.png height=''75''><br>";\n');
fprintf(fHTML,'	    return div;\n');
fprintf(fHTML,'	};\n');
fprintf(fHTML,'	legend.addTo(mymap);\n');

fprintf(fHTML,' //Funcion para crear el titulo\n');
fprintf(fHTML,'	var titulo = L.control({position: ''topright''});\n');
fprintf(fHTML,'	titulo.onAdd = function (map) {\n');
fprintf(fHTML,'	    var div = L.DomUtil.create(''div'', ''info legend'');\n');
fprintf(fHTML,'			div.innerHTML  = '''' ;\n', DataArgoEs.iactiva,DataArgoEs.iinactiva,DataArgoEs.inodesplegada);
fprintf(fHTML,'  			div.style.color = ''white'';\n');
fprintf(fHTML,'			div.style.fontSize = ''12px'';\n');
fprintf(fHTML,'		    div.style.paddingLeft = ''0px'';\n');
fprintf(fHTML,'		    div.style.paddingRight = ''0px'';\n');
fprintf(fHTML,'		    div.style.paddingTop = ''0px'';\n');
fprintf(fHTML,'	    return div;\n');
fprintf(fHTML,'	};\n');
fprintf(fHTML,'	titulo.addTo(mymap);\n');
fprintf(fHTML,'</script> \n');

%% Tabla con los datos
%fprintf(fHTML,'<style type="text/css">\n');
%fprintf(fHTML,'<!--.style1 {font-size: 16px; font-weight: bold;font-family: verdana; color: #0c2046;}-->\n');
%fprintf(fHTML,'<!--.style3 {font-size: 12px; font-weight: normal; font-family: verdana; color: #0c2046}-->\n');
%fprintf(fHTML,'</style>\n');
fprintf(fHTML,'<BR>\n');
fprintf(fHTML,'<BR>\n');
fprintf(fHTML,'<TABLE width="900" border="0" align="center" cellpadding="2" cellspacing="3" >\n');
fprintf(fHTML,'<tr bgcolor="#C0C0C0">\n');
fprintf(fHTML,'<td width="56"> <div align="center" class="style1" ><div align="center"><strong>Estado</strong></div></div></td>\n');
fprintf(fHTML,'<td width="74"> <div align="center" class="style1" ><div align="center"><strong>WMO</strong></div></div></td>\n');
fprintf(fHTML,'<td width="113"><div align="center" class="style1" ><div align="center"><strong>Proyecto</strong></div></div></td>\n');
fprintf(fHTML,'<td width="106"><div align="center" class="style1" ><div align="center"><strong>Primer perfil</strong></div></div></td>\n');
fprintf(fHTML,'<td width="106"><div align="center" class="style1" ><div align="center"><strong>&Uacute;ltimo perfil </strong></div></div></td>\n');
fprintf(fHTML,'<td width="45"> <div align="center" class="style1" ><div align="center"><strong>Edad</strong></div></div></td>\n');
fprintf(fHTML,'<td width="100"><div align="center" class="style1" ><div align="center"><strong>Tipo boya</strong></div></div></td>\n');
%fprintf(fid,'<td width="50"> <div align="center" class="style1" ><div align="center"><strong>Voltaje</strong></div></div></td>\n');
%fprintf(fid,'<td width="50"> <div align="center" class="style1" ><div align="center"><strong>Surface offset</strong></div></div></td>\n');
fprintf(fHTML,'</TR>\n');
fprintf(fTxt,'# Boyas del Argo España ordenadas por ultimo perfil emitido \n');
fprintf(fTxt,'Estado; WMO; Proyecto; Primer perfil; ultimo perfil; Edad; Tipo de boya \n');

%Lee los datos de las boyas para poder crear la tabla de datos
%iactiva=0;iinactiva=0;inodesplegada=0;
for ifloat=1:size(DataArgoEs.WMO,2)
    MD = createDataSetStatus_FunctionMetadata(DataArgoEs.WMO(ifloat),DirArgoData);
    if DataArgoEs.activa(ifloat)>=1 %Activa o Inactiva con datos

        FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
        if DataArgoEs.activa(ifloat)==1
            fprintf('     > ACTIVA %7d; %12s; first:%s; last:%s; Age:%s; %s \n',MD.WMOFloat,MD.ProjectName,datestr(FloatData.HIDf.julds(1),22),datestr(FloatData.HIDf.julds(end),22),MD.Age,MD.PlatformModel)
            fprintf(fTxt,'Activa; %7d; %12s; %s; %s; %s; %s \n',MD.WMOFloat,MD.ProjectName,datestr(FloatData.HIDf.julds(1),22),datestr(FloatData.HIDf.julds(end),22),MD.Age,MD.PlatformModel);
            if mod(ifloat,2);
                fprintf(fHTML,'<tr height: 55px; bgcolor="#e5e5e5">\n');
            else
                fprintf(fHTML,'<tr height: 55px;">\n');
            end
            fprintf(fHTML,'<td width="56"> <div align="center" class="style3"><a href="https://www.argoespana.es/float/%d.html" target="_blank">Activa</span></div></td>',MD.WMOFloat);
            fprintf(fHTML,'<td width="74"> <div align="center" class="style3">%07d</span></div></td>',MD.WMOFloat);
            fprintf(fHTML,'<td width="113"><div align="center" class="style3">%12s</span></div></td>',MD.ProjectName);
            fprintf(fHTML,'<td width="106"><div align="center" class="style3">%s</span></div></td>',datestr(FloatData.HIDf.julds(1),22));
            fprintf(fHTML,'<td width="106"><div align="center" class="style3">%s</span></div></td>',datestr(FloatData.HIDf.julds(end),22));
            fprintf(fHTML,'<td width="45"> <div align="center" class="style3">%s</span></div></td>',MD.Age);
            fprintf(fHTML,'<td width="100"><div align="center" class="style3">%12s</span></div></td>',MD.PlatformModel);
            fprintf(fHTML,'</tr>');
        else
            fprintf('     > INACTIVA %7d; %12s; first:%s; last:%s; Age:%s; %s \n',MD.WMOFloat,MD.ProjectName,datestr(FloatData.HIDf.julds(1),22),datestr(FloatData.HIDf.julds(end),22),MD.Age,MD.PlatformModel)
            fprintf(fTxt,'Inactiva; %7d; %12s; %s; %s; %s; %s \n',MD.WMOFloat,MD.ProjectName,datestr(FloatData.HIDf.julds(1),22),datestr(FloatData.HIDf.julds(end),22),MD.Age,MD.PlatformModel);
            if mod(ifloat,2);
                fprintf(fHTML,'<TR height: 55px; bgcolor="#e5e5e5">\n');
            else
                fprintf(fHTML,'<TR height: 55px;">\n');
            end
            fprintf(fHTML,'<td width="56"> <div align="center" class="style3"><a href="https://www.argoespana.es/float/%d.html" target="_blank">Inactiva</span></div></td>',MD.WMOFloat);
            fprintf(fHTML,'<td width="74"> <div align="center" class="style3">%07d</span></div></td>',MD.WMOFloat);
            fprintf(fHTML,'<td width="113"><div align="center" class="style3">%12s</span></div></td>',MD.ProjectName);
            fprintf(fHTML,'<td width="106"><div align="center" class="style3">%s</span></div></td>',datestr(FloatData.HIDf.julds(1),22));
            fprintf(fHTML,'<td width="106"><div align="center" class="style3">%s</span></div></td>',datestr(FloatData.HIDf.julds(end),22));
            fprintf(fHTML,'<td width=" 45"><div align="center" class="style3">%s</span></div></td>',MD.Age);
            fprintf(fHTML,'<td width="100"><div align="center" class="style3">%12s</span></div></td>',MD.PlatformModel);
            fprintf(fHTML,'</tr>');
        end
    else
        fprintf('     > No Desplegada %7d\n',MD.WMOFloat)
        fprintf(fTxt,'No Desplegada; %7d;;;;;\n',MD.WMOFloat);
        fprintf(fHTML,'<tr class="style3">\n');
        fprintf(fHTML,'<td width="56"><div align="center" class="style3"><a>Inactiva</span></div></td>');
        fprintf(fHTML,'<td width="74"><div align="center" class="style3">%07d</span></div></td>',MD.WMOFloat);
        fprintf(fHTML,'<td width="113"><div align="center" class="style3">Por desplegar</span></div></td>');
        fprintf(fHTML,'<td width="106"><div align="center" class="style3"> ---- </span></div></td>');
        fprintf(fHTML,'<td width="106"><div align="center" class="style3"> ---- </span></div></td>');
        fprintf(fHTML,'<td width=" 45"><div align="center"  class="style3"> ---- </span></div></td>');
        fprintf(fHTML,'<td width="100"><div align="center" class="style3"> ---- </span></div></td>');
        fprintf(fHTML,'</tr>');
    end
end
fprintf(fHTML,'</Table>\n');
fprintf(fHTML,'</div>\n');

fprintf(fHTML,'</body>\n');
fprintf(fHTML,'</html>\n');
fclose(fHTML);
fclose(fTxt);

%% Ftp the file
fprintf('     > Uploading  %s, %s \n',FileHtmlArgoEsStatus,strrep(FileHtmlArgoEsStatus,'.html','.txt'));
ftpobj=FtpArgoespana;
cd(ftpobj,ftp_dir_html);
mput(ftpobj,FileHtmlArgoEsStatus);
mput(ftpobj,strrep(FileHtmlArgoEsStatus,'.html','.txt'));

%% Writting Informe
if exist(FileNameInforme,'file')>0
    InformeOld=load(FileNameInforme);
    Incremento=DataArgoEs.iactiva-InformeOld.iactiva;
else
    Incremento=0;
end
if Incremento~=0
    Informe=sprintf('ArgoSpainStatus - https://www.argoespana.es/argoesstatus.html \n     Activos (%d,%d) Inactivos (%d) No desplegados (%d)\n     Fecha ultimo dato %s\n     Updated on %s',DataArgoEs.iactiva,Incremento,DataArgoEs.iinactiva,DataArgoEs.inodesplegada,datestr(max(DataArgoEs.FechaUltimoPerfil)),datestr(now));
else
    Informe=sprintf('ArgoSpainStatus - https://www.argoespana.es/argoesstatus.html \n     Activos (%d) Inactivos (%d) No desplegados (%d)\n     Fecha ultimo dato %s\n     Updated on %s',DataArgoEs.iactiva,DataArgoEs.iinactiva,DataArgoEs.inodesplegada,datestr(max(DataArgoEs.FechaUltimoPerfil)),datestr(now));
end
iactiva=DataArgoEs.iactiva;
juldsAS=DataArgoEs.FechaUltimoPerfil;
WMO=DataArgoEs.WMO;
save(FileNameInforme,'Informe','iactiva','juldsAS','WMO')
fprintf('%s <<<<< \n',mfilename)

