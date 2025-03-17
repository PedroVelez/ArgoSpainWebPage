function flt = readArgoFloatProfilesDM(inpath,Verbose)

%function to read in Argo float netcdf files.
%Second argument is optional and may be single value or vector
%if no second argument is passed then function loads all available profiles
%PVB Jun 2011
%PER Jun 2010

if nargin < 2
    Verbose=1;
end
profiles = 0:1000;  % set up large vector or possible profile #s

grdir = dir([inpath,'/R*.nc']);
gddir = dir([inpath,'/D*.nc']);
NR = length(grdir); % number of R files
ND = length(gddir); % numbe of D files

if Verbose==1
    fprintf('>>>>> Reading WMO %s with %d (%d RT, %d DM) profiles \n',inpath(end-16:end-10),NR+ND,NR,ND)
end

%Reading individual files
ncp=0;
for i1 = 1:NR+ND;
    %i1
    % Determine file name
    if i1 <= NR;
        fname = grdir(i1).name;
    else
        fname = gddir(i1-NR).name;
    end
    %Check to see if this nunber matches those to load
    %Nprof = str2double(fname(10:13));
    Nprof = str2double(fname(10:12));
    if any(Nprof == profiles)
        % load the data
        ncp=ncp+1;
        flt_profT= ReadArgoFloatProfile(fullfile(inpath,fname));
       
        if length(flt_profT)==1
            flt_prof(ncp) = flt_profT(1);
        end
    end
end

%eliminate structure elements that never got filled and sort by cycle number
fkill = cellfun('isempty',{flt_prof.data_mode});
flt_prof = flt_prof(~fkill);
[~,I] = sort([flt_prof.cycle_number]); %Reordena la estructura por numeo de ciclos
flt = flt_prof(I);  % assign output structure
if Verbose==1
    fprintf('    > From %s and procesed at %s \n', deblank(flt(1).project_name),deblank(flt(1).data_centre))
    fprintf('    > With %d (%d R, %d A, %d D) profiles Created %s and updated %s\n',NR+ND,length(strfind([flt.data_mode],'R')),length(strfind([flt.data_mode],'A')),length(strfind([flt.data_mode],'D')),flt(1).date_creation',flt(end).date_update')
    fprintf('    > %d parameters',flt(1).n_param)
    for i1=1:length(flt)
        fprintf('%3d%1s ',flt(i1).cycle_number,flt(i1).data_mode)
    end
    fprintf('\n')
end

%---------------------------------------------------------------------
%% function to open and read netcdf file
%---------------------------------------------------------------------
function flt_prof = ReadArgoFloatProfile(ncfile)
ncid= netcdf.open(ncfile, 'NC_NOWRITE');

inprof=1;
[~,n_prof]=netcdf.inqDim(ncid,netcdf.inqDimID(ncid,'N_PROF')); %Dimenson ID 8

