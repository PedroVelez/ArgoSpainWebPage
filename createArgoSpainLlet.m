clear all;close all
%Crea la pagina argoesstatus.html con el google mapa de las posiciones de
%las boyas Argo-Es y las Argo-In

%% Read configuration
configArgoSpainWebpage

% TrajectorySpanArgo=now-datenum(2005,1,1);
% %GoogleMap
% GMCentroArgoEs=[30,-16];
% GMZoomArgoEs=1;
% GMTamanoArgoEs=[675,390];
% %Output file
% FileHtmlArgoEsStatus='argoesstatusgm.html';
FileHtmlArgoEsStatus=FilellHtmlArgoEsStatus;

%% Inicio
% Read Data
DataArgoEs=load(strcat(PaginaWebDir,'/data/dataArgoSpain.mat'),'activa','iactiva','iinactiva','inodesplegada','FechaUltimoPerfil','WMO','UltimoVoltaje','UltimoSurfaceOffset');

%Cuento numero de perfiles
NTotalPerfiles=0;

fprintf('>>>>> %s\n',mfilename)
FileNameInforme=strcat(PaginaWebDir,'/data/report',mfilename,'.mat');
fid = fopen(FileHtmlArgoEsStatus,'w');
fprintf('     > Writting leaflet file \n');
fprintf(fid,'<!DOCTYPE html> \n');
fprintf(fid,'<html> \n');
fprintf(fid,'<head> \n');
fprintf(fid,'	<title>Argo Espa&ntilde;a</title> \n');
fprintf(fid,'	<meta charset="utf-8" /> \n');
fprintf(fid,'	<meta name="viewport" content="width=device-width, initial-scale=1.0"> \n');
%Leaflet libraries
fprintf(fid,'    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.6.0/dist/leaflet.css" integrity="sha512-xwE/Az9zrjBIphAcBb3F6JVqxf46+CDLwfLMHloNu6KEQCAWi6HcDUbeOfBIptF7tcCzusKFjFw2yuvEpDL9wQ==" crossorigin=""/> \n');
fprintf(fid,'    <script src="https://unpkg.com/leaflet@1.6.0/dist/leaflet.js" integrity="sha512-gZwIG9x3wUXg2hdXF6+rVkLF/0Vi9U8D2Ntg4Ga5I5BZpVkVxlJWbSQtXPSiUTtC0TjtGOmxa1AJPuV0CPthew==" crossorigin=""></script> \n');
%Full screen control
fprintf(fid,'    <script src=''https://api.mapbox.com/mapbox.js/plugins/leaflet-fullscreen/v1.0.1/Leaflet.fullscreen.min.js''></script>\n');
fprintf(fid,'    <link href=''https://api.mapbox.com/mapbox.js/plugins/leaflet-fullscreen/v1.0.1/leaflet.fullscreen.css'' rel=''stylesheet'' />\n');
fprintf(fid,'</head> \n');
fprintf(fid,'<body> \n');
fprintf(fid,'<div align="center">\n');
%Add current status of tthe Argo Spain Contribution 
fprintf(fid,'<p>\n');
fprintf(fid,'Cobertura del programa <b>Argo Espa&ntilde;a</b> el %s a las %s <br />\n',datestr(now,1),datestr(now,13));
fprintf(fid,'(%d) perfiladores Activos, (%d) No desplegados y (%d) Inactivos. Ultimo perfil recibido el %s <br />\n',DataArgoEs.iactiva,DataArgoEs.inodesplegada,DataArgoEs.iinactiva,datestr(max(DataArgoEs.FechaUltimoPerfil)) );
fprintf(fid,'Hasta la fecha %d perfiles han sido realizados por las boyas del programa <b>Argo Espa&ntilde;a</b>\n',sum(NTotalPerfiles));
fprintf(fid,'</p>\n');

