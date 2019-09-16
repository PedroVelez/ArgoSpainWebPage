function [platform,daynum,lats,lons,pres,sals,tems,stapar,project,cycle,nprof,nparam,info]=ReadArgoDailyFileDM(file,Verbose)
if nargin<2
    Verbose=1;
end

ncid=netcdf.open(file,'nc_nowrite');
platform=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PLATFORM_NUMBER'))';
t=str2num(platform);
if isempty(t)==0
    [~,nprof]=netcdf.inqDim(ncid,netcdf.inqDimID(ncid,'N_PROF'));
    [~,nparam]=netcdf.inqDim(ncid,netcdf.inqDimID(ncid,'N_PARAM'));
    daynumr=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'DATE_CREATION'));
    DATE_CREATION=datenum(str2double(daynumr(1:4)),str2double(daynumr(5:6)),str2double(daynumr(7:8)));
    daynumr=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'DATE_UPDATE'));
    DATE_UPDATE=datenum(str2double(daynumr(1:4)),str2double(daynumr(5:6)),str2double(daynumr(7:8)));
    
    if Verbose==1
        fprintf('    > %s with %d profiles Created %s and updated %s\n',file(max(findstr(file,'/'))+1:end-3),nprof,datestr(DATE_CREATION),datestr(DATE_UPDATE))
    end
    
    project= netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PROJECT_NAME'))';
    cycle= netcdf.getVar(ncid,netcdf.inqVarID(ncid,'CYCLE_NUMBER'));
    daynumr=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'REFERENCE_DATE_TIME'));
    timeref=datenum(str2double(daynumr(1:4)),str2double(daynumr(5:6)),str2double(daynumr(7:8)));
    daynum=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'JULD'))+timeref;
    stapar=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'STATION_PARAMETERS'));
    info.datamode=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'DATA_MODE'));
    info.datacentre=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'DATA_CENTRE'))';
    info.wmo_inst_type=str2num(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'WMO_INST_TYPE'))');
    
    ipsal=0;
    itemp=0;
    if nparam>=3
        ipsal=1;
        itemp=1;
    elseif nparam>=2
        itemp=1;
    end
    lats=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'LATITUDE'));
    lons=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'LONGITUDE'));
    positionqc=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'POSITION_QC'));
    pres=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PRES'))';
    presqc=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PRES_QC'))';
    pres_ad=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PRES_ADJUSTED'))'; %Valores ajustado en DM
    pres_adqc=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PRES_ADJUSTED_QC'))';
    if itemp==1
        tems=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'TEMP'))';
        temsqc=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'TEMP_QC'))';
        tems_ad=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'TEMP_ADJUSTED'))';
        tems_adqc=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'TEMP_ADJUSTED_QC'))';
    else
        tems=pres.*NaN;
        temsqc=pres.*NaN;
        tems_ad=pres.*NaN;
        tems_adqc=pres.*NaN;
    end
    if ipsal==1
        sals=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PSAL'))';
        salsqc=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PSAL_QC'))';
        sals_ad=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PSAL_ADJUSTED'))';
        sals_adqc=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PSAL_ADJUSTED_QC'))';
    else
        sals=pres.*NaN;
        salqc=pres.*NaN;
        sals_ad=pres.*NaN;
        sals_adqc=pres.*NaN;
    end
    netcdf.close(ncid);
    %Argo Quality Control Manual
    %http://www.coriolis.eu.org/cdc/argo/argo-quality-control-manual.pdf
    %Argo user manual
    %http://www.usgodae.org/argo/argo-dm-user-manual.pdf
    %Real Time QC used to NaN values
    %QC=0 No QC was performed
    %QC=3 An adjustment has been applied, but the value may still be bad.
    %Test 15 or Test 16 or Test 17 failed and all other real-time QC tests
    %passed. These data are not to be used without scientific correction.
    %A flag ‘3’ may be assigned by an operator during additional visual QC for
    %bad data that may be corrected in delayed mode.
    %QC=4 Bad data. Not adjustable.
    %Data have failed one or more of the real-time QC tests, excluding Test 16.
    %A flag ‘4’ may be assigned by an operator during additional visual QC for
    %bad data that are not correctable
    %QC=9 Missing value
    pres(presqc=='0' | presqc=='3' | presqc=='4' |  presqc=='9')=NaN; %Bad data
    if itemp==1
        tems(temsqc=='0' | temsqc=='3' | temsqc=='4' | temsqc=='9')=NaN; %Bad data
    end
    if ipsal==1
        sals(salsqc=='0' | salsqc=='3' | salsqc=='4' | salsqc=='9')=NaN; %Bad data
    end
    %Delayed Mode QC used to NaN values
    %QC=0 No QC was performed
    %QC=3 An adjustment has been applied, but the value may still be
    %bad..(I keep this data!!)s
    %QC=4 Bad data. Not adjustable.
    %QC=9 Missing value
    pres_ad(pres_adqc=='4' | pres_adqc=='9')=NaN; %Bad data
    tems_ad(tems_adqc=='4' | tems_adqc=='9')=NaN; %Bad data
    if ipsal==1
        sals_ad(sals_adqc=='4' | sals_adqc=='9')=NaN; %Bad data
    end
    %Change absent data by Nan
    pres(pres==99999)=NaN;
    tems(tems==99999)=NaN;
    sals(sals==99999)=NaN;
    pres_ad(pres_ad==99999)=NaN;
    tems_ad(tems_ad==99999)=NaN;
    sals_ad(sals_ad==99999)=NaN;
    lats(lats==99999 | lats==-99999)=NaN;
    lons(lons==99999 | lons==-99999)=NaN;
    
    %Find those profiles with DM or A, and use the DM or A data
    iDM=findstr(info.datamode','D');
    iA=findstr(info.datamode','A');
    
    if ~isempty(iA)
        if Verbose==1
            fprintf('    > %4d of %4d profiles with Automatic Deleyed Mode control (A)\n',size(iA,2),size(tems,1))
        end
        tems(iA,:)=tems_ad(iA,:);
        sals(iA,:)=sals_ad(iA,:);
        pres(iA,:)=pres_ad(iA,:);
    end
    if ~isempty(iDM)
        if Verbose==1
            fprintf('    > %4d of %4d profiles with Delayed Mode QC (DM)\n',size(iDM,2),size(tems,1))
        end
        tems(iDM,:)=tems_ad(iDM,:);
        sals(iDM,:)=sals_ad(iDM,:);
        pres(iDM,:)=pres_ad(iDM,:);
    end

    %I take out those profiles with bad position
    ipQC=find(positionqc==0|positionqc==3|positionqc==4|positionqc==9);
    if ~isempty(ipQC)
        if Verbose==1
            fprintf('    > Data with Delayed Mode QC (DM)\n')
        end
        tems(ipQC,:)=NaN;
        sals(ipQC,:)=NaN;
        pres(ipQC,:)=NaN;
    end
else
    lats=NaN;lons=NaN;daynum=NaN;pres=NaN;sals=NaN;tems=NaN;stapar=NaN;project=NaN;cycle=NaN;nprof=NaN;nparam=NaN;info=NaN;
end
return
