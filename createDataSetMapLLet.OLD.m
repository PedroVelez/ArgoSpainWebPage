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
fid = fopen(FileHtmlArgoEsStatus,'w');
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
fprintf(fid,'<!DOCTYPE html> \n');
fprintf(fid,'<html> \n');
fprintf(fid,'<head> \n');
fprintf(fid,'	<title>Argo Espa&ntilde;a</title> \n');
fprintf(fid,'	<meta charset="utf-8" /> \n');
fprintf(fid,'	<meta name="viewport" content="width=device-width, initial-scale=1.0"> \n');
%Estilo
fprintf(fid,'<style type="text/css">\n');
fprintf(fid,'<!--.style1 {font-size: 16px; font-weight: bold;font-family: verdana; color: #0c2046;}-->\n');
fprintf(fid,'<!--.style2 {font-size: 14px; font-weight: normal; font-family: verdana; color: #0c2046}-->\n');
fprintf(fid,'<!--.style3 {font-size: 12px; font-weight: normal; font-family: verdana; color: #0c2046}-->\n');
fprintf(fid,'</style>\n');

%Leaflet libraries
fprintf(fid,'    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.6.0/dist/leaflet.css" integrity="sha512-xwE/Az9zrjBIphAcBb3F6JVqxf46+CDLwfLMHloNu6KEQCAWi6HcDUbeOfBIptF7tcCzusKFjFw2yuvEpDL9wQ==" crossorigin=""/> \n');
fprintf(fid,'    <script src="https://unpkg.com/leaflet@1.6.0/dist/leaflet.js" integrity="sha512-gZwIG9x3wUXg2hdXF6+rVkLF/0Vi9U8D2Ntg4Ga5I5BZpVkVxlJWbSQtXPSiUTtC0TjtGOmxa1AJPuV0CPthew==" crossorigin=""></script> \n');
fprintf(fid,'    <script src=''https://api.mapbox.com/mapbox.js/plugins/leaflet-fullscreen/v1.0.1/Leaflet.fullscreen.min.js''></script>\n');
fprintf(fid,'    <link href=''https://api.mapbox.com/mapbox.js/plugins/leaflet-fullscreen/v1.0.1/leaflet.fullscreen.css'' rel=''stylesheet''/>\n');
fprintf(fid,'</head> \n');
fprintf(fid,'<body> \n');
fprintf(fid,'<div align="center">\n');
fprintf(fid,'    <style>\n');
fprintf(fid,'	      html, body {height: 80%%;0;padding: 0;}\n');
fprintf(fid,'	      #map {width: 100%%;height: 100vh;}\n');
fprintf(fid,'	      .info { padding: 6px; font: 14px/16px Arial, Helvetica, sans-serif; box-shadow: 0 0 15px rgba(0,0,0,0.2); border-radius: 5px; }\n');
fprintf(fid,'	      .legend { text-align: left; line-height: 18px; color: #555; }\n');
fprintf(fid,'	      .legend i { width: 18px; height: 18px; float: left; margin-right: 8px; opacity: 1; }\n');
fprintf(fid,'	      .leaflet-control-layers label { text-align: left; }\n');
fprintf(fid,'	 </style>\n');
fprintf(fid,'</head> \n');
fprintf(fid,'<body> \n');


%Add current status of tthe Argo Spain Contribution
fprintf(fid,'<br><span class="style2"><div align="center">\n');
fprintf(fid,'Cobertura del programa <b>Argo Espa&ntilde;a</b> el %s a las %s <br/>\n',datestr(now,1),datestr(now,13));
%fprintf(fid,'</span></div>\n');
%fprintf(fid,'<br><span class="style2"><div align="center">\n');
fprintf(fid,'(%d) perfiladores Activos, (%d) No desplegados y (%d) Inactivos. Último dato recibido el %s <br />\n',DataArgoEs.iactiva,DataArgoEs.inodesplegada,DataArgoEs.iinactiva,datestr(max(DataArgoEs.FechaUltimoPerfil)) );
%fprintf(fid,'</span></div>\n');
%fprintf(fid,'<br><span class="style2"><div align="center">\n');
fprintf(fid,'Hasta la fecha %d perfiles han sido realizados por las boyas del programa <b>Argo Espa&ntilde;a</b>\n',sum(NTotalPerfiles));
fprintf(fid,'</span></div><br>\n');

