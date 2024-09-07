clear all;close all
%Crea el mapa de las posiciones numeradas en la cuenca iberica argoibpositionsname.ps
%Crea el documento argoibstatus.html que conteine una tabla con enlaces a todas las boyas del area iberica

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
AI=load(strcat(PaginaWebDir,'/Data/DataArgoIn.mat'),'WMO','TRD','activa','FechaUltimoPerfil','HID');
AE=load(strcat(PaginaWebDir,'/Data/DataArgoEs.mat'),'WMO','TRD','MTD','activa','FechaUltimoPerfil','HID');

%Cuento numero de perfiles de Argo Espana
NTotalPerfiles=0;
for ifloat=1:length(AE.HID)
    NTotalPerfiles=[NTotalPerfiles nanmax(AE.HID{ifloat}.cycle)'];
end

ntper=0;
ntperes=0;
FileNameInforme=strcat(PaginaWebDir,'/Data/Informe',mfilename,'.mat');

%% Trajectoria de las Argo Espana
iTrajectoryAS=0;
sprintf('  // Trayectorias de las boyas ArgoEspana\n');
for ifloat=1:size(AE.WMO,2)
    if AE.FechaUltimoPerfil(ifloat)>now-TrajectorySpanArgo && AE.activa(ifloat)==1
        lon=AE.HID{ifloat}.lons;
        lat=AE.HID{ifloat}.lats;
        julds=AE.HID{ifloat}.julds;
        ind=find(isnan(lon)==0 & isnan(lat)==0);
        lon=lon(ind);
        lat=lat(ind);
        julds=julds(ind);
        ind=find((julds-(now-TrajectorySpanArgo))>0);
        lon=lon(ind);
        lat=lat(ind);
        if isempty(lon)==0
            iTrajectoryAS=iTrajectoryAS+1;
            TrajectoryAS.type='FeatureCollection';
            TrajectoryAS.features{iTrajectoryAS}.type='Feature';
            TrajectoryAS.features{iTrajectoryAS}.properties.stroke='#555555';
            TrajectoryAS.features{iTrajectoryAS}.properties.strokewidth=2;
            TrajectoryAS.features{iTrajectoryAS}.properties.icon=1;
            TrajectoryAS.features{iTrajectoryAS}.geometry.type='Point';
            for i1=1:length(lon)
                TrajectoryAS.features{iTrajectoryAS}.geometry.coordinates{i1}=[lon(i1),lat(i1)];
            end

        end
    end
end


%% Trajectoria de las Argo Interes
fprintf('  // Trayectorias de las boyas Argo Interes\n');
iTrajectoryAI=0;
for ifloat=1:size(AI.WMO,2)
    if AI.FechaUltimoPerfil(ifloat)>now-TrajectorySpanArgo && AI.activa(ifloat)==1
        lon=AI.HID{ifloat}.lons;
        lat=AI.HID{ifloat}.lats;
        julds=AI.HID{ifloat}.julds;
        ind=find(isnan(lon)==0 & isnan(lat)==0);
        lon=lon(ind);
        lat=lat(ind);
        julds=julds(ind);
        ind=find((julds-(now-TrajectorySpanArgo))>0);
        lon=lon(ind);
        lat=lat(ind);
        if isempty(lon)==0
            iTrajectoryAI=iTrajectoryAI+1;
            TrajectoryAI.type='FeatureCollection';
            TrajectoryAI.features{iTrajectoryAI}.type='Feature';
            TrajectoryAI.features{iTrajectoryAI}.properties.stroke='#555555';
            TrajectoryAI.features{iTrajectoryAI}.properties.strokewidth=2;
            TrajectoryAI.features{iTrajectoryAI}.properties.icon=1;
            TrajectoryAI.features{iTrajectoryAI}.geometry.type='Point';
            for i1=1:length(lon)
                TrajectoryAI.features{iTrajectoryAI}.geometry.coordinates{i1}=[lon(i1),lat(i1)];
            end
        end
    end
end

%% Lee todos los perfiles en los ultimos 30 dias.
fprintf(' //Datos de ultima posicion de las las boyas\n');
for ifecha=FechaF:-1:FechaI
    [anho,mes,dia]=datevec(ifecha);
    file=sprintf('%s/%04d/%02d/%04d%02d%02d_prof.nc',DataDirGeo,anho,mes,anho,mes,dia);
    if exist(file,'file')>0
        fprintf('>>>>>>> %02d/%02d/%04d \n',dia,mes,anho)
        [platform,julds,lats,lons,pres,sals,tems,stapar,project,cycle,nprof,nparam,info]=ReadArgoDailyFileDM(file);
        nproftest=size(lats,1);
        if nproftest ~= nprof
            fprintf('>>>>>>>>>>>>>>>>>>>>>>> Error con nprof sigo con el valor obtenido con size\n')
            nprof=nproftest;
        end
        for np=1:nprof
            if lats(np) > lat_min && lats(np) < lat_max && lons(np) > lon_min && lons(np) < lon_max %Reviso si los perfiles estan en la zona que quiero
                if ntper>=1 %Para el primer perfiel
                    if isempty(find(platformes==str2double(platform(np,:)), 1))
                        ntper=ntper+1;
                        juldsIB(ntper)=julds(np);
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
                        if isempty(iSV);SurfaceValue='';else;SurfaceValue=sprintf('%3.0fdbar %4.1fC %4.1f',pres(np,iSV),tems(np,iSV),sals(np,iSV));
                        end
                        if isempty(iBV);BottonValue='';else;BottonValue=sprintf('%3.0fdbar %4.1fC %4.1f',pres(np,iBV),tems(np,iBV),sals(np,iBV));
                        end
                        PosicionBoyas.type='FeatureCollection';
                        PosicionBoyas.features{ntper}.type='Feature';
                        PosicionBoyas.features{ntper}.properties.marker_size='small';
                        PosicionBoyas.features{ntper}.properties.WMO=deblank(platform(np,:));
                        PosicionBoyas.features{ntper}.properties.Description=deblank(project(np,:));
                        PosicionBoyas.features{ntper}.properties.Date=datestr(julds(np));
                        PosicionBoyas.features{ntper}.properties.SurfaceValue=SurfaceValue;
                        PosicionBoyas.features{ntper}.properties.BottonValue=BottonValue;
                        PosicionBoyas.features{ntper}.geometry.type='Point';
                        PosicionBoyas.features{ntper}.geometry.coordinates=[lons(np),lats(np)];
                        if isempty(find(AE.WMO==platformes(ntper), 1))==0
                            ntperes=ntperes+1;
                            PosicionBoyas.features{ntper}.properties.Icon=1;
                        elseif ~isempty(find(AI.WMO==platformes(ntper), 1))
                            PosicionBoyas.features{ntper}.properties.Icon=2;
                        else
                            PosicionBoyas.features{ntper}.properties.Icon=0;
                        end
                    end
                else
                    ntper=ntper+1;
                    juldsIB(ntper)=julds(np);
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
                    PosicionBoyas.type='FeatureCollection';
                    PosicionBoyas.features{ntper}.type='Feature';
                    PosicionBoyas.features{ntper}.properties.marker_size='small';
                    PosicionBoyas.features{ntper}.properties.WMO=deblank(platform(np,:));
                    PosicionBoyas.features{ntper}.properties.Description=deblank(project(np,:));
                    PosicionBoyas.features{ntper}.properties.Date=datestr(julds(np));
                    PosicionBoyas.features{ntper}.properties.SurfaceValue=SurfaceValue;
                    PosicionBoyas.features{ntper}.properties.BottonValue=BottonValue;
                    PosicionBoyas.features{ntper}.geometry.type='Point';
                    PosicionBoyas.features{ntper}.geometry.coordinates=[lons(np),lats(np)];
                    if isempty(find(AE.WMO==platformes(ntper), 1))==0
                        ntperes=ntperes+1;
                        PosicionBoyas.features{ntper}.properties.Icon=1;
                    elseif ~isempty(find(AI.WMO==platformes(ntper), 1))
                        PosicionBoyas.features{ntper}.properties.Icon=2;
                    else
                        PosicionBoyas.features{ntper}.properties.Icon=0;
                    end
                end
            end
        end
    end
end


%% Escribe geojson
TEXT=jsonencode(TrajectoryAI);
fid=fopen('./Html/TrajectoryAI.geojson','w');
fprintf(fid,'%s',TEXT);
fclose(fid);
TEXT=jsonencode(TrajectoryAS);
fid=fopen('./Html/TrajectoryAS.geojson','w');
fprintf(fid,'%s',TEXT);
fclose(fid)
TEXT=jsonencode(PosicionBoyas);
fid=fopen('./Html/PosicionBoyas.geojson','w');
fprintf(fid,'%s',TEXT);
fclose(fid)

% Para el infome Selecciono solo aquellos dentro de la region IB
ipIB=find(lonsIB>lon_minIB & lonsIB<lon_maxIB & latsIB>lat_minIB & latsIB<lat_maxIB);

platformes=platformes(ipIB);
juldsIB=juldsIB(ipIB);
platdatacentr=platdatacentr(ipIB,:);

%% Writting Informe
if exist(FileNameInforme,'file')>0
    InformeOld=load(FileNameInforme);
    Incremento=length(unique(platformes))-length(unique(InformeOld.platformes));
else
    Incremento=0;
end

if Incremento~=0
    Informe=sprintf('ArgoIbStatus - Activos Iberian Basin %03d (%d) [%s,%s]\n     Ultimo perfil %s\n     Actualizado %s',length(unique(platformes)),Incremento,datestr(FechaI,1),datestr(FechaF,1),datestr(max(juldsIB)),datestr(now));
else
    Informe=sprintf('ArgoIbStatus - Activos Iberian Basin %03d [%s,%s]\n     Ultimo perfil %s\n     Actualizado %s',length(unique(platformes)),datestr(FechaI,1),datestr(FechaF,1),datestr(max(juldsIB)),datestr(now));
end
if exist('ME')
    Informe=sprintf('%s\n >>>>>> Error ArgoIbStatusGM.m %s line %d\n     %s <<<<<<',Informe,ME.message,ME.stack(1).line,datestr(now));
end

save(FileNameInforme,'Informe','platformes','juldsIB','platdatacentr')

fprintf('    > %s \n',Informe)
fprintf('    > %s \n',mfilename)
