clear all;close all
% Crea la pagina argoesstatus.html con el mapa creado con Leaflet de las posiciones de
% las boyas Argo-Es y las Argo-In

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

fidM = fopen(strrep(FileHtmlArgoEsStatus,'.html','_mapa.html'),'w');
fidT = fopen(strrep(FileHtmlArgoEsStatus,'.html','_tabla.html'),'w');
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

%% Writting leaflet file
fprintf('     > Writting leaflet file \n');
fprintf(fidM,'<!DOCTYPE html> \n');
fprintf(fidM,'<html> \n');
fprintf(fidM,'<head> \n');
fprintf(fidM,'	<title>Argo Espa&ntilde;a</title> \n');
fprintf(fidM,'	<meta charset="utf-8" /> \n');
fprintf(fidM,'	<meta name="viewport" content="width=device-width, initial-scale=1.0"> \n');
%Estilo
fprintf(fidM,'<style>\n');
fprintf(fidM,'  html, body {height: 100%%;}\n');
fprintf(fidM,'	#map {width: 100%%;height: 80vh;touch-action: none;}\n');
fprintf(fidM,'	.info { padding: 6px; font: 14px/16px Arial, Helvetica, sans-serif; background: rgba(255,255,255,0.8); box-shadow: 0 0 15px rgba(0,0,0,0.2); border-radius: 5px; }\n');
fprintf(fidM,'	.legend {text-align: left; line-height: 18px; color: #555; }\n');
fprintf(fidM,'	.legend i {text-align: left; width: 18px; height: 18px; float: left; margin-right: 8px;}\n');
fprintf(fidM,'	.leaflet-control-layers label {text-align: left; width: 170px;}\n');
fprintf(fidM,'	 /*---Leyendas colapsable movil/tablet*/\n');
fprintf(fidM,'	  @media (max-width: 767px) {\n');
fprintf(fidM,'	 /*---Contenedor de la leyenda*/\n');
fprintf(fidM,'	.info.legend{\n');
fprintf(fidM,'	  padding: 0 !important;\n');
fprintf(fidM,'	  font-size: 11px !important;\n');
fprintf(fidM,'	  width: 160px !important;\n');
fprintf(fidM,'	  overflow: hidden;\n');
fprintf(fidM,'	  border-radius: 8px;\n');
fprintf(fidM,'	  background: transparent;\n');
fprintf(fidM,'	  box-shadow: 0 0 10px rgba(0,0,0,0.25);\n');
fprintf(fidM,'	  }\n');
fprintf(fidM,'	 /*---Boton siempre visible*/\n');
fprintf(fidM,'	.legend-toggle-btn{\n');
fprintf(fidM,'	  display: flex;\n');
fprintf(fidM,'	  align-items: center;\n');
fprintf(fidM,'	  justify-content: space-between;\n');
fprintf(fidM,'	  width: 100	     background: rgba(255, 255, 255, 0.95);\n');
fprintf(fidM,'	  border: none;\n');
fprintf(fidM,'	  padding: 7px 10px;\n');
fprintf(fidM,'	  font-size: 11px;\n');
fprintf(fidM,'	  font-weight: bold;\n');
fprintf(fidM,'	  cursor: pointer;\n');
fprintf(fidM,'	  color: #333;\n');
fprintf(fidM,'	  box-sizing: border-box;\n');
fprintf(fidM,'	  border-radius: 8px;\n');
fprintf(fidM,'	  }\n');
fprintf(fidM,'	 /*Redondea boton cuando se abre*/\n');
fprintf(fidM,'	.legend-toggle-btn.open{\n');
fprintf(fidM,'	  border-radius: 8px 8px 0 0;\n');
fprintf(fidM,'	  }\n');
fprintf(fidM,'	 /*Flecha desplegable con transición*/\n');
fprintf(fidM,'	.legend-arrow{\n');
fprintf(fidM,'	  font-size: 10px;\n');
fprintf(fidM,'	  display: inline-block;\n');
fprintf(fidM,'	  transition: transform 0.25s ease;\n');
fprintf(fidM,'	  transform: rotate(0deg);\n');
fprintf(fidM,'	  }\n');
fprintf(fidM,'	.legend-toggle-btn.open .legend-arrow{\n');
fprintf(fidM,'	  transform: rotate(180deg);\n');
fprintf(fidM,'	  }\n');
fprintf(fidM,'	 /*Contenido despegable*/\n');
fprintf(fidM,'	.legend-collapsible{\n');
fprintf(fidM,'	  overflow: hidden;\n');
fprintf(fidM,'	  max-height: 0;\n');
fprintf(fidM,'	  opacity: 0;\n');
fprintf(fidM,'	  transition: max-height 0.3s ease, opacity 0.25s ease;\n');
fprintf(fidM,'	  background: rgba(255, 255, 255, 0.95);\n');
fprintf(fidM,'	  padding: 0 8px;\n');
fprintf(fidM,'	  border-radius: 0 0 8px 8px;\n');
fprintf(fidM,'	  }\n');
fprintf(fidM,'	.legend-collapsible.open{\n');
fprintf(fidM,'	  max-height: 300px;\n');
fprintf(fidM,'	  opacity: 1;\n');
fprintf(fidM,'	  padding: 6px 8px;\n');
fprintf(fidM,'	  }\n');
fprintf(fidM,'}\n');
fprintf(fidM,'</style>\n');