%% Add map
fprintf(fid,'<div align="center">\n');
fprintf(fid,'<div id="map" style="width: %d px; height: %d px;"></div> \n',MTamanoArgoIb(1),MTamanoArgoIb(2));
fprintf(fid,'</div> \n');
fprintf(fid,'<script type="text/javascript">\n');

%% Initialize the map and set up control
fprintf(fid,'// Initialize the map and set up control \n');
fprintf(fid,'  const esMovil = window.innerWidth <= 767; //ancho máximo movil\n');
fprintf(fid,'  const map = L.map(''map'',{\n');
fprintf(fid,'                scrollWheelZoom: false, \n');
fprintf(fid,'                center: esMovil ? [%d,%d] : [%d,%d],\n',MCentroArgoEs(1),MCentroArgoEs(2),MCentroArgoEs(1),MCentroArgoEs(2));
fprintf(fid,'                zoom: esMovil ? %d : %d ,\n',MZoomArgoIb-1,MZoomArgoIb);
fprintf(fid,'              });\n');

fprintf(fid,'//Propagación activa haciendo click \n');
fprintf(fid,'   map.on(''click'', function() {\n');
fprintf(fid,'      map.scrollWheelZoom.enable();\n');
fprintf(fid,'  });\n');
fprintf(fid,'//Propagar mapa cuando se cliquea un polígono\n');
fprintf(fid,'  map.on(''focus'', function() { \n');
fprintf(fid,'      map.scrollWheelZoom.enable();\n');
fprintf(fid,'  });\n');
fprintf(fid,'//Desactiva propagación mapa cuando el puntero sale del área de acción\n');
fprintf(fid,'  map.on(''mouseout'', function() {\n');
fprintf(fid,'      map.scrollWheelZoom.disable();\n');
fprintf(fid,'  });\n');

fprintf(fid,'     map.addControl(new L.Control.Fullscreen());\n');

% Tiles
fprintf(fid,'//Tiles \n');
fprintf(fid,'   L.tileLayer(''https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'', { \n');
fprintf(fid,'       attribution: ''Tiles &copy ESRI''}).addTo(map); \n');

%fprintf(fid,'//Defino iconos \n');
%fprintf(fid,'   var buoyIcon = L.Icon.extend({ \n');
%fprintf(fid,'       options: { \n');
%fprintf(fid,'           iconSize:     [33, 30], \n');
%fprintf(fid,'           iconAnchor:   [16, 20], \n');
%fprintf(fid,'           popupAnchor:  [-3, -76] \n');
%fprintf(fid,'       } \n');
%fprintf(fid,'   }); \n');
%fprintf(fid,'   var buoyred = new buoyIcon({iconUrl: ''https://www.argoespana.es/imagenes/boyaroja.png''}), \n');
%fprintf(fid,'       buoywhite = new buoyIcon({iconUrl: ''https://www.argoespana.es/imagenes/boyablanca.png''}); \n');


%% Escribo las trajectorias de las boyas activas
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
            fprintf(fid,'		var polyline = L.polyline(TrayectoriaCoordinates,{color: ''#ff0000'',opacity: 0.6,weight: 2.00}).addTo(map) \n');
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
            fprintf(fid,'		var polyline = L.polyline(TrayectoriaCoordinates,{color: ''#FFFAFA'',opacity: 0.6,weight: 2.00}).addTo(map) \n');
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
fprintf(fid,'		if(perfilador[0] == 1){\n');
%fprintf(fid,'			L.marker([perfilador[2], perfilador[3]],{\n');
%fprintf(fid,'			icon: buoyred,\n');
fprintf(fid,'			L.circleMarker([perfilador[2], perfilador[3]],{\n');
fprintf(fid,'			radius : 3,\n');
fprintf(fid,'			color: ''#ff0000'',\n');
fprintf(fid,'			opacity: 1,\n');
fprintf(fid,'			fillOpacity:.85,\n');
fprintf(fid,'			title: perfilador[4]+'' WMO ''+perfilador[1]+'' ''+perfilador[5],\n');
fprintf(fid,'			}).addTo(map).bindPopup(''<center><p>Boya <b><a href="https://www.argoespana.es/float/''+perfilador[1]+''.html" target="_blank">''+perfilador[1]+''</a></b><br><b>''+perfilador[4]+''</b><br><br><b>Fecha ultimo dato&nbsp;</b>''+perfilador[5]+''</p></center>'');\n');
fprintf(fid,'		}else if (perfilador[0] == 0) {\n');
%fprintf(fid,'			L.marker([perfilador[2], perfilador[3]],{\n');
%fprintf(fid,'			icon: buoywhite,\n');
fprintf(fid,'			L.circleMarker([perfilador[2], perfilador[3]],{\n');
fprintf(fid,'			radius : 3,\n');
fprintf(fid,'			color: ''#ffffff'',\n');
fprintf(fid,'			opacity: 1,\n');
fprintf(fid,'			fillOpacity:.85,\n');
fprintf(fid,'			title: perfilador[4]+'' WMO ''+perfilador[1]+'' ''+perfilador[5],\n');
fprintf(fid,'			}).addTo(map).bindPopup(''<center><p>Boya <b><a href="https://www.argoespana.es/float/''+perfilador[1]+''.html" target="_blank">''+perfilador[1]+''</a></b><br><b>''+perfilador[4]+''</b><br><br><b>Fecha ultimo dato&nbsp;</b>''+perfilador[5]+''</p></center>'');\n');
fprintf(fid,'		}\n');
fprintf(fid,'	}// Marcador de posicion de las boyas\n');


