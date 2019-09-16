import sys
sys.path.append("/Users/pvb/Dropbox/Oceanografia/LibreriasPython")
#%matplotlib inline
import os
import matplotlib.colors
import matplotlib.pyplot as plt
#import cartopy.crs as ccrs
import numpy as np
import netCDF4
#import ncdump
import datetime as dt
import folium
import folium.plugins
import ftplib

#------------------------------------------------------------------------------
# Funciones
#------------------------------------------------------------------------------


def ReadArgoDailyFileDM(fichero_diario):
    nc_fid  =  netCDF4.Dataset(fichero_diario, 'r')  # Dataset is the class behavior to open the file
    nprof = nc_fid.dimensions['N_PROF'].size
    lats  =  nc_fid.variables['LATITUDE'][:]  # extract/copy the data
    lons  =  nc_fid.variables['LONGITUDE'][:]
    juld  =  netCDF4.num2date(nc_fid.variables['JULD'][:],units = nc_fid.variables['JULD'].units)
    pres  =  nc_fid.variables['PRES'][:]
    temp  =  nc_fid.variables['TEMP'][:]
    psal  =  nc_fid.variables['PSAL'][:]
    platform_number = netCDF4.chartostring(nc_fid.variables['PLATFORM_NUMBER'][:]).astype(float)
    project_name = netCDF4.chartostring(nc_fid.variables['PROJECT_NAME'][:])
    nc_fid.close()
    return nprof, lons, lats, juld, pres, temp, psal, platform_number, project_name

def ReadArgoFloatFileDM(fichero_boya):
    nc_fid  =  netCDF4.Dataset(fichero_boya, 'r')  # Dataset is the class behavior to open the file
    lats  =  nc_fid.variables['LATITUDE'][:]
    lons  =  nc_fid.variables['LONGITUDE'][:]
    juld  =  netCDF4.num2date(nc_fid.variables['JULD'][:],units = nc_fid.variables['JULD'].units)
    pres  =  nc_fid.variables['PRES'][:]
    temp  =  nc_fid.variables['TEMP'][:]
    nc_fid.close()
    return lons,lats,juld,pres,temp

#------------------------------------------------------------------------------
# Incio
#------------------------------------------------------------------------------

# Configuracion
#-----------------
#Time Span
#fecha_inicio = dt.date(2018,1,30)
fecha_inicio = dt.datetime.today()
# FechaF = now;
TrajectorySpanArgo = 90;
HidrographySpanArgo = 30;

#Geographical Region
lat_minIB =  15.00; lat_maxIB = 54
lon_minIB = -45;    lon_maxIB = 38
lat_min = -65
lat_max = 65
lon_min = -95
lon_max = 40

#Map
FoCentroArgoIb = [-20,20]
FoZoomArgoIb = 4

ColorArgoEs = 'red'
IconArgoEs = 'http://www.oceanografia.es/argo/imagenes/boyaroja.png'
ColorArgoIn = 'red'
IconArgoIn = 'http://www.oceanografia.es/argo/imagenes/boyaroja.png'
ColorArgoAll = 'white'
IconArgoAll = 'http://www.oceanografia.es/argo/imagenes/boyablanca.png'

#Files and dirs
PaginaWebDir = '/Users/pvb/Dropbox/Oceanografia/LibreriasMatlab/Programas/Argo/GetData'
DataDirGeo = '/Users/pvb/Data/Argo/geo/atlantic_ocean'
DataDirFloat = '/Users/pvb/Data/Argo/Floats'
FileArgoEs = '/Users/pvb/Dropbox/Oceanografia/LibreriasMatlab/Programas/Argo/GetData/FloatsArgoEs.dat'
FileArgoIn = '/Users/pvb/Dropbox/Oceanografia/LibreriasMatlab/Programas/Argo/GetData/FloatsArgoIn.dat'
FileHtmlArgoAtlanticStatus = 'ArgoStatusAtlantic.html'

#Titulo
TituloArgoIbStatus = 'en las aguas que rodean Espa&ntilde;a'

#Create hmtl map in folim
#-----------------
map_osm  =  folium.Map(location = [FoCentroArgoIb[1],FoCentroArgoIb[0]],
                detect_retina = 'True',
                zoom_start = FoZoomArgoIb,
                tiles = 'http://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}',
                attr = 'google',
                subdomains = ['mt0', 'mt1', 'mt2', 'mt3'])