%Leaflet libraries
fprintf(fidM,'    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.6.0/dist/leaflet.css" integrity="sha512-xwE/Az9zrjBIphAcBb3F6JVqxf46+CDLwfLMHloNu6KEQCAWi6HcDUbeOfBIptF7tcCzusKFjFw2yuvEpDL9wQ==" crossorigin=""/> \n');
fprintf(fidM,'    <script src="https://unpkg.com/leaflet@1.6.0/dist/leaflet.js" integrity="sha512-gZwIG9x3wUXg2hdXF6+rVkLF/0Vi9U8D2Ntg4Ga5I5BZpVkVxlJWbSQtXPSiUTtC0TjtGOmxa1AJPuV0CPthew==" crossorigin=""></script> \n');
fprintf(fidM,'    <script src=''https://api.mapbox.com/mapbox.js/plugins/leaflet-fullscreen/v1.0.1/Leaflet.fullscreen.min.js''></script>\n');
fprintf(fidM,'    <link href=''https://api.mapbox.com/mapbox.js/plugins/leaflet-fullscreen/v1.0.1/leaflet.fullscreen.css'' rel=''stylesheet''/>\n');
fprintf(fidM,'</head> \n');
fprintf(fidM,'<body> \n');
fprintf(fidM,'<div align="center">\n');
fprintf(fidM,'  <style>\n');
fprintf(fidM,'	   html, body {height: 80%%;0;padding: 0;}\n');
fprintf(fidM,'	    #map {width: 100%%;height: 100vh;}\n');
fprintf(fidM,'	   .info { padding: 6px; font: 14px/16px Arial, Helvetica, sans-serif; box-shadow: 0 0 15px rgba(0,0,0,0.2); border-radius: 5px; }\n');
fprintf(fidM,'	   .legend { text-align: left; line-height: 18px; color: #555; }\n');
fprintf(fidM,'	   .legend i { width: 18px; height: 18px; float: left; margin-right: 8px; opacity: 1; }\n');
fprintf(fidM,'	   .leaflet-control-layers label { text-align: left; }\n');
fprintf(fidM,'  </style>\n');
fprintf(fidM,'</head> \n');
fprintf(fidM,'<body> \n');

%Add current status of tthe Argo Spain Contribution
fprintf(fidM,'<br><span class="style2"><div align="center">\n');
fprintf(fidM,'Cobertura del programa <b>Argo Espa&ntilde;a</b> el %s a las %s <br/>\n',datestr(now,1),datestr(now,13));
fprintf(fidM,'(%d) perfiladores Activos, (%d) No desplegados y (%d) Inactivos. Último dato recibido el %s <br />\n',DataArgoEs.iactiva,DataArgoEs.inodesplegada,DataArgoEs.iinactiva,datestr(max(DataArgoEs.FechaUltimoPerfil)) );
fprintf(fidM,'Hasta la fecha %d perfiles han sido realizados por las boyas del programa <b>Argo Espa&ntilde;a</b>\n',sum(NTotalPerfiles));
fprintf(fidM,'</span></div><br>\n');

