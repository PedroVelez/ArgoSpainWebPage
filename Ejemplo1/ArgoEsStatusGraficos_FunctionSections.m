function ArgoEsStatusGraficos_FunctionSections(OneFloatData,Limits);

% Limites de los ejes
hT1P=[0.06 0.83 0.807  0.13];
hT2P=[0.06 0.55 0.807  0.27];
hTCP=[0.88 0.55 0.0358 0.41];

hS1P=[0.06 0.34 0.807  0.13];
hS2P=[0.06 0.06 0.807  0.27];
hSCP=[0.88 0.06 0.0358 0.41];

RepresentaOxigen=0;
if isfield(OneFloatData,'oxysA')
    if ~isempty(OneFloatData.oxysA)
        if size(OneFloatData.oxysA,2)>1 && sum(isnan(OneFloatData.oxysA(:))) ~= length(OneFloatData.oxysA(:))
            RepresentaOxigen=0;
            hT1P=[0.06 0.85 0.807  0.080];
            hT2P=[0.06 0.67 0.807  0.172];
            hTCP=[0.88 0.67 0.0358 0.260];
            
            hS1P=[0.06 0.54 0.807  0.080];
            hS2P=[0.06 0.36 0.807  0.172];
            hSCP=[0.88 0.36 0.0358 0.260];
            
            hO1P=[0.06 0.23 0.807  0.080];
            hO2P=[0.06 0.05 0.807  0.172];
            hOCP=[0.88 0.05 0.0358 0.260];
        end
    end
end

rangoS=[5 10 15 20 25];
rangoT=[35 35.5 36 36.5 37 37.5 38];
rangoO=[50 100 150 200 250 300 350 400];

%Test for monotonic increase in julds
[SjuldsA,IA,IC] = unique(OneFloatData.juldsA);
if length(SjuldsA)~=length(OneFloatData.juldsA) || issorted(OneFloatData.juldsA)==0
    OneFloatData.temsA=OneFloatData.temsA(:,IA);
    OneFloatData.presA=OneFloatData.presA(:,IA);
    OneFloatData.salsA=OneFloatData.salsA(:,IA);
    OneFloatData.juldsA=SjuldsA;
    if RepresentaOxigen==1
            OneFloatData.oxysA=OneFloatData.oxysA(:,IA);
    end
end

color=linspace(1,64,length(OneFloatData.juldsA));
cl=parula;
if size(OneFloatData.juldsA,2)>5
    LV=ceil(linspace(1,size(OneFloatData.juldsA,2),5));
end

presiar=[1:10:Limits.maxP]';

%% Temperature
if size(OneFloatData.temsA,2)>1 && sum(isnan(OneFloatData.temsA(:))) ~= length(OneFloatData.temsA(:))
    rangoG=nice([Limits.minT  Limits.maxT],2);
    if isnan(sum(rangoG))==1
        rangoG=rangoT;
    end
    for inp=1:size(OneFloatData.temsA,2)
        ptem=OneFloatData.temsA(:,inp);
        ppre=OneFloatData.presA(:,inp);
        ptem(ptem>Limits.maxT)=NaN;
        ptem(ptem<Limits.minT)=NaN;
        ind=find(isnan(ptem)==0 & isnan(ppre)==0);
        ptem=ptem(ind);
        ppre=ppre(ind);
        if length(ptem)>2
            [ppre,I,J] = unique(ppre);
            ptem=ptem(I);
            temsAi(:,inp)= interp1(ppre,ptem,presiar);
        else
            temsAi(:,inp)=presiar.*NaN;
        end
    end
    
    hT1=axes('position',hT1P);hT1P=get(hT1,'position');
    temsAic=temsAi(1:Locate(presiar,-Limits.UpperPL(1))+1,:);
    [~,ch]=contourf(OneFloatData.juldsA,-presiar(1:Locate(presiar,-Limits.UpperPL(1))+1),temsAic,linspace(Limits.minT,Limits.maxT,40));set(ch,'edgecolor','none');hold on
    contour(OneFloatData.juldsA,-presiar(1:Locate(presiar,-Limits.UpperPL(1))+1),temsAic,rangoG(1:2:end),'color',[0.6 0.6 0.6],'linewidth',0.15);
    [cs,h]=contour(OneFloatData.juldsA,-presiar(1:Locate(presiar,-Limits.UpperPL(1))+1),temsAic,rangoG(1:4:end),'color',[0.6 0.6 0.6],'linewidth',0.15);
    axis([Limits.minJ Limits.maxJ Limits.UpperPL])
    caxis([Limits.minT Limits.maxT])
    title(strcat('Temperature [ITS-90]',sprintf('   [%5.2f - %5.2f]',nanmin(temsAi(:)),nanmax(temsAi(:)))),'fontsize',8,'VerticalAlignment','baseline')
        
    hT2=axes('position',hT2P);hT2P=get(hT2,'position');
    temsAic=temsAi(Locate(presiar,-Limits.UpperPL(1)):end,:);
    [~,ch]=contourf(OneFloatData.juldsA,-presiar(Locate(presiar,-Limits.UpperPL(1)):end),temsAic,linspace(Limits.minT,Limits.maxT,40));set(ch,'edgecolor','none');hold on
    contour(OneFloatData.juldsA,-presiar(Locate(presiar,-Limits.UpperPL(1)):end),temsAic,rangoG(1:2:end),'color',[0.6 0.6 0.6],'linewidth',0.15);hold on
    [cs,h]=contour(OneFloatData.juldsA,-presiar(Locate(presiar,-Limits.UpperPL(1)):end),temsAic,rangoG(1:1:end),'color',[0.6 0.6 0.6],'linewidth',0.15);hold on
    axis([Limits.minJ Limits.maxJ Limits.DeepPL])
    datetick('x',12,'keepLimits')
    colormap(jet)
    caxis([Limits.minT Limits.maxT])
    
    hTC=colorbar;
    hTC.FontSize=6;
    hTC.Color=[0.5 0.5 0.5];
    hTC.LineWidth=0.1;
    hTC.Position=hTCP;
    
    hT1.Position=hT1P;
    hT1.XLim=hT2.XLim;
    hT1.XTick=hT2.XTick;
    hT1.XTickLabel=[];
    hT1.FontSize=7;
    hT1.TitleFontWeight='normal';
    hT1.XColor=[0.5 0.5 0.5];
    hT1.YColor=[0.5 0.5 0.5];
    hT1.XMinorTick='on';
    hT1.XAxis.MinorTickValues=OneFloatData.juldsA;
    
    hT2.Position=hT2P;
    hT2.FontSize=7;
    hT2.TitleFontWeight='normal';
    hT2.XColor=[0.5 0.5 0.5];
    hT2.YColor=[0.5 0.5 0.5];
    hT2.XMinorTick='on';
    hT2.XAxis.MinorTickValues=OneFloatData.juldsA;