%Add map
fprintf(fid,'<div id="mapid" style="width: %dpx; height: %dpx;"></div> \n',GMTamanoArgoEs(1),GMTamanoArgoEs(2));
fprintf(fid,'</div> \n');
fprintf(fid,'<script> \n');
fprintf(fid,'// Initialize the map and set up control \n');
fprintf(fid,'   var mymap = L.map(''mapid'',{scrollwheelzoom: false}).setView([%4.2f, %4.2f],  %d); \n', GMCentroArgoEs(1),GMCentroArgoEs(2),GMZoomArgoEs);
fprintf(fid,'     mymap.addControl(new L.Control.Fullscreen());\n');
fprintf(fid,'//Tiles \n');
fprintf(fid,'   L.tileLayer(''https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'', { \n');
fprintf(fid,'       attribution: ''Tiles &copy ESRI''}).addTo(mymap); \n');
fprintf(fid,'//Defino iconos \n');
fprintf(fid,'   var buoyIcon = L.Icon.extend({ \n');
fprintf(fid,'       options: { \n');
fprintf(fid,'           iconSize:     [33, 30], \n');
fprintf(fid,'           iconAnchor:   [16, 20], \n');
fprintf(fid,'           popupAnchor:  [-3, -76] \n');
fprintf(fid,'       } \n');
fprintf(fid,'   }); \n');
fprintf(fid,'   var buoyred = new buoyIcon({iconUrl: ''http://www.oceanografia.es/argo/imagenes/boyaroja.png''}), \n');
fprintf(fid,'       buoywhite = new buoyIcon({iconUrl: ''http://www.oceanografia.es/argo/imagenes/boyablanca.png''}); \n');


%% Escribo las trajectorias de lasboyas activas
fprintf(fid,'// Trayectorias de las boyas ArgoEspana \n');
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
            fprintf(fid,'		var TrayectoriaCoordinates = [ \n');
            for ii=1:1:length(lon)
                fprintf(fid,'			[%7.4f,%7.4f], \n',lat(ii),lon(ii));
            end
            fprintf(fid,'	                 ]; \n');
            fprintf(fid,'		var polyline = L.polyline(TrayectoriaCoordinates,{color: ''#FFFAFA'',opacity: 0.6,weight: 2.00}).addTo(mymap) \n');
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
            fprintf(fid,'		var TrayectoriaCoordinates = [ \n');
            for ii=1:1:length(lon)
                fprintf(fid,'			[%7.4f,%7.4f], \n',lat(ii),lon(ii));
            end
            fprintf(fid,'	                 ]; \n');
            fprintf(fid,'		var polyline = L.polyline(TrayectoriaCoordinates,{color: ''#FFFAFA'',opacity: 0.6,weight: 2.00}).addTo(mymap) \n');
        end
    end
end