%% Add map
fprintf(fidM,'<div align="center">\n');
fprintf(fidM,'<div id="map" style="width: %d px; height: %d px;"></div> \n',MTamanoArgoIb(1),MTamanoArgoIb(2));
fprintf(fidM,'</div> \n');
fprintf(fidM,'<script type="text/javascript">\n');

%% Initialize the map and set up control
fprintf(fidM,'const esMovil = window.innerWidth <= 767;\n');
fprintf(fidM,'\n');
fprintf(fidM,'const map = L.map(''map'', {\n');
fprintf(fidM,'  center: [39, -16],\n');
fprintf(fidM,'  zoom: esMovil ? 3 : 4,\n');
fprintf(fidM,'  scrollWheelZoom: false,\n');
fprintf(fidM,'  dragging: false,\n');
fprintf(fidM,'  touchZoom: false,\n');
fprintf(fidM,'  doubleClickZoom: false\n');
fprintf(fidM,'});\n');
fprintf(fidM,'\n');

fprintf(fidM,'//Activar interacción\n');
fprintf(fidM,'function activarInteraccion() {\n');
fprintf(fidM,'  map.dragging.enable();\n');
fprintf(fidM,'  map.touchZoom.enable();\n');
fprintf(fidM,'  map.scrollWheelZoom.enable();\n');
fprintf(fidM,'  map.doubleClickZoom.enable();\n');
fprintf(fidM,'}\n');
fprintf(fidM,'\n');

fprintf(fidM,'//Desactivar interacción\n');
fprintf(fidM,'function desactivarInteraccion() {\n');
fprintf(fidM,'  map.dragging.disable();\n');
fprintf(fidM,'  map.touchZoom.disable();\n');
fprintf(fidM,'  map.scrollWheelZoom.disable();\n');
fprintf(fidM,'  map.doubleClickZoom.disable();\n');
fprintf(fidM,'}\n');
fprintf(fidM,'\n');

fprintf(fidM,'//ESCRITORIO\n');
fprintf(fidM,'map.on(''click'', activarInteraccion);\n');
fprintf(fidM,'map.on(''mouseout'', desactivarInteraccion);\n');
fprintf(fidM,'\n');


fprintf(fidM,'//MÓVIL\n');
fprintf(fidM,'const container = map.getContainer();\n');
fprintf(fidM,'\n');
fprintf(fidM,'// Detectar número de dedos\n');
fprintf(fidM,'container.addEventListener(''touchstart'', function (e) {\n');
fprintf(fidM,'  if (e.touches.length === 2) {\n');
fprintf(fidM,'    //Dos dedos → activar directamente\n');
fprintf(fidM,'    activarInteraccion();\n');
fprintf(fidM,'  }\n');
fprintf(fidM,'});\n');
fprintf(fidM,'\n');
fprintf(fidM,'// Si solo usa un dedo → NO activar (deja hacer scroll normal)\n');
fprintf(fidM,'\n');
fprintf(fidM,'// Desactivar cuando termina interacción\n');
fprintf(fidM,'let timeout;\n');
fprintf(fidM,'\n');
fprintf(fidM,'container.addEventListener(''touchend'', function () {\n');
fprintf(fidM,'  clearTimeout(timeout);\n');
fprintf(fidM,'  timeout = setTimeout(() => {\n');
fprintf(fidM,'    desactivarInteraccion();\n');
fprintf(fidM,'  }, 800);\n');
fprintf(fidM,'});\n');
fprintf(fidM,'\n');