#Trajectories for ArgoProject floats
#-----------------
for iPro in range(0,2):
    if iPro  ==  0:
        FileArgoPro = FileArgoEs
        ColorArgoPro = ColorArgoEs
    elif iPro  ==  1:
        FileArgoPro = FileArgoIn
        ColorArgoPro = ColorArgoAll
        
    APWMO = []
    text_file = open(FileArgoPro, "r")
    lines = text_file.readlines()
    text_file.close()
    APWMO = np.zeros(len(lines))
    for i1 in range(0,len(lines)):
        APWMO[i1] = float(lines[i1][9:-1])
    
    if iPro  ==  0:
        AEWMO = APWMO
    elif iPro  ==  1:
        AIWMO=APWMO

    #Read trajectoriess
    for ifloats in range(0,len(APWMO)):
        fichero_float = '{}/{:7.0f}/{:7.0f}_prof.nc'.format(DataDirFloat,APWMO[ifloats],APWMO[ifloats])
        if os.path.exists(fichero_float):
            lons,lats,juld,pres,temp =  ReadArgoFloatFileDM(fichero_float)
            X = lons[(juld>dt.datetime.today()-dt.timedelta(days = TrajectorySpanArgo)).nonzero()]
            Y = lats[(juld>dt.datetime.today()-dt.timedelta(days = TrajectorySpanArgo)).nonzero()]
            folium.PolyLine(np.column_stack((Y,X)).tolist() , 
                            color = ColorArgoPro ,
                            weight = 2).add_to(map_osm)
        

#Read the daily files
#-----------------
ntper = 0
for iday in range(0,HidrographySpanArgo):
    ifecha = fecha_inicio-dt.timedelta(days = iday)
    fichero_diario = '{}/{}_prof.nc'.format(DataDirGeo,ifecha.strftime("%Y/%m/%Y%m%d"))

    if os.path.exists(fichero_diario):
        nprof,lons,lats,juld,pres,temp, psal, platform_number,project_name  =  ReadArgoDailyFileDM(fichero_diario)

        for nper in range(0,nprof):
            #Reviso si los perfiles estan en la zona que quiero
            if lats[nper] > lat_min and lats[nper] < lat_max and lons[nper] > lon_min and lons[nper] < lon_max:
                if ntper == 0 :
                    lonsIB = lons[nper]
                    latsIB = lats[nper]
                    juldsIB = [juld[nper]]
                    platformes = platform_number[nper]
                    project_names=project_name[nper]
                    pp=pres[nper,:]
                    pt=temp[nper,:]
                    ps=psal[nper,:]
                    min_indices =np.ma.where(pp == pp.min())[0][0]
                    Surface_Value = '{:3.2f} dbar {:3.2f} ºC {:3.2f}'.format(float(pp[min_indices]),float(pt[min_indices]),float(ps[min_indices]))
                    Temp_surface = pt[min_indices]
                    max_indices =np.ma.where(pp == pp.max())[0][0]
                    Bottom_Value = '{:3.2f} dbar {:3.2f} ºC {:3.2f}'.format(float(pp[max_indices]),float(pt[max_indices]),float(ps[max_indices]))                    
                    ntper = ntper+1
                else:
                    if not((platformes == platform_number[nper]).any()):
                        ntper = ntper+1
                        lonsIB = np.append(lonsIB,lons[nper])
                        latsIB = np.append(latsIB,lats[nper])
                        juldsIB.append(juld[nper])
                        project_names = np.append(project_names,project_name[nper])
                        platformes = np.append(platformes,platform_number[nper])
                        pp=pres[nper,:]
                        pt=temp[nper,:]
                        ps=psal[nper,:]
                        max_indices =np.ma.where(pp == pp.max())
                        min_indices =np.ma.where(pp == pp.min())
                        if len(min_indices[0]) > 0:
                            min_indices = min_indices[0][0]
                            Surface_Value = np.append(Surface_Value,'{:3.2f} dbar {:3.2f} ºC {:3.2f}'.format(float(pp[min_indices]),float(pt[min_indices]),float(ps[min_indices])))                    
                            Temp_surface = np.append(Temp_surface,pt[min_indices])
                        else:
                            Surface_Value=np.append(Surface_Value,'')
                            Temp_surface=np.append(Temp_surface,np.nan)
                            
                        if len(max_indices[0]) > 0:
                            max_indices = max_indices[0][0]
                            Bottom_Value = np.append(Bottom_Value,'{:3.2f} dbar {:3.2f} ºC {:3.2f}'.format(float(pp[max_indices]),float(pt[max_indices]),float(ps[max_indices])))                    
                        else:
                            Bottom_Value= np.append(Bottom_Value,'')

  
#fig = plt.figure()
#ax = fig.add_subplot(1, 1, 1, projection = ccrs.PlateCarree())
#ax.set_extent([lon_min,lon_max,lat_min,lat_max], crs = ccrs.PlateCarree())
#ax.add_feature(cfeature.OCEAN, zorder = 0)
#ax.add_feature(cfeature.LAND, zorder = 0)
#ax.plot(lonsIB,latsIB,'.',ms = 1)

