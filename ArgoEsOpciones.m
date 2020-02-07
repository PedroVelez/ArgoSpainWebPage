% ArgoEsOpciones
% Here are the variables used by the different programs

%% Input Directories and files
%Directory that contains the argo float data, and the Argo geo data
DirArgoData=strcat(getenv('HOME'),'/Dropbox/Oceanografia/Data/Argo');

%Directory with the geographical data and the floats
DataDirGeo=fullfile(DirArgoData,'geo','atlantic_ocean');
DataDirFloats=fullfile(DirArgoData,'Floats');

%Directory where the matlab scripts than update the Argo web page area
%located
PaginaWebDir=strcat(getenv('HOME'),'/Dropbox/Oceanografia/Proyectos/PaginaWebArgoEs');

%Directory with list of floats for each national program to monitor
DirFloatLists=strcat(getenv('HOME'),'/Dropbox/Oceanografia/Proyectos/PaginaWebArgoEs');

%Climatolyfile
ClimatologyFile=strcat(getenv('HOME'),'/Dropbox/Oceanografia/Proyectos/PaginaWebArgoEs/Data/WOA05.mat');

%% Output Directories and files
%Directory to output the graphic files
DirOutGraph=strcat(PaginaWebDir,'/Html/ArgoEsGraficos');

%Names of the outputs files
FileHtmlArgoEsStatus=strcat(PaginaWebDir,'/Html/','argoesstatusgm.html');
FileHtmlArgoIbStatus=strcat(PaginaWebDir,'/Html/','argoibstatusgm.html');
FileHtmlArgoStatus=strcat(PaginaWebDir,'/Html/','ArgoStatus.html');

%% General settings
Verbose=0;
Visible=0;      %Flag to outpun in the screen the figures
SubeFTP=1;      %1 to upload from matlab de figures and web page to the ftp.
NumberOfDatSets=[1 2]; %Number of DataSets to monitor
DataSetNameM=['ArgoEs';'ArgoIn'];  %Names of the DataSets to monitor

%% ArgoEsLeeDatos
InterDiasEmision=30; %Dias sin emision a partir de los cuales considero que una boya ha dejado de operar
ForceDataUpdate=0;   %1 to force to re-read the netcdf files

%% ArgoIbStatusGM ArgoEsStatusGM ArgoStatusGM
%Time interval
FechaI=now-30;
FechaF=now;
TrajectorySpanArgo=180; %en dias

%Geographical Regions
%Area de influencia espanola
lat_minIB= 15.00; lat_maxIB=54;
lon_minIB=-45;    lon_maxIB=38;
%Atlantico
lat_min=-65;    lat_max=65;
lon_min=-80;    lon_max=40;

%Google Map ArgoIB
GMCentroArgoIb=[39,-16];
GMZoomArgoIb=4;
GMTamanoArgoIb=[700,650]; %Ancho,Alto
TituloArgoIbStatus='en las aguas que rodean Espa&ntilde;a';

%Google Map ArgoEsStatusGM
GMCentroArgoEs=[30,-16];
GMZoomArgoEs=1;
GMTamanoArgoEs=[800,390];

%API key
GoogleMapsAPIKey

%% ArgoEsStatusGraficos
POSBorder=2;  %Margen [en grados] adicional para el mapa de la trayectoria
DiasAnalisis=10.0; %Days to look for to update the figures