fprintf(fidM,'//OVERLAY (mensaje UX)\n');
fprintf(fidM,'const overlay = document.createElement(''div'');\n');
fprintf(fidM,'overlay.className = ''map-overlay'';\n');
fprintf(fidM,'overlay.innerHTML = esMovil \n');
fprintf(fidM,'  ? ''Usa dos dedos para mover el mapa'' \n');
fprintf(fidM,'  : ''Haz click para activar el mapa'';\n');
fprintf(fidM,'\n');
fprintf(fidM,'container.appendChild(overlay);\n');
fprintf(fidM,'\n');
fprintf(fidM,'// Ocultar overlay cuando se activa\n');
fprintf(fidM,'function ocultarOverlay() {\n');
fprintf(fidM,'  overlay.style.display = ''none'';\n');
fprintf(fidM,'}\n');
fprintf(fidM,'\n');
fprintf(fidM,'// Mostrar overlay al desactivar\n');
fprintf(fidM,'function mostrarOverlay() {\n');
fprintf(fidM,'  overlay.style.display = ''flex'';\n');
fprintf(fidM,'}\n');
fprintf(fidM,'\n');
fprintf(fidM,'map.on(''click'', ocultarOverlay);\n');
fprintf(fidM,'\n');
fprintf(fidM,'container.addEventListener(''touchstart'', function (e) {\n');
fprintf(fidM,'  if (e.touches.length === 2) {\n');
fprintf(fidM,'    ocultarOverlay();\n');
fprintf(fidM,'  }\n');
fprintf(fidM,'});\n');
fprintf(fidM,'\n');
fprintf(fidM,'container.addEventListener(''touchend'', function () {\n');
fprintf(fidM,'  setTimeout(mostrarOverlay, 800);\n');
fprintf(fidM,'});\n');

fprintf(fidM,'     map.addControl(new L.Control.Fullscreen());\n');

% Tiles
fprintf(fidM,'//Tiles\n');
fprintf(fidM,'const tiles = L.tileLayer(''https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'', {\n');
fprintf(fidM,'       attribution: ''Tiles & copy ESRI'',\n');
fprintf(fidM,'       zIndex: 1\n');
fprintf(fidM,'}).addTo(map);\n');
fprintf(fidM,'\n');

%% Escribo las trayectorias de las boyas activas
fprintf(fidM,'// Trayectorias de las boyas ArgoEspana \n');
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
            fprintf(fidM,'var TrayectoriaCoordinates = [ \n');
            for ii=1:1:length(lon)
                fprintf(fidM,'  [%7.4f,%7.4f], \n',lat(ii),lon(ii));
            end
            fprintf(fidM,'	                 ]; \n');
            fprintf(fidM,'var polyline = L.polyline(TrayectoriaCoordinates,{color: ''#ff0000'',opacity: 0.6,weight: 2.00}).addTo(map) \n');
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
            fprintf(fidM,'var TrayectoriaCoordinates = [ \n');
            for ii=1:1:length(lon)
                fprintf(fidM,'  [%7.4f,%7.4f], \n',lat(ii),lon(ii));
            end
            fprintf(fidM,'	                 ]; \n');
            fprintf(fidM,'var polyline = L.polyline(TrayectoriaCoordinates,{color: ''#FFFAFA'',opacity: 0.6,weight: 2.00}).addTo(map) \n');
        end
    end
end

%% last position [Flag,Platform, lat, lon, project]
% Number of profiles done
fprintf(fidM,'//Datos de ultima posicion de las las boyas\n');
fprintf(fidM,'var perfiladores = [ \n');
for ifloat=1:size(DataArgoEs.WMO,2)
    if DataArgoEs.activa(ifloat)==1 %Active
        FloatData = load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
        lats=FloatData.HIDf.lats(end);
        lons=FloatData.HIDf.lons(end);
        ind=find(isnan(lats)==0 & isnan(lons)==0);
        lats=lats(ind);
        lons=lons(ind);
        if ~isempty(lons) && ~isempty(lats)
            fprintf(fidM,'  [1,%s,%4.2f,%4.2f,''%s'',''%s''], \n',deblank(FloatData.HIDf.platform(end,:)),lats(end),lons(end),deblank(FloatData.MTDf.PROJECT_NAME),datestr(FloatData.HIDf.julds(end)));
        end
    else
        FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
        lats=FloatData.HIDf.lats(end);
        lons=FloatData.HIDf.lons(end);
        ind=find(isnan(lats)==0 & isnan(lons)==0);
        lats=lats(ind);
        lons=lons(ind);
        if ~isempty(lons) && ~isempty(lats)
            fprintf(fidM,'  [0,%s,%4.2f,%4.2f,''%s'',''%s''], \n',deblank(FloatData.HIDf.platform(end,:)),lats(end),lons(end),deblank(FloatData.MTDf.PROJECT_NAME),datestr(FloatData.HIDf.julds(end)));
        end
    end