%fprintf(fid,'//Funcion para crear la leyenda\n');
%fprintf(fid,'	var legend = L.control({position: ''bottomright''});\n');
%fprintf(fid,'	legend.onAdd = function (map) {\n');
%fprintf(fid,'	    var div = L.DomUtil.create(''div'', ''info legend'');\n');
%fprintf(fid,'       		div.innerHTML = "<img src=https://www.argoespana.es/imagenes/LeyendaArgoEs.png height=''75''><br>";\n');
%fprintf(fid,'	    return div;\n');
%fprintf(fid,'	};\n');
%fprintf(fid,'	legend.addTo(map);\n');

%%// Leyenda
fprintf(fid,'//Leyenda \n');
fprintf(fid,'    var legend = L.control({position: ''bottomright''});\n');
fprintf(fid,'    legend.onAdd = function (map) {\n');
fprintf(fid,'    function getColor(d) {\n');
fprintf(fid,'        return d === "Boya activa" ? "#ff0000" :\n');
fprintf(fid,'               d === "Boya inactiva" ? "#ffffff" :\n');
fprintf(fid,'               "#ffffff";\n');
fprintf(fid,'    }\n');
fprintf(fid,'    var div = L.DomUtil.create(''div'', ''info legend'');\n');
fprintf(fid,'    div.style.background = "#ffffff";\n');
fprintf(fid,'    div.style.padding = "10px";\n');
fprintf(fid,'    div.style.borderRadius = "8px";\n');
fprintf(fid,'    div.style.boxShadow = "0 0 10px rgba(0,0,0,0.2)";\n');
fprintf(fid,'    div.style.lineHeight = "18px";\n');
fprintf(fid,'    div.style.opacity = "1"; // valor entre 0 y 1\n');
fprintf(fid,'    labels = [''<strong>Boyas Argo</strong>''],\n');
fprintf(fid,'    categories = [''Boya activa'',''Boya inactiva''];\n');
fprintf(fid,'    for (var i = 0; i < categories.length; i++) {\n');
fprintf(fid,'        labels.push(\n');
fprintf(fid,'            ''<div style="display:flex; align-items:center;">'' +\n');
fprintf(fid,'            ''<span style="width:12px;height:12px;border:2px solid black;border-radius:50%%;background:'' + getColor(categories[i]) + '';display:inline-block;margin-right:6px;"></span>'' +\n');
fprintf(fid,'            categories[i] +\n');
fprintf(fid,'            ''</div>''\n');
fprintf(fid,'        );\n');
fprintf(fid,'    }\n');
fprintf(fid,'    div.innerHTML = labels.join("");\n');
fprintf(fid,'    return div;\n');
fprintf(fid,'};\n');
fprintf(fid,'	legend.addTo(map);\n');