%% last position [Flag,Platform, lat, lon, project]
%number of profiles done
fprintf(fid,' //Datos de ultima poscion de las las boyas\n');
fprintf(fid,'   var perfiladores = [ \n');
for ifloat=1:size(DataArgoEs.WMO,2)
    if DataArgoEs.activa(ifloat)==1 %Active
        FloatData = load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
        NTotalPerfiles = [NTotalPerfiles nanmax(FloatData.HIDf.cycle)'];
        lats=FloatData.HIDf.lats(end);
        lons=FloatData.HIDf.lons(end);
        ind=find(isnan(lats)==0 & isnan(lons)==0);
        lats=lats(ind);
        lons=lons(ind);
        if ~isempty(lons) && ~isempty(lats)
            fprintf(fid,'           [1,%s,%4.2f,%4.2f,''%s'',''%s''], \n',deblank(FloatData.HIDf.platform(end,:)),lats(end),lons(end),deblank(FloatData.MTDf.PROJECT_NAME),datestr(FloatData.HIDf.julds(end)));
        end
    else
        FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
        NTotalPerfiles=[NTotalPerfiles nanmax(FloatData.HIDf.cycle)'];
        lats=FloatData.HIDf.lats(end);
        lons=FloatData.HIDf.lons(end);
        ind=find(isnan(lats)==0 & isnan(lons)==0);
        lats=lats(ind);
        lons=lons(ind);
        if ~isempty(lons) && ~isempty(lats)
            fprintf(fid,'           [0,%s,%4.2f,%4.2f,''%s'',''%s''], \n',deblank(FloatData.HIDf.platform(end,:)),lats(end),lons(end),deblank(FloatData.MTDf.PROJECT_NAME),datestr(FloatData.HIDf.julds(end)));
        end
    end
end
fprintf(fid,'		]; \n');

fprintf(fid,'// Marcador de posicion de las boyas\n');
fprintf(fid,'	for (var i = 0; i < perfiladores.length; i++) {\n');
fprintf(fid,'		var perfilador = perfiladores[i];\n');
fprintf(fid,'		if(perfilador[0] == 0){\n');
fprintf(fid,'			L.marker([perfilador[2], perfilador[3]],{\n');
fprintf(fid,'			icon: buoyred,\n');
fprintf(fid,'			title: perfilador[4]+'' WMO ''+perfilador[1]+'' ''+perfilador[5],\n');
fprintf(fid,'			}).addTo(mymap).bindPopup(''<center><p>Float <b><a href="http://www.oceanografia.es/argo/datos/floats/''+perfilador[1]+''.html" target="_blank">''+perfilador[1]+''</a></b><br><b>''+perfilador[4]+''</b><br><br><b>Last profile&nbsp;</b>''+perfilador[5]+''</p></center>'');\n');
fprintf(fid,'		}else if (perfilador[0] == 1) {\n');
fprintf(fid,'			L.marker([perfilador[2], perfilador[3]],{\n');
fprintf(fid,'			icon: buoywhite,\n');
fprintf(fid,'			title: perfilador[4]+'' WMO ''+perfilador[1]+'' ''+perfilador[5],\n');
fprintf(fid,'			}).addTo(mymap).bindPopup(''<center><p>Float <b><a href="http://www.oceanografia.es/argo/datos/floats/''+perfilador[1]+''.html" target="_blank">''+perfilador[1]+''</a></b><br><b>''+perfilador[4]+''</b><br><br><b>Last profile&nbsp;</b>''+perfilador[5]+''</p></center>'');\n');
fprintf(fid,'		}\n');
fprintf(fid,'	}// Marcador de posicion de las boyas\n');


fprintf(fid,'//Funcion para crear la leyenda\n');
fprintf(fid,'	var legend = L.control({position: ''bottomright''});\n');
fprintf(fid,'	legend.onAdd = function (map) {\n');
fprintf(fid,'	    var div = L.DomUtil.create(''div'', ''info legend'');\n');
fprintf(fid,'       		div.innerHTML = "<img src=http://www.oceanografia.es/argo/imagenes/LeyendaArgoEs.png height=''75''><br>";\n');
fprintf(fid,'	    return div;\n');
fprintf(fid,'	};\n');
fprintf(fid,'	legend.addTo(mymap);\n');

fprintf(fid,' //Funcion para crear el titulo\n');
fprintf(fid,'	var titulo = L.control({position: ''topright''});\n');
fprintf(fid,'	titulo.onAdd = function (map) {\n');
fprintf(fid,'	    var div = L.DomUtil.create(''div'', ''info legend'');\n');
fprintf(fid,'			div.innerHTML  = '''' \n');
%fprintf(fid,'			div.innerHTML  = ''<b>Cobertura del programa Argo %s el %s a las %s</b> <br/>'' +\n',TituloArgoIbStatus,datestr(LastJday,1),datestr(LastJday,13));
%fprintf(fid,'	                         ''<b>Hasta la fecha %d perfiles oceanogr&aacute;ficos han sido medidos por las boyas del programa <b>Argo Espa&ntilde;a</b><br />'' +\n',sum(NTotalPerfiles));
%fprintf(fid,'	                         ''<b>Pulse en el icono de un perfilador para acceder a informaci&oacute;n m&aacute;s detallada sobre los datos medidos </b><br />'';\n');
fprintf(fid,'  			div.style.color = ''white'';\n');
fprintf(fid,'			div.style.fontSize = ''12px'';\n');
fprintf(fid,'		    div.style.paddingLeft = ''0px'';\n');
fprintf(fid,'		    div.style.paddingRight = ''0px'';\n');
fprintf(fid,'		    div.style.paddingTop = ''0px'';\n');
fprintf(fid,'	    return div;\n');
fprintf(fid,'	};\n');
fprintf(fid,'	titulo.addTo(mymap);\n');
fprintf(fid,'</script> \n');

%% Tabla con los datos
fprintf(fid,'<style type="text/css">\n');
fprintf(fid,'<!--\n');
fprintf(fid,'.style1 {font-family: Verdana, Arial, Helvetica, sans-serif}\n');
fprintf(fid,'.style4 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px; }\n');
fprintf(fid,'-->\n');
fprintf(fid,'</style>\n');
fprintf(fid,'<BR>\n');
fprintf(fid,'<BR>\n');
fprintf(fid,'<TABLE width="800" border="1" align="center" bordercolor="#003366">\n');
fprintf(fid,'<TR bgcolor="#C0C0C0">\n');
fprintf(fid,'<TD width="56"> <div align="center" class="style1" ><div align="center"><strong>Estado</strong></div></div></TD>\n');
fprintf(fid,'<TD width="74"> <div align="center" class="style1" ><div align="center"><strong>ID</strong></div></div></TD>\n');
fprintf(fid,'<TD width="113"><div align="center" class="style1" ><div align="center"><strong>Proyecto</strong></div></div></TD>\n');
fprintf(fid,'<TD width="106"><div align="center" class="style1" ><div align="center"><strong>Primer perfil </strong></div></div></TD>\n');
fprintf(fid,'<TD width="106"><div align="center" class="style1" ><div align="center"><strong>&Uacute;ltimo perfil </strong></div></div></TD>\n');
fprintf(fid,'<TD width="45"> <div align="center" class="style1" ><div align="center"><strong>Edad</strong></div></div></TD>\n');
fprintf(fid,'<TD width="100"><div align="center" class="style1" ><div align="center"><strong>Tipo boya </strong></div></div></TD>\n');
fprintf(fid,'<TD width="50"> <div align="center" class="style1" ><div align="center"><strong>Voltaje</strong></div></div></TD>\n');
fprintf(fid,'<TD width="50"> <div align="center" class="style1" ><div align="center"><strong>Surface offset</strong></div></div></TD>\n');
fprintf(fid,'</TR>\n');

%Lee los datos de las boyas para poder crear la tabla de datos
%iactiva=0;iinactiva=0;inodesplegada=0;
for ifloat=1:size(DataArgoEs.WMO,2)
    MD = createArgoSpainStatus_FunctionMetadata(DataArgoEs.WMO(ifloat),DirArgoData);
    if DataArgoEs.activa(ifloat)>=1 %Activa o Inactiva con datos
        FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
        if DataArgoEs.activa(ifloat)==1
            fprintf('     > ACTIVA %7d; %12s; first:%s; last:%s; Age:%s; %s \n',MD.WMOFloat,MD.ProjectName,datestr(FloatData.HIDf.julds(1),22),datestr(FloatData.HIDf.julds(end),22),MD.Age,MD.PlatformModel)
            fprintf(fid,'<TR class="style4">\n');
            fprintf(fid,'<TD width="56"> <div align="center" class="style4"><a href="http://www.oceanografia.es/argo/datos/floats/%d.html" target="_blank">Activa</span></div></TD>',MD.WMOFloat);
            fprintf(fid,'<TD width="74"> <div align="center" class="style4">%07d</span></div></TD>',MD.WMOFloat);
            fprintf(fid,'<TD width="113"><div align="center" class="style4">%12s</span></div></TD>',MD.ProjectName);
            fprintf(fid,'<TD width="106"><div align="center" class="style4">%s</span></div></TD>',datestr(FloatData.HIDf.julds(1),22));
            fprintf(fid,'<TD width="106"><div align="center" class="style4">%s</span></div></TD>',datestr(FloatData.HIDf.julds(end),22));
            fprintf(fid,'<TD width="45"> <div align="center"  class="style4">%s</span></div></TD>',MD.Age);
            fprintf(fid,'<TD width="100"><div align="center" class="style4">%12s</span></div></TD>',MD.PlatformModel);
            fprintf(fid,'<TD width="50"> <div align="center" class="style4">%4.2f</span></div></TD>',DataArgoEs.UltimoVoltaje(ifloat));
            fprintf(fid,'<TD width="50"> <div align="center" class="style4">%4.2f</span></div></TD>',DataArgoEs.UltimoSurfaceOffset(ifloat));
            fprintf(fid,'</TR>');
        else
            fprintf('     > INACTIVA %7d; %12s; first:%s; last:%s; Age:%s; %s \n',MD.WMOFloat,MD.ProjectName,datestr(FloatData.HIDf.julds(1),22),datestr(FloatData.HIDf.julds(end),22),MD.Age,MD.PlatformModel)
            fprintf(fid,'<TR class="style4">\n');
            fprintf(fid,'<TD width="56"> <div align="center" class="style4"><a href="http://www.oceanografia.es/argo/datos/floats/%d.html" target="_blank">Inactiva</span></div></TD>',MD.WMOFloat);
            fprintf(fid,'<TD width="74"> <div align="center" class="style4">%07d</span></div></TD>',MD.WMOFloat);
            fprintf(fid,'<TD width="113"><div align="center" class="style4">%12s</span></div></TD>',MD.ProjectName);
            fprintf(fid,'<TD width="106"><div align="center" class="style4">%s</span></div></TD>',datestr(FloatData.HIDf.julds(1),22));
            fprintf(fid,'<TD width="106"><div align="center" class="style4">%s</span></div></TD>',datestr(FloatData.HIDf.julds(end),22));
            fprintf(fid,'<TD width="45"> <div align="center" class="style4">%s</span></div></TD>',MD.Age);
            fprintf(fid,'<TD width="100"><div align="center" class="style4">%12s</span></div></TD>',MD.PlatformModel);
            fprintf(fid,'<TD width="50"> <div align="center" class="style4">%4.2f</span></div></TD>',DataArgoEs.UltimoVoltaje(ifloat));
            fprintf(fid,'<TD width="50"> <div align="center" class="style4">%4.2f</span></div></TD>',DataArgoEs.UltimoSurfaceOffset(ifloat));
            fprintf(fid,'</TR>');
        end
    else
        fprintf('     > No Desplegada %7d\n',MD.WMOFloat)
        fprintf(fid,'<TR class="style4">\n');
        fprintf(fid,'<TD width="56"><div align="center" class="style4"><a>Inactiva</span></div></TD>');
        fprintf(fid,'<TD width="74"><div align="center" class="style4">%07d</span></div></TD>',MD.WMOFloat);
        fprintf(fid,'<TD width="113"><div align="center" class="style4">Por desplegar</span></div></TD>');
        fprintf(fid,'<TD width="106"><div align="center" class="style4"> ---- </span></div></TD>');
        fprintf(fid,'<TD width="106"><div align="center" class="style4"> ---- </span></div></TD>');
        fprintf(fid,'<TD width="45"><div align="center"  class="style4"> ---- </span></div></TD>');
        fprintf(fid,'<TD width="100"><div align="center" class="style4"> ---- </span></div></TD>');
        fprintf(fid,'<TD width="50"><div align="center" class="style4"> ---- </span></div></TD>');
        fprintf(fid,'<TD width="50"><div align="center" class="style4"> ---- </span></div></TD>');
        fprintf(fid,'</TR>');
    end
end
fprintf(fid,'</Table> \n');
fprintf(fid,'</div>  \n');

fprintf(fid,'  </body> \n');
fprintf(fid,'</html>\n');
fclose(fid);

%% Ftp the file
fprintf('     > Uploading  %s \n',FileHtmlArgoEsStatus);
ftpobj=FtpOceanografia;
cd(ftpobj,'/html/argo/html_files');
mput(ftpobj,FileHtmlArgoEsStatus);

%% Writting Informe
if exist(FileNameInforme,'file')>0
    InformeOld=load(FileNameInforme);
    Incremento=DataArgoEs.iactiva-InformeOld.iactiva;
else
    Incremento=0;
end
if Incremento~=0
    Informe=sprintf('createArgoSpainGMap - Activos (%d,%d) Inactivos (%d) No desplegados (%d)\n     Last profile %s\n     Updated on %s',DataArgoEs.iactiva,Incremento,DataArgoEs.iinactiva,DataArgoEs.inodesplegada,datestr(max(DataArgoEs.FechaUltimoPerfil)),datestr(now));
else
    Informe=sprintf('createArgoSpainGMap - Activos (%d) Inactivos (%d) No desplegados (%d)\n     Last profile %s\n     Updated on %s',DataArgoEs.iactiva,DataArgoEs.iinactiva,DataArgoEs.inodesplegada,datestr(max(DataArgoEs.FechaUltimoPerfil)),datestr(now));
end
iactiva=DataArgoEs.iactiva;
juldsAS=DataArgoEs.FechaUltimoPerfil;
WMO=DataArgoEs.WMO;
save(FileNameInforme,'Informe','iactiva','juldsAS','WMO')
fprintf('%s <<<<< \n',mfilename)
