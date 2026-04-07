clear all;close all
%This script create the map with the positions of all Argo floats
%active in the Regio, and it creates the file  FileHtmlRegionStatus (argoibstatus.html)

%% Read options
configWebPage

% %Time Span
% FechaI=now-30;
% FechaF=now;
% TrajectorySpanArgo=90;
%
% %Geographical Region
% lat_minIB= 15.00; lat_maxIB=54;
% lon_minIB=-45;    lon_maxIB=38;
% lat_min=-65;    lat_max=65;
% lon_min=-80;    lon_max=40;
%
% %Map
% MCentroArgoIb=[39,-16];
% MZoomArgoIb=4;
% MTamanoArgoIb=[700,650];
%
% FileHtmlRegionStatus =strcat(PaginaWebDir,'/html/','argoibstatus.html');
% DataDirGeo='... /Argo/geo/atlantic_ocean');

%% Inicio
%Read data
DataArgoEs=load(strcat(PaginaWebDir,'/data/dataArgoSpain.mat'),'WMO','activa','iactiva','FechaUltimoPerfil');
DataArgoIn=load(strcat(PaginaWebDir,'/data/dataArgoInterest.mat'),'WMO','activa','FechaUltimoPerfil');

NTotalPerfiles=0;
for ifloat=1:length(DataArgoEs.WMO)
    FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))),'HIDf');
    NTotalPerfiles=[NTotalPerfiles nanmax(FloatData.HIDf.cycle)'];
end

fprintf('>>>>> %s\n',mfilename)
ntper=0;
ntperes=0;
FileNameInforme=strcat(PaginaWebDir,'/data/report',mfilename,'.mat');
fid = fopen(FileHtmlRegionStatus,'w');

fprintf('     > Writting leaflet file \n');
fprintf(fid,'<!DOCTYPE html> \n');
fprintf(fid,'<html> \n');
fprintf(fid,'<head> \n');
fprintf(fid,'	<title>Argo Espa&ntilde;a</title> \n');
fprintf(fid,'	<meta charset="utf-8" /> \n');
fprintf(fid,'	<meta name="viewport" content="width=device-width, initial-scale=1.0"> \n');

% Leaflet libraries
fprintf(fid,'    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.6.0/dist/leaflet.css" integrity="sha512-xwE/Az9zrjBIphAcBb3F6JVqxf46+CDLwfLMHloNu6KEQCAWi6HcDUbeOfBIptF7tcCzusKFjFw2yuvEpDL9wQ==" crossorigin=""/> \n');
fprintf(fid,'    <script src="https://unpkg.com/leaflet@1.6.0/dist/leaflet.js" integrity="sha512-gZwIG9x3wUXg2hdXF6+rVkLF/0Vi9U8D2Ntg4Ga5I5BZpVkVxlJWbSQtXPSiUTtC0TjtGOmxa1AJPuV0CPthew==" crossorigin=""></script> \n');
fprintf(fid,'    <script src=''https://api.mapbox.com/mapbox.js/plugins/leaflet-fullscreen/v1.0.1/Leaflet.fullscreen.min.js''></script>\n');
fprintf(fid,'    <link href=''https://api.mapbox.com/mapbox.js/plugins/leaflet-fullscreen/v1.0.1/leaflet.fullscreen.css'' rel=''stylesheet''/>\n');
fprintf(fid, '  <style>\n');
fprintf(fid, '	   html, body {height: 100%%;}\n');
fprintf(fid, '	   #map {width: 100%%;height: 90vh;touch-action: none;}\n');
fprintf(fid, '	   .info { padding: 6px; font: 14px/16px Arial, Helvetica, sans-serif; background: rgba(255,255,255,0.8); box-shadow: 0 0 15px rgba(0,0,0,0.2); border-radius: 5px; }\n');
fprintf(fid, '	   .legend {text-align: left; line-height: 18px; color: #555; }\n');
fprintf(fid, '	   .legend i {text-align: left; width: 18px; height: 18px; float: left; margin-right: 8px;}\n');
fprintf(fid, '	   .leaflet-control-layers label {text-align: left; width: 170px;}\n');
fprintf(fid, '	 /*---Leyendas colapsable movil/tablet*/\n');
fprintf(fid, '	   @media (max-width: 767px) {\n');
fprintf(fid, '	 /*---Contenedor de la leyenda*/\n');
fprintf(fid, '	     .info.legend{\n');
fprintf(fid, '	     padding: 0 !important;\n');
fprintf(fid, '	     font-size: 11px !important;\n');
fprintf(fid, '	     width: 160px !important;\n');
fprintf(fid, '	     overflow: hidden;\n');
fprintf(fid, '	     border-radius: 8px;\n');
fprintf(fid, '	     background: transparent;\n');
fprintf(fid, '	     box-shadow: 0 0 10px rgba(0,0,0,0.25);\n');
fprintf(fid, '	     }\n');
fprintf(fid, '	 /*---Boton siempre visible*/\n');
fprintf(fid, '	    .legend-toggle-btn{\n');
fprintf(fid, '	     display: flex;\n');
fprintf(fid, '	     align-items: center;\n');
fprintf(fid, '	     justify-content: space-between;\n');
fprintf(fid, '	     width: 100	     background: rgba(255, 255, 255, 0.95);\n');
fprintf(fid, '	     border: none;\n');
fprintf(fid, '	     padding: 7px 10px;\n');
fprintf(fid, '	     font-size: 11px;\n');
fprintf(fid, '	     font-weight: bold;\n');
fprintf(fid, '	     cursor: pointer;\n');
fprintf(fid, '	     color: #333;\n');
fprintf(fid, '	     box-sizing: border-box;\n');
fprintf(fid, '	     border-radius: 8px;\n');
fprintf(fid, '	     }\n');
fprintf(fid, '	 /*Redondea boton cuando se abre*/\n');
fprintf(fid, '	    .legend-toggle-btn.open{\n');
fprintf(fid, '	     border-radius: 8px 8px 0 0;\n');
fprintf(fid, '	     }\n');
fprintf(fid, '	 /*Flecha desplegable con transición*/\n');
fprintf(fid, '	    .legend-arrow{\n');
fprintf(fid, '	     font-size: 10px;\n');
fprintf(fid, '	     display: inline-block;\n');
fprintf(fid, '	     transition: transform 0.25s ease;\n');
fprintf(fid, '	     transform: rotate(0deg);\n');
fprintf(fid, '	     }\n');
fprintf(fid, '	     .legend-toggle-btn.open .legend-arrow{\n');
fprintf(fid, '	     transform: rotate(180deg);\n');
fprintf(fid, '	     }\n');
fprintf(fid, '	 /*Contenido despegable*/\n');
fprintf(fid, '	    .legend-collapsible{\n');
fprintf(fid, '	     overflow: hidden;\n');
fprintf(fid, '	     max-height: 0;\n');
fprintf(fid, '	     opacity: 0;\n');
fprintf(fid, '	     transition: max-height 0.3s ease, opacity 0.25s ease;\n');
fprintf(fid, '	     background: rgba(255, 255, 255, 0.95);\n');
fprintf(fid, '	     padding: 0 8px;\n');
fprintf(fid, '	     border-radius: 0 0 8px 8px;\n');
fprintf(fid, '	     }\n');
fprintf(fid, '	    .legend-collapsible.open{\n');
fprintf(fid, '	     max-height: 300px;\n');
fprintf(fid, '	     opacity: 1;\n');
fprintf(fid, '	     padding: 6px 8px;\n');
fprintf(fid, '	     }\n');
fprintf(fid, '	    }\n');
fprintf(fid, '	 </style>\n');
fprintf(fid,'</head> \n');
fprintf(fid,'<body> \n');
%fprintf(fid,'<div id="map" style="width: %d px; height: %d px;"></div> \n',MTamanoArgoIb(1),MTamanoArgoIb(2));
fprintf(fid,'<div id="map"></div> \n');
fprintf(fid,'<script type="text/javascript">\n');

%% Initialize the map and set up control
fprintf(fid, 'const esMovil = window.innerWidth <= 767;\n');
fprintf(fid, '\n');
fprintf(fid, 'const map = L.map(''map'', {\n');
fprintf(fid, '  center: [39, -16],\n');
fprintf(fid, '  zoom: esMovil ? 3 : 4,\n');
fprintf(fid, '  scrollWheelZoom: false,\n');
fprintf(fid, '  dragging: false,\n');
fprintf(fid, '  touchZoom: false,\n');
fprintf(fid, '  doubleClickZoom: false\n');
fprintf(fid, '});\n');
fprintf(fid, '\n');

fprintf(fid, '//Activar interacción\n');
fprintf(fid, 'function activarInteraccion() {\n');
fprintf(fid, '  map.dragging.enable();\n');
fprintf(fid, '  map.touchZoom.enable();\n');
fprintf(fid, '  map.scrollWheelZoom.enable();\n');
fprintf(fid, '  map.doubleClickZoom.enable();\n');
fprintf(fid, '}\n');
fprintf(fid, '\n');

fprintf(fid, '//Desactivar interacción\n');
fprintf(fid, 'function desactivarInteraccion() {\n');
fprintf(fid, '  map.dragging.disable();\n');
fprintf(fid, '  map.touchZoom.disable();\n');
fprintf(fid, '  map.scrollWheelZoom.disable();\n');
fprintf(fid, '  map.doubleClickZoom.disable();\n');
fprintf(fid, '}\n');
fprintf(fid, '\n');

fprintf(fid, '//ESCRITORIO\n');
fprintf(fid, 'map.on(''click'', activarInteraccion);\n');
fprintf(fid, 'map.on(''mouseout'', desactivarInteraccion);\n');
fprintf(fid, '\n');


fprintf(fid, '//MÓVIL\n');
fprintf(fid, 'const container = map.getContainer();\n');
fprintf(fid, '\n');
fprintf(fid, '// Detectar número de dedos\n');
fprintf(fid, 'container.addEventListener(''touchstart'', function (e) {\n');
fprintf(fid, '  if (e.touches.length === 2) {\n');
fprintf(fid, '    //Dos dedos → activar directamente\n');
fprintf(fid, '    activarInteraccion();\n');
fprintf(fid, '  }\n');
fprintf(fid, '});\n');
fprintf(fid, '\n');
fprintf(fid, '// Si solo usa un dedo → NO activar (deja hacer scroll normal)\n');
fprintf(fid, '\n');
fprintf(fid, '// Desactivar cuando termina interacción\n');
fprintf(fid, 'let timeout;\n');
fprintf(fid, '\n');
fprintf(fid, 'container.addEventListener(''touchend'', function () {\n');
fprintf(fid, '  clearTimeout(timeout);\n');
fprintf(fid, '  timeout = setTimeout(() => {\n');
fprintf(fid, '    desactivarInteraccion();\n');
fprintf(fid, '  }, 800);\n');
fprintf(fid, '});\n');
fprintf(fid, '\n');

fprintf(fid, '//OVERLAY (mensaje UX)\n');
fprintf(fid, 'const overlay = document.createElement(''div'');\n');
fprintf(fid, 'overlay.className = ''map-overlay'';\n');
fprintf(fid, 'overlay.innerHTML = esMovil \n');
fprintf(fid, '  ? ''Usa dos dedos para mover el mapa'' \n');
fprintf(fid, '  : ''Haz click para activar el mapa'';\n');
fprintf(fid, '\n');
fprintf(fid, 'container.appendChild(overlay);\n');
fprintf(fid, '\n');
fprintf(fid, '// Ocultar overlay cuando se activa\n');
fprintf(fid, 'function ocultarOverlay() {\n');
fprintf(fid, '  overlay.style.display = ''none'';\n');
fprintf(fid, '}\n');
fprintf(fid, '\n');
fprintf(fid, '// Mostrar overlay al desactivar\n');
fprintf(fid, 'function mostrarOverlay() {\n');
fprintf(fid, '  overlay.style.display = ''flex'';\n');
fprintf(fid, '}\n');
fprintf(fid, '\n');
fprintf(fid, 'map.on(''click'', ocultarOverlay);\n');
fprintf(fid, '\n');
fprintf(fid, 'container.addEventListener(''touchstart'', function (e) {\n');
fprintf(fid, '  if (e.touches.length === 2) {\n');
fprintf(fid, '    ocultarOverlay();\n');
fprintf(fid, '  }\n');
fprintf(fid, '});\n');
fprintf(fid, '\n');
fprintf(fid, 'container.addEventListener(''touchend'', function () {\n');
fprintf(fid, '  setTimeout(mostrarOverlay, 800);\n');
fprintf(fid, '});\n');

fprintf(fid,'map.addControl(new L.Control.Fullscreen());\n');

% Tiles
fprintf(fid, '//Tiles\n');
fprintf(fid, 'const tiles = L.tileLayer(''https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'', {\n');
fprintf(fid, '       attribution: ''Tiles & copy ESRI'',\n');
fprintf(fid, '       zIndex: 1\n');
fprintf(fid, '}).addTo(map);\n');
fprintf(fid, '\n');

%% Trajectoria de las Argo Espana
fprintf(fid,'// Trayectorias de las boyas ArgoEspana\n');
for ifloat=1:size(DataArgoEs.WMO,2)
    if DataArgoEs.FechaUltimoPerfil(ifloat)>now-TrajectorySpanArgo && DataArgoEs.activa(ifloat)==1
        FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
        lon=FloatData.HIDf.lons;
        lat=FloatData.HIDf.lats;
        julds=FloatData.HIDf.julds;
        ind=find(isnan(lon)==0 & isnan(lat)==0);
        lon=lon(ind);
        lat=lat(ind);
        julds=julds(ind);
        ind=find((julds-(now-TrajectorySpanArgo))>0);
        lon=lon(ind);
        lat=lat(ind);
        if isempty(lon)==0
            fprintf(fid,'var TrayectoriaCoordinates = [\n');
            for ii=1:1:length(lon)
                fprintf(fid,'  [%7.4f,%7.4f],\n',lat(ii),lon(ii));
            end
            fprintf(fid,'  ];\n');
            fprintf(fid,'var polyline = L.polyline(TrayectoriaCoordinates,{color: ''#FF0000'',opacity: 0.6,weight: 2.00}).addTo(map)\n');
        end
    end
end

%% Trajectoria de las Argo Interes
fprintf(fid,'// Trayectorias de las boyas Argo Interes\n');
for ifloat=1:size(DataArgoIn.WMO,2)
    if DataArgoIn.FechaUltimoPerfil(ifloat)>now-TrajectorySpanArgo && DataArgoIn.activa(ifloat)==1
        FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoIn.WMO(ifloat))));
        lon=FloatData.HIDf.lons;
        lat=FloatData.HIDf.lats;
        julds=FloatData.HIDf.julds;
        ind=find(isnan(lon)==0 & isnan(lat)==0);
        lon=lon(ind);
        lat=lat(ind);
        julds=julds(ind);
        ind=find((julds-(now-TrajectorySpanArgo))>0);
        lon=lon(ind);
        lat=lat(ind);
        if isempty(lon)==0
            fprintf(fid,'		var TrayectoriaCoordinates = [\n');
            for ii=1:1:length(lon)
                fprintf(fid,'			[%7.4f,%7.4f],\n',lat(ii),lon(ii));
            end
            fprintf(fid,'		];\n');
            fprintf(fid,'var polyline = L.polyline(TrayectoriaCoordinates,{color: ''#ffee00'',opacity: 0.6,weight: 2.00}).addTo(map)\n');
        end
    end