end
fprintf(fidM,'		]; \n');

fprintf(fidM,'// Marcador de posicion de las boyas\n');
fprintf(fidM,'for (var i = 0; i < perfiladores.length; i++) {\n');
fprintf(fidM,'  var perfilador = perfiladores[i];\n');
fprintf(fidM,'	if(perfilador[0] == 1){\n');
fprintf(fidM,'	  L.circleMarker([perfilador[2], perfilador[3]],{\n');
fprintf(fidM,'	    radius : 3,\n');
fprintf(fidM,'		color: ''#ff0000'',\n');
fprintf(fidM,'		opacity: 1,\n');
fprintf(fidM,'		fillOpacity:.85,\n');
fprintf(fidM,'		title: perfilador[4]+'' WMO ''+perfilador[1]+'' ''+perfilador[5],\n');
fprintf(fidM,'		}).addTo(map).bindPopup(''<center><p>Boya <b><a href="https://www.argoespana.es/float/''+perfilador[1]+''.html" target="_blank">''+perfilador[1]+''</a></b><br><b>''+perfilador[4]+''</b><br><br><b>Fecha ultimo dato&nbsp;</b>''+perfilador[5]+''</p></center>'');\n');
fprintf(fidM,'	}else if (perfilador[0] == 0) {\n');
fprintf(fidM,'	  L.circleMarker([perfilador[2], perfilador[3]],{\n');
fprintf(fidM,'	    radius : 3,\n');
fprintf(fidM,'		color: ''#ffffff'',\n');
fprintf(fidM,'		opacity: 1,\n');
fprintf(fidM,'		fillOpacity:.85,\n');
fprintf(fidM,'		title: perfilador[4]+'' WMO ''+perfilador[1]+'' ''+perfilador[5],\n');
fprintf(fidM,'	}).addTo(map).bindPopup(''<center><p>Boya <b><a href="https://www.argoespana.es/float/''+perfilador[1]+''.html" target="_blank">''+perfilador[1]+''</a></b><br><b>''+perfilador[4]+''</b><br><br><b>Fecha ultimo dato&nbsp;</b>''+perfilador[5]+''</p></center>'');\n');
fprintf(fidM,'	}\n');
fprintf(fidM,'}\n');

%% Leyenda
fprintf(fidM,'//funcion leyenda \n');
fprintf(fidM,'function toggleLeyenda(btnId, contenidoId){\n');
fprintf(fidM,' var btn = document.getElementById(btnId);\n');
fprintf(fidM,' var contenido = document.getElementById(contenidoId);\n');
fprintf(fidM,' var arrow = btn.querySelector(''.legend-arrow'');\n');
fprintf(fidM,' var abierto = contenido.classList.contains(''open'')\n');
fprintf(fidM,' if(abierto){\n');
fprintf(fidM,'   contenido.classList.remove(''open'');\n');
fprintf(fidM,'   btn.classList.remove(''open'');\n');
fprintf(fidM,' }else{\n');
fprintf(fidM,'   contenido.classList.add(''open'');\n');
fprintf(fidM,'   btn.classList.add(''open'');\n');
fprintf(fidM,' }\n');
fprintf(fidM,'}\n');

