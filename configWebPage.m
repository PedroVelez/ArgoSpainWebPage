load Globales
% Here are the variables used by the different programs

%% General settings
domainName='https://www.argoespana.es';
RegionNameS='Ib';
RegionNameL='Cuenca Iberica-Canaria';
DataSetNameM{1} = 'ArgoSpain'; %Names of the DataSets to monitor
DataSetNameM{2} = 'ArgoInterest';  
Verbose=0;
Visible=0;      %Flag to output the figures on the screen
SubeFTP=1;      %1 to upload from matlab the figures and web page to the ftp.
NumberOfDatSets=[1 2]; %Number of DataSets to monitor

%% Input Directories and files
% Directory that contains the argo float data, and the Argo geo data
DirArgoData=GlobalSU.ArgoData;
DataDirGeo=fullfile(DirArgoData,'geo','atlantic_ocean');
DataDirFloats=fullfile(DirArgoData,'Floats');

% Directory where the matlab scripts that update the Argo web page are
% located
PaginaWebDir=strcat(GlobalSU.ProPath,'/ArgoSpainWebpage');

% Directory with list of floats for each program to monitor
DirFloatLists=strcat(GlobalSU.ProPath,'/ArgoSpainWebpage');

%% Climatology file
ClimatologyFile=strcat(GlobalSU.ProPath,'/ArgoSpainWebpage/data/WOA05.mat');

%% Output Directories and files
% Directory to output the graphic files
DirOutGraph=strcat(PaginaWebDir,'/html/floats');

% Names of the outputs files
FileHtmlRegionStatus = strcat(PaginaWebDir,'/html/','argoregionstatus.html');
FileHtmlArgoEsStatus = strcat(PaginaWebDir,'/html/','argoesstatus.html');
%FileTableArgoEsStatus  = strcat(PaginaWebDir,'/html/','argoesstatustable.html');
FileTableArgoEsSummary  = strcat(PaginaWebDir,'/html/','argoessummary.html');

%% createDataSet
InterDiasEmision=60; %Dias sin emision a partir de los cuales considero que una boya ha dejado de operar
InterDiasEmisionPolar=200; %Idem para boyas polares (pueden pasar meses bajo el hielo)
LatitudPolar=58;     %Boyas con ultimo perfil al sur de -LatitudPolar o al norte de LatitudPolar se consideran polares
ForceDataUpdate=1;   %1 to force to re-read the netcdf files

%% createRegionLLet
%Time interval
FechaI=now-60;
FechaF=now;
TrajectorySpanArgo=90; %en dias

%Geographical Region
%Region
lat_minIB= 15.00; lat_maxIB=54;
lon_minIB=-45;    lon_maxIB=38;
%Atlantic
lat_min=-65;    lat_max=65;
lon_min=-80;    lon_max=40;

%Map createArgoRegionMap
MCentroArgoIb=[39,-16];
MZoomArgoIb=4;
MTamanoArgoIb=[100,100]; %Ancho,Alto

%Map createArgoSpainGMap
MCentroArgoEs=[35,+5];
MZoomArgoEs=2;
MTamanoArgoEs=[400,400];

%% Ftp
ftp_dir='/html/float';
ftp_dir_html='/html';

%% StatusGraficos
POSBorder=2;  %Margen [en grados] adicional para el mapa de la trayectoria
DiasAnalisisPolar=200; %Days to look for to update the figures (polar floats)
DiasAnalisis=1.2; %Days to look for to update the figures

%% About sending reports
sendEmail=1;