end

%% Lee todos los perfiles en los ultimos 30 dias.
fprintf(fid,'//Datos de ultima posicion de las las boyas\n');
fprintf(fid,'var perfiladores = [\n');
LastJday=[];
for ifecha=FechaF:-1:FechaI
    [anho,mes,dia]=datevec(ifecha);
    file=sprintf('%s/%04d/%02d/%04d%02d%02d_prof.nc',DataDirGeo,anho,mes,anho,mes,dia);
    if exist(file,'file')>0
        fprintf('     > Day %02d/%02d/%04d \n',dia,mes,anho)
        [platform,julds,lats,lons,pres,sals,tems,stapar,project,cycle,nprof,nparam,info] = readArgoDailyFileDM(file);
        nproftest=size(lats,1);
        if nproftest ~= nprof f
            fprintf('>>>>>>>>>>>>>>>>>>>>>>> Error con nprof sigo con el valor obtenido con size\n')
            nprof=nproftest;
        end
        for np=1:nprof
            if lats(np) > lat_min && lats(np) < lat_max && lons(np) > lon_min && lons(np) < lon_max %Reviso si los perfiles estan en la zona que quiero
                if ntper>=1
                    if isempty(find(platformes==str2double(platform(np,:)), 1))
                        ntper=ntper+1;
                        juldsIB(ntper)=julds(np);
                        LastJday=max([juldsIB LastJday]);
                        platformes(ntper)=str2double(platform(np,:));
                        platdatacentr(ntper,1:2)=info.datacentre(np,1:2);
                        lonsIB(ntper)=lons(np);
                        latsIB(ntper)=lats(np);
                        %Values
                        pp=pres(np,:);
                        pt=tems(np,:);
                        ps=sals(np,:);
                        iSV=find(isnan(pp)==0&isnan(pt)==0, 1 );
                        iBV=find(isnan(pp)==0&isnan(pt)==0, 1, 'last' );
                        if isempty(iSV)
                            SurfaceValue='';
                        else
                            SurfaceValue=sprintf('Presion %3.0f dbar Temp %4.1fC Sal %4.1f',pres(np,iSV),tems(np,iSV),sals(np,iSV));
                        end
                        if isempty(iBV)
                            BottonValue='';
                        else
                            BottonValue=sprintf('Presion %3.0f dbar Temp %4.1fC Sal %4.1f',pres(np,iBV),tems(np,iBV),sals(np,iBV));
                        end
                        %try
                        if isempty(find(DataArgoEs.WMO==platformes(ntper), 1))==0
                            ntperes=ntperes+1;
                            FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
                            fprintf(fid,'  [1,%s,%4.2f,%4.2f,''%s'',''%s'',''%s'',''%s''], \n',deblank(platform(np,:)),lats(np),lons(np),FloatData.MTDf.PROJECT_NAME,datestr(julds(np)),SurfaceValue,BottonValue);
                        elseif ~isempty(find(DataArgoIn.WMO==platformes(ntper), 1))
                            fprintf(fid,'  [2,%s,%4.2f,%4.2f,''%s'',''%s'',''%s'',''%s''], \n',deblank(platform(np,:)),lats(np),lons(np),deblank(project(np,:)),datestr(julds(np)),SurfaceValue,BottonValue);
                        else
                            fprintf(fid,'  [0,%s,%4.2f,%4.2f,''%s'',''%s'',''%s'',''%s''], \n',deblank(platform(np,:)),lats(np),lons(np),deblank(project(np,:)),datestr(julds(np)),SurfaceValue,BottonValue);
                        end
                    end
                else
                    ntper=ntper+1;
                    juldsIB(ntper)=julds(np);
                    LastJday=max([juldsIB LastJday]);
                    platformes(ntper)=str2double(platform(np,:));
                    lonsIB(ntper)=lons(np);
                    latsIB(ntper)=lats(np);
                    %Values
                    pp=pres(np,:);
                    pt=tems(np,:);
                    ps=sals(np,:);
                    iSV=find(isnan(pp)==0&isnan(pt)==0, 1 );
                    iBV=find(isnan(pp)==0&isnan(pt)==0, 1, 'last' );
                    if isempty(iSV)
                        SurfaceValue='';
                    else
                        SurfaceValue=sprintf('Presion %3.0f dbar Temp %4.1fC Sal %4.1f',pres(np,iSV),tems(np,iSV),sals(np,iSV));
                    end
                    if isempty(iBV)
                        BottonValue='';
                    else
                        BottonValue=sprintf('Presion %3.0f dbar Temp %4.1fC Sal %4.1f',pres(np,iBV),tems(np,iBV),sals(np,iBV));
                    end
                    if isempty(find(DataArgoEs.WMO==platformes(ntper), 1))==0
                        ntperes=ntperes+1;
                        FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
                        fprintf(fid,'   [1,%s,%4.2f,%4.2f,''%s'',''%s'',''%s'',''%s''], \n',deblank(platform(np,:)),lats(np),lons(np),FloatData.MTDf.PROJECT_NAME,datestr(julds(np)),SurfaceValue,BottonValue);
                    elseif ~isempty(find(DataArgoIn.WMO==platformes(ntper), 1))
                        fprintf(fid,'   [2,%s,%4.2f,%4.2f,''%s'',''%s'',''%s'',''%s''], \n',deblank(platform(np,:)),lats(np),lons(np),deblank(project(np,:)),datestr(julds(np)),SurfaceValue,BottonValue);
                    else
                        fprintf(fid,'   [0,%s,%4.2f,%4.2f,''%s'',''%s'',''%s'',''%s''], \n',deblank(platform(np,:)),lats(np),lons(np),deblank(project(np,:)),datestr(julds(np)),SurfaceValue,BottonValue);
                    end
                end
            end
        end
    end
end
fprintf(fid,'		];\n');
fprintf(fid,'// Marcador de posicion de las boyas\n');
fprintf(fid,'for (var i = 0; i < perfiladores.length; i++) {\n');
fprintf(fid,'  var perfilador = perfiladores[i];\n');
fprintf(fid,'    if(perfilador[0] == 0){\n');
fprintf(fid,'		L.circleMarker([perfilador[2], perfilador[3]],{\n');
fprintf(fid,'		radius : 3,\n');
fprintf(fid,'		color: ''#ffffff'',\n');
fprintf(fid,'		opacity: 1,\n');
fprintf(fid,'		fillOpacity:.85,\n');
fprintf(fid,'		title: perfilador[4]+'' WMO ''+perfilador[1]+'' ''+perfilador[5],\n');
fprintf(fid,'	    }).addTo(map).bindPopup(''<center><p>Boya <b><a href="https://fleetmonitoring.euro-argo.eu/float/''+perfilador[1]+''" target="_blank">''+perfilador[1]+''</a></b><br><b>''+perfilador[4]+''</b><br><br><b>Ultimo dato&nbsp;</b>''+perfilador[5]+''<br><b>Dato superficial&nbsp;</b>''+perfilador[6]+''<br><b>Dato profundo&nbsp;</b>''+perfilador[7]+''</p></center>'');\n');
fprintf(fid,'	 }else if (perfilador[0] == 1) {\n');
fprintf(fid,'		L.circleMarker([perfilador[2], perfilador[3]],{\n');
fprintf(fid,'		radius : 3,\n');
fprintf(fid,'		color: ''#ff0000'',\n');
fprintf(fid,'		opacity: 1,\n');
fprintf(fid,'		fillOpacity:.85,\n');
fprintf(fid,'		title: perfilador[4]+'' WMO ''+perfilador[1]+'' ''+perfilador[5],\n');
fprintf(fid,'	    }).addTo(map).bindPopup(''<center><p>Boya <b><a href="https://www.argoespana.es/float/''+perfilador[1]+''.html" target="_blank">''+perfilador[1]+''</a></b><br><b>''+perfilador[4]+''</b><br><br><b>Ultimo dato&nbsp;</b>''+perfilador[5]+''<br><b>Dato superficial&nbsp;</b>''+perfilador[6]+''<br><b>Dato profundo&nbsp;</b>''+perfilador[7]+''</p></center>'');\n');
fprintf(fid,'	 }else if (perfilador[0] == 2) {\n');
fprintf(fid,'		L.circleMarker([perfilador[2], perfilador[3]],{\n');
fprintf(fid,'		radius : 3,\n');
fprintf(fid,'		color: ''#ffffff'',\n');
fprintf(fid,'		opacity: 1,\n');
fprintf(fid,'		fillOpacity:.85,\n');
fprintf(fid,'		title: perfilador[4]+'' WMO ''+perfilador[1]+'' ''+perfilador[5],\n');
fprintf(fid,'	    }).addTo(map).bindPopup(''<center><p>Boya <b><a href="https://www.argoespana.es/float/''+perfilador[1]+''.html" target="_blank">''+perfilador[1]+''</a></b><br><b>''+perfilador[4]+''</b><br><br><b>Ultimo dato&nbsp;</b>''+perfilador[5]+''<br><b>Dato superficial&nbsp;</b>''+perfilador[6]+''<br><b>Dato profundo&nbsp;</b>''+perfilador[7]+''</p></center>'');\n');
fprintf(fid,'	}\n');
fprintf(fid,'}\n');

