clear all;close all
% Crea la pagina argoesstatus_mapa.html con el mapa creado con Leaflet de las posiciones de
% las boyas Argo-Es y las Argo-In y argoesstatus_table.html con las boyas de Argo Es

%% Read configuration
configWebPage

% TrajectorySpanArgo=now-datenum(2005,1,1);
% FileHtmlArgoEsStatus;

%% Inicio
fprintf('>>>>> %s\n',mfilename)

% Read Data
DataArgoEs=load(strcat(PaginaWebDir,'/data/dataArgoSpain.mat'),'activa','iactiva','iinactiva','inodesplegada','FechaUltimoPerfil','WMO','UltimoVoltaje','UltimoSurfaceOffset');
FileNameInforme=strcat(PaginaWebDir,'/data/report',mfilename,'.mat');

ScriptDir = fileparts(mfilename('fullpath'));
OutDir    = fullfile(ScriptDir, 'data');
if exist(OutDir,'dir')==0
    mkdir(OutDir);
end

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

%Add current status of tthe Argo Spain Contribution
fid=fopen(fullfile(OutDir,'SummaryDataSet.txt'),'w');
fprintf(fid,'Cobertura del programa <b>Argo Espa&ntilde;a</b> el %s a las %s <br/>\n',datestr(now,1),datestr(now,13));
fprintf(fid,'(%d) perfiladores Activos, (%d) No desplegados y (%d) Inactivos. Último dato recibido el %s <br />\n',DataArgoEs.iactiva,DataArgoEs.inodesplegada,DataArgoEs.iinactiva,datestr(max(DataArgoEs.FechaUltimoPerfil)) );
fprintf(fid,'Hasta la fecha %d perfiles han sido realizados por las boyas del programa <b>Argo Espa&ntilde;a</b>\n',sum(NTotalPerfiles));
fclose(fid);

%% Escribo las trayectorias de las boyas activas
iTrajectoryDS=0;
for ifloat=1:size(DataArgoEs.WMO,2)
    if DataArgoEs.activa(ifloat)==1
        FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
        lon=FloatData.HIDf.lons;
        lat=FloatData.HIDf.lats;
        julds=FloatData.HIDf.julds;
        ind=find((julds-(now-TrajectorySpanArgo))>0 & isnan(lon)==0 & isnan(lat)==0);
        lon=lon(ind);
        lat=lat(ind);
        if numel(lon)>=2
            iTrajectoryDS=iTrajectoryDS+1;
            Trajectory.type='FeatureCollection';
            Trajectory.features{iTrajectoryDS}.type='Feature';
            Trajectory.features{iTrajectoryDS}.properties.stroke='#FF0000';
            Trajectory.features{iTrajectoryDS}.properties.strokewidth=2;
            Trajectory.features{iTrajectoryDS}.geometry.type='LineString';
            Trajectory.features{iTrajectoryDS}.geometry.coordinates = num2cell([lon(:), lat(:)], 2);
        end
    elseif DataArgoEs.activa(ifloat)==2
        FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
        lon=FloatData.HIDf.lons;
        lat=FloatData.HIDf.lats;
        julds=FloatData.HIDf.julds;
        ind=find((julds-(now-TrajectorySpanArgo))>0 & isnan(lon)==0 & isnan(lat)==0);
        lon=lon(ind);
        lat=lat(ind);
        if numel(lon)>=2
            iTrajectoryDS=iTrajectoryDS+1;
            Trajectory.type='FeatureCollection';
            Trajectory.features{iTrajectoryDS}.type='Feature';
            Trajectory.features{iTrajectoryDS}.properties.stroke='#ffffff';
            Trajectory.features{iTrajectoryDS}.properties.strokewidth=2;
            Trajectory.features{iTrajectoryDS}.geometry.type='LineString';
            Trajectory.features{iTrajectoryDS}.geometry.coordinates = num2cell([lon(:), lat(:)], 2);
        end
    end