for inp=1:n_prof
    [~,flt_prof(inprof).n_prof]=netcdf.inqDim(ncid,netcdf.inqDimID(ncid,'N_PROF')); %Dimenson ID 8
    [~,flt_prof(inprof).n_param]=netcdf.inqDim(ncid,netcdf.inqDimID(ncid,'N_PARAM')); %Dimenson ID 9
    [~,flt_prof(inprof).n_levels] = netcdf.inqDim(ncid,netcdf.inqDimID(ncid,'N_LEVELS'));% Dimension ID 10

    %% General information on the profile file This section contains information about the whole file.
    flt_prof(inprof).data_type=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'DATA_TYPE'))';
    flt_prof(inprof).format_version=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'FORMAT_VERSION'))';
    flt_prof(inprof).handbook_version=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'HANDBOOK_VERSION'))';
    format_version=str2num(flt_prof(inprof).format_version);
    flt_prof(inprof).reference_data_time=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'REFERENCE_DATE_TIME'));
    flt_prof(inprof).date_creation=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'DATE_CREATION'));
    flt_prof(inprof).date_update=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'DATE_UPDATE'));

    %% General information for each profile
    % Each item of this section has a N_PROF (number of profiles) dimension.
    flt_prof(inprof).platform_number=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PLATFORM_NUMBER'),[0 inprof-1],[7 inprof-1+1]);
    flt_prof(inprof).platform_type='';
    if format_version>=3
        flt_prof(inprof).platform_type=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PLATFORM_TYPE'),[0 inprof-1],[31 inprof-1+1]); %Format 3.0
    end
    flt_prof(inprof).project_name= netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PROJECT_NAME'),[0 inprof-1],[63 inprof-1+1])';
    flt_prof(inprof).pi_name=(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PI_NAME'),[0 inprof-1],[63 inprof-1+1])');
    flt_prof(inprof).station_parameters=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'STATION_PARAMETERS'),[0 0 inprof-1],[15 2 inprof-1+1]);
    isdoxy=0;

    SP=flt_prof(inprof).station_parameters';
    for isp=1:size(SP,1)
        if strcmp(SP(isp,1:4),'DOXY')
            isdoxy=1;
        end
    end
    flt_prof(inprof).cycle_number=double(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'CYCLE_NUMBER'),[inprof-1],[inprof-1+1]));
    flt_prof(inprof).direction=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'DIRECTION'),[inprof-1],[inprof-1+1]);
    flt_prof(inprof).data_centre=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'DATA_CENTRE'),[0 inprof-1],[1 inprof-1+1]);
    flt_prof(inprof).dc_reference=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'DC_REFERENCE'),[0 inprof-1],[31 inprof-1+1]);
    flt_prof(inprof).data_state_indicator=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'DATA_STATE_INDICATOR'),[0 inprof-1],[3 inprof-1+1])';

    flt_prof(inprof).data_mode=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'DATA_MODE'),[inprof-1],[inprof-1+1])';
    if format_version<3
        flt_prof(inprof).platform_type=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'INST_REFERENCE')); %Format 1.2
    end
    flt_prof(inprof).firmware_version='';
    if format_version>=3
        flt_prof(inprof).firmware_version=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'FIRMWARE_VERSION'),[0 inprof-1],[15 inprof-1+1]);
    end
    flt_prof(inprof).wmo_inst_type=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'WMO_INST_TYPE'),[0 inprof-1],[3 inprof-1+1])';
    flt_prof(inprof).juld =netcdf.getVar(ncid,netcdf.inqVarID(ncid,'JULD'),[inprof-1],[inprof-1+1]);
    flt_prof(inprof).juld_matlab=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'JULD'),[inprof-1],[inprof-1+1])+datenum(str2double(flt_prof(inprof).reference_data_time(1:4)),str2double(flt_prof(inprof).reference_data_time(5:6)),str2double(flt_prof(inprof).reference_data_time(7:8)));
    flt_prof(inprof).juld_qc=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'JULD_QC'),[inprof-1],[inprof-1+1])';
    flt_prof(inprof).juld_location=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'JULD_LOCATION'),[inprof-1],[inprof-1+1])';
    flt_prof(inprof).latitude =netcdf.getVar(ncid,netcdf.inqVarID(ncid,'LATITUDE'),[inprof-1],[inprof-1+1]);
    flt_prof(inprof).longitude=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'LONGITUDE'),[inprof-1],[inprof-1+1]);
    flt_prof(inprof).position_qc=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'POSITION_QC'),[inprof-1],[inprof-1+1])';
    flt_prof(inprof).positioning_system=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'POSITIONING_SYSTEM'),[0 inprof-1],[7 inprof-1+1])';
    flt_prof(inprof).profile_pres_qc=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PROFILE_PRES_QC'),[inprof-1],[inprof-1+1]);
    flt_prof(inprof).profile_temp_qc=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PROFILE_TEMP_QC'),[inprof-1],[inprof-1+1]);
    flt_prof(inprof).profile_psal_qc=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PROFILE_PSAL_QC'),[inprof-1],[inprof-1+1]);

    flt_prof(inprof).vertical_sampling_scheme='';
    if format_version>=3
        flt_prof(inprof).vertical_sampling_scheme=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'VERTICAL_SAMPLING_SCHEME'),[0 inprof-1],[255 inprof-1+1]);
    end
    %% Measurements for each profile. This section contains information on each level of each profile.
    %Each variable in this section has a N_PROF (number of profiles), N_LEVELS (number of pressure levels) dimension.
    flt_prof(inprof).pres=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PRES'),[0 inprof-1],[flt_prof(inprof).n_levels-1 inprof-1+1])'; % get all elements of pressure
    flt_prof(inprof).pres(flt_prof(inprof).pres==netcdf.getAtt(ncid,netcdf.inqVarID(ncid,'PRES'),'_FillValue'))=NaN;
    flt_prof(inprof).pres_qc=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PRES_QC'),[0 inprof-1],[flt_prof(inprof).n_levels-1 inprof-1+1])';
    flt_prof(inprof).pres_adjusted=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PRES_ADJUSTED'),[0 inprof-1],[flt_prof(inprof).n_levels-1 inprof-1+1])'; % get all elements of pressure
    flt_prof(inprof).pres_adjusted(flt_prof(inprof).pres_adjusted==netcdf.getAtt(ncid,netcdf.inqVarID(ncid,'PRES'),'_FillValue'))=NaN;
    flt_prof(inprof).pres_adjusted_qc=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PRES_ADJUSTED_QC'),[0 inprof-1],[flt_prof(inprof).n_levels-1 inprof-1+1])';
    flt_prof(inprof).pres_adjusted_error=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PRES_ADJUSTED_ERROR'),[0 inprof-1],[flt_prof(inprof).n_levels-1 inprof-1+1])';
    
    flt_prof(inprof).temp=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'TEMP'),[0 inprof-1],[flt_prof(inprof).n_levels-1 inprof-1+1])';
    flt_prof(inprof).temp(flt_prof(inprof).pres==netcdf.getAtt(ncid,netcdf.inqVarID(ncid,'TEMP'),'_FillValue'))=NaN;
    flt_prof(inprof).temp_qc=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'TEMP_QC'),[0 inprof-1],[flt_prof(inprof).n_levels-1 inprof-1+1])';
    flt_prof(inprof).temp_adjusted=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'TEMP_ADJUSTED'),[0 inprof-1],[flt_prof(inprof).n_levels-1 inprof-1+1])';
    flt_prof(inprof).temp_adjusted(flt_prof(inprof).pres_adjusted==netcdf.getAtt(ncid,netcdf.inqVarID(ncid,'TEMP'),'_FillValue'))=NaN;
    flt_prof(inprof).temp_adjusted_qc=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'TEMP_ADJUSTED_QC'),[0 inprof-1],[flt_prof(inprof).n_levels-1 inprof-1+1])';
    flt_prof(inprof).temp_adjusted_error=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'TEMP_ADJUSTED_ERROR'),[0 inprof-1],[flt_prof(inprof).n_levels-1 inprof-1+1])';

    flt_prof(inprof).psal=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PSAL'),[0 inprof-1],[flt_prof(inprof).n_levels-1 inprof-1+1])';
    flt_prof(inprof).psal(flt_prof(inprof).pres==netcdf.getAtt(ncid,netcdf.inqVarID(ncid,'PSAL'),'_FillValue'))=NaN;
    flt_prof(inprof).psal_qc=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PSAL_QC'),[0 inprof-1],[flt_prof(inprof).n_levels-1 inprof-1+1])';
    flt_prof(inprof).psal_adjusted=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PSAL_ADJUSTED'),[0 inprof-1],[flt_prof(inprof).n_levels-1 inprof-1+1])';
    flt_prof(inprof).psal_adjusted(flt_prof(inprof).pres_adjusted==netcdf.getAtt(ncid,netcdf.inqVarID(ncid,'PSAL'),'_FillValue'))=NaN;
    flt_prof(inprof).psal_adjusted_qc=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PSAL_ADJUSTED_QC'),[0 inprof-1],[flt_prof(inprof).n_levels-1 inprof-1+1])';
    flt_prof(inprof).psal_adjusted_error=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PSAL_ADJUSTED_ERROR'),[0 inprof-1],[flt_prof(inprof).n_levels-1 inprof-1+1])';

    if isdoxy == 1
        flt_prof(inprof).doxy=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'DOXY'),[0 inprof-1],[flt_prof(inprof).n_levels-1 inprof-1+1])';
        flt_prof(inprof).doxy(flt_prof(inprof).doxy==netcdf.getAtt(ncid,netcdf.inqVarID(ncid,'DOXY'),'_FillValue'))=NaN;
        flt_prof(inprof).doxy_qc=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'DOXY_QC'),[0 inprof-1],[flt_prof(inprof).n_levels-1 inprof-1+1])';
        flt_prof(inprof).doxy_adjusted=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'DOXY_ADJUSTED'),[0 inprof-1],[flt_prof(inprof).n_levels-1 inprof-1+1])';
        flt_prof(inprof).doxy_adjusted(flt_prof(inprof).doxy_adjusted==netcdf.getAtt(ncid,netcdf.inqVarID(ncid,'DOXY'),'_FillValue'))=NaN;
        flt_prof(inprof).doxy_adjusted_qc=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'DOXY_ADJUSTED_QC'),[0 inprof-1],[flt_prof(inprof).n_levels-1 inprof-1+1])';
        flt_prof(inprof).doxy_adjusted_error=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'DOXY_ADJUSTED_ERROR'),[0 inprof-1],[flt_prof(inprof).n_levels-1 inprof-1+1])';
    else
        flt_prof(inprof).doxy=[];
        flt_prof(inprof).doxy_qc=[];
        flt_prof(inprof).doxy_adjusted=[];
        flt_prof(inprof).doxy_adjusted_qc=[];
        flt_prof(inprof).doxy_adjusted_error=[];
    end

    %Using QC flags
    %Using QC flags
    flt_prof(inprof).latitude(flt_prof(inprof).position_qc=='4' |  flt_prof(inprof).position_qc=='9')=NaN;
    flt_prof(inprof).longitude(flt_prof(inprof).position_qc=='4' |  flt_prof(inprof).position_qc=='9')=NaN;

    flt_prof(inprof).pres(flt_prof(inprof).pres_qc=='4' |  flt_prof(inprof).pres_qc=='9')=NaN;
    flt_prof(inprof).pres_adjusted(flt_prof(inprof).pres_adjusted_qc=='4' |  flt_prof(inprof).pres_adjusted_qc=='9')=NaN;

    flt_prof(inprof).temp(flt_prof(inprof).temp_qc=='4' |  flt_prof(inprof).temp_qc=='9')=NaN;
    flt_prof(inprof).temp_adjusted(flt_prof(inprof).temp_adjusted_qc=='4' |  flt_prof(inprof).temp_adjusted_qc=='9')=NaN;

    flt_prof(inprof).psal(flt_prof(inprof).psal_qc=='4' |  flt_prof(inprof).psal_qc=='9')=NaN;
    flt_prof(inprof).psal_adjusted(flt_prof(inprof).psal_adjusted_qc=='4' |  flt_prof(inprof).psal_adjusted_qc=='9')=NaN;

    %% Calibration information for each profile
    % Calibrations are applied to parameters to create adjusted parameters. Different calibration methods will be used by groups processing Argo data. When a method is applied, its description is stored in the following fields.
    % This section contains calibration information for each parameter of each profile.
    % Each item of this section has a N_PROF (number of profiles), N_CALIB (number of calibrations), N_PARAM (number of parameters) dimension.
    % If no calibration is available, N_CALIB is set to 1, all values of calibration section are set to fill values.

    %flt_prof(inprof).parameter=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'PARAMETER'));
    %flt_prof(inprof).scientific_calib_equation=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'SCIENTIFIC_CALIB_EQUATION'));
    %flt_prof(inprof).scientific_calib_coefficient=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'SCIENTIFIC_CALIB_COEFFICIENT'));
    %flt_prof(inprof).scientific_calib_comment=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'SCIENTIFIC_CALIB_COMMENT'));
    %flt_prof(inprof).scientific_calib_date=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'SCIENTIFIC_CALIB_DATE'));
    %     %Si if N_CALIB is set to 1 por compatibilidad creo las matrices con el tama?o adecuado
    %     if flt_prof(inprof).n_calib==1
    %         for ipara=1:flt_prof(inprof).n_param
    %             if strncmp(flt_prof(inprof).station_parameters(:,ipara)','PRES',4)
    %                 iPres=ipara;
    %             elseif strncmp(flt_prof(inprof).station_parameters(:,ipara)','TEMP',4)
    %                 iTemp=ipara;
    %             elseif strncmp(flt_prof(inprof).station_parameters(:,ipara)','PSAL',4)
    %                 iPsal=ipara;
    %             end
    %         end
    %
    %         VT=flt_prof(inprof).parameter;
    %         VT(1:4,iPres,2)='    ';
    %         VT(1:4,iTemp,2)='    ';
    %         VT(1:4,iPsal,2)='    ';
    %         flt_prof(inprof).parameter=reshape(VT,16,2,3);clear VT
    %         flt_prof(inprof).parameter=flt_prof(inprof).parameter(:,1,:);
    %
    %         VT=flt_prof(inprof).scientific_calib_coefficient;
    %         VT(1:256,iPres,2)=repmat(' ',1,256);
    %         VT(1:256,iTemp,2)=repmat(' ',1,256);
    %         VT(1:256,iPsal,2)=repmat(' ',1,256);
    %         flt_prof(inprof).scientific_calib_coefficient=reshape(VT,256,2,3);clear VT
    %         flt_prof(inprof).scientific_calib_coefficient=flt_prof(inprof).scientific_calib_coefficient(:,1,:);
    %
    %         VT=flt_prof(inprof).scientific_calib_comment;
    %         VT(1:256,iPres,2)=repmat(' ',1,256);
    %         VT(1:256,iTemp,2)=repmat(' ',1,256);
    %         VT(1:256,iPsal,2)=repmat(' ',1,256);
    %         flt_prof(inprof).scientific_calib_comment=reshape(VT,256,2,3);clear VT
    %         flt_prof(inprof).scientific_calib_comment=flt_prof(inprof).scientific_calib_comment(:,1,:);
    %
    %         VT=flt_prof(inprof).scientific_calib_date;
    %         VT(1:14,iPres,2)=repmat(' ',1,14);
    %         VT(1:14,iTemp,2)=repmat(' ',1,14);
    %         VT(1:14,iPsal,2)=repmat(' ',1,14);
    %         flt_prof(inprof).scientific_calib_date=reshape(VT,14,2,3);clear VT
    %         flt_prof(inprof).scientific_calib_date=flt_prof(inprof).scientific_calib_date(:,1,:);
    %
    %         VT=flt_prof(inprof).scientific_calib_equation;
    %         VT(1:256,iPres,2)=repmat(' ',1,256);
    %         VT(1:256,iTemp,2)=repmat(' ',1,256);
    %         VT(1:256,iPsal,2)=repmat(' ',1,256);
    %         flt_prof(inprof).scientific_calib_equation=reshape(VT,256,2,3);clear VT
    %         flt_prof(inprof).scientific_calib_equation=flt_prof(inprof).scientific_calib_equation(:,1,:);
    %     end


    %% History information for each profile
    % This section contains history information for each action performed on each profile by a data centre.
    % Each item of this section has a N_HISTORY (number of history records), N_PROF (number of profiles) dimension.
    % A history record is created whenever an action is performed on a profile.
    % The recorded actions are coded and described in the history code table from the reference table 7.
    % On the GDAC, multi-profile history section is empty to reduce the size of the file. History section is available on mono-profile files, or in multi-profile files distributed from the web data selection.

    % flt_prof(inprof).history_institution=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'HISTORY_INSTITUTION'));
    % flt_prof(inprof).history_step=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'HISTORY_STEP'));
    % flt_prof(inprof).history_software=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'HISTORY_SOFTWARE'));
    % flt_prof(inprof).history_software_release=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'HISTORY_SOFTWARE_RELEASE'));
    % flt_prof(inprof).history_reference=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'HISTORY_REFERENCE'));
    % flt_prof(inprof).history_date=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'HISTORY_DATE'));
    % flt_prof(inprof).history_action=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'HISTORY_ACTION'));
    % flt_prof(inprof).history_parameter=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'HISTORY_PARAMETER'));
    % flt_prof(inprof).history_start_pres=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'HISTORY_START_PRES'));
    % flt_prof(inprof).history_stop_pres=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'HISTORY_STOP_PRES'));
    % flt_prof(inprof).history_previous_value=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'HISTORY_PREVIOUS_VALUE'));
    % flt_prof(inprof).history_qctest=netcdf.getVar(ncid,netcdf.inqVarID(ncid,'HISTORY_QCTEST'));
end

netcdf.close(ncid);