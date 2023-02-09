load Globales
%Here are the variables used by the different programs

%% Input Directories and files
%Directory that contains the argo float data, and the Argo geo data
DirArgoData=GlobalSU.ArgoData;

%Directory with the geographical data and the floats
DataDirGeo=fullfile(DirArgoData,'geo','atlantic_ocean');
DataDirFloats=fullfile(DirArgoData,'Floats');

%Directory where the matlab scripts than update the Argo web page area
%located
PaginaWebDir=strcat(GlobalSU.ProPath,'/ArgoSpainWebpage');

%Directory with list of floats for each program to monitor
DirFloatLists=strcat(GlobalSU.ProPath,'/ArgoSpainWebpage');

%Climatoly file
ClimatologyFile=strcat(GlobalSU.ProPath,'/ArgoSpainWebpage/data/WOA05.mat');

%% Output Directories and files
%Directory to output the graphic files
DirOutGraph=strcat(PaginaWebDir,'/html/floats');

%Names of the outputs files
FileHtmlArgoEsStatus   = strcat(PaginaWebDir,'/html/','argoesstatusgm.html');
FilellHtmlArgoEsStatus = strcat(PaginaWebDir,'/html/','argoesstatusll.html');
FileTableArgoEsStatus  = strcat(PaginaWebDir,'/html/','argoesstatustable.html');
FilellHtmlArgoIbStatus = strcat(PaginaWebDir,'/html/','argoibstatusll.html');
FileHtmlArgoIbStatus   = strcat(PaginaWebDir,'/html/','argoibstatusgm.html');
FilellHtmlArgoIbStatus = strcat(PaginaWebDir,'/html/','argoibstatusll.html');
FileHtmlArgoStatus     = strcat(PaginaWebDir,'/html/','argoibstatusgmfull.html');


%% General settings
Verbose=0;
Visible=0;      %Flag to outpun in the screen the figures
SubeFTP=1;      %1 to upload from matlab de figures and web page to the ftp.
NumberOfDatSets=[1 2]; %Number of DataSets to monitor
DataSetNameM{1} = 'ArgoSpain'; %Names of the DataSets to monitor
DataSetNameM{2} = 'ArgoInterest';  

%% readArgoSpainData
InterDiasEmision=30; %Dias sin emision a partir de los cuales considero que una boya ha dejado de operar
ForceDataUpdate=1;   %1 to force to re-read the netcdf files

%% createArgoRegionGMap createArgoSpainGMap ArgoStatusGM
%Time interval
FechaI=now-30;
FechaF=now;
TrajectorySpanArgo=180; %en dias

%Geographical Regions
%Region
lat_minIB= 15.00; lat_maxIB=54;
lon_minIB=-45;    lon_maxIB=38;
%Atlantic
lat_min=-65;    lat_max=65;
lon_min=-80;    lon_max=40;

%Google Map createArgoRegionGMap
GMCentroArgoIb=[39,-16];
GMZoomArgoIb=4;
GMTamanoArgoIb=[700,650]; %Ancho,Alto
TituloArgoIbStatus='en las aguas que rodean Espa&ntilde;a';

%Google Map createArgoSpainGMap
GMCentroArgoEs=[20,0];
GMZoomArgoEs=1;
GMTamanoArgoEs=[600,350];

%API key
%GoogleMapsAPIKey

%% ArgoEsStatusGraficos
POSBorder=2;  %Margen [en grados] adicional para el mapa de la trayectoria
DiasAnalisis=1.1; %Days to look for to update the figures

%% About sending reports
sendEmail=0;