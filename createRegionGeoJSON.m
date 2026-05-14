clear all;close all
%Crea los GeoJSON que consume argoregionstatus2.html. Replica la estructura
%y la nomenclatura del createRegionGeoJSON.m original (raiz del repositorio)
%y solo aplica los cambios estrictamente necesarios para producir GeoJSON
%valido. Cada cambio va marcado inline con un comentario "% Cambio: ...".
%
%Salida (junto a argoregionstatus2.html):
%   <ScriptDir>/data/TrajectoryAS2.geojson
%   <ScriptDir>/data/TrajectoryAI2.geojson
%   <ScriptDir>/data/PosicionBoyas2.geojson

%% Read configuration
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
%
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

%Cuento numero de perfiles de Argo Espana
%NTotalPerfiles=0;
%for ifloat=1:length(AE.HID)
%    NTotalPerfiles=[NTotalPerfiles nanmax(AE.HID{ifloat}.cycle)'];
%end

ntper=0;
ntperes=0;
FileNameInforme=strcat(PaginaWebDir,'/data/report',mfilename,'.mat');

ScriptDir = fileparts(mfilename('fullpath'));
OutDir    = fullfile(ScriptDir, 'data');
if exist(OutDir,'dir')==0
    mkdir(OutDir);
end

%% Trajectoria de las Argo Espana
iTrajectoryAS=0;
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
        if numel(lon)>=2
            iTrajectoryAS=iTrajectoryAS+1;
            TrajectoryAS.type='FeatureCollection';
            TrajectoryAS.features{iTrajectoryAS}.type='Feature';
            TrajectoryAS.features{iTrajectoryAS}.properties.stroke='#FF0000';
            TrajectoryAS.features{iTrajectoryAS}.properties.strokewidth=2;
            TrajectoryAS.features{iTrajectoryAS}.geometry.type='LineString';
            TrajectoryAS.features{iTrajectoryAS}.geometry.coordinates = num2cell([lon(:), lat(:)], 2);
        end
    end
end

%% Trajectoria de las Argo Interes
iTrajectoryAI=0;
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
        if numel(lon)>=2
            iTrajectoryAI=iTrajectoryAI+1;
            TrajectoryAI.type='FeatureCollection';
            TrajectoryAI.features{iTrajectoryAI}.type='Feature';            
            TrajectoryAI.features{iTrajectoryAI}.properties.stroke='#ffee00'; 
            TrajectoryAI.features{iTrajectoryAI}.properties.strokewidth=2;
            TrajectoryAI.features{iTrajectoryAI}.geometry.type='LineString';
            TrajectoryAI.features{iTrajectoryAI}.geometry.coordinates = num2cell([lon(:), lat(:)], 2);
        end
    end
end

%% Lee todos los perfiles en los ultimos 30 dias.
fprintf('//Datos de ultima posicion de las las boyas\n');
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

                        if isempty(iSV);
                            SurfaceValue='';
                        else;
                            SurfaceValue=sprintf('Presion %3.0f dbar Temp %4.1fC Sal %4.1f',pres(np,iSV),tems(np,iSV),sals(np,iSV));
                        end
                        if isempty(iBV);
                            BottomValue='';
                        else;
                            BottomValue=sprintf('Presion %3.0f dbar Temp %4.1fC Sal %4.1f',pres(np,iBV),tems(np,iBV),sals(np,iBV));
                        end
                        
                        PosicionBoyas.type='FeatureCollection';
                        PosicionBoyas.features{ntper}.type='Feature';
                        PosicionBoyas.features{ntper}.properties.WMO=deblank(platform(np,:));
                        PosicionBoyas.features{ntper}.properties.Description=deblank(project(np,:));
                        PosicionBoyas.features{ntper}.properties.Date=datestr(julds(np));
                        PosicionBoyas.features{ntper}.properties.SurfaceValue=SurfaceValue;
                        PosicionBoyas.features{ntper}.properties.BottomValue=BottomValue;
                        PosicionBoyas.features{ntper}.geometry.type='Point';
                        PosicionBoyas.features{ntper}.geometry.coordinates=[lons(np),lats(np)];

                        if isempty(find(DataArgoEs.WMO==platformes(ntper), 1))==0
                            ntperes=ntperes+1;
                            PosicionBoyas.features{ntper}.properties.Icon=1;
                            PosicionBoyas.features{ntper}.properties.href = strcat('https://www.argoespana.es/float/',deblank(platform(np,:)),'.html');
                            PosicionBoyas.features{ntper}.properties.stroke='#ff0000'; % Argo España
                        elseif ~isempty(find(DataArgoIn.WMO==platformes(ntper), 1))
                            PosicionBoyas.features{ntper}.properties.Icon=2;
                            PosicionBoyas.features{ntper}.properties.href = strcat('https://www.argoespana.es/float/',deblank(platform(np,:)),'.html');
                            PosicionBoyas.features{ntper}.properties.stroke='#ffffff'; % Argo Interest
                        else
                            PosicionBoyas.features{ntper}.properties.Icon=0;
                            PosicionBoyas.features{ntper}.properties.href = strcat('https://fleetmonitoring.euro-argo.eu/float/',deblank(platform(np,:)));
                            PosicionBoyas.features{ntper}.properties.stroke='#ffffff'; % Argo Internacional
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
                    % Cambio: BottomValue (era BottonValue).
                    if isempty(iBV)
                        BottomValue='';
                    else
                        BottomValue=sprintf('Presion %3.0f dbar Temp %4.1fC Sal %4.1f',pres(np,iBV),tems(np,iBV),sals(np,iBV));
                    end
                    PosicionBoyas.type='FeatureCollection';
                    PosicionBoyas.features{ntper}.type='Feature';
                    PosicionBoyas.features{ntper}.properties.WMO=deblank(platform(np,:));
                    PosicionBoyas.features{ntper}.properties.Description=deblank(project(np,:));
                    PosicionBoyas.features{ntper}.properties.Date=datestr(julds(np));
                    PosicionBoyas.features{ntper}.properties.SurfaceValue=SurfaceValue;
                    PosicionBoyas.features{ntper}.properties.BottomValue=BottomValue;
                    PosicionBoyas.features{ntper}.geometry.type='Point';
                    PosicionBoyas.features{ntper}.geometry.coordinates=[lons(np),lats(np)];


                    if isempty(find(DataArgoEs.WMO==platformes(ntper), 1))==0
                        ntperes=ntperes+1;
                        PosicionBoyas.features{ntper}.properties.Icon=1;
                        PosicionBoyas.features{ntper}.properties.href = strcat('https://www.argoespana.es/float/',deblank(platform(np,:)),'.html');
                        PosicionBoyas.features{ntper}.properties.stroke='#ff0000'; % Argo España
                    elseif ~isempty(find(DataArgoIn.WMO==platformes(ntper), 1))
                        PosicionBoyas.features{ntper}.properties.Icon=2;
                        PosicionBoyas.features{ntper}.properties.href = strcat('https://www.argoespana.es/float/',deblank(platform(np,:)),'.html');
                        PosicionBoyas.features{ntper}.properties.stroke='#ffffff'; % Argo Interest
                    else
                        PosicionBoyas.features{ntper}.properties.Icon=0;
                        PosicionBoyas.features{ntper}.properties.href = strcat('https://fleetmonitoring.euro-argo.eu/float/',deblank(platform(np,:)));
                        PosicionBoyas.features{ntper}.properties.stroke='#ffffff'; % Argo Internacional
                    end
                end
            end
        end
    end
end



fid=fopen(fullfile(OutDir,'Summary.txt'),'w');
fprintf(fid,'<b>Argo Espa&ntilde;a: %d boyas y %d perfiles oceanogr&aacute;ficos medidos </b><br/>\n',DataArgoEs.iactiva,sum(NTotalPerfiles));
fprintf(fid,'<b>&Uacuteltimo dato %s, actualizado el %s </b><br/>',datestr(LastJday),datestr(now));
fclose(fid);

%% Escribe los ficheros geojson
TEXT=jsonencode(TrajectoryAI);
fid=fopen(fullfile(OutDir,'TrajectoryAI.geojson'),'w');
fprintf(fid,'%s',TEXT);
fclose(fid);

TEXT=jsonencode(TrajectoryAS);
fid=fopen(fullfile(OutDir,'TrajectoryAS.geojson'),'w');
fprintf(fid,'%s',TEXT);
fclose(fid);

TEXT=jsonencode(PosicionBoyas);
fid=fopen(fullfile(OutDir,'PosicionBoyas.geojson'),'w');
fprintf(fid,'%s',TEXT);
fclose(fid);

%% Ftp the files
fprintf('     > Uploading  %s \n',fullfile(OutDir,'TrajectoryAI.geojson'));
ftpobj=FtpArgoespana;
cd(ftpobj,strcat(ftp_dir_html,'/data'));
mput(ftpobj,fullfile(OutDir,'TrajectoryAI.geojson'));

fprintf('     > Uploading  %s \n',fullfile(OutDir,'TrajectoryAS.geojson'));
ftpobj=FtpArgoespana;
cd(ftpobj,strcat(ftp_dir_html,'/data'));
mput(ftpobj,fullfile(OutDir,'TrajectoryAS.geojson'));

fprintf('     > Uploading  %s \n',fullfile(OutDir,'PosicionBoyas.geojson'));
ftpobj=FtpArgoespana;
cd(ftpobj,strcat(ftp_dir_html,'/data'));
mput(ftpobj,fullfile(OutDir,'PosicionBoyas.geojson'));


fprintf('     > Uploading  %s \n',fullfile(OutDir,'Summary.txt'));
ftpobj=FtpArgoespana;
cd(ftpobj,strcat(ftp_dir_html,'/data'));
mput(ftpobj,fullfile(OutDir,'Summary.txt'));


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


fprintf('    > %s \n',mfilename)
