function [FileOutA,FileOutAz,FileOutB,FileOutC]=createArgoSpainStatus_Figures(WMO,GlobalDS)

if nargin==1
    GlobalDS.Regionnombre{1}='GLOB';
    GlobalDS.RegionnombreLargo{1}='Global';
    GlobalDS.RegionmaxAT(1)=28;
    GlobalDS.RegionminAT(1)=2;
    GlobalDS.RegionmaxAS(1)=38.8;
    GlobalDS.RegionminAS(1)=34;
    GlobalDS.RegionmaxAO(1)=400;
    GlobalDS.RegionminAO(1)=50;
    GlobalDS.RegionmaxAP(1)=2000;
    GlobalDS.RegionLonLimits{1}=[0 0 360 0];
    GlobalDS.RegionLatLimits{1}=[90 -90 -90 90];
    GlobalDS.POSBorder=2;
    GlobalDS.Visible=1;
    GlobalDS.DirOutGraph='./html/floats';
    GlobalDS.DirArgoData='/Users/pvb/Dropbox/Oceanografia/Data/Argo';
end

%load data
fileFloat=fullfile(GlobalDS.DirArgoData,'Floats',num2str(WMO));
FloatData=load(fileFloat);
OneFloatData.julds=FloatData.HIDf.julds;
OneFloatData.lons=FloatData.HIDf.lons;
OneFloatData.lats=FloatData.HIDf.lats;
OneFloatData.pres=FloatData.HIDf.pres;
OneFloatData.tems=FloatData.HIDf.tems;
OneFloatData.sals=FloatData.HIDf.sals;
OneFloatData.ptms=FloatData.HIDf.ptems;
if isfield(FloatData.HIDf,'oxys') == 1
    if ~isempty(FloatData.HIDf.oxys)
        OneFloatData.oxys=FloatData.HIDf.oxys;
    end
end

%load CTD data if exist
fileCTD0=fullfile(GlobalDS.DirArgoData,'Floats','CTD',strcat(num2str(WMO),'CTD0.mat'));
if exist(fileCTD0,'file')==2
    fprintf('load CTD file, ')
    OneFloatData.CTD0=load(fileCTD0);
end

%Geographical limits
Limits.lat_min=nanmin(OneFloatData.lats);  Limits.lat_max=nanmax(OneFloatData.lats);
Limits.lon_min=nanmin(OneFloatData.lons);  Limits.lon_max=nanmax(OneFloatData.lons);
%Region
iRegion=1;
for ii=size(GlobalDS.Regionnombre,2)
    if inpolygon(Limits.lon_min,Limits.lat_min,GlobalDS.RegionLonLimits{ii},GlobalDS.RegionLatLimits{ii}) == 1 && inpolygon(Limits.lon_max,Limits.lat_max,GlobalDS.RegionLonLimits{ii},GlobalDS.RegionLatLimits{ii}) == 1
        iRegion=ii;
    end
end
Limits.lat_min=nanmin(OneFloatData.lats)-GlobalDS.POSBorder;  Limits.lat_max=nanmax(OneFloatData.lats)+GlobalDS.POSBorder;
Limits.lon_min=nanmin(OneFloatData.lons)-GlobalDS.POSBorder;  Limits.lon_max=nanmax(OneFloatData.lons)+GlobalDS.POSBorder;

%JulD
Limits.maxJ=nanmax(OneFloatData.julds(:))+5;
Limits.minJ=nanmin(OneFloatData.julds(:))-5;

%Pressure
Limits.maxP=ceil(nanmax(OneFloatData.pres(:))+.5);
if Limits.maxP>GlobalDS.RegionmaxAP(iRegion) || isnan(Limits.maxP) == 1 || Limits.maxP<1000
    Limits.maxP=GlobalDS.RegionmaxAP(iRegion);
end
if FloatData.WMOf==6901246 || FloatData.WMOf==6901248 || FloatData.WMOf==3902126
    %Deep Argo
    Limits.maxP=4000;
end
if FloatData.WMOf==4902321 || FloatData.WMOf==4902322 || FloatData.WMOf==4902323 || FloatData.WMOf==4902324 || FloatData.WMOf==4902325 || FloatData.WMOf==4902326
    %Deep Argo
    Limits.maxP=6000;
end