#Add icons for every float
#-----------------
cmap = plt.cm.RdBu.reversed()

for nper in range(1,len(lonsIB)):
#for nper in range(1,10):
    if (platformes[nper] == AEWMO).any():
        Color = ColorArgoEs
        Ventana1 = '<center><p>Float <b><a href = "http://www.oceanografia.es/argo/datos/ArgoEsGraficos/'+str(int(platformes[nper]))
        Ventana2 = '.html" target = "_blank">'+str(int(platformes[nper]))+'</a></b><br><b>'+str(project_names[nper])
        Ventana3 = '</b><br><b>Last profile&nbsp;</b>'+(juldsIB[nper]).strftime("%d %h %Y %H:%M")
        Ventana4 = '<br><b>Surface&nbsp;</b>'+Surface_Value[nper]
        Ventana5 = '<br><b>Botton&nbsp;</b>'+Bottom_Value[nper]+'</p></center>'
        Radio = 4
        icono = folium.features.CustomIcon(IconArgoEs,icon_size = (33,31))  # Creating a custom Icon

    elif (platformes[nper] == AIWMO).any():
        Color = ColorArgoIn
        Ventana1 = '<center><p>Float <b><a href = "http://www.oceanografia.es/argo/datos/ArgoEsGraficos/'+str(int(platformes[nper]))
        Ventana2 = '.html" target = "_blank">'+str(int(platformes[nper]))+'</a></b><br><b>'+str(project_names[nper])
        Ventana3 = '</b><br><b>Last profile&nbsp;</b>'+(juldsIB[nper]).strftime("%d %h %Y %H:%M")
        Ventana4 = '<br><b>Surface&nbsp;</b>'+Surface_Value[nper]
        Ventana5 = '<br><b>Botton&nbsp;</b>'+Bottom_Value[nper]+'</p></center>'
        Radio = 4
        icono = folium.features.CustomIcon(IconArgoIn,icon_size = (33,31))  # Creating a custom Icon

    else:
        Color = ColorArgoAll
        Ventana1 = '<center><p>Float <b><a href = "http://www.ifremer.fr/argoMonitoring/float/'+str(int(platformes[nper]))
        Ventana2 = '.html" target = "_blank">'+str(int(platformes[nper]))+'</a></b><br><b>'+str(project_names[nper])
        Ventana3 = '</b><br><b>Last profile&nbsp;</b>'+(juldsIB[nper]).strftime("%d %h %Y %H:%M")
        Ventana4 = '<br><b>Surface&nbsp;</b>'+Surface_Value[nper]
        Ventana5 = '<br><b>Botton&nbsp;</b>'+Bottom_Value[nper]+'</p></center>'
        icono = folium.features.CustomIcon(IconArgoAll,icon_size = (33,31))  # Creating a custom Icon
        Radio = 3

    Ventana = Ventana1+Ventana2+Ventana3+Ventana4+Ventana5

#    folium.Marker([latsIB[nper],lonsIB[nper]],
#                        icon=icono,
#                        popup = folium.Popup(folium.Html(Ventana, script = True))).add_to(map_osm)

    folium.CircleMarker([latsIB[nper],lonsIB[nper]],
                        radius = Radio, color = matplotlib.colors.to_hex(cmap((Temp_surface[nper]-min(Temp_surface))/(max(Temp_surface)-min(Temp_surface)))), fill='true',
                        popup = folium.Popup(folium.Html(Ventana, script = True))).add_to(map_osm)

#Adding legend to the map
folium.plugins.FloatImage('http://www.oceanografia.es/argo/imagenes/Leyenda.png', bottom = 90, left = 80).add_to(map_osm)
folium.Html('<h1>This is a title</h1>').add_to(map_osm)

#Adding grid lines
for il in range(-180,180,6):
    folium.PolyLine([[90,il],[-90,il]],color = 'white' , weight = 1, opacity=0.2).add_to(map_osm)
for il in range(-90,90,6):
    folium.PolyLine([[il,-180],[il,180]],color = 'white' , weight = 1, opacity=0.2).add_to(map_osm)

#add pop up with Lon Lat
map_osm.add_child(folium.LatLngPopup())
map_osm.add_child(folium.plugins.Fullscreen())
map_osm.add_child(folium.plugins.MeasureControl())

#Save map
map_osm.save(FileHtmlArgoAtlanticStatus)

#Ftp Maps
ftp = ftplib.FTP("ftp.oceanografia.es")
ftp.login("oceanografia.es", "JoaquinP2018")
ftp.cwd("/html")
file = open(FileHtmlArgoAtlanticStatus,'rb')                  # file to send
ftp.storbinary('STOR '+FileHtmlArgoAtlanticStatus, file)     # send the file
file.close() 