fprintf(fid,' //Funcion para crear el titulo\n');
fprintf(fid,'	var titulo = L.control({position: ''topright''});\n');
fprintf(fid,'	titulo.onAdd = function (map) {\n');
fprintf(fid,'	    var div = L.DomUtil.create(''div'', ''info legend'');\n');
fprintf(fid,'	        div.innerHTML  = ''<b><center>Argo Espa&ntilde;a: %d boyas activas, %d boyas inactivas, %d boyas no desplegadas</b></center>''\n',DataArgoEs.iactiva,DataArgoEs.iinactiva,DataArgoEs.inodesplegada);
fprintf(fid,'           div.style.background = "#ffffff";\n');
fprintf(fid,'  			div.style.color = ''black'';\n');
fprintf(fid,'			div.style.fontSize = ''14px'';\n');
fprintf(fid,'		    div.style.paddingLeft = ''4px'';\n');
fprintf(fid,'		    div.style.paddingRight = ''4px'';\n');
fprintf(fid,'		    div.style.paddingTop = ''4px'';\n');
fprintf(fid,'		    div.style.paddingBottom = ''4px'';\n');
fprintf(fid,'           div.style.opacity = "1"; // valor entre 0 y 1\n');
fprintf(fid,'	    return div;\n');
fprintf(fid,'	};\n');
fprintf(fid,'	titulo.addTo(map);\n');

fprintf(fid,'</script> \n');

%% Tabla con los datos
%fprintf(fid,'<style type="text/css">\n');
%fprintf(fid,'<!--.style1 {font-size: 16px; font-weight: bold;font-family: verdana; color: #0c2046;}-->\n');
%fprintf(fid,'<!--.style3 {font-size: 12px; font-weight: normal; font-family: verdana; color: #0c2046}-->\n');
%fprintf(fid,'</style>\n');
fprintf(fid,'<BR>\n');
fprintf(fid,'<BR>\n');
fprintf(fid,'<TABLE width="900" border="0" align="center" cellpadding="2" cellspacing="3" >\n');
fprintf(fid,'<tr bgcolor="#C0C0C0">\n');
fprintf(fid,'<td width="56"> <div align="center" class="style1" ><div align="center"><strong>Estado</strong></div></div></td>\n');
fprintf(fid,'<td width="74"> <div align="center" class="style1" ><div align="center"><strong>WMO</strong></div></div></td>\n');
fprintf(fid,'<td width="113"><div align="center" class="style1" ><div align="center"><strong>Proyecto</strong></div></div></td>\n');
fprintf(fid,'<td width="106"><div align="center" class="style1" ><div align="center"><strong>Primer perfil</strong></div></div></td>\n');
fprintf(fid,'<td width="106"><div align="center" class="style1" ><div align="center"><strong>&Uacute;ltimo perfil </strong></div></div></td>\n');
fprintf(fid,'<td width="45"> <div align="center" class="style1" ><div align="center"><strong>Edad</strong></div></div></td>\n');
fprintf(fid,'<td width="100"><div align="center" class="style1" ><div align="center"><strong>Tipo boya</strong></div></div></td>\n');
%fprintf(fid,'<td width="50"> <div align="center" class="style1" ><div align="center"><strong>Voltaje</strong></div></div></td>\n');
%fprintf(fid,'<td width="50"> <div align="center" class="style1" ><div align="center"><strong>Surface offset</strong></div></div></td>\n');
fprintf(fid,'</TR>\n');
fprintf(fTxt,'# Boyas del Argo España ordenadas por ultimo perfil emitido \n');
fprintf(fTxt,'Estado; WMO; Proyecto; Primer perfil; ultimo perfil; Edad; Tipo de boya; FloatOwner; Lon; Lat \n');

%Lee los datos de las boyas para poder crear la tabla de datos
%iactiva=0;iinactiva=0;inodesplegada=0;
for ifloat=1:size(DataArgoEs.WMO,2)
    MD = createDataSetStatus_FunctionMetadata(DataArgoEs.WMO(ifloat),DirArgoData);
    if DataArgoEs.activa(ifloat)>=1 %Activa o Inactiva con datos

        FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
        if DataArgoEs.activa(ifloat)==1
            fprintf('     > ACTIVA %7d; %12s; first:%s; last:%s; Age:%s; %s;%s \n',MD.WMOFloat,MD.ProjectName,datestr(FloatData.HIDf.julds(1),22),datestr(FloatData.HIDf.julds(end),22),MD.Age,MD.PlatformModel,MD.FloatOwner)
            fprintf(fTxt,'Activa; %7d; %12s; %s; %s; %s; %s; %s; %6.3f; %6.3f\n',MD.WMOFloat,MD.ProjectName,datestr(FloatData.HIDf.julds(1),22),datestr(FloatData.HIDf.julds(end),22),MD.Age,MD.PlatformModel,MD.FloatOwner,FloatData.HIDf.lons(end),FloatData.HIDf.lats(end) );
            if mod(ifloat,2);
                fprintf(fid,'<tr height: 55px; bgcolor="#e5e5e5">\n');
            else
                fprintf(fid,'<tr height: 55px;">\n');
            end
            fprintf(fid,'<td width="56"> <div align="center" class="style3"><a href="https://www.argoespana.es/float/%d.html" target="_blank">Activa</span></div></td>',MD.WMOFloat);
            fprintf(fid,'<td width="74"> <div align="center" class="style3">%07d</span></div></td>',MD.WMOFloat);
            fprintf(fid,'<td width="113"><div align="center" class="style3">%12s</span></div></td>',MD.ProjectName);
            fprintf(fid,'<td width="106"><div align="center" class="style3">%s</span></div></td>',datestr(FloatData.HIDf.julds(1),22));
            fprintf(fid,'<td width="106"><div align="center" class="style3">%s</span></div></td>',datestr(FloatData.HIDf.julds(end),22));
            fprintf(fid,'<td width="45"> <div align="center" class="style3">%s</span></div></td>',MD.Age);
            fprintf(fid,'<td width="100"><div align="center" class="style3">%12s</span></div></td>',MD.PlatformModel);
            fprintf(fid,'</tr>');
        else
            fprintf('     > INACTIVA %7d; %12s; first:%s; last:%s; Age:%s; %s \n',MD.WMOFloat,MD.ProjectName,datestr(FloatData.HIDf.julds(1),22),datestr(FloatData.HIDf.julds(end),22),MD.Age,MD.PlatformModel)
            fprintf(fTxt,'Inactiva; %7d; %12s; %s; %s; %s; %s; %s; %6.3f; %6.3f\n',MD.WMOFloat,MD.ProjectName,datestr(FloatData.HIDf.julds(1),22),datestr(FloatData.HIDf.julds(end),22),MD.Age,MD.PlatformModel,MD.FloatOwner,FloatData.HIDf.lons(end),FloatData.HIDf.lats(end));
            if mod(ifloat,2);
                fprintf(fid,'<TR height: 55px; bgcolor="#e5e5e5">\n');
            else
                fprintf(fid,'<TR height: 55px;">\n');
            end
            fprintf(fid,'<td width="56"> <div align="center" class="style3"><a href="https://www.argoespana.es/float/%d.html" target="_blank">Inactiva</span></div></td>',MD.WMOFloat);
            fprintf(fid,'<td width="74"> <div align="center" class="style3">%07d</span></div></td>',MD.WMOFloat);
            fprintf(fid,'<td width="113"><div align="center" class="style3">%12s</span></div></td>',MD.ProjectName);
            fprintf(fid,'<td width="106"><div align="center" class="style3">%s</span></div></td>',datestr(FloatData.HIDf.julds(1),22));
            fprintf(fid,'<td width="106"><div align="center" class="style3">%s</span></div></td>',datestr(FloatData.HIDf.julds(end),22));
            fprintf(fid,'<td width=" 45"><div align="center" class="style3">%s</span></div></td>',MD.Age);
            fprintf(fid,'<td width="100"><div align="center" class="style3">%12s</span></div></td>',MD.PlatformModel);
            fprintf(fid,'</tr>');
        end
    else
        fprintf('     > No Desplegada %7d\n',MD.WMOFloat)
        fprintf(fTxt,'No Desplegada; %7d;;;;;\n',MD.WMOFloat);
        fprintf(fid,'<tr class="style3">\n');
        fprintf(fid,'<td width="56"><div align="center" class="style3"><a>Inactiva</span></div></td>');
        fprintf(fid,'<td width="74"><div align="center" class="style3">%07d</span></div></td>',MD.WMOFloat);
        fprintf(fid,'<td width="113"><div align="center" class="style3">Por desplegar</span></div></td>');
        fprintf(fid,'<td width="106"><div align="center" class="style3"> ---- </span></div></td>');
        fprintf(fid,'<td width="106"><div align="center" class="style3"> ---- </span></div></td>');
        fprintf(fid,'<td width=" 45"><div align="center"  class="style3"> ---- </span></div></td>');
        fprintf(fid,'<td width="100"><div align="center" class="style3"> ---- </span></div></td>');
        fprintf(fid,'</tr>');
    end
end
fprintf(fid,'</Table>\n');
fprintf(fid,'</div>\n');

fprintf(fid,'</body>\n');
fprintf(fid,'</html>\n');
fclose(fid);
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

