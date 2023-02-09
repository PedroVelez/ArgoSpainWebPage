%Read the data from the Argo Spaon data set
clear all;close all

%% Read configuration
ArgoEsOpciones

% NumberOfDatSets=[1 2]; %Number of DataSets to monitor
% DataSetNameM=['ArgoEs';'ArgoIn'];
% DataDirFloats=' ... /Argo/Floats';
% DirFloatLists='... /Programas/Argo/GetData';

%% Inicio
fprintf('>>>>> %s\n',mfilename)
for NumDatSet=NumberOfDatSets
    DataSetName=DataSetNameM(NumDatSet,:);
    
    %Reading floats in the DataSet
    fprintf('   >> Reading %s\n',DataSetName)
    i1=0;
    boyasDataSet=[];
    fid=fopen(strcat(DirFloatLists,'/Floats',DataSetName,'.dat'));
    while feof(fid)==0
        linea=fgetl(fid);
        DACDSt=linea(1:strfind(linea,'/')-1);
        boyasDSt=str2double(linea(strfind(linea,'/')+1:end));
        if  exist(sprintf('%s/%07d',DataDirFloats,boyasDSt),'file')
            FloatData=load(sprintf('%s/%07d',DataDirFloats,boyasDSt),'FechaUltimoPerfilf');
            fprintf('%s/%07d %s %s.\n',DACDSt,boyasDSt,datestr(FloatData.FechaUltimoPerfilf),DataSetName);
        else
            fprintf('%s/%07d %s.\n',DACDSt,boyasDSt,DataSetName);
        end
    end
    
    %           
end
fprintf('    > %s <<<<< \n',mfilename)