end

%% Salinity
if size(OneFloatData.salsA,2)>1 && sum(isnan(OneFloatData.salsA(:))) ~= length(OneFloatData.salsA(:))
    rangoG=nice([Limits.minS Limits.maxS],2);
    if isnan(sum(rangoG))==1
        rangoG=rangoS;
    end
    for inp=1:size(OneFloatData.temsA,2)
        psal=OneFloatData.salsA(:,inp);
        ppre=OneFloatData.presA(:,inp);
        psal(psal>Limits.maxS)=NaN;
        psal(psal<Limits.minS)=NaN;
        ind=find(isnan(psal)==0 & isnan(ppre)==0);
        psal=psal(ind);
        ppre=ppre(ind);
        if length(psal)>2
            [ppre,I,J] = unique(ppre);
            psal=psal(I);
            salsAi(:,inp)= interp1(ppre,psal,presiar);
        else
            salsAi(:,inp)=presiar.*NaN;
                   end
    end
    hS1=axes('position',hS1P);hS1P=get(hS1,'position');
    salsAic=salsAi(1:Locate(presiar,-Limits.UpperPL(1))+1,:);
    [~,ch]=contourf(OneFloatData.juldsA,-presiar(1:Locate(presiar,-Limits.UpperPL(1))+1),salsAic,linspace(Limits.minS,Limits.maxS,40));set(ch,'edgecolor','none');hold on
    contour(OneFloatData.juldsA,-presiar(1:Locate(presiar,-Limits.UpperPL(1))+1),salsAic,rangoG(1:2:end),'color',[0.6 0.6 0.6],'linewidth',0.15);hold on
    [cs,h]=contour(OneFloatData.juldsA,-presiar(1:Locate(presiar,-Limits.UpperPL(1))+1),salsAic,rangoG(1:4:end),'color',[0.6 0.6 0.6],'linewidth',0.15);hold on
    axis([Limits.minJ Limits.maxJ Limits.UpperPL])
    caxis([Limits.minS Limits.maxS])
    title(strcat('Salinity [psu]',sprintf('   [%5.2f - %5.2f]',nanmin(salsAi(:)),nanmax(salsAi(:)))),'fontsize',8,'VerticalAlignment','baseline')
    
    hS2=axes('position',hS2P);hS2P=get(hS2,'position');
    salsAic=salsAi(Locate(presiar,-Limits.UpperPL(1)):end,:);
    [~,ch]=contourf(OneFloatData.juldsA,-presiar(Locate(presiar,-Limits.UpperPL(1)):end),salsAic,linspace(Limits.minS,Limits.maxS,40));set(ch,'edgecolor','none');hold on
    contour(OneFloatData.juldsA,-presiar(Locate(presiar,-Limits.UpperPL(1)):end),salsAic,rangoG(1:2:end),'color',[0.6 0.6 0.6],'linewidth',0.15);hold on
    [cs,h]=contour(OneFloatData.juldsA,-presiar(Locate(presiar,-Limits.UpperPL(1)):end),salsAic,rangoG(1:1:end),'color',[0.6 0.6 0.6],'linewidth',0.15);hold on
    axis([Limits.minJ Limits.maxJ Limits.DeepPL])
    datetick('x',12,'keepLimits')
    colormap(jet)
    caxis([Limits.minS Limits.maxS])
    
    hSC=colorbar;
    hSC.FontSize=6;
    hSC.Color=[0.5 0.5 0.5];
    hSC.LineWidth=0.1;
    hSC.Position=hSCP;
    
    hS1.Position=hS1P;
    hS1.XLim=hS2.XLim;
    hS1.XTick=hS2.XTick;
    hS1.XTickLabel=[];
    hS1.FontSize=7;
    hS1.TitleFontWeight='normal';
    hS1.XColor=[0.5 0.5 0.5];
    hS1.YColor=[0.5 0.5 0.5];
    hS1.XMinorTick='on';
    hS1.XAxis.MinorTickValues=OneFloatData.juldsA;
    
    hS2.Position=hS2P;
    hS2.FontSize=7;
    hS2.TitleFontWeight='normal';
    hS2.XColor=[0.5 0.5 0.5];
    hS2.YColor=[0.5 0.5 0.5];
    hS2.XMinorTick='on';
    hS2.XAxis.MinorTickValues=OneFloatData.juldsA;
    