fprintf(fid,'//funcion leyenda \n');
fprintf(fid, 'function toggleLeyenda(btnId, contenidoId){\n');
fprintf(fid, '  var btn = document.getElementById(btnId);\n');
fprintf(fid, '  var contenido = document.getElementById(contenidoId);\n');
fprintf(fid, '  var arrow = btn.querySelector(''.legend-arrow'');\n');
fprintf(fid, '  var abierto = contenido.classList.contains(''open'')\n');
fprintf(fid, '  if(abierto){\n');
fprintf(fid, '    contenido.classList.remove(''open'');\n');
fprintf(fid, '    btn.classList.remove(''open'');\n');
fprintf(fid, '  }else{\n');
fprintf(fid, '    contenido.classList.add(''open'');\n');
fprintf(fid, '    btn.classList.add(''open'');\n');
fprintf(fid, '  }\n');
fprintf(fid, '}\n');

%% Leyenda
fprintf(fid,'//Leyenda \n');
fprintf(fid, 'var legend = L.control({position: ''bottomright''},{collapsed:esMovil});\n');
fprintf(fid, 'legend.onAdd = function (map) {\n');
fprintf(fid, 'function getColor(d) {\n');
fprintf(fid, '  return d === "Argo Internacional" ? "#ffffff" :\n');
fprintf(fid, '         d === "Argo España" ? "#ff0000" :\n');
fprintf(fid, '         "#ffffff";\n');
fprintf(fid, '  }\n');
fprintf(fid, 'var div = L.DomUtil.create(''div'', ''info legend'');\n');
fprintf(fid, 'div.style.background = "#ffffff";\n');
fprintf(fid, 'div.style.padding = "10px";\n');
fprintf(fid, 'div.style.borderRadius = "8px";\n');
fprintf(fid, 'div.style.boxShadow = "0 0 10px rgba(0,0,0,0.2)";\n');
fprintf(fid, 'div.style.lineHeight = "18px";\n');
fprintf(fid, 'div.style.opacity = "1"; // valor entre 0 y 1\n');
fprintf(fid, 'labels = [''<strong>Boyas Argo</strong>''],\n');
fprintf(fid, 'categories = [''Argo Internacional'',''Argo España''];\n');
fprintf(fid, 'for (var i = 0; i < categories.length; i++) {\n');
fprintf(fid, '  labels.push(\n');
fprintf(fid, '     ''<div style="display:flex; align-items:center;">'' +\n');
fprintf(fid, '     ''<span style="width:12px;height:12px;border:2px solid black;border-radius:50%%;background:'' + getColor(categories[i]) + '';display:inline-block;margin-right:6px;"></span>'' +\n');
fprintf(fid, '      categories[i] +\n');
fprintf(fid, '      ''</div>'');\n');
fprintf(fid, '}\n');
fprintf(fid, 'div.innerHTML = labels.join("");\n');
fprintf(fid, 'if (window.innerWidth <= 767) {\n');
fprintf(fid, '  //div.style.padding = "0";\n');
fprintf(fid, '  //div.style.background = "transparent";\n');
fprintf(fid, '  div.innerHTML =\n');
fprintf(fid, '  ''<button class="legend-toggle-btn" onclick="toggleLeyenda(\\''btnLeyenda\\'',\\''contentIEOOS\\'')" id="btnLeyenda">Boyas Argo <span class="legend-arrow">▼</span></button>'' +\n');
fprintf(fid, '  ''<div id="contentIEOOS" class="legend-collapsible">'' + div.innerHTML + ''</div>'';\n');
fprintf(fid, '  }\n');
fprintf(fid, '  return div;\n');
fprintf(fid, '};\n');

