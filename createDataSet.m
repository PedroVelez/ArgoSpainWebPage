% Read the data from the Argo Spaon data set
clear all;close all

%% Read configuration
configWebPage

% Verbose=1;
% InterDiasEmision=30;  % Dias sin emision a partir de los cuales una boya ha dejado de operar
% NumberOfDatSets=[1 2]; %Number of DataSets to monitor
% DataSetNameM=['ArgoEs';'ArgoIn']; % Names of the DataSets to monitor
% DataDirFloats=' ... /Argo/Floats'; % Directory with the geographical data and the floats
% DirFloatLists='... /Programas/Argo/GetData'; % Directory with list of floats for each program to monitor
% ForceDataUpdate=1; % Flag to force to re-read the netcdf files

%% Inicio
fprintf('>>>>> %s\n',mfilename)
for NumDatSet = NumberOfDatSets
    DataSetName = DataSetNameM{NumDatSet};
    
    %Reading floats in the DataSet
    fprintf('     > Reading %s\n',DataSetName)
    i1 = 0;
    boyasDataSet = [];
    fprintf('     > Reading %s\n',strcat(DirFloatLists,'/floats',DataSetName,'.dat'))
    fid = fopen(strcat(DirFloatLists,'/floats',DataSetName,'.dat'));
    while feof(fid) == 0
        linea=  fgetl(fid);
        boyasDSt=str2double(linea(strfind(linea,'/')+1:end));
        fileM=sprintf('%s/%07d/%07d_meta.nc',DataDirFloats,boyasDSt,boyasDSt);
        fileTe=sprintf('%s/%07d/%07d_tech.nc',DataDirFloats,boyasDSt,boyasDSt);
        if exist(fileM,'file')>0 && exist(fileTe,'file')>0
            i1=i1+1;
            boyasDataSet(i1) = boyasDSt;
        end
    end
    
    %Read data
    Age=boyasDataSet.*0;
    ibData=0;
    for ibO=1:size(boyasDataSet,2)
        fileT = sprintf('%s/%07d/%07d_Rtraj.nc',DataDirFloats,boyasDataSet(ibO),boyasDataSet(ibO));
        fileM = sprintf('%s/%07d/%07d_meta.nc',DataDirFloats,boyasDataSet(ibO),boyasDataSet(ibO));
        fileTe = sprintf('%s/%07d/%07d_tech.nc',DataDirFloats,boyasDataSet(ibO),boyasDataSet(ibO));
        fileHi = sprintf('%s/%07d/profiles/',DataDirFloats,boyasDataSet(ibO));
        %Verifica si hay un .mat reciente con los datos
        ReadNCData = 1;
        if  exist(sprintf('%s/%07d.mat',DataDirFloats,boyasDataSet(ibO)),'file')==2 && ForceDataUpdate==0
            FloatData = load(sprintf('%s/%07d',DataDirFloats,boyasDataSet(ibO)),'FechaUltimoPerfilf');
            FechaUltimoPerfilMat=FloatData.FechaUltimoPerfilf;
            if (now-FloatData.FechaUltimoPerfilf)>4*InterDiasEmision
                ReadNCData=0;
            end
        end
        
        %Lee data nuevamente si existen los ficheros de datos y no existe
        %un mat con datos recientes
        if  exist(sprintf('%s/%07d',DataDirFloats,boyasDataSet(ibO)),'file') && ForceDataUpdate==0 && ReadNCData==0
            fprintf('     > %07d mat file %s, ',boyasDataSet(ibO),DataSetName);
            ibData=ibData+1;
            FloatData =load(sprintf('%s/%07d',DataDirFloats,boyasDataSet(ibO)));
            WMO(ibData) = FloatData.WMOf;
            HID{ibData} = FloatData.HIDf;
            MTD{ibData} = FloatData.MTDf;
            TED{ibData} = FloatData.TEDf;
            TRD{ibData} = FloatData.TRDf;
            FechaUltimoPerfil(ibData)=FloatData.FechaUltimoPerfilf;
            FechaPrimerPerfil(ibData)=FloatData.FechaPrimerPerfilf;
            UltimoVoltaje(ibData)=FloatData.UltimoVoltajef;
            UltimoSurfaceOffset(ibData)=FloatData.UltimoSurfaceOffsetf;
            Age(ibData)=FloatData.Agef;
            activa(ibData)=2;
            fprintf('last profile %s\n',datestr(nanmax(HID{ibData}.julds)))
        elseif exist(fileM,'file')>0 && exist(fileTe,'file')>0 && exist(fileHi,'file')>0
            try
                Profs=readArgoFloatProfilesDM(fileHi,Verbose);
                fprintf('     >> Updating %07d  with nc file %s, ',boyasDataSet(ibO),DataSetName);
                ibData=ibData+1;
                WMO(ibData) = boyasDataSet(ibO);
                activa(ibData) = 2; %No esta activa pero tiene datos
                MTD{ibData} = readArgoMetaFile(fileM);
                try
                    TED{ibData} = readArgoTechFile(fileTe);
                catch ME
                    TED{ibData}=[];
                    fprintf('>>>>>> Problem with techincal files for %07d  with nc file %s. ', ...
                        boyasDataSet(ibO),DataSetName);
                end
                if exist(fileT,'file')>0
                    try
                        TRD{ibData} = ReadArgoTrayectoryFile(fileT);
                    catch ME
                        fprintf('>>>>>> Problem with Trayectory files for %07d  with nc file %s. ', ...
                            boyasDataSet(ibO),DataSetName);
                        TRD{ibData}=[];
                    end
                else
                    TRD{ibData}=[];
                end
                HID{ibData}.platform=[Profs.platform_number]';
                HID{ibData}.julds=[Profs.juld_matlab];
                HID{ibData}.lats=[Profs.latitude];
                HID{ibData}.lons=[Profs.longitude];
                HID{ibData}.cycle=[Profs.cycle_number]';
                pres=double(Profs(1).pres');
                sals=double(Profs(1).psal');
                tems=double(Profs(1).temp');
                for i2=2:1:size(Profs,2)
                    pres=merge(pres,double(Profs(i2).pres'));
                    tems=merge(tems,double(Profs(i2).temp'));
                    sals=merge(sals,double(Profs(i2).psal'));
                end
                if isfield(Profs,'doxy') == 1
                    oxys=double(Profs(1).doxy');
                    for i2=2:1:size(Profs,2)
                        oxys=merge(oxys,double(Profs(i2).doxy'));
                    end
                    HID{ibData}.oxys=oxys;
                end
                HID{ibData}.pres=pres;
                HID{ibData}.tems=tems;
                HID{ibData}.sals=sals;
                HID{ibData}.nprof=size(Profs);
                
                FechaUltimoPerfil(ibData)=HID{ibData}.julds(end);
                FechaPrimerPerfil(ibData)=HID{ibData}.julds(1);
                Age(ibData)=(FechaUltimoPerfil(ibData)-FechaPrimerPerfil(ibData))/365;
                %Boyas Acticas
                if max(HID{ibData}.julds) > (now-InterDiasEmision) %Solo actualizo las boyas nuevas
                    activa(ibData)=1;
                end
                fprintf('last profile %s\n',datestr(HID{ibData}.julds(end)))
                
                %VoltageFinal
                if isfield(TED{ibData},'VOLTAGE_BatteryParkEnd_VOLTS')==1
                    UltimoVoltaje(ibData)=TED{ibData}.VOLTAGE_BatteryParkEnd_VOLTS(end);
                else
                    UltimoVoltaje(ibData)=NaN;
                end
                
                %SurfaceOffsetFinal
                if isfield(TED{ibData},'PRES_SurfaceOffsetTruncatedplus5dBar_dBAR')==1
                    UltimoSurfaceOffset(ibData)=TED{ibData}.PRES_SurfaceOffsetTruncatedplus5dBar_dBAR(end)-5;
                elseif isfield(TED{ibData},'PRES_SurfaceOffsetNotTruncated_dBAR')==1
                    UltimoSurfaceOffset(ibData)=TED{ibData}.PRES_SurfaceOffsetNotTruncated_dBAR(end);
                else
                    UltimoSurfaceOffset(ibData)=NaN;
                end
                
                %Calculo variables derivadas
                HID{ibData}.ptems=sw_ptmp(HID{ibData}.sals,HID{ibData}.tems,HID{ibData}.pres,0);
                HID{ibData}.pdens=sw_pden(HID{ibData}.sals,HID{ibData}.tems,HID{ibData}.pres,0);
                
                %Grabo los datos de cada boya por separado
                WMOf=WMO(ibData);
                HIDf=HID{ibData};
                MTDf=MTD{ibData};
                TEDf=TED{ibData};
                TRDf=TRD{ibData};
                FechaUltimoPerfilf=FechaUltimoPerfil(ibData);
                FechaPrimerPerfilf=FechaPrimerPerfil(ibData);
                UltimoVoltajef=UltimoVoltaje(ibData);
                UltimoSurfaceOffsetf=UltimoSurfaceOffset(ibData);
                Agef=Age(ibData);
                save(sprintf('%s/%07d',DataDirFloats,WMOf),'HIDf','TRDf','TEDf','MTDf','WMOf', ...
                    'FechaUltimoPerfilf','FechaPrimerPerfilf', ...
                    'UltimoVoltajef','UltimoSurfaceOffsetf','Agef');
            catch ME
                fprintf('>>>>>> Problem with profile files for %07d  with nc file %s.\n ', ...
                    boyasDataSet(ibO),DataSetName);
            end
            
        end
    end
    
    % Ordeno por ultimo perfil
    [FechaUltimoPerfil,IndiceOrdena] = sort(FechaUltimoPerfil,'descend');
    WMO = WMO(IndiceOrdena);
    activa = activa(IndiceOrdena);
    UltimoVoltaje = UltimoVoltaje(IndiceOrdena);
    UltimoSurfaceOffset = UltimoSurfaceOffset(IndiceOrdena);
    FechaPrimerPerfil = FechaPrimerPerfil(IndiceOrdena);
    Age = Age(IndiceOrdena);
    UltimoVoltaje(UltimoVoltaje == 0) = NaN;
    iactiva =length(find(activa == 1));
    iinactiva =length(find(activa == 2));
    inodesplegada =length(find(activa == 0));
    fprintf('     > Writing %s\n',DataSetName)
    
    %Saving the data
    save(strcat(PaginaWebDir,'/data/data',DataSetName),'WMO','activa','FechaUltimoPerfil', ...
        'FechaPrimerPerfil','InterDiasEmision','UltimoVoltaje','UltimoSurfaceOffset','iactiva', ...
        'iinactiva','inodesplegada','Age')
    clear HID TRD TED MTD WMO activa FechaUltimoPerfil FechaPrimerPerfil UltimoVoltaje
    clear UltimoSurfaceOffset iactiva iinactiva inodesplegada Age boyasAS ib
end
fprintf('%s <<<<< \n',mfilename)
