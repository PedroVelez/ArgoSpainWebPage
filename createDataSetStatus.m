clear all;close all
%Este script crea una serie de datos y graficos para topdas las boyas del
%programa Argo Espana y Argo Interest

%% Read configuration
configWebPage
%Visible=1;
%POSBorder=2;  %Margen adicional para el mapa de la trayectoria
%DiasAnalisis=11
%ClimatologyFile='./Data/WOA05.mat';
%SubeFTP=0;

%Configuraciones
GlobalDS.Visible=Visible;
GlobalDS.DirOutGraph=DirOutGraph;
GlobalDS.DirOutGraph=DirOutGraph;
GlobalDS.DirArgoData=DirArgoData;

%Coast and Batimetry
GlobalDS.filecoast='./data/SpainCoast.mat';% Fichero con la costa de la zona
GlobalDS.filebat='./data/SpainBat.mat';TMP=load(GlobalDS.filebat);
GlobalDS.batylon=TMP.batylon;
GlobalDS.batylat=TMP.batylat;
GlobalDS.elevations=TMP.elevations;clear TMP
GlobalDS.POSBorder=POSBorder;

GlobalDS.Wfilecoast='./data/WorldOceanCoast.mat';% Fichero con la costa de la zona
GlobalDS.Wfilebat='./data/WorldOceanBat.mat';TMP=load(GlobalDS.Wfilebat);
GlobalDS.Wbatylon=TMP.batylon;
GlobalDS.Wbatylat=TMP.batylat;
GlobalDS.Welevations=TMP.elevations;clear TMP

%Climatology
GlobalDS.CLIFile=ClimatologyFile;
GlobalDS.Cli=load(GlobalDS.CLIFile);

%Configuration for Geographical Regions
GlobalDS.Region=[1,2,3];
GlobalDS.Regionnombre{1}='GLOB';
GlobalDS.RegionnombreLargo{1}='Global';
GlobalDS.RegionmaxAT(1)=28;
GlobalDS.RegionminAT(1)=-20;
GlobalDS.RegionmaxAS(1)=38.8;
GlobalDS.RegionminAS(1)=34;
GlobalDS.RegionmaxAO(1)=400;
GlobalDS.RegionminAO(1)=50;
GlobalDS.RegionmaxAP(1)=2000;

GlobalDS.Regionnombre{2}='ATNO';
GlobalDS.RegionnombreLargo{2}='Atlantico nor-oriental';
GlobalDS.RegionLonLimits{2}=[-45 -5.30 -5.30 0 10 -45 -45];
GlobalDS.RegionLatLimits{2}=[16 16 36 43 50 50 16];
GlobalDS.RegionmaxAT(2)=28;
GlobalDS.RegionminAT(2)=2;
GlobalDS.RegionmaxAS(2)=38.8;
GlobalDS.RegionminAS(2)=34;
GlobalDS.RegionmaxAO(2)=400;
GlobalDS.RegionminAO(2)=50;
GlobalDS.RegionmaxAP(2)=2000;

GlobalDS.Regionnombre{3}='MEDO';
GlobalDS.RegionnombreLargo{3}='Mediterranero Occidental';
GlobalDS.RegionLonLimits{3}=[-5.30 10 10 0 -5.30];
GlobalDS.RegionLatLimits{3}=[33.00 33.00 46 46 33.00];
GlobalDS.RegionmaxAT(3)=28;
GlobalDS.RegionminAT(3)=11;
GlobalDS.RegionmaxAS(3)=38.8;
GlobalDS.RegionminAS(3)=36;
GlobalDS.RegionmaxAO(3)=400;
GlobalDS.RegionminAO(3)=50;
GlobalDS.RegionmaxAP(3)=700;

%% Inicio
fprintf('>>>>> %s\n',mfilename)
for NumDatSet = NumberOfDatSets
    DataSetName = DataSetNameM{NumDatSet};
    DataArgoEs = load(strcat(PaginaWebDir,'/data/data',DataSetName,'.mat'),'WMO','activa','iactiva','FechaUltimoPerfil','UltimoVoltaje');
    fprintf('     >> Dataset %s\n',DataSetName)
    
    if SubeFTP == 1
        ftpobj=FtpArgoespana;
        cd(ftpobj,ftp_dir);
    end
    
    %Figures and web page for each active float
    for ifloat = 1:1:size(DataArgoEs.WMO,2)
        if DataArgoEs.FechaUltimoPerfil(ifloat)>now-DiasAnalisis && DataArgoEs.activa(ifloat)>=1
            fprintf('     \n> WMO %d (%d of %d) ',DataArgoEs.WMO(ifloat),ifloat,size(DataArgoEs.WMO,2))
            [FileOutA,FileOutAz,FileOutB,FileOutC] = createDataSetStatus_FunctionFigures(DataArgoEs.WMO(ifloat),GlobalDS);
            FileOutFHtml = createDataSetStatus_FunctionWebPage(DataArgoEs.WMO(ifloat),GlobalDS);
            if SubeFTP == 1
                fprintf('uploading files to ftp.\n')
                binary(ftpobj)
                
                mput(ftpobj,FileOutA);
                mput(ftpobj,FileOutAz);
                mput(ftpobj,FileOutB);
                mput(ftpobj,FileOutC);
                ascii(ftpobj)
                mput(ftpobj,FileOutFHtml);
            end
        end
    end
    if SubeFTP == 1
        close(ftpobj)
    end
    %Report for each dataset
    createDataSetStatus_FunctionReport
end
fprintf('      %s <<<<< \n',mfilename)
