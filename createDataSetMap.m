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


figure

m_proj('Mollweide','long',[-80 20],'lat',[-70 60]);

    m_coast('patch',[.7 .7 .7],'edgecolor','none'); hold on
m_grid('linestyle',':','fontsize',10)
    

%% Escribo las trajectorias de lasboyas activas
for ifloat=1:size(DataArgoEs.WMO,2)
    MD = createDataSetStatus_FunctionMetadata(DataArgoEs.WMO(ifloat),DirArgoData);
    if DataArgoEs.activa(ifloat)==1
        FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
        lon=FloatData.HIDf.lons;
        lat=FloatData.HIDf.lats;
        julds=FloatData.HIDf.julds;
        %ind=find((julds-(now-TrajectorySpanArgo))>0 & isnan(lon)==0 & isnan(lat)==0);
        %lon=lon(ind);
        %lat=lat(ind);
        fprintf('%d  ACTIVA %7d; %12s; first:%s; last:%s; Age:%s; %s \n',ifloat,MD.WMOFloat,MD.ProjectName,datestr(FloatData.HIDf.julds(1),22),datestr(FloatData.HIDf.julds(end),22),MD.Age,MD.PlatformModel)
            m_plot(lon(end),lat(end),'o','markerfacecolor','b','markeredgecolor','b','markersize',5);
    elseif DataArgoEs.activa(ifloat)==2
        FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
        lon=FloatData.HIDf.lons;
        lat=FloatData.HIDf.lats;
        julds=FloatData.HIDf.julds;
        %ind=find((julds-(now-TrajectorySpanArgo))>0 & isnan(lon)==0 & isnan(lat)==0);
        %lon=lon(ind);
        %lat=lat(ind);
        fprintf('%d INACTIVA %7d; %12s; first:%s; last:%s; Age:%s; %s \n',ifloat,MD.WMOFloat,MD.ProjectName,datestr(FloatData.HIDf.julds(1),22),datestr(FloatData.HIDf.julds(end),22),MD.Age,MD.PlatformModel)
            m_plot(lon(end),lat(end),'o','markerfacecolor','r','markeredgecolor','r','markersize',5);
    end
end


fprintf('%s <<<<< \n',mfilename)

