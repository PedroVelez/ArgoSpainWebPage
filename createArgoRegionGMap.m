clear all;close all
%This script create the google maps with the positions of all Argo floats
%active in the canary basin, and it creates the file  FileHtmlArgoIbStatus (argoibstatus.html)

%% Read options
configArgoSpainWebpage
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
%exit

% %Google Map
% GMCentroArgoIb=[39,-16];
% GMZoomArgoIb=4;
% GMTamanoArgoIb=[700,650];
%
% %Titulo
% TituloArgoIbStatus='en las aguas que rodean Espa&ntilde;a';
%
% FileHtmlArgoIbStatus='argoibstatusgm.html';
% DataDirGeo='... /Argo/geo/atlantic_ocean');

%% Inicio
%Read data
DataArgoEs=load(strcat(PaginaWebDir,'/data/dataArgoSpain.mat'),'WMO','activa','FechaUltimoPerfil');
DataArgoIn=load(strcat(PaginaWebDir,'/data/dataArgoInterest.mat'),'WMO','activa','FechaUltimoPerfil');

%lo
NTotalPerfiles=0;
for ifloat=1:length(DataArgoEs.WMO)
    FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))),'HIDf');
    NTotalPerfiles=[NTotalPerfiles nanmax(FloatData.HIDf.cycle)'];
end

fprintf('>>>>> %s\n',mfilename)
ntper=0;
ntperes=0;
FileNameInforme=strcat(PaginaWebDir,'/data/report',mfilename,'.mat');
fid = fopen(FileHtmlArgoIbStatus,'w');
fprintf('     > Writting Google Earth file \n');
fprintf(fid,'<!DOCTYPE html> \n');
fprintf(fid,'<html> \n');
fprintf(fid,'<head> \n');
fprintf(fid,'<meta name="viewport" content="initial-scale=1.0, user-scalable=no" /> \n');
fprintf(fid,'<meta http-equiv="content-type" content="text/html; charset=UTF-8"/> \n');
fprintf(fid,'<title>Argo Espa&ntilde;a</title> \n');
fprintf(fid,'<style>\n');
fprintf(fid,'	body { font-family: Arial, sans-serif; }\n');
fprintf(fid,'	#map_canvas { width:%dpx; height: %dpx;  }\n',GMTamanoArgoIb(1),GMTamanoArgoIb(2));
fprintf(fid,'</style>\n');
fprintf(fid,'<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=%s&callback=initialize"></script> \n',APIkey);
fprintf(fid,'\n');
fprintf(fid,'<script type="text/javascript" id="script"> \n');
fprintf(fid,'function initialize() {\n');
fprintf(fid,'  // Initialize the map and set up control\n');
fprintf(fid,'  var map = new google.maps.Map(document.getElementById(''map_canvas''), {\n');
fprintf(fid,'    center: new google.maps.LatLng(%4.2f, %4.2f),\n',GMCentroArgoIb(1),GMCentroArgoIb(2));
fprintf(fid,'    zoom: %d,\n',GMZoomArgoIb);
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
fprintf(fid,'  // Create the title and display og the map\n');
fprintf(fid,'  var tituloDiv = document.createElement(''DIV'');\n');
fprintf(fid,'  var titulo = new Titulo(tituloDiv, map);\n');
fprintf(fid,'  tituloDiv.index = 1;\n');
fprintf(fid,'  map.controls[google.maps.ControlPosition.TOP_CENTER].push(tituloDiv);\n');
fprintf(fid,'  //Defino los iconos\n');
fprintf(fid,'  var buoyred = new google.maps.MarkerImage(''https://www.argoespana.es/imagenes/boyaroja.png'',\n');
fprintf(fid,'      // This marker is 20 pixels wide by 32 pixels tall.\n');
fprintf(fid,'      new google.maps.Size(32,30),\n');
fprintf(fid,'      // The origin for this image is 0,0.\n');
fprintf(fid,'      new google.maps.Point(0,0),\n');
fprintf(fid,'      // The anchor for this image is the base of the flagpole at 0,32.\n');
fprintf(fid,'      new google.maps.Point(16,20));\n');
fprintf(fid,'  var buoywhitered = new google.maps.MarkerImage(''https://www.argoespana.es/imagenes/boyablancaroja.png'',\n');
fprintf(fid,'      // This marker is 20 pixels wide by 32 pixels tall.\n');
fprintf(fid,'      new google.maps.Size(32,30),\n');
fprintf(fid,'      // The origin for this image is 0,0.\n');
fprintf(fid,'      new google.maps.Point(0,0),\n');
fprintf(fid,'      // The anchor for this image is the base of the flagpole at 0,32.\n');
fprintf(fid,'      new google.maps.Point(16,20));\n');
fprintf(fid,'  var buoywhite = new google.maps.MarkerImage(''https://www.argoespana.es/imagenes/boyablanca.png'',\n');
fprintf(fid,'      // This marker is 20 pixels wide by 32 pixels tall.v\n');
fprintf(fid,'      new google.maps.Size(32,30),\n');
fprintf(fid,'      // The origin for this image is 0,0.\n');
fprintf(fid,'      new google.maps.Point(0,0),\n');
fprintf(fid,'      // The anchor for this image is the base of the flagpole at 0,32.\n');
fprintf(fid,'      new google.maps.Point(16,20));\n');

%% Trajectoria de las Argo Espana
fprintf(fid,'  // Trayectorias de las boyas ArgoEspana\n');
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
            fprintf(fid,'  var TrayectoriaCoordinates = [\n');
            for ii=1:1:length(lon)
                fprintf(fid,'		 new google.maps.LatLng(%7.4f,%7.4f),\n',lat(ii),lon(ii));
            end
            fprintf(fid,'            		 ];\n');
            fprintf(fid,'  var Trayectoria = new google.maps.Polyline({path: TrayectoriaCoordinates,strokeColor: "#FF0000",strokeOpacity: 1.0,strokeWeight: 1.25});\n');
            fprintf(fid,'  Trayectoria.setMap(map);\n');
        end
    end
end

%% Trajectoria de las Argo Interes
fprintf(fid,'  // Trayectorias de las boyas Argo Interes\n');
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
            fprintf(fid,'  var TrayectoriaCoordinates = [\n');
            for ii=1:1:length(lon)
                fprintf(fid,'		 new google.maps.LatLng(%7.4f,%7.4f),\n',lat(ii),lon(ii));
            end
            fprintf(fid,'            		 ];\n');
            fprintf(fid,'  var Trayectoria = new google.maps.Polyline({path: TrayectoriaCoordinates,strokeColor: "#FFFAFA",strokeOpacity: 0.5,strokeWeight: 1.25});\n');
            fprintf(fid,'  Trayectoria.setMap(map);\n');
        end
    end
end

%% Lee todos los perfiles en los ultimos 30 dias.
fprintf(fid,' //Datos de ultima posicion de las las boyas\n');
fprintf(fid,'	var perfiladores = [\n');

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
                            SurfaceValue=sprintf('%3.0fdbar %4.1fC %4.1f',pres(np,iSV),tems(np,iSV),sals(np,iSV));
                        end
                        if isempty(iBV)
                            BottonValue='';
                        else
                            BottonValue=sprintf('%3.0fdbar %4.1fC %4.1f',pres(np,iBV),tems(np,iBV),sals(np,iBV));
                        end
                        %try
                        if isempty(find(DataArgoEs.WMO==platformes(ntper), 1))==0
                            ntperes=ntperes+1;
                            FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
                            fprintf(fid,'           [1,%s,%4.2f,%4.2f,''%s'',''%s'',''%s'',''%s''], \n',deblank(platform(np,:)),lats(np),lons(np),FloatData.MTDf.PROJECT_NAME,datestr(julds(np)),SurfaceValue,BottonValue);
                        elseif ~isempty(find(DataArgoIn.WMO==platformes(ntper), 1))
                            fprintf(fid,'           [2,%s,%4.2f,%4.2f,''%s'',''%s'',''%s'',''%s''], \n',deblank(platform(np,:)),lats(np),lons(np),deblank(project(np,:)),datestr(julds(np)),SurfaceValue,BottonValue);
                        else
                            fprintf(fid,'           [0,%s,%4.2f,%4.2f,''%s'',''%s'',''%s'',''%s''], \n',deblank(platform(np,:)),lats(np),lons(np),deblank(project(np,:)),datestr(julds(np)),SurfaceValue,BottonValue);
                        end
                        %catch ME
                        %    ME
                        %end
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
                        SurfaceValue=sprintf('%3.0fdbar %4.1fC %4.1f',pres(np,iSV),tems(np,iSV),sals(np,iSV));
                    end
                    if isempty(iBV)
                        BottonValue='';
                    else
                        BottonValue=sprintf('%3.0fdbar %4.1fC %4.1f',pres(np,iBV),tems(np,iBV),sals(np,iBV));
                    end
                    if isempty(find(DataArgoEs.WMO==platformes(ntper), 1))==0
                        ntperes=ntperes+1;
                        FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
                        fprintf(fid,'           [1,%s,%4.2f,%4.2f,''%s'',''%s'',''%s'',''%s''], \n',deblank(platform(np,:)),lats(np),lons(np),FloatData.MTDf.PROJECT_NAME,datestr(julds(np)),SurfaceValue,BottonValue);
                    elseif ~isempty(find(DataArgoIn.WMO==platformes(ntper), 1))
                        
                        fprintf(fid,'           [2,%s,%4.2f,%4.2f,''%s'',''%s'',''%s'',''%s''], \n',deblank(platform(np,:)),lats(np),lons(np),deblank(project(np,:)),datestr(julds(np)),SurfaceValue,BottonValue);
                    else
                        fprintf(fid,'           [0,%s,%4.2f,%4.2f,''%s'',''%s'',''%s'',''%s''], \n',deblank(platform(np,:)),lats(np),lons(np),deblank(project(np,:)),datestr(julds(np)),SurfaceValue,BottonValue);
                    end
                end
            end
        end
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
fprintf(fid,'        	infowindowcontent: ''<center><p>Float <b><a href="https://www.argoespana.es/datos/floats/''+perfilador[1]+''.html" target="_blank">''+perfilador[1]+''</a></b><br><b>''+perfilador[4]+''</b><br><br><b>Last profile&nbsp;</b>''+perfilador[5]+''<br><b>Surface&nbsp;</b>''+perfilador[6]+''<br><b>Botton&nbsp;</b>''+perfilador[7]+''</p></center>'',\n');
fprintf(fid,'        	title: perfilador[4]+'' WMO ''+perfilador[1]+'' ''+perfilador[5]});\n');
fprintf(fid,'		google.maps.event.addListener(marker, ''click'', function(e) {infowindow.setContent(this.infowindowcontent);infowindow.open(map,this);});\n');
fprintf(fid,'	   }else if (perfilador[0] == 2) {	\n');
fprintf(fid,'        var marker = new google.maps.Marker({\n');
fprintf(fid,'        	position: new google.maps.LatLng(perfilador[2], perfilador[3]),\n');
fprintf(fid,'        	map: map,\n');
fprintf(fid,'        	icon: buoywhitered,\n');
fprintf(fid,'        	infowindowcontent: ''<center><p>Float <b><a href="https://www.argoespana.es/datos/floats/''+perfilador[1]+''.html" target="_blank">''+perfilador[1]+''</a></b><br><b>''+perfilador[4]+''</b><br><br><b>Last profile&nbsp;</b>''+perfilador[5]+''<br><b>Surface&nbsp;</b>''+perfilador[6]+''<br><b>Botton&nbsp;</b>''+perfilador[7]+''</p></center>'',\n');
fprintf(fid,'        	title: perfilador[4]+'' WMO ''+perfilador[1]+'' ''+perfilador[5]});\n');
fprintf(fid,'		google.maps.event.addListener(marker, ''click'', function(e) {infowindow.setContent(this.infowindowcontent);infowindow.open(map,this);});\n');
fprintf(fid,'	   }else{	\n');
fprintf(fid,'    	var marker = new google.maps.Marker({\n');
fprintf(fid,'        	position: myLatLng,\n');
fprintf(fid,'        	map: map,\n');
fprintf(fid,'        	icon: buoywhite,\n');
fprintf(fid,'        	infowindowcontent: ''<center><p>Float <b><a href="http://www.ifremer.fr/co-argoFloats/float?active=true&ptfCode=''+perfilador[1]+''" target="_blank">''+perfilador[1]+''</a></b><br><b>''+perfilador[4]+''</b><br><br><b>Last profile&nbsp;</b>''+perfilador[5]+''<br><b>Surface&nbsp;</b>''+perfilador[6]+''<br><b>Botton&nbsp;</b>''+perfilador[7]+''</p></center>'',\n');
fprintf(fid,'        	title: ''WMO ''+perfilador[1]+'' ''+perfilador[4]+'' ''+perfilador[5]});\n');
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
fprintf(fid,'  controlText.innerHTML = ''<img src="https://www.argoespana.es/imagenes/Leyenda.png" />'';\n');
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
%fprintf(fid,'  controlText.style.backgroundColor = ''#fff'';\n');
fprintf(fid,'  controlText.style.color = ''white'';\n');
fprintf(fid,'  controlText.style.fontFamily = ''Arial,sans-serif'';\n');
fprintf(fid,'  controlText.style.fontSize = ''12px'';\n');
fprintf(fid,'  controlText.style.paddingLeft = ''1px'';\n');
fprintf(fid,'  controlText.style.paddingRight = ''1px'';\n');
fprintf(fid,'  controlText.style.paddingTop = ''1px'';\n');
fprintf(fid,'  // Add the text\n');
fprintf(fid,'     controlText.innerHTML = ''<b>Cobertura del programa Argo %s el %s a las %s</b> <br />'' +\n',TituloArgoIbStatus,datestr(LastJday,1),datestr(LastJday,13));
fprintf(fid,'                             ''<b>Hasta la fecha %d perfiles oceanogr&aacute;ficos han sido medidos por las boyas del programa <b>Argo Espa&ntilde;a</b><br />'' +\n',sum(NTotalPerfiles));
fprintf(fid,'                             ''<b>Pulse en el icono de un perfilador para acceder a informaci&oacute;n m&aacute;s detallada sobre los datos medidos </b><br />''; +\n');

fprintf(fid,'  controlUI.appendChild(controlText);\n');
fprintf(fid,'}\n');

fprintf(fid,'</script> \n');
fprintf(fid,'</head> \n');
fprintf(fid,'<body onload="initialize();"> \n');
fprintf(fid,'<div align="center">\n');
fprintf(fid,'<div id="map_canvas"></div>\n');
fprintf(fid,'<div id="code"></div>\n');
fprintf(fid,'<script type="text/javascript" src="script/script.js"></script>\n');
fprintf(fid,'</div> \n');
fprintf(fid,'</body> \n');
fprintf(fid,'</html>\n');
fclose(fid);

%% Ftp the file
fprintf('     > Uploading  %s \n',FileHtmlArgoIbStatus);
ftpobj=FtpArgoespana;
cd(ftpobj,ftp_dir);
mput(ftpobj,FileHtmlArgoIbStatus);

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
    Informe=sprintf('ArgoIbStatus - Active floats Iberian Basin %03d (%d) [%s,%s]\n     Last profile %s\n     Updated on %s',length(unique(platformes)),Incremento,datestr(FechaI,1),datestr(FechaF,1),datestr(max(juldsIB)),datestr(now));
else
    Informe=sprintf('ArgoIbStatus - Active floats Iberian Basin %03d [%s,%s]\n     Las profile %s\n     Updated on %s',length(unique(platformes)),datestr(FechaI,1),datestr(FechaF,1),datestr(max(juldsIB)),datestr(now));
end
if exist('ME')
    Informe = sprintf('%s\n >>>>>> Error createArgoRegionGMap.m %s line %d\n     %s <<<<<<',Informe,ME.message,ME.stack(1).line,datestr(now));
end

save(FileNameInforme,'Informe','platformes','juldsIB','platdatacentr')

fprintf('     > %s \n',Informe)
fprintf('%s <<<<<\n',mfilename)