fprintf(fid, '//Funcion para crear el titulo\n');
fprintf(fid, 'var titulo = L.control({position: ''topright''},{collapsed:esMovil});\n');
fprintf(fid, 'titulo.onAdd = function (map) {\n');
fprintf(fid, '	var div = L.DomUtil.create(''div'', ''info legend'');\n');
fprintf(fid, '	div.innerHTML  = ''<b><center>Argo Espa&ntilde;a: 36 boyas y 18947 perfiles oceanogr&aacute;ficos medidos </b><br />''+\n');
fprintf(fid, '	                 ''<b>                 Último dato 06-Apr-2026 00:50:30, actualizado el 06-Apr-2026 09:16:54 </b><br/></center>'';\n');
fprintf(fid, '  div.style.background = "#ffffff";\n');
fprintf(fid, '  div.style.color = ''black'';\n');
fprintf(fid, '	div.style.fontSize = ''14px'';\n');
fprintf(fid, '	div.style.paddingLeft = ''4px'';\n');
fprintf(fid, '	div.style.paddingRight = ''4px'';\n');
fprintf(fid, '	div.style.paddingTop = ''4px'';\n');
fprintf(fid, '	div.style.paddingBottom = ''4px'';\n');
fprintf(fid, '  div.style.opacity = "1"; // valor entre 0 y 1\n');
fprintf(fid, '  if (window.innerWidth <= 767) {\n');
fprintf(fid, '    //div.style.padding = "0";\n');
fprintf(fid, '    //div.style.background = "transparent";\n');
fprintf(fid, '    div.innerHTML =\n');
fprintf(fid, '     ''<button class="legend-toggle-btn" onclick="toggleLeyenda(\\''btn\\'',\\''content\\'')" id="btn">Resumen contribucion <span class="legend-arrow">▼</span></button>'' +\n');
fprintf(fid, '     ''<div id="content" class="legend-collapsible">'' + div.innerHTML + ''</div>'';\n');
fprintf(fid, '  }\n');
fprintf(fid, '  return div;\n');
fprintf(fid, '};\n');