end
%% Oxygen
if RepresentaOxigen==1
    rangoG=nice([Limits.minO Limits.maxO],2);
    if isnan(sum(rangoG))==1
        rangoG=rangoO;
    end
    for inp=1:size(OneFloatData.oxysA,2)
        poxy=OneFloatData.oxysA(:,inp);
        ppre=OneFloatData.presA(:,inp);
        poxy(poxy>maxO)=NaN;
        poxy(poxy<minO)=NaN;
        ind=find(isnan(poxy)==0 & isnan(ppre)==0);
        poxy=poxy(ind);
        ppre=ppre(ind);
        if length(poxy)>2
            [ppre,I,J] = unique(ppre);
            ptem=poxy(I);
            oxysAi(:,inp)= interp1(ppre,poxy,presiar);
        else
            oxysAi(:,inp)=presiar.*NaN;
        end
    end
    hO1=axes('position',[x0 0.23 dx 0.08]);hO1P=get(hO1,'position');
    [~,ch]=contourf(OneFloatData.juldsA,-presiar,oxysAi,linspace(Limits.minO,Limits.maxO,40));set(ch,'edgecolor','none');hold on
    contour(OneFloatData.juldsA,-presiar,oxysAi,rangoG(1:2:end),'color',[0.6 0.6 0.6],'linewidth',0.15);hold on
    [cs,h]=contour(OneFloatData.juldsA,-presiar,oxysAi,rangoG(1:4:end),'color',[0.6 0.6 0.6],'linewidth',0.15);hold on
    %cl=clabel(cs,'fontsize',6,'color','k','rotation',0,'BackgroundColor','w','margin',1);
    axis([Limits.minJ Limits.maxJ Limits.UpperPL])
    caxis([Limits.minO Limits.maxO])
    title(strcat('Dissolved oxygen [micromole/kg]',sprintf('   [%5.2f - %5.2f]',nanmin(OneFloatData.oxysAi(:)),nanmax(OneFloatData.oxysAi(:)))),'fontsize',8,'VerticalAlignment','baseline')
    
    hO2=axes('position',[x0 0.05 dx 0.172]);hO2P=get(hO2,'position');
    [~,ch]=contourf(OneFloatData.juldsA,-presiar,oxysAi,linspace(minO,maxO,40));set(ch,'edgecolor','none');hold on
    contour(OneFloatData.juldsA,-presiar,oxysAi,rangoG(1:2:end),'color',[0.6 0.6 0.6],'linewidth',0.15);hold on
    [cs,h]=contour(OneFloatData.juldsA,-presiar,oxysAi,rangoG(1:1:end),'color',[0.6 0.6 0.6],'linewidth',0.15);hold on
    %cl=clabel(cs,'fontsize',6,'color','k','rotation',0,'BackgroundColor','w','margin',1);
    axis([Limits.minJ Limits.maxJ Limits.DeepPL])
    datetick('x',12,'keepLimits')
    colormap(jet)
    caxis([Limits.minO Limits.maxO])
    hOC=colorbar;
    set(hOC,'position',hOCP);
    hOC.FontSize=6;
    hOC.Color=[0.5 0.5 0.5];
    hOC.LineWidth=0.1;
    set(hO2,'position',hO2P);
    set(hO1,'position',hO1P);
    set(hO1,'xlim',get(hO2,'xlim'))
    set(hO1,'xtick',get(hO2,'xtick'))
    set(hO1,'xtickLabel',[])
    hO1.FontSize=7;
    hO1.TitleFontWeight='normal';
    hO1.XColor=[0.5 0.5 0.5];
    hO1.YColor=[0.5 0.5 0.5];
    hO2.FontSize=7;
    hO2.TitleFontWeight='normal';
    hO2.XColor=[0.5 0.5 0.5];
    hO2.YColor=[0.5 0.5 0.5];
end

clear presiar temsAi salsAi oxysAi
