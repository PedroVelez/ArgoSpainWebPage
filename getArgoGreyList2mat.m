clc;clear all;close all
load Globales;global GlobalSU

datadir=strcat(GlobalSU.ArgoData,'/');

if exist(strcat(datadir,'ar_greylist.txt'),'file')
	fid=fopen(strcat(datadir,'ar_greylist.txt'));
	str=fgets(fid);
	i=0;
	while feof(fid)==0
		str=fgets(fid);
		if length(str)>2
			i=i+1;
			in=findstr(str,',');
			platform(i)=str2double(str(1:in(1)-1));
			
			if size(str(in(1)+1:in(2)-1),2)==4;
				paramete(i,:)=str(in(1)+1:in(2)-1);
			else size(str(in(1)+1:in(2)-1),2)==4;
				if findstr(str(in(1)+1:in(2)-1),'SAL')>0
					paramete(i,:)='PSAL';
				end
			end
			dateinicstr=str(in(2)+1:in(3)-1);
			dateinic(i)=datenum(str2double(dateinicstr(1:4)),str2double(dateinicstr(5:6)),str2double(dateinicstr(7:8)));
			if in(4)-in(3)==8
				datefinastr=str(in(3)+1:in(4)-1);
				datefina(i)=datenum(str2double(datefinastr(1:4)),str2double(datefinastr(5:6)),str2double(datefinastr(7:8)));
			end
			%fprintf('%8d %s \n',platform(i),paramete(i,:))
		end
	end
	
	fprintf('     GetArgoGreyList %d floats <<<<<\n',i)
	save(strcat(datadir,'ar_greylist'),'platform','paramete','dateinic')
else
	fprintf('>>>>> No ArgoGreyList file found <<<<< \n',i)
end

