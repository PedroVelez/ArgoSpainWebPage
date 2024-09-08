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
% %Google Map
% GMCentroArgoIb=[39,-16];
% GMZoomArgoIb=4;
% GMTamanoArgoIb=[700,650];
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
%Leaflet libraries
fprintf(fid,'    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.6.0/dist/leaflet.css" integrity="sha512-xwE/Az9zrjBIphAcBb3F6JVqxf46+CDLwfLMHloNu6KEQCAWi6HcDUbeOfBIptF7tcCzusKFjFw2yuvEpDL9wQ==" crossorigin=""/> \n');
fprintf(fid,'    <script src="https://unpkg.com/leaflet@1.6.0/dist/leaflet.js" integrity="sha512-gZwIG9x3wUXg2hdXF6+rVkLF/0Vi9U8D2Ntg4Ga5I5BZpVkVxlJWbSQtXPSiUTtC0TjtGOmxa1AJPuV0CPthew==" crossorigin=""></script> \n');
%Full screen control
fprintf(fid,'    <script src=''https://api.mapbox.com/mapbox.js/plugins/leaflet-fullscreen/v1.0.1/Leaflet.fullscreen.min.js''></script>\n');
fprintf(fid,'    <link href=''https://api.mapbox.com/mapbox.js/plugins/leaflet-fullscreen/v1.0.1/leaflet.fullscreen.css'' rel=''stylesheet'' />\n');
fprintf(fid,'</head> \n');
fprintf(fid,'<body> \n');
fprintf(fid,'<div align="center">\n');
fprintf(fid,'<div id="mapid" style="width: %dpx; height: %dpx;"></div> \n',GMTamanoArgoIb(1),GMTamanoArgoIb(2));
fprintf(fid,'</div> \n');
fprintf(fid,'<script> \n');
fprintf(fid,'// Initialize the map and set up control \n');
fprintf(fid,'   var mymap = L.map(''mapid'',{scrollwheelzoom: false}).setView([%4.2f, %4.2f],  %d); \n',GMCentroArgoIb(1),GMCentroArgoIb(2),GMZoomArgoIb);
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
fprintf(fid,'   var buoyred = new buoyIcon({iconUrl: ''https://www.argoespana.es/imagenes/boyaroja.png''}), \n');
fprintf(fid,'       buoyyellow = new buoyIcon({iconUrl: ''https://www.argoespana.es/imagenes/boyablancaroja.png''}), \n');
fprintf(fid,'       buoywhite = new buoyIcon({iconUrl: ''https://www.argoespana.es/imagenes/boyablanca.png''}); \n');
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
            fprintf(fid,'		var TrayectoriaCoordinates = [\n');
            for ii=1:1:length(lon)
                fprintf(fid,'			[%7.4f,%7.4f],\n',lat(ii),lon(ii));
            end
            fprintf(fid,'		];\n');
            fprintf(fid,'var polyline = L.polyline(TrayectoriaCoordinates,{color: ''#FF0000'',opacity: 0.6,weight: 2.00}).addTo(mymap)\n');
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
            fprintf(fid,'		var TrayectoriaCoordinates = [\n');
            for ii=1:1:length(lon)
                fprintf(fid,'			[%7.4f,%7.4f],\n',lat(ii),lon(ii));
            end
            fprintf(fid,'		];\n');
            fprintf(fid,'var polyline = L.polyline(TrayectoriaCoordinates,{color: ''#FFFAFA'',opacity: 0.6,weight: 2.00}).addTo(mymap)\n');
        end
    end
