%% Writting Report

%Read previous report
FileNameInforme=strcat(PaginaWebDir,'/Data/report',DataSetName,'Status.mat');

if exist(FileNameInforme,'file')>0
    InformeOld=load(FileNameInforme);
    Incremento=DataArgoEs.iactiva-InformeOld.iactiva;
else
    Incremento=0;
end

%Last Profiles
PUD=find(DataArgoEs.FechaUltimoPerfil>=now-DiasAnalisis);
PUDT=[];
for ipud=1:length(PUD)
    PUDT=[PUDT sprintf('        http://www.oceanografia.es/argo/datos/floats/%7d.html\n',DataArgoEs.WMO(PUD(ipud)))];
end

%Write the new report
if Incremento==0
    Informe1=sprintf('%sStatusGraficos - Activos (%d)   \n',DataSetName,DataArgoEs.iactiva);
    Informe5='';
elseif Incremento>0
    IWMO=setdiff(DataArgoEs.WMO,InformeOld.WMO);
    IT=[];
    for idif=1:length(IWMO)
        IT=[IT sprintf('%d ',IWMO(idif))];
    end
    Informe1=sprintf('%sStatusFloats - Activos (%d,+%d)\n',DataSetName,DataArgoEs.iactiva,Incremento);
    Informe5=sprintf('     New active: %s\n',IT);
elseif Incremento<0 && DataArgoEs.iactiva>0
    IWMO=setdiff(DataArgoEs.WMO,InformeOld.WMO);
    IT=[];
    for idif=1:length(IWMO)
        IT=[IT sprintf('%d ',IWMO(idif))];
    end
    Informe1=sprintf('%sStatus Floats - Activos (%d,-%d)\n',DataSetName,DataArgoEs.iactiva,Incremento);
    Informe5=sprintf('     New inactive: %s\n',IT);
end
Informe2=sprintf('     Ultimo perfil %s\n',datestr(DataArgoEs.FechaUltimoPerfil(1)));
if ~isempty(PUDT)
    Informe3=sprintf('     Ultimos perfiles \n%s',PUDT);
else
    Informe3='';
end

if strcmp(DataSetName,'ArgoEs')
    if isnan(nanmin(DataArgoEs.UltimoVoltaje(DataArgoEs.activa==1)))==0
        Informe4=sprintf('     Voltaje minimo %4.2f v\n       http://www.oceanografia.es/argo/datos/floats/%7d.html\n',nanmin(DataArgoEs.UltimoVoltaje(DataArgoEs.activa==1)),DataArgoEs.WMO(find(DataArgoEs.UltimoVoltaje==nanmin(DataArgoEs.UltimoVoltaje(DataArgoEs.activa==1)),1)));
    else
        Informe4='';
    end
else
    Informe4='';
end

Informe6=sprintf('     Actualizado %s',datestr(now));
Informe=[Informe1 Informe2 Informe3 Informe4 Informe5 Informe6];

iactiva=DataArgoEs.iactiva;
WMO=DataArgoEs.WMO;

disp(Informe)
save(FileNameInforme,'Informe','iactiva','WMO')