end

%% last position [Flag,Platform, lat, lon, project]
iBoyasDS=0;
for ifloat=1:size(DataArgoEs.WMO,2)
    if DataArgoEs.activa(ifloat)==1 %Active
        FloatData = load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
        lats=FloatData.HIDf.lats(end);
        lons=FloatData.HIDf.lons(end);
        ind=find(isnan(lats)==0 & isnan(lons)==0);
        lats=lats(ind);
        lons=lons(ind);
        if ~isempty(lons) && ~isempty(lats)
            iBoyasDS=iBoyasDS+1;
            PosicionBoyas.type='FeatureCollection';
            PosicionBoyas.features{iBoyasDS}.type='Feature';
            PosicionBoyas.features{iBoyasDS}.properties.Icon=1;
            PosicionBoyas.features{iBoyasDS}.properties.WMO=deblank(FloatData.HIDf.platform(end,:));
            PosicionBoyas.features{iBoyasDS}.properties.Description=deblank(FloatData.MTDf.PROJECT_NAME);
            PosicionBoyas.features{iBoyasDS}.properties.Date=datestr(FloatData.HIDf.julds(end));
            PosicionBoyas.features{iBoyasDS}.geometry.type='Point';
            PosicionBoyas.features{iBoyasDS}.geometry.coordinates=[lons(end),lats(end)];
        end
    else
        FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
        lats=FloatData.HIDf.lats(end);
        lons=FloatData.HIDf.lons(end);
        ind=find(isnan(lats)==0 & isnan(lons)==0);
        lats=lats(ind);
        lons=lons(ind);
        if ~isempty(lons) && ~isempty(lats)
            iBoyasDS=iBoyasDS+1;
            PosicionBoyas.type='FeatureCollection';
            PosicionBoyas.features{iBoyasDS}.type='Feature';
            PosicionBoyas.features{iBoyasDS}.properties.Icon=2;
            PosicionBoyas.features{iBoyasDS}.properties.WMO=deblank(FloatData.HIDf.platform(end,:));
            PosicionBoyas.features{iBoyasDS}.properties.Description=deblank(FloatData.MTDf.PROJECT_NAME);
            PosicionBoyas.features{iBoyasDS}.properties.Date=datestr(FloatData.HIDf.julds(end));
            PosicionBoyas.features{iBoyasDS}.geometry.type='Point';
            PosicionBoyas.features{iBoyasDS}.geometry.coordinates=[lons(end),lats(end)];
        end
    end
end

%% Escribe los ficheros geojson
TEXT=jsonencode(Trajectory);
fid=fopen(fullfile(OutDir,'TrajectoryDataSet.geojson'),'w');
fprintf(fid,'%s',TEXT);
fclose(fid);

TEXT=jsonencode(PosicionBoyas);
fid=fopen(fullfile(OutDir,'PosicionBoyasDataSet.geojson'),'w');
fprintf(fid,'%s',TEXT);
fclose(fid);

%% Ftp the files
fprintf('     > Uploading  %s \n',fullfile(OutDir,'TrajectoryDataSet.geojson'));
ftpobj=FtpArgoespana;
cd(ftpobj,strcat(ftp_dir_html,'/data'));
mput(ftpobj,fullfile(OutDir,'TrajectoryDataSet.geojson'));

fprintf('     > Uploading  %s \n',fullfile(OutDir,'PosicionBoyasDataSet.geojson'));
ftpobj=FtpArgoespana;
cd(ftpobj,strcat(ftp_dir_html,'/data'));
mput(ftpobj,fullfile(OutDir,'PosicionBoyasDataSet.geojson'));


fprintf('     > Uploading  %s \n',fullfile(OutDir,'SummaryDataSet.txt'));
ftpobj=FtpArgoespana;
cd(ftpobj,strcat(ftp_dir_html,'/data'));
mput(ftpobj,fullfile(OutDir,'SummaryDataSet.txt'));

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