%Limites en presion de las secciones
Limits.UpperPL=[-300 0];
Limits.DeepPL=[-Limits.maxP Limits.UpperPL(1)-1];
if  iRegion == 3
    Limits.UpperPL=[-150 0];
    Limits.DeepPL=[-700 Limits.UpperPL(1)-1];
end

%Temperature
Limits.maxT=nanmax(OneFloatData.tems(:))+.5;
if Limits.maxT>GlobalDS.RegionmaxAT(iRegion) || isnan(Limits.maxT) == 1
    Limits.maxT=GlobalDS.RegionmaxAT(iRegion);
end
Limits.minT=nanmin(OneFloatData.tems(:))-.5;
if Limits.minT<GlobalDS.RegionminAT(iRegion) || isnan(Limits.minT) == 1
    Limits. minT=GlobalDS.RegionminAT(iRegion);
end

%Salinity
Limits.maxS=nanmax(OneFloatData.sals(:))+0.1;
if Limits.maxS>GlobalDS.RegionmaxAS(iRegion) || isnan(Limits.maxS) == 1
    Limits.maxS=GlobalDS.RegionmaxAS(iRegion);
end
Limits.minS=nanmin(OneFloatData.sals(:))-0.1;

if Limits.minS<GlobalDS.RegionminAS(iRegion) || isnan(Limits.minS) == 1
    Limits.minS=GlobalDS.RegionminAS(iRegion);
    if Limits.minS>GlobalDS.RegionmaxAS(iRegion)
        Limits.minS=GlobalDS.RegionmaxAS(iRegion)-1;
    end
end

%Oxygen
if isfield(FloatData.HIDf,'oxys') == 1
    if ~isempty(FloatData.HIDf.oxys)
        Limits.maxO=nanmax(OneFloatData.oxys(:))+10;
        if Limits.maxO>GlobalDS.RegionmaxAO(iRegion) || isnan(Limits.maxO) == 1
            Limits.maxO=GlobalDS.RegionmaxAO(iRegion);
        end
        Limits.minO=nanmin(OneFloatData.oxys(:))-10;
        if  Limits.minO<GlobalDS.RegionminAO(iRegion) || isnan( Limits.minO) == 1
            Limits.minO=GlobalDS.RegionminAO(iRegion);
        end
    end
end

%% FigureA - Map of trajectories, TS Diagram, T, S and O perfiles
hTraPosition=[0.05 0.54 0.38 0.38];
hTSPosition=[0.50 0.54 0.42 0.42];

figureA=figure('visible','off','clipping','on');
if GlobalDS.Visible==1
    set(gcf,'visible','on')
end
createArgoSpainStatus_FunctionTrajectory(OneFloatData,GlobalDS,Limits,hTraPosition);
createArgoSpainStatus_FunctionTS(OneFloatData,GlobalDS,Limits,hTSPosition);
createArgoSpainStatus_FunctionProfiles(OneFloatData,Limits);
FileOutA=sprintf('%s/%sA.png',GlobalDS.DirOutGraph,deblank(num2str(FloatData.WMOf)));
orient portrait;print(gcf,'-dpng',FileOutA)

%Map of trajectories_Zoom
figureA_Zoom=figure('visible','off','clipping','on');
if GlobalDS.Visible==1
    set(gcf,'visible','on')
end
createArgoSpainStatus_FunctionTrajectoryZoom(OneFloatData,GlobalDS,Limits);
FileOutAz=sprintf('%s/%sA_Zoom.png',GlobalDS.DirOutGraph,deblank(num2str(FloatData.WMOf)));
orient portrait;print(gcf,'-dpng',FileOutAz)

%% FigureB - Vertical Sections
figureB=figure('visible','off');
if GlobalDS.Visible==1
    set(gcf,'visible','on')
end
createArgoSpainStatus_FunctionSections(OneFloatData,Limits);
FileOutB=sprintf('%s/%sB.png',GlobalDS.DirOutGraph,deblank(num2str(FloatData.WMOf)));
orient portrait;print(gcf,'-dpng',FileOutB)

%% FigureC - Technical data
figure03=figure('visible','off');
if GlobalDS.Visible==1
    set(gcf,'visible','on')
end
createArgoSpainStatus_FunctionTechnicalData
FileOutC=sprintf('%s/%sC.png',GlobalDS.DirOutGraph,deblank(num2str(FloatData.WMOf)));
orient portrait;print(gcf,'-dpng',FileOutC)
if GlobalDS.Visible==0
    close all
end