%% Leyenda
fprintf(fidM,'//Leyenda \n');
fprintf(fidM,'var legend = L.control({position: ''bottomright''},{collapsed:esMovil});\n');
fprintf(fidM,'legend.onAdd = function (map) {\n');
fprintf(fidM,'function getColor(d) {\n');
fprintf(fidM,'  return d === "Boya activa" ? "#ff0000" :\n');
fprintf(fidM,'         d === "Boya inactiva" ? "#ffffff" :\n');
fprintf(fidM,'         "#ffffff";\n');
fprintf(fidM,'  }\n');
fprintf(fidM,'var div = L.DomUtil.create(''div'', ''info legend'');\n');
fprintf(fidM,'div.style.background = "#ffffff";\n');
fprintf(fidM,'div.style.padding = "10px";\n');
fprintf(fidM,'div.style.borderRadius = "8px";\n');
fprintf(fidM,'div.style.boxShadow = "0 0 10px rgba(0,0,0,0.2)";\n');
fprintf(fidM,'div.style.lineHeight = "18px";\n');
fprintf(fidM,'div.style.opacity = "1"; // valor entre 0 y 1\n');
fprintf(fidM,'labels = [''<strong>Argo España</strong>''],\n');
fprintf(fidM,'categories = [''Boya activa'',''Boya inactiva''];\n');
fprintf(fidM,'for (var i = 0; i < categories.length; i++) {\n');
fprintf(fidM,'  labels.push(\n');
fprintf(fidM,'     ''<div style="display:flex; align-items:center;">'' +\n');
fprintf(fidM,'     ''<span style="width:12px;height:12px;border:2px solid black;border-radius:50%%;background:'' + getColor(categories[i]) + '';display:inline-block;margin-right:6px;"></span>'' +\n');
fprintf(fidM,'      categories[i] +\n');
fprintf(fidM,'      ''</div>'');\n');
fprintf(fidM,'}\n');
fprintf(fidM,'div.innerHTML = labels.join("");\n');
fprintf(fidM,'if (window.innerWidth <= 767) {\n');
fprintf(fidM,'  //div.style.padding = "0";\n');
fprintf(fidM,'  //div.style.background = "transparent";\n');
fprintf(fidM,'  div.innerHTML =\n');
fprintf(fidM,'  ''<button class="legend-toggle-btn" onclick="toggleLeyenda(\\''btnLeyenda\\'',\\''contentIEOOS\\'')" id="btnLeyenda">Boyas Argo <span class="legend-arrow">▼</span></button>'' +\n');
fprintf(fidM,'  ''<div id="contentIEOOS" class="legend-collapsible">'' + div.innerHTML + ''</div>'';\n');
fprintf(fidM,'  }\n');
fprintf(fidM,'  return div;\n');
fprintf(fidM,'};\n');

fprintf(fidM,' //Funcion para crear el titulo\n');
fprintf(fidM,'var titulo = L.control({position: ''topright''});\n');
fprintf(fidM,'titulo.onAdd = function (map) {\n');
fprintf(fidM,'  var div = L.DomUtil.create(''div'', ''info legend'');\n');
fprintf(fidM,'  div.innerHTML  = ''<b><center>Argo Espa&ntilde;a: %d boyas activas, %d boyas inactivas, %d boyas no desplegadas</b></center>''\n',DataArgoEs.iactiva,DataArgoEs.iinactiva,DataArgoEs.inodesplegada);
fprintf(fidM,'  div.style.background = "#ffffff";\n');
fprintf(fidM,'  div.style.color = ''black'';\n');
fprintf(fidM,'	div.style.fontSize = ''14px'';\n');
fprintf(fidM,'	div.style.paddingLeft = ''4px'';\n');
fprintf(fidM,'	div.style.paddingRight = ''4px'';\n');
fprintf(fidM,'	div.style.paddingTop = ''4px'';\n');
fprintf(fidM,'	div.style.paddingBottom = ''4px'';\n');
fprintf(fidM,'  div.style.opacity = "1"; // valor entre 0 y 1\n');
fprintf(fidM,'  if (window.innerWidth <= 767) {\n');
fprintf(fidM,'    //div.style.padding = "0";\n');
fprintf(fidM,'    //div.style.background = "transparent";\n');
fprintf(fidM,'    div.innerHTML =\n');
fprintf(fidM,'     ''<button class="legend-toggle-btn" onclick="toggleLeyenda(\\''btn\\'',\\''content\\'')" id="btn">Resumen contribucion <span class="legend-arrow">▼</span></button>'' +\n');
fprintf(fidM,'     ''<div id="content" class="legend-collapsible">'' + div.innerHTML + ''</div>'';\n');
fprintf(fidM,'  }\n');
fprintf(fidM,'  return div;\n');
fprintf(fidM,'};\n');

