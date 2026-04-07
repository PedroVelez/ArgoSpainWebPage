clear all;close all
%Crea la pagina argoesstatus.html con el google mapa de las posiciones de
%las boyas Argo-Es y las Argo-In

%% Read configuration
configWebPage

%CoberturaArgoGlobal, para calcular el porcentajes
CoberturaArgoGlobal=4000; 

%CoberturaArgoMed
CoberturaArgoMed=100;

%% Begin
fprintf('>>>>> %s\n',mfilename)

% Read Data
DataArgoEs=load(strcat(PaginaWebDir,'/data/dataArgoSpain.mat'), ... 
    'activa','iactiva','iinactiva','inodesplegada','FechaUltimoPerfil','WMO','UltimoVoltaje','UltimoSurfaceOffset');
BoyasActivaArgoEs=DataArgoEs.iactiva;

%Numero total de perfiles medidos
NTotalPerfiles=0;
for ifloat=1:length(DataArgoEs.WMO)
    FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
    NTotalPerfiles=[NTotalPerfiles nanmax(FloatData.HIDf.cycle)'];
end

%Numero total de perfiles medidos en el Med
BoyasActivaArgoEsMed=0;
for ifloat=1:length(DataArgoEs.WMO)
    FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
    if strcmp(FloatData.MTDf.FLOAT_OWNER,'SOCIB')
    BoyasActivaArgoEsMed = BoyasActivaArgoEsMed + 1;
    end
end


%% Begin
fprintf('>>>>> %s\n',mfilename)

fid = fopen(FileTableArgoEsStatus,'w');

fprintf(fid, '<!DOCTYPE html>\n');
fprintf(fid, '<html>\n');
fprintf(fid, '<head>\n');
fprintf(fid, '<meta name="viewport" content="width=device-width, initial-scale=1">\n');
fprintf(fid, '<style>\n');
fprintf(fid, '* { box-sizing: border-box; margin: 0; padding: 0; }\n');
fprintf(fid, 'body { background-color: #00A2DD; font-family: Montserrat, Arial, sans-serif; }\n');
fprintf(fid, '\n');
fprintf(fid, '.stats-container {\n');
fprintf(fid, '    display: flex;\n');
fprintf(fid, '    flex-wrap: nowrap;\n');
fprintf(fid, '    align-items: center;\n');
fprintf(fid, '    justify-content: center;\n');
fprintf(fid, '    width: 100%%;\n');
fprintf(fid, '    padding: 10px 0;\n');
fprintf(fid, '}\n');
fprintf(fid, '.stat-item {\n');
fprintf(fid, '    display: flex;\n');
fprintf(fid, '    flex-direction: column;\n');
fprintf(fid, '    align-items: center;\n');
fprintf(fid, '    justify-content: center;\n');
fprintf(fid, '    flex: 1;\n');
fprintf(fid, '    padding: 10px 5px;\n');
fprintf(fid, '}\n');
fprintf(fid, '\n');
fprintf(fid, '.stat-number {\n');
fprintf(fid, '    color: #FFFFFF;\n');
fprintf(fid, '    font-weight: 700;\n');
fprintf(fid, '    font-size: 4vw;\n');
fprintf(fid, '    line-height: 1;\n');
fprintf(fid, '    text-align: center;\n');
fprintf(fid, '}\n');
fprintf(fid, '\n');
fprintf(fid, '.stat-label {\n');
fprintf(fid, '    color: #FFFFFF;\n');
fprintf(fid, '    font-weight: 500;\n');
fprintf(fid, '    font-size: 1vw;\n');
fprintf(fid, '    text-align: center;\n');
fprintf(fid, '    margin-top: 6px;\n');
fprintf(fid, '    text-transform: uppercase;\n');
fprintf(fid, '}\n');
fprintf(fid, '\n');
fprintf(fid, '.separator {\n');
fprintf(fid, '    color: rgba(255,255,255,0.5);\n');
fprintf(fid, '    font-size: 2vw;\n');
fprintf(fid, '    align-self: center;\n');
fprintf(fid, '    padding: 0 2px;\n');
fprintf(fid, '}\n');
fprintf(fid, '\n');
fprintf(fid, '/* MÓVIL */\n');
fprintf(fid, '@media (max-width: 767px) {\n');
fprintf(fid, '    .stats-container {\n');
fprintf(fid, '        flex-wrap: wrap;\n');
fprintf(fid, '    }\n');
fprintf(fid, '    .stat-item {\n');
fprintf(fid, '        flex: 0 0 45%%;\n');
fprintf(fid, '        padding: 12px 5px;\n');
fprintf(fid, '    }\n');
fprintf(fid, '    .stat-number {\n');
fprintf(fid, '        font-size: 10vw;\n');
fprintf(fid, '    }\n');
fprintf(fid, '    .stat-label {\n');
fprintf(fid, '        font-size: 3vw;\n');
fprintf(fid, '    }\n');
fprintf(fid, '    .separator {\n');
fprintf(fid, '        display: none;\n');
fprintf(fid, '    }\n');
fprintf(fid, '}\n');
fprintf(fid, '</style>\n');
fprintf(fid, '</head>\n');
fprintf(fid, '<body>\n');
fprintf(fid, '<div class="stats-container">\n');
fprintf(fid, '    <div class="stat-item">\n');
fprintf(fid, '        <div class="stat-number">%d</div>\n',BoyasActivaArgoEs);
fprintf(fid, '        <div class="stat-label">PERFILADORES</div>\n');
fprintf(fid, '    </div>\n');
fprintf(fid, '    <div class="separator">|</div>\n');
fprintf(fid, '    <div class="stat-item">\n');
fprintf(fid, '        <div class="stat-number">%d</div>\n',sum(NTotalPerfiles));
fprintf(fid, '        <div class="stat-label">PERFILES OCEANOGRÁFICOS</div>\n');
fprintf(fid, '    </div>\n');
fprintf(fid, '    <div class="separator">|</div>\n');
fprintf(fid, '    <div class="stat-item">\n');
fprintf(fid, '        <div class="stat-number">%3.1f%%</div>\n',BoyasActivaArgoEs/CoberturaArgoGlobal*100);
fprintf(fid, '        <div class="stat-label">COBERTURA GLOBAL</div>\n');
fprintf(fid, '    </div>\n');
fprintf(fid, '    <div class="separator">|</div>\n');
fprintf(fid, '    <div class="stat-item">\n');
fprintf(fid, '        <div class="stat-number">%3.1f%%</div>\n',BoyasActivaArgoEsMed/CoberturaArgoMed*100);
fprintf(fid, '        <div class="stat-label">COBERTURA MEDITERRÁNEA</div>\n');
fprintf(fid, '    </div>\n');
fprintf(fid, '</div>\n');
fprintf(fid, '</body>\n');
fprintf(fid, '</html>\n');
fclose(fid);

%% Ftp the file
fprintf('     > Uploading  %s \n',FileTableArgoEsStatus);
ftpobj=FtpArgoespana;
var=cd(ftpobj,ftp_dir_html);
outftp=mput(ftpobj,FileTableArgoEsStatus);


fprintf('%s <<<<< \n',mfilename)