end
%% Lee todos los perfiles en los ultimos 30 dias.
fprintf(fid,' //Datos de ultima posicion de las las boyas\n');
fprintf(fid,'   var perfiladores = [\n');
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
                            fprintf(fid,'   [1,%s,%4.2f,%4.2f,''%s'',''%s'',''%s'',''%s''], \n',deblank(platform(np,:)),lats(np),lons(np),FloatData.MTDf.PROJECT_NAME,datestr(julds(np)),SurfaceValue,BottonValue);
                        elseif ~isempty(find(DataArgoIn.WMO==platformes(ntper), 1))
                            fprintf(fid,'   [2,%s,%4.2f,%4.2f,''%s'',''%s'',''%s'',''%s''], \n',deblank(platform(np,:)),lats(np),lons(np),deblank(project(np,:)),datestr(julds(np)),SurfaceValue,BottonValue);
                        else
                            fprintf(fid,'   [0,%s,%4.2f,%4.2f,''%s'',''%s'',''%s'',''%s''], \n',deblank(platform(np,:)),lats(np),lons(np),deblank(project(np,:)),datestr(julds(np)),SurfaceValue,BottonValue);
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
fprintf(fid,' // Marcador de posicion de las boyas\n');
fprintf(fid,'	for (var i = 0; i < perfiladores.length; i++) {\n');
fprintf(fid,'		var perfilador = perfiladores[i];\n');
fprintf(fid,'		if(perfilador[0] == 0){\n');
fprintf(fid,'			L.marker([perfilador[2], perfilador[3]],{\n');
fprintf(fid,'			icon: buoywhite,\n');
fprintf(fid,'			title: perfilador[4]+'' WMO ''+perfilador[1]+'' ''+perfilador[5],\n');
fprintf(fid,'			}).addTo(mymap).bindPopup(''<center><p>Boya <b><a href="https://fleetmonitoring.euro-argo.eu/float/''+perfilador[1]+''" target="_blank">''+perfilador[1]+''</a></b><br><b>''+perfilador[4]+''</b><br><br><b>Fecha ultimo dato&nbsp;</b>''+perfilador[5]+''<br><b>Dato mas superficial&nbsp;</b>''+perfilador[6]+''<br><b>Dato mas profundo&nbsp;</b>''+perfilador[7]+''</p></center>'');\n');
fprintf(fid,'		}else if (perfilador[0] == 1) {\n');
fprintf(fid,'			L.marker([perfilador[2], perfilador[3]],{\n');
fprintf(fid,'			icon: buoyred,\n');
fprintf(fid,'			title: perfilador[4]+'' WMO ''+perfilador[1]+'' ''+perfilador[5],\n');
fprintf(fid,'			}).addTo(mymap).bindPopup(''<center><p>Boya <b><a href="https://www.argoespana.es/float/''+perfilador[1]+''.html" target="_blank">''+perfilador[1]+''</a></b><br><b>''+perfilador[4]+''</b><br><br><b>Fecha ultimo dato&nbsp;</b>''+perfilador[5]+''<br><b>Dato mas superficial&nbsp;</b>''+perfilador[6]+''<br><b>Dato mas profundo&nbsp;</b>''+perfilador[7]+''</p></center>'');\n');
fprintf(fid,'		}else if (perfilador[0] == 2) {\n');
fprintf(fid,'			L.marker([perfilador[2], perfilador[3]],{\n');
fprintf(fid,'			icon: buoyyellow,\n');
fprintf(fid,'			title: perfilador[4]+'' WMO ''+perfilador[1]+'' ''+perfilador[5],\n');
fprintf(fid,'			}).addTo(mymap).bindPopup(''<center><p>Boya <b><a href="https://www.argoespana.es/float/''+perfilador[1]+''.html" target="_blank">''+perfilador[1]+''</a></b><br><b>''+perfilador[4]+''</b><br><br><b>Fecha ultimo dato&nbsp;</b>''+perfilador[5]+''<br><b>Dato mas superficial&nbsp;</b>''+perfilador[6]+''<br><b>Dato mas profundo&nbsp;</b>''+perfilador[7]+''</p></center>'');\n');
fprintf(fid,'		}\n');
fprintf(fid,'	}// Marcador de posicion de las boyas\n');

fprintf(fid,'//Funcion para crear la leyenda\n');
fprintf(fid,'	var legend = L.control({position: ''bottomright''});\n');
fprintf(fid,'	legend.onAdd = function (map) {\n');
fprintf(fid,'	    var div = L.DomUtil.create(''div'', ''info legend'');\n');
fprintf(fid,'       		div.innerHTML = "<img src=https://www.argoespana.es/imagenes/Leyenda.png height=''75''><br>";\n');
fprintf(fid,'	    return div;\n');
fprintf(fid,'	};\n');
fprintf(fid,'	legend.addTo(mymap);\n');

fprintf(fid,' //Funcion para crear el titulo\n');
fprintf(fid,'	var titulo = L.control({position: ''topright''});\n');
fprintf(fid,'	titulo.onAdd = function (map) {\n');
fprintf(fid,'	    var div = L.DomUtil.create(''div'', ''info legend'');\n');
fprintf(fid,'	        div.innerHTML  = ''<b>Argo Espa&ntilde;a: %d boyas y %d perfiles oceanogr&aacute;ficos medidos </b><br />''+\n',DataArgoEs.iactiva,sum(NTotalPerfiles));
fprintf(fid,'	                         ''<b>                 Último dato %s, actualizado el %s </b><br />'';\n',datestr(LastJday),datestr(now));
fprintf(fid,'  			div.style.color = ''white'';\n');
fprintf(fid,'			div.style.fontSize = ''12px'';\n');
fprintf(fid,'		    div.style.paddingLeft = ''0px'';\n');
fprintf(fid,'		    div.style.paddingRight = ''0px'';\n');
fprintf(fid,'		    div.style.paddingTop = ''0px'';\n');
fprintf(fid,'	    return div;\n');
fprintf(fid,'	};\n');
fprintf(fid,'	titulo.addTo(mymap);\n');
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
    Informe=sprintf('ArgoIbStatus - Boyas activas Iberian Basin %03d (%d) [%s,%s]\n     Fecha ultimo dato %s\n     actualizado el %s',length(unique(platformes)),Incremento,datestr(FechaI,1),datestr(FechaF,1),datestr(max(juldsIB)),datestr(now));
else
    Informe=sprintf('ArgoIbStatus - Boyas activas Iberian Basin %03d [%s,%s]\n     Las profile %s\n     actualizado el %s',length(unique(platformes)),datestr(FechaI,1),datestr(FechaF,1),datestr(max(juldsIB)),datestr(now));
end
if exist('ME')
    Informe = sprintf('%s\n >>>>>> Error createArgoRegionGMap.m %s line %d\n     %s <<<<<<',Informe,ME.message,ME.stack(1).line,datestr(now));
end

save(FileNameInforme,'Informe','platformes','juldsIB','platdatacentr')

fprintf('     > %s \n',Informe)
fprintf('%s <<<<<\n',mfilename)
