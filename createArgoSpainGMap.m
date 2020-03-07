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

%% Read Data
DataArgoEs=load(strcat(PaginaWebDir,'/data/dataArgoSpain.mat'),'activa','iactiva','iinactiva','inodesplegada','FechaUltimoPerfil','WMO','UltimoVoltaje','UltimoSurfaceOffset');

%Cuento numero de perfiles
NTotalPerfiles=0;
%for ifloat=1:length(AE.HID)
%    if AE.activa(ifloat)>0
%        NTotalPerfiles=[NTotalPerfiles nanmax(AE.HID{ifloat}.cycle)'];
%    end
%end

fprintf('>>>>> %s\n',mfilename)
FileNameInforme=strcat(PaginaWebDir,'/Data/report',mfilename,'.mat');

fid = fopen(FileHtmlArgoEsStatus,'w');
fprintf('     > Writting Google Earth file \n');
fprintf(fid,'<!DOCTYPE html> \n');
fprintf(fid,'<html> \n');
fprintf(fid,'<head> \n');
fprintf(fid,'<meta name="viewport" content="initial-scale=1.0, user-scalable=no" /> \n');
fprintf(fid,'<meta http-equiv="content-type" content="text/html; charset=UTF-8"/> \n');
fprintf(fid,'<title>Argo Espa&ntilde;a</title> \n');
fprintf(fid,'<style>\n');
fprintf(fid,'	body { font-family: Arial, sans-serif; }\n');
fprintf(fid,'	#map_canvas { width:%dpx; height: %dpx;  }\n',GMTamanoArgoEs(1),GMTamanoArgoEs(2));
fprintf(fid,'</style>\n');

fprintf(fid,'<p>\n');
fprintf(fid,'<div align="center">\n');
fprintf(fid,'Cobertura del programa <b>Argo Espa&ntilde;a</b> el %s a las %s <br />\n',datestr(now,1),datestr(now,13));
fprintf(fid,'(%d) perfiladores Activos, (%d) No desplegados y (%d) Inactivos. Ultimo perfil recibido el %s <br />\n',DataArgoEs.iactiva,DataArgoEs.inodesplegada,DataArgoEs.iinactiva,datestr(max(DataArgoEs.FechaUltimoPerfil)) );
fprintf(fid,'Hasta la fecha %d perfiles han sido realizados por las boyas del programa <b>Argo Espa&ntilde;a</b>\n',sum(NTotalPerfiles));
fprintf(fid,'</div>\n');
fprintf(fid,'</p>\n');
fprintf(fid,'<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=%s&callback=initialize"></script> \n',APIkey);
fprintf(fid,'\n');
fprintf(fid,'<script type="text/javascript" id="script"> \n');
fprintf(fid,'function initialize() {\n');
fprintf(fid,'  // Initialize the map and set up control\n');
fprintf(fid,'  var map = new google.maps.Map(document.getElementById(''map_canvas''), {\n');
fprintf(fid,'    center: new google.maps.LatLng(%4.2f, %4.2f),\n',GMCentroArgoEs(1),GMCentroArgoEs(2));
fprintf(fid,'    zoom: %d,\n',GMZoomArgoEs);
fprintf(fid,'    zoomControl: true,\n');
fprintf(fid,'    scrollwheel: false,\n');
fprintf(fid,'    zoomControlOptions: {style: google.maps.ZoomControlStyle.SMALL,position: google.maps.ControlPosition.LEFT_TOP},\n');
fprintf(fid,'    streetViewControl: false,\n');
fprintf(fid,'    panControl: false,\n');
fprintf(fid,'    mapTypeControl: false,\n');
fprintf(fid,'    overviewMapControl: false,\n');
fprintf(fid,'    mapTypeId: google.maps.MapTypeId.SATELLITE});\n');
fprintf(fid,'  \n');
fprintf(fid,'  // Create the legend and display on the map\n');
fprintf(fid,'  var legendDiv = document.createElement(''DIV'');\n');
fprintf(fid,'  var legend = new Legend(legendDiv, map);\n');
fprintf(fid,'  legendDiv.index = 1;\n');
fprintf(fid,'  map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(legendDiv);\n');
fprintf(fid,'  // Create the Titulo and display on the map\n');
fprintf(fid,'  var tituloDiv = document.createElement(''DIV'');\n');
fprintf(fid,'  var titulo = new Titulo(tituloDiv, map);\n');
fprintf(fid,'  tituloDiv.index = 1;\n');
fprintf(fid,'  map.controls[google.maps.ControlPosition.TOP_CENTER].push(tituloDiv);\n');
fprintf(fid,'  //Defino los inconos\n');
fprintf(fid,'  var buoyred = new google.maps.MarkerImage(''http://www.oceanografia.es/argo/imagenes/boyaroja.png'',\n');
fprintf(fid,'      // This marker is 20 pixels wide by 32 pixels tall.\n');
fprintf(fid,'      new google.maps.Size(32,30),\n');
fprintf(fid,'      // The origin for this image is 0,0.\n');
fprintf(fid,'      new google.maps.Point(0,0),\n');
fprintf(fid,'      // The anchor for this image is the base of the flagpole at 0,32.\n');
fprintf(fid,'      new google.maps.Point(16,20));\n');
fprintf(fid,'  var buoywhite = new google.maps.MarkerImage(''http://www.oceanografia.es/argo/imagenes/boyablanca.png'',\n');
fprintf(fid,'      // This marker is 20 pixels wide by 32 pixels tall.v\n');
fprintf(fid,'      new google.maps.Size(32,30),\n');
fprintf(fid,'      // The origin for this image is 0,0.\n');
fprintf(fid,'      new google.maps.Point(0,0),\n');
fprintf(fid,'      // The anchor for this image is the base of the flagpole at 0,32.\n');
fprintf(fid,'      new google.maps.Point(16,20));\n');
%Trajectoria de las Argo Espana
fprintf(fid,'  // Trayectorias de las boyas\n');

%% Escribo las trajectorias de lasboyas activas
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
            fprintf(fid,'  var TrayectoriaCoordinates = [\n');
            for ii=1:1:length(lon)
                fprintf(fid,'		 new google.maps.LatLng(%7.4f,%7.4f),\n',lat(ii),lon(ii));
            end
            fprintf(fid,'            		 ];\n');
            fprintf(fid,'  var Trayectoria = new google.maps.Polyline({path: TrayectoriaCoordinates,strokeColor: "#FF0000",strokeOpacity: 0.5,strokeWeight: 1.});\n');
            fprintf(fid,'  Trayectoria.setMap(map);\n');
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
            fprintf(fid,'  var TrayectoriaCoordinates = [\n');
            for ii=1:1:length(lon)
                fprintf(fid,'		 new google.maps.LatLng(%7.4f,%7.4f),\n',lat(ii),lon(ii));
            end
            fprintf(fid,'            		 ];\n');
            fprintf(fid,'  var Trayectoria = new google.maps.Polyline({path: TrayectoriaCoordinates,strokeColor: "#FFFFFF",strokeOpacity: 0.25,strokeWeight: 1.});\n');
            fprintf(fid,'  Trayectoria.setMap(map);\n');
        end
    end
end

%% last position [Flag,Platform, lat, lon, project]
%number of profiles done
fprintf(fid,' //Datos de ultima poscion de las las boyas\n');
fprintf(fid,'	var perfiladores = [\n');
for ifloat=1:size(DataArgoEs.WMO,2)
    if DataArgoEs.activa(ifloat)==1 %Active
        FloatData = load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
        NTotalPerfiles = [NTotalPerfiles nanmax(FloatData.HIDf.cycle)'];
        fprintf(fid,'           [1,%s,%4.2f,%4.2f,''%s''], \n',deblank(FloatData.HIDf.platform(end,:)),FloatData.HIDf.lats(end),FloatData.HIDf.lons(end),deblank(FloatData.MTDf.PROJECT_NAME));
    elseif DataArgoEs.activa(ifloat)==2 %Inactiva pero con datos
        FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
        NTotalPerfiles=[NTotalPerfiles nanmax(FloatData.HIDf.cycle)'];
        fprintf(fid,'           [0,%s,%4.2f,%4.2f,''%s''], \n',deblank(FloatData.HIDf.platform(end,:)),FloatData.HIDf.lats(end),FloatData.HIDf.lons(end),deblank(FloatData.MTDf.PROJECT_NAME));
    end
end
fprintf(fid,'           ];\n');
fprintf(fid,'  // Marcador de posicion de las boyas\n');
fprintf(fid,'  var infowindow = new google.maps.InfoWindow();\n');
fprintf(fid,'  for (var i = 0; i < perfiladores.length; i++) {\n');
fprintf(fid,'      var perfilador = perfiladores[i];\n');
fprintf(fid,'      var myLatLng = new google.maps.LatLng(perfilador[2], perfilador[3]);\n');
fprintf(fid,'      if(perfilador[0] == 1){\n');
fprintf(fid,'        var marker = new google.maps.Marker({\n');
fprintf(fid,'        	position: new google.maps.LatLng(perfilador[2], perfilador[3]),\n');
fprintf(fid,'        	map: map,\n');
fprintf(fid,'        	icon: buoyred,\n');
fprintf(fid,'        	infowindowcontent: ''<center><p>Float <b><a href="http://www.oceanografia.es/argo/datos/floats/''+perfilador[1]+''.html" target="_blank">''+perfilador[1]+''</a></b><br>''+perfilador[4]+''</p></center>'',\n');
fprintf(fid,'        	title: perfilador[4]+'' WMO ''+perfilador[1]});\n');
fprintf(fid,'		google.maps.event.addListener(marker, ''click'', function(e) {infowindow.setContent(this.infowindowcontent);infowindow.open(map,this);});\n');
fprintf(fid,'	  }else{	\n');
fprintf(fid,'    	var marker = new google.maps.Marker({\n');
fprintf(fid,'        	position: myLatLng,\n');
fprintf(fid,'        	map: map,\n');
fprintf(fid,'        	icon: buoywhite,\n');
fprintf(fid,'        	infowindowcontent: ''<center><p>Float <b><a href="http://www.oceanografia.es/argo/datos/floats/''+perfilador[1]+''.html" target="_blank">''+perfilador[1]+''</a></b><br>''+perfilador[4]+''</p></center>'',\n');
fprintf(fid,'        	title: perfilador[4]+'' WMO ''+perfilador[1]});\n');
fprintf(fid,'		google.maps.event.addListener(marker, ''click'', function(e) {infowindow.setContent(this.infowindowcontent);infowindow.open(map,this);});\n');
fprintf(fid,'	  }//if \n');
fprintf(fid,'  }//for Marcador de poscion de las boyas\n');
fprintf(fid,'}//function initialize\n');

fprintf(fid,'function Legend(controlDiv, map) {\n');
fprintf(fid,'  //Fucnion para crear la leyenda\n');
fprintf(fid,'  // Set CSS styles for the DIV containing the control\n');
fprintf(fid,'  controlDiv.style.padding = ''0px'';\n');
fprintf(fid,'  // Set CSS for the control border\n');
fprintf(fid,'  var controlUI = document.createElement(''DIV'');\n');
fprintf(fid,'  controlUI.style.backgroundColor = ''transparent'';\n');
fprintf(fid,'  controlUI.style.borderStyle = ''solid'';\n');
fprintf(fid,'  controlUI.style.borderWidth = ''0px'';\n');
fprintf(fid,'  controlUI.title = ''Legend'';\n');
fprintf(fid,'  controlDiv.appendChild(controlUI);\n');
fprintf(fid,'  // Set CSS for the control text\n');
fprintf(fid,'  var controlText = document.createElement(''DIV'');\n');
fprintf(fid,'  controlText.style.fontFamily = ''Arial,sans-serif'';\n');
fprintf(fid,'  controlText.style.fontSize = ''12px'';\n');
fprintf(fid,'  controlText.style.paddingLeft = ''1px'';\n');
fprintf(fid,'  controlText.style.paddingRight = ''1px'';\n');
fprintf(fid,'  // Add the text\n');
fprintf(fid,'  controlText.innerHTML = ''<img src="http://www.oceanografia.es/argo/imagenes/LeyendaArgoEs.png" />'';\n');
fprintf(fid,'  controlUI.appendChild(controlText);\n');
fprintf(fid,'}\n');

fprintf(fid,'function Titulo(controlDiv, map) {\n');
fprintf(fid,'  //Fucnion para crear el Titulo\n');
fprintf(fid,'  // Set CSS styles for the DIV containing the control\n');
fprintf(fid,'  controlDiv.style.padding = ''0px'';\n');
fprintf(fid,'  // Set CSS for the control border\n');
fprintf(fid,'  var controlUI = document.createElement(''DIV'');\n');
fprintf(fid,'  controlUI.style.backgroundColor = ''trasparent'';\n');
fprintf(fid,'  controlUI.style.borderStyle = ''solid'';\n');
fprintf(fid,'  controlUI.style.borderWidth = ''0px'';\n');
fprintf(fid,'  controlUI.title = ''Titulo'';\n');
fprintf(fid,'  controlDiv.appendChild(controlUI);\n');
fprintf(fid,'  // Set CSS for the control text\n');
fprintf(fid,'  var controlText = document.createElement(''DIV'');\n');
fprintf(fid,'  controlText.style.color = ''yellow'';\n');
fprintf(fid,'  controlText.style.fontFamily = ''Arial,sans-serif'';\n');
fprintf(fid,'  controlText.style.fontSize = ''12px'';\n');
fprintf(fid,'  controlText.style.paddingLeft = ''1px'';\n');
fprintf(fid,'  controlText.style.paddingRight = ''px'';\n');
fprintf(fid,'  controlText.style.paddingTop = ''10px'';\n');
fprintf(fid,'  // Add the text\n');
fprintf(fid,'    controlText.innerHTML =  ''<b>Haga clic en los diferentes perfiladores para acceder a informaci&oacute;n m&aacute;s detallada sobre los datos medidos</b> <br />''; +\n');
%fprintf(fid,'     controlText.innerHTML = ''Cobertura del programa <b>Argo Espa&ntilde;a</b> el %s a las %s <br />'' +\n',datestr(now,1),datestr(now,13));
%fprintf(fid,'                             ''(%d) perfiladores Activos, (%d) No desplegados y (%d) Inactivos. Ultimo perfil recibido %s <br />'' +\n',AE.iactiva,AE.inodesplegada,AE.iinactiva,datestr(max(AE.FechaUltimoPerfil)) );
%fprintf(fid,'                             ''Haga clic en los diferentes perfiladores para acceder a informaci&oacute;n m&aacute;s detallada sobre los datos medidos <br />''; +\n');
fprintf(fid,'  controlUI.appendChild(controlText);\n');
fprintf(fid,'}\n');

fprintf(fid,'</script> \n');
fprintf(fid,'</head> \n');
fprintf(fid,'<body onload="initialize();"> \n');
fprintf(fid,'<style type="text/css">\n');
fprintf(fid,'<!--\n');
fprintf(fid,'  .style1 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px; }\n');
fprintf(fid,'-->\n');
fprintf(fid,'</style>\n');
fprintf(fid,'<div align="center">\n');
fprintf(fid,'<div align="center"><p class="style1"><BR></p>\n');
fprintf(fid,'<div id="map_canvas"></div>\n');
fprintf(fid,'<div id="code"></div>\n');
fprintf(fid,'<script type="text/javascript" src="script/script.js"></script>\n');
fprintf(fid,'<BR>\n\n');

%% Tabla con los datos
fprintf(fid,'<style type="text/css">\n');
fprintf(fid,'<!--\n');
fprintf(fid,'.style1 {font-family: Verdana, Arial, Helvetica, sans-serif}\n');
fprintf(fid,'.style4 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px; }\n');
fprintf(fid,'-->\n');
fprintf(fid,'</style>\n');
fprintf(fid,'<TABLE width="746" border="1" align="center" bordercolor="#003366">\n');
fprintf(fid,'<TR bgcolor="#C0C0C0">\n');
fprintf(fid,'<TD width="56"><div align="center" class="style1" ><div align="center"><strong>Estado</strong></div></div></TD>\n');
fprintf(fid,'<TD width="74"><div align="center" class="style1" ><div align="center"><strong>ID</strong></div></div></TD>\n');
fprintf(fid,'<TD width="113"><div align="center" class="style1" ><div align="center"><strong>Proyecto</strong></div></div></TD>\n');
fprintf(fid,'<TD width="106"><div align="center" class="style1" ><div align="center"><strong>Primer perfil </strong></div></div></TD>\n');
fprintf(fid,'<TD width="106"><div align="center" class="style1" ><div align="center"><strong>&Uacute;ltimo perfil </strong></div></div></TD>\n');
fprintf(fid,'<TD width="45"><div align="center" class="style1" ><div align="center"><strong>Edad</strong></div></div></TD>\n');
fprintf(fid,'<TD width="100"><div align="center" class="style1" ><div align="center"><strong>Tipo boya </strong></div></div></TD>\n');
fprintf(fid,'<TD width="50"><div align="center" class="style1" ><div align="center"><strong>Voltaje</strong></div></div></TD>\n');
fprintf(fid,'<TD width="50"><div align="center" class="style1" ><div align="center"><strong>Surface offset</strong></div></div></TD>\n');
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
            fprintf(fid,'<TD width="56"><div align="center" class="style4"><a href="http://www.oceanografia.es/argo/datos/floats/%d.html" target="_blank">Activa</span></div></TD>',MD.WMOFloat);
            fprintf(fid,'<TD width="74"><div align="center" class="style4">%07d</span></div></TD>',MD.WMOFloat);
            fprintf(fid,'<TD width="113"><div align="center" class="style4">%12s</span></div></TD>',MD.ProjectName);
            fprintf(fid,'<TD width="106"><div align="center" class="style4">%s</span></div></TD>',datestr(FloatData.HIDf.julds(1),22));
            fprintf(fid,'<TD width="106"><div align="center" class="style4">%s</span></div></TD>',datestr(FloatData.HIDf.julds(end),22));
            fprintf(fid,'<TD width="45"><div align="center"  class="style4">%s</span></div></TD>',MD.Age);
            fprintf(fid,'<TD width="100"><div align="center" class="style4">%12s</span></div></TD>',MD.PlatformModel);
            fprintf(fid,'<TD width="50"><div align="center" class="style4">%4.2f</span></div></TD>',DataArgoEs.UltimoVoltaje(ifloat));
            fprintf(fid,'<TD width="50"><div align="center" class="style4">%4.2f</span></div></TD>',DataArgoEs.UltimoSurfaceOffset(ifloat));
            fprintf(fid,'</TR>');
        else
            fprintf('     > INACTIVA %7d; %12s; first:%s; last:%s; Age:%s; %s \n',MD.WMOFloat,MD.ProjectName,datestr(FloatData.HIDf.julds(1),22),datestr(FloatData.HIDf.julds(end),22),MD.Age,MD.PlatformModel)
            fprintf(fid,'<TR class="style4">\n');
            fprintf(fid,'<TD width="56"><div align="center" class="style4"><a href="http://www.oceanografia.es/argo/datos/floats/%d.html" target="_blank">Inactiva</span></div></TD>',MD.WMOFloat);
            fprintf(fid,'<TD width="74"><div align="center" class="style4">%07d</span></div></TD>',MD.WMOFloat);
            fprintf(fid,'<TD width="113"><div align="center" class="style4">%12s</span></div></TD>',MD.ProjectName);
            fprintf(fid,'<TD width="106"><div align="center" class="style4">%s</span></div></TD>',datestr(FloatData.HIDf.julds(1),22));
            fprintf(fid,'<TD width="106"><div align="center" class="style4">%s</span></div></TD>',datestr(FloatData.HIDf.julds(end),22));
            fprintf(fid,'<TD width="45"><div align="center"  class="style4">%s</span></div></TD>',MD.Age);
            fprintf(fid,'<TD width="100"><div align="center" class="style4">%12s</span></div></TD>',MD.PlatformModel);
            fprintf(fid,'<TD width="50"><div align="center" class="style4">%4.2f</span></div></TD>',DataArgoEs.UltimoVoltaje(ifloat));
            fprintf(fid,'<TD width="50"><div align="center" class="style4">%4.2f</span></div></TD>',DataArgoEs.UltimoSurfaceOffset(ifloat));
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
