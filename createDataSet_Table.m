clear all;close all

% Crea argoesstatus_table.html con las boyas de Argo Es

%% Read configuration
configWebPage

% TrajectorySpanArgo=now-datenum(2005,1,1);
% FileHtmlArgoEsStatus;

%% Inicio
fprintf('>>>>> %s\n',mfilename)

% Read Data
DataArgoEs=load(strcat(PaginaWebDir,'/data/dataArgoSpain.mat'),'activa','iactiva','iinactiva','inodesplegada','FechaUltimoPerfil','WMO','UltimoVoltaje','UltimoSurfaceOffset');
FileNameInforme=strcat(PaginaWebDir,'/data/report',mfilename,'.mat');

fidT = fopen(strrep(FileHtmlArgoEsStatus,'.html','_tabla.html'),'w');
fTxt = fopen(strrep(FileHtmlArgoEsStatus,'.html','_tabla.txt'),'w');

% Cuento numero de perfiles
NTotalPerfiles=0;
for ifloat=1:size(DataArgoEs.WMO,2)
    if DataArgoEs.activa(ifloat)==1 %Active
        FloatData = load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
        NTotalPerfiles = [NTotalPerfiles nanmax(FloatData.HIDf.cycle)'];
    else
        FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
        NTotalPerfiles=[NTotalPerfiles nanmax(FloatData.HIDf.cycle)'];
    end
end

%% Tabla con los datos
fprintf(fidT,'<!DOCTYPE html> \n');
fprintf(fidT,'<html> \n');
fprintf(fidT,'<head> \n');
fprintf(fidT,'	<title>Argo Espa&ntilde;a</title> \n');
fprintf(fidT,'	<meta charset="utf-8" /> \n');
fprintf(fidT,'	<meta name="viewport" content="width=device-width, initial-scale=1.0"> \n');
%Estilo
fprintf(fidT,'<style type="text/css">\n');
fprintf(fidT,'<!--.style1 {font-size: 16px; font-weight: bold;font-family: verdana; color: #0c2046;}-->\n');
fprintf(fidT,'<!--.style3 {font-size: 12px; font-weight: normal; font-family: verdana; color: #0c2046}-->\n');
fprintf(fidT, '    body { margin: 0; padding: 8px; font-family: verdana; overflow-x: hidden; }\n');
fprintf(fidT, '    .style1 { font-size: 16px; font-weight: bold; color: #0c2046; }\n');
fprintf(fidT, '    .style3 { font-size: 12px; font-weight: normal; color: #0c2046; }\n');
fprintf(fidT, '    @media screen and (max-width: 700px) {\n');
fprintf(fidT, '      table { width: 100%% !important; }\n');
fprintf(fidT, '      table tr th:nth-child(4), table tr td:nth-child(4),\n');
fprintf(fidT, '      table tr th:nth-child(5), table tr td:nth-child(5),\n');
fprintf(fidT, '      table tr th:nth-child(6), table tr td:nth-child(6),\n');
fprintf(fidT, '      table tr th:nth-child(7), table tr td:nth-child(7) {\n');
fprintf(fidT, '        display: none;\n');
fprintf(fidT, '      }\n');
fprintf(fidT, '      table tr th:nth-child(8), table tr td:nth-child(8) {\n');
fprintf(fidT, '        display: table-cell;\n');
fprintf(fidT, '      }\n');
fprintf(fidT, '      tr.detalle-movil { display: none; }\n');
fprintf(fidT, '      tr.detalle-movil.abierto { display: table-row; }\n');
fprintf(fidT, '      tr.detalle-movil td {\n');
fprintf(fidT, '        padding: 6px 10px 10px 10px;\n');
fprintf(fidT, '        background: #f5f5f5;\n');
fprintf(fidT, '        font-size: 12px;\n');
fprintf(fidT, '        color: #0c2046;\n');
fprintf(fidT, '      }\n');
fprintf(fidT, '      tr.detalle-movil table {\n');
fprintf(fidT, '        width: 100%% !important;\n');
fprintf(fidT, '        border-collapse: collapse;\n');
fprintf(fidT, '      }\n');
fprintf(fidT, '      tr.detalle-movil table td {\n');
fprintf(fidT, '        padding: 3px 4px;\n');
fprintf(fidT, '        vertical-align: top;\n');
fprintf(fidT, '      }\n');
fprintf(fidT, '      tr.detalle-movil table td:first-child {\n');
fprintf(fidT, '        font-weight: bold;\n');
fprintf(fidT, '        white-space: nowrap;\n');
fprintf(fidT, '        width: 38%%;\n');
fprintf(fidT, '        color: #555;\n');
fprintf(fidT, '      }\n');
fprintf(fidT, '      .btn-expandir {\n');
fprintf(fidT, '        display: inline-block;\n');
fprintf(fidT, '        width: 24px;\n');
fprintf(fidT, '        height: 24px;\n');
fprintf(fidT, '        line-height: 22px;\n');
fprintf(fidT, '        text-align: center;\n');
fprintf(fidT, '        border: 1px solid #aaa;\n');
fprintf(fidT, '        border-radius: 4px;\n');
fprintf(fidT, '        background: #fff;\n');
fprintf(fidT, '        color: #0c2046;\n');
fprintf(fidT, '        font-size: 14px;\n');
fprintf(fidT, '        font-weight: bold;\n');
fprintf(fidT, '        cursor: pointer;\n');
fprintf(fidT, '        user-select: none;\n');
fprintf(fidT, '      }\n');
fprintf(fidT, '      .btn-expandir.abierto { background: #0c2046; color: #fff; }\n');
fprintf(fidT, '    }\n');
fprintf(fidT, '\n');
fprintf(fidT, '    @media screen and (min-width: 701px) {\n');
fprintf(fidT, '      table tr th:nth-child(8), table tr td:nth-child(8) { display: none; }\n');
fprintf(fidT, '      tr.detalle-movil { display: none !important; }\n');
fprintf(fidT, '    }\n');
fprintf(fidT,'</style>\n');
fprintf(fidT, '</head>\n');
fprintf(fidT, '<body>\n');
fprintf(fidT, '<br>\n');

%Table
fprintf(fidT, '<TABLE width="900" border="0" align="center" cellpadding="2" cellspacing="3" style="max-width:900px; width:100%%;">\n');
fprintf(fidT,'<tr bgcolor="#C0C0C0">\n');

fprintf(fidT, '<td width="56"> <div align="center" class="style1" ><div align="center"><strong>Estado</strong></div></div></td>\n');
fprintf(fidT, '<td width="74"> <div align="center" class="style1" ><div align="center"><strong>WMO</strong></div></div></td>\n');
fprintf(fidT, '<td width="113"><div align="center" class="style1" ><div align="center"><strong>Proyecto</strong></div></div></td>\n');
fprintf(fidT, '<td width="106"><div align="center" class="style1" ><div align="center"><strong>Primer perfil</strong></div></div></td>\n');
fprintf(fidT, '<td width="106"><div align="center" class="style1" ><div align="center"><strong>&Uacute;ltimo perfil </strong></div></div></td>\n');
fprintf(fidT, '<td width="45"> <div align="center" class="style1" ><div align="center"><strong>Edad</strong></div></div></td>\n');
fprintf(fidT, '<td width="100"><div align="center" class="style1" ><div align="center"><strong>Tipo boya</strong></div></div></td>\n');
fprintf(fidT, '<td width="30"></td>\n');

fprintf(fidT,'</TR>\n');
fprintf(fTxt,'# Boyas del Argo España ordenadas por ultimo perfil emitido \n');
fprintf(fTxt,'Estado; WMO; Proyecto; Primer perfil; ultimo perfil; Edad; Tipo de boya; FloatOwner; Lon; Lat \n');

%Lee los datos de las boyas para poder crear la tabla de datos
%iactiva=0;iinactiva=0;inodesplegada=0;
for ifloat=1:size(DataArgoEs.WMO,2)
    MD = createDataSetStatus_FunctionMetadata(DataArgoEs.WMO(ifloat),DirArgoData);
    if DataArgoEs.activa(ifloat)>=1 %Activa o Inactiva con datos
        FloatData=load(fullfile(DirArgoData,'Floats',num2str(DataArgoEs.WMO(ifloat))));
        if DataArgoEs.activa(ifloat)==1
            fprintf('     > ACTIVA %7d; %12s; first:%s; last:%s; Age:%s; %s;%s \n',MD.WMOFloat,MD.ProjectName,datestr(FloatData.HIDf.julds(1),22),datestr(FloatData.HIDf.julds(end),22),MD.Age,MD.PlatformModel,MD.FloatOwner)
            fprintf(fTxt,'Activa; %7d; %12s; %s; %s; %s; %s; %s; %6.3f; %6.3f\n',MD.WMOFloat,MD.ProjectName,datestr(FloatData.HIDf.julds(1),22),datestr(FloatData.HIDf.julds(end),22),MD.Age,MD.PlatformModel,MD.FloatOwner,FloatData.HIDf.lons(end),FloatData.HIDf.lats(end) );
            if mod(ifloat,2);
                fprintf(fidT,'<tr height: 55px; bgcolor="#e5e5e5">\n');
            else
                fprintf(fidT,'<tr height: 55px;">\n');
            end
            fprintf(fidT,'<td width="56"> <div align="center" class="style3"><a href="https://www.argoespana.es/float/%d.html" target="_blank">Activa</span></div></td>',MD.WMOFloat);
            fprintf(fidT,'<td width="74"> <div align="center" class="style3">%07d</span></div></td>',MD.WMOFloat);
            fprintf(fidT,'<td width="113"><div align="center" class="style3">%12s</span></div></td>',MD.ProjectName);
            fprintf(fidT,'<td width="106"><div align="center" class="style3">%s</span></div></td>',datestr(FloatData.HIDf.julds(1),22));
            fprintf(fidT,'<td width="106"><div align="center" class="style3">%s</span></div></td>',datestr(FloatData.HIDf.julds(end),22));
            fprintf(fidT,'<td width="45"> <div align="center" class="style3">%s</span></div></td>',MD.Age);
            fprintf(fidT,'<td width="100"><div align="center" class="style3">%12s</span></div></td>',MD.PlatformModel);
            fprintf(fidT,'<td width="30" style="vertical-align:middle;text-align:center;"><span class="btn-expandir" onclick="toggleDetalle(''det_%d'', this)">+</span></td></tr>\n',MD.WMOFloat);
            fprintf(fidT,'<tr class="detalle-movil" id="det_%d"><td colspan="8"></td>\n',MD.WMOFloat);
            fprintf(fidT,'</tr>');
        else
            fprintf('     > INACTIVA %7d; %12s; first:%s; last:%s; Age:%s; %s \n',MD.WMOFloat,MD.ProjectName,datestr(FloatData.HIDf.julds(1),22),datestr(FloatData.HIDf.julds(end),22),MD.Age,MD.PlatformModel)
            fprintf(fTxt,'Inactiva; %7d; %12s; %s; %s; %s; %s; %s; %6.3f; %6.3f\n',MD.WMOFloat,MD.ProjectName,datestr(FloatData.HIDf.julds(1),22),datestr(FloatData.HIDf.julds(end),22),MD.Age,MD.PlatformModel,MD.FloatOwner,FloatData.HIDf.lons(end),FloatData.HIDf.lats(end));
            if mod(ifloat,2);
                fprintf(fidT,'<TR height: 55px; bgcolor="#e5e5e5">\n');
            else
                fprintf(fidT,'<TR height: 55px;">\n');
            end
            fprintf(fidT,'<td width="56"> <div align="center" class="style3"><a href="https://www.argoespana.es/float/%d.html" target="_blank">Inactiva</span></div></td>',MD.WMOFloat);
            fprintf(fidT,'<td width="74"> <div align="center" class="style3">%07d</span></div></td>',MD.WMOFloat);
            fprintf(fidT,'<td width="113"><div align="center" class="style3">%12s</span></div></td>',MD.ProjectName);
            fprintf(fidT,'<td width="106"><div align="center" class="style3">%s</span></div></td>',datestr(FloatData.HIDf.julds(1),22));
            fprintf(fidT,'<td width="106"><div align="center" class="style3">%s</span></div></td>',datestr(FloatData.HIDf.julds(end),22));
            fprintf(fidT,'<td width=" 45"><div align="center" class="style3">%s</span></div></td>',MD.Age);
            fprintf(fidT,'<td width="100"><div align="center" class="style3">%12s</span></div></td>',MD.PlatformModel);
            fprintf(fidT,'<td width="30" style="vertical-align:middle;text-align:center;"><span class="btn-expandir" onclick="toggleDetalle(''det_%d'', this)">+</span></td></tr>\n',MD.WMOFloat);
            fprintf(fidT, '<tr class="detalle-movil" id="det_%d"><td colspan="8"></td>\n',MD.WMOFloat);
            fprintf(fidT,'</tr>');
        end
    else
        fprintf('     > No Desplegada %7d\n',MD.WMOFloat)
        fprintf(fTxt,'No Desplegada; %7d;;;;;\n',MD.WMOFloat);
        fprintf(fidT,'<tr class="style3">\n');
        fprintf(fidT,'<td width="56"><div align="center" class="style3"><a>Inactiva</span></div></td>');
        fprintf(fidT,'<td width="74"><div align="center" class="style3">%07d</span></div></td>',MD.WMOFloat);
        fprintf(fidT,'<td width="113"><div align="center" class="style3">Por desplegar</span></div></td>');
        fprintf(fidT,'<td width="106"><div align="center" class="style3"> ---- </span></div></td>');
        fprintf(fidT,'<td width="106"><div align="center" class="style3"> ---- </span></div></td>');
        fprintf(fidT,'<td width=" 45"><div align="center"  class="style3"> ---- </span></div></td>');
        fprintf(fidT,'<td width="100"><div align="center" class="style3"> ---- </span></div></td>');
        fprintf(fidT,'</tr>');
    end
end
fprintf(fidT,'</Table>\n');
fprintf(fidT,'</div>\n');
fclose(fTxt);

%Scripts para plegar la tabla
fprintf(fidT, '<script>\n');
fprintf(fidT, '  function enviarAltura() {\n');
fprintf(fidT, '    var altura = document.documentElement.scrollHeight;\n');
fprintf(fidT, '    window.parent.postMessage({ iframeAltura: altura, iframeId: ''tabla'' }, ''*'');\n');
fprintf(fidT, '  }\n');
fprintf(fidT, '  window.addEventListener(''load'', enviarAltura);\n');
fprintf(fidT, '  window.addEventListener(''resize'', enviarAltura);\n');
fprintf(fidT, '\n');

%% Incluir en elementor
fprintf(fidT, '  /***********************\n');
fprintf(fidT, '  <iframe id="iframe-tabla"\n');
fprintf(fidT, '    src="/argoesstatus_tabla.html"\n');
fprintf(fidT, '    style="width:100%%; border:none; display:block;"\n');
fprintf(fidT, '    scrolling="no">\n');
fprintf(fidT, '  </iframe>\n');
fprintf(fidT, '\n');
fprintf(fidT, '  <script>\n');
fprintf(fidT, '    window.addEventListener(''message'', function(e) {\n');
fprintf(fidT, '      if (e.data && e.data.iframeId === ''tabla'') {\n');
fprintf(fidT, '        document.getElementById(''iframe-tabla'').style.height = e.data.iframeAltura + ''px'';\n');
fprintf(fidT, '      }\n');
fprintf(fidT, '    });\n');
fprintf(fidT, '  <//script>\n');
fprintf(fidT, '  ***********************/\n');

fprintf(fidT, '  function toggleDetalle(id, btn) {\n');
fprintf(fidT, '    var filaDet = document.getElementById(id);\n');
fprintf(fidT, '    if (!filaDet) return;\n');
fprintf(fidT, '\n');
fprintf(fidT, '    var abierto = filaDet.classList.toggle(''abierto'');\n');
fprintf(fidT, '    btn.classList.toggle(''abierto'', abierto);\n');
fprintf(fidT, '    btn.textContent = abierto ? ''−'' : ''+'';\n');
fprintf(fidT, '\n');
fprintf(fidT, '    // Si se abre y la celda ests vacia, leer los datos de la fila padre\n');
fprintf(fidT, '    if (abierto) {\n');
fprintf(fidT, '      var celda = filaDet.querySelector(''td'');\n');
fprintf(fidT, '      if (!celda.hasChildNodes()) {\n');
fprintf(fidT, '        var filaPadre = filaDet.previousElementSibling;\n');
fprintf(fidT, '        // Buscar la fila de datos anterior (saltando otras filas detalle)\n');
fprintf(fidT, '        while (filaPadre && filaPadre.classList.contains(''detalle-movil'')) {\n');
fprintf(fidT, '          filaPadre = filaPadre.previousElementSibling;\n');
fprintf(fidT, '        }\n');
fprintf(fidT, '        if (filaPadre) {\n');
fprintf(fidT, '          var celdas = filaPadre.querySelectorAll(''td'');\n');
fprintf(fidT, '          // celdas[3]=Primer perfil, [4]=Último perfil, [5]=Edad, [6]=Tipo boya\n');
fprintf(fidT, '          var etiquetas = [''Primer perfil:'', ''Último perfil:'', ''Edad:'', ''Tipo boya:''];\n');
fprintf(fidT, '          var indices   = [3, 4, 5, 6];\n');
fprintf(fidT, '          var tabla = document.createElement(''table'');\n');
fprintf(fidT, '          indices.forEach(function(i, j) {\n');
fprintf(fidT, '            var tr = document.createElement(''tr'');\n');
fprintf(fidT, '            var tdEtq = document.createElement(''td'');\n');
fprintf(fidT, '            var tdVal = document.createElement(''td'');\n');
fprintf(fidT, '            tdEtq.textContent = etiquetas[j];\n');
fprintf(fidT, '            tdVal.textContent = celdas[i] ? celdas[i].innerText.trim() : ''-'';\n');
fprintf(fidT, '            tr.appendChild(tdEtq);\n');
fprintf(fidT, '            tr.appendChild(tdVal);\n');
fprintf(fidT, '            tabla.appendChild(tr);\n');
fprintf(fidT, '          });\n');
fprintf(fidT, '          celda.appendChild(tabla);\n');
fprintf(fidT, '        }\n');
fprintf(fidT, '      }\n');
fprintf(fidT, '    }\n');
fprintf(fidT, '\n');
fprintf(fidT, '    setTimeout(enviarAltura, 50);\n');
fprintf(fidT, '  }\n');
fprintf(fidT, '</script>\n');
fprintf(fidT,'</body>\n');
fprintf(fidT,'</html>\n');

fclose(fidT);


%% Ftp the files
ftpobj=FtpArgoespana;
cd(ftpobj,ftp_dir_html);
mput(ftpobj,strrep(FileHtmlArgoEsStatus,'.html','_tabla.html'));
fprintf('     > Uploading  %s, %s \n',FileHtmlArgoEsStatus,strrep(FileHtmlArgoEsStatus,'.html','_table.html'));
mput(ftpobj,strrep(FileHtmlArgoEsStatus,'.html','_tabla.txt'));
fprintf('     > Uploading  %s, %s \n',FileHtmlArgoEsStatus,strrep(FileHtmlArgoEsStatus,'.html','_tabla.txt'));

%% Writting Informe
if exist(FileNameInforme,'file')>0
    InformeOld=load(FileNameInforme);
    Incremento=DataArgoEs.iactiva-InformeOld.iactiva;
else
    Incremento=0;
end
if Incremento~=0
    Informe=sprintf('ArgoSpainStatus - https://www.argoespana.es/argoesstatus.html \n     Activos (%d,%d) Inactivos (%d) No desplegados (%d)\n     Fecha ultimo dato %s\n     Updated on %s',DataArgoEs.iactiva,Incremento,DataArgoEs.iinactiva,DataArgoEs.inodesplegada,datestr(max(DataArgoEs.FechaUltimoPerfil)),datestr(now));
else
    Informe=sprintf('ArgoSpainStatus - https://www.argoespana.es/argoesstatus.html \n     Activos (%d) Inactivos (%d) No desplegados (%d)\n     Fecha ultimo dato %s\n     Updated on %s',DataArgoEs.iactiva,DataArgoEs.iinactiva,DataArgoEs.inodesplegada,datestr(max(DataArgoEs.FechaUltimoPerfil)),datestr(now));
end
iactiva=DataArgoEs.iactiva;
juldsAS=DataArgoEs.FechaUltimoPerfil;
WMO=DataArgoEs.WMO;
save(FileNameInforme,'Informe','iactiva','juldsAS','WMO')
fprintf('%s <<<<< \n',mfilename)