fprintf(fidM,'titulo.addTo(map);\n');
fprintf(fidM,'legend.addTo(map);\n');
fprintf(fidM,'</script> \n');
fprintf(fidM,'</body>\n');
fprintf(fidM,'</html>\n');
fclose(fidM);



%% Tabla con los datos
fprintf(fidT,'<!DOCTYPE html> \n');
fprintf(fidT,'<html> \n');
fprintf(fidT,'<head> \n');
fprintf(fidT,'	<title>Argo Espa&ntilde;a</title> \n');
fprintf(fidT,'	<meta charset="utf-8" /> \n');
fprintf(fidT,'	<meta name="viewport" content="width=device-width, initial-scale=1.0"> \n');
%Estilo
fprintf(fidT,'<style type="text/css">\n');
fprintf(fidT,'<!--.style1 {font-size: 16px; font-weight: bold;font-family: verdana; color: #0c2046;}-->\n');
fprintf(fidT,'<!--.style3 {font-size: 12px; font-weight: normal; font-family: verdana; color: #0c2046}-->\n');
fprintf(fidT,'</style>\n');
fprintf(fidT,'<BR>\n');
fprintf(fidT,'<BR>\n');
fprintf(fidT,'<TABLE width="900" border="0" align="center" cellpadding="2" cellspacing="3" >\n');
fprintf(fidT,'<tr bgcolor="#C0C0C0">\n');
fprintf(fidT,'<td width="56"> <div align="center" class="style1" ><div align="center"><strong>Estado</strong></div></div></td>\n');
fprintf(fidT,'<td width="74"> <div align="center" class="style1" ><div align="center"><strong>WMO</strong></div></div></td>\n');
fprintf(fidT,'<td width="113"><div align="center" class="style1" ><div align="center"><strong>Proyecto</strong></div></div></td>\n');
fprintf(fidT,'<td width="106"><div align="center" class="style1" ><div align="center"><strong>Primer perfil</strong></div></div></td>\n');
fprintf(fidT,'<td width="106"><div align="center" class="style1" ><div align="center"><strong>&Uacute;ltimo perfil </strong></div></div></td>\n');
fprintf(fidT,'<td width="45"> <div align="center" class="style1" ><div align="center"><strong>Edad</strong></div></div></td>\n');
fprintf(fidT,'<td width="100"><div align="center" class="style1" ><div align="center"><strong>Tipo boya</strong></div></div></td>\n');
fprintf(fidT,'</TR>\n');
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
                fprintf(fidT,'<tr height: 55px; bgcolor="#e5e5e5">\n');
            else
                fprintf(fidT,'<tr height: 55px;">\n');
            end
            fprintf(fidT,'<td width="56"> <div align="center" class="style3"><a href="https://www.argoespana.es/float/%d.html" target="_blank">Activa</span></div></td>',MD.WMOFloat);
            fprintf(fidT,'<td width="74"> <div align="center" class="style3">%07d</span></div></td>',MD.WMOFloat);
            fprintf(fidT,'<td width="113"><div align="center" class="style3">%12s</span></div></td>',MD.ProjectName);
            fprintf(fidT,'<td width="106"><div align="center" class="style3">%s</span></div></td>',datestr(FloatData.HIDf.julds(1),22));
            fprintf(fidT,'<td width="106"><div align="center" class="style3">%s</span></div></td>',datestr(FloatData.HIDf.julds(end),22));
            fprintf(fidT,'<td width="45"> <div align="center" class="style3">%s</span></div></td>',MD.Age);
            fprintf(fidT,'<td width="100"><div align="center" class="style3">%12s</span></div></td>',MD.PlatformModel);
            fprintf(fidT,'</tr>');
        else
            fprintf('     > INACTIVA %7d; %12s; first:%s; last:%s; Age:%s; %s \n',MD.WMOFloat,MD.ProjectName,datestr(FloatData.HIDf.julds(1),22),datestr(FloatData.HIDf.julds(end),22),MD.Age,MD.PlatformModel)
            fprintf(fTxt,'Inactiva; %7d; %12s; %s; %s; %s; %s; %s; %6.3f; %6.3f\n',MD.WMOFloat,MD.ProjectName,datestr(FloatData.HIDf.julds(1),22),datestr(FloatData.HIDf.julds(end),22),MD.Age,MD.PlatformModel,MD.FloatOwner,FloatData.HIDf.lons(end),FloatData.HIDf.lats(end));
            if mod(ifloat,2);
                fprintf(fidT,'<TR height: 55px; bgcolor="#e5e5e5">\n');
            else
                fprintf(fidT,'<TR height: 55px;">\n');
            end
            fprintf(fidT,'<td width="56"> <div align="center" class="style3"><a href="https://www.argoespana.es/float/%d.html" target="_blank">Inactiva</span></div></td>',MD.WMOFloat);
            fprintf(fidT,'<td width="74"> <div align="center" class="style3">%07d</span></div></td>',MD.WMOFloat);
            fprintf(fidT,'<td width="113"><div align="center" class="style3">%12s</span></div></td>',MD.ProjectName);
            fprintf(fidT,'<td width="106"><div align="center" class="style3">%s</span></div></td>',datestr(FloatData.HIDf.julds(1),22));
            fprintf(fidT,'<td width="106"><div align="center" class="style3">%s</span></div></td>',datestr(FloatData.HIDf.julds(end),22));
            fprintf(fidT,'<td width=" 45"><div align="center" class="style3">%s</span></div></td>',MD.Age);
            fprintf(fidT,'<td width="100"><div align="center" class="style3">%12s</span></div></td>',MD.PlatformModel);
            fprintf(fidT,'</tr>');
        end
    else
        fprintf('     > No Desplegada %7d\n',MD.WMOFloat)
        fprintf(fTxt,'No Desplegada; %7d;;;;;\n',MD.WMOFloat);
        fprintf(fidT,'<tr class="style3">\n');
        fprintf(fidT,'<td width="56"><div align="center" class="style3"><a>Inactiva</span></div></td>');
        fprintf(fidT,'<td width="74"><div align="center" class="style3">%07d</span></div></td>',MD.WMOFloat);
        fprintf(fidT,'<td width="113"><div align="center" class="style3">Por desplegar</span></div></td>');
        fprintf(fidT,'<td width="106"><div align="center" class="style3"> ---- </span></div></td>');
        fprintf(fidT,'<td width="106"><div align="center" class="style3"> ---- </span></div></td>');
        fprintf(fidT,'<td width=" 45"><div align="center"  class="style3"> ---- </span></div></td>');
        fprintf(fidT,'<td width="100"><div align="center" class="style3"> ---- </span></div></td>');
        fprintf(fidT,'</tr>');
    end
end
fprintf(fidT,'</Table>\n');
fprintf(fidT,'</div>\n');

fprintf(fidT,'</body>\n');
fprintf(fidT,'</html>\n');
fclose(fidT);
fclose(fTxt);

%% Ftp the files
ftpobj=FtpArgoespana;
cd(ftpobj,ftp_dir_html);
mput(ftpobj,strrep(FileHtmlArgoEsStatus,'.html','_mapa.html'));
fprintf('     > Uploading  %s, %s \n',FileHtmlArgoEsStatus,strrep(FileHtmlArgoEsStatus,'.html','_mapa.html'));
mput(ftpobj,strrep(FileHtmlArgoEsStatus,'.html','_tabla.html'));
fprintf('     > Uploading  %s, %s \n',FileHtmlArgoEsStatus,strrep(FileHtmlArgoEsStatus,'.html','_table.html'));
mput(ftpobj,strrep(FileHtmlArgoEsStatus,'.html','.txt'));
fprintf('     > Uploading  %s, %s \n',FileHtmlArgoEsStatus,strrep(FileHtmlArgoEsStatus,'.html','.txt'));

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