fprintf(fid, 'titulo.addTo(map);\n');
fprintf(fid, 'legend.addTo(map);\n');

fprintf(fid,'</script> \n');
fprintf(fid,'</body> \n');
fprintf(fid,'</html>\n');
fclose(fid);

%% Ftp the file
fprintf('     > Uploading  %s \n',FileHtmlRegionStatus);
ftpobj=FtpArgoespana;
cd(ftpobj,ftp_dir_html);
mput(ftpobj,FileHtmlRegionStatus);

%% Writting Informe
% Para el infome Selecciono solo aquellos dentro de la region IB
ipIB=find(lonsIB>lon_minIB & lonsIB<lon_maxIB & latsIB>lat_minIB & latsIB<lat_maxIB);
platformes=platformes(ipIB);
juldsIB=juldsIB(ipIB);
platdatacentr=platdatacentr(ipIB,:);

if exist(FileNameInforme,'file')>0
    InformeOld=load(FileNameInforme);
    Incremento=length(unique(platformes))-length(unique(InformeOld.platformes));
else
    Incremento=0;
end

if Incremento~=0
    Informe=sprintf('Argo%sStatus - %s/argoregionstatus.html \n     Boyas activas en %s %03d (%d) [%s,%s]\n     Fecha ultimo dato %s\n     actualizado el %s',RegionNameS,domainName,RegionNameL,length(unique(platformes)),Incremento,datestr(FechaI,1),datestr(FechaF,1),datestr(max(juldsIB)),datestr(now));
else
    Informe=sprintf('Argo%sStatus - %s/argoregionstatus.html \n     Boyas activas en %s %03d [%s,%s]\n     Fecha ultimo dato %s\n     actualizado el %s',RegionNameS,domainName,RegionNameL,length(unique(platformes)),datestr(FechaI,1),datestr(FechaF,1),datestr(max(juldsIB)),datestr(now));
end
if exist('ME')
    Informe = sprintf('%s\n >>>>>> Error %s %s line %d\n     %s <<<<<<',mfilename,Informe,ME.message,ME.stack(1).line,datestr(now));
end

save(FileNameInforme,'Informe','platformes','juldsIB','platdatacentr')

fprintf('     > %s \n',Informe)
fprintf('%s <<<<<\n',mfilename)
