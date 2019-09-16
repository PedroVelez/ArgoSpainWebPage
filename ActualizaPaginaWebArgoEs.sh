#!/bin/bash

Verbose=0
SoloSube=0 #Si es 1 solo sube los datos. Si es 0 actualiza y sube los datos

PaginaWebDir=/Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebArgoEs
DirLog=$PaginaWebDir/Log

MatVersion=/Applications/MATLAB_R2019a.app/bin/matlab

/bin/rm -f $DirLog/*.log

printf ">>>> Updating PaginaWebArgoEs \n"
printf "  Verbose $Verbose SoloSube $SoloSube \n"
printf "  PaginaWebDir $PaginaWebDir \n"
printf "  DirLog      $DirLog \n"


#------------------------------------
#Convierte la ArgoGreyList a mat
#------------------------------------
 printf "  Updating grey list\n"
 if [ $Verbose -eq 1 ]
 then
   $MatVersion -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebArgoEs;GetArgoGreyList2mat;exit'
 else
   $MatVersion -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebArgoEs;GetArgoGreyList2mat;exit' >> $DirLog/ActualizaPaginaWebArgoEs.log
  fi

#------------------------------------
# Update the files for the web page
#------------------------------------
if [ $SoloSube == 0 ]
then
  /bin/rm -f $PaginaWebDir/Log/ErrorArgoEsLeeDatos.mat
  /bin/rm -f $PaginaWebDir/Data/DataArgoEs.mat
  /bin/rm -f $PaginaWebDir/Data/DataArgoIn.mat

# Updating data sets
  printf "  Updating data sets\n"
  if [ $Verbose -eq 1 ]
  then
  $MatVersion -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebArgoEs;ArgoEsLeeDatos;exit'
  else
  $MatVersion -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebArgoEs;ArgoEsLeeDatos;exit' >> $DirLog/ActualizaPaginaWebArgoEs.log
  fi

#Update Ib GoogleMap
  printf "  Update Ib GoogleMap\n"
  if [ $Verbose -eq 1 ]
  then
  $MatVersion -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebArgoEs;ArgoIbStatusGM;exit'
  else
  $MatVersion -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebArgoEs;ArgoIbStatusGM;exit' >> $DirLog/ActualizaPaginaWebArgoEs.log
  fi

#Update ArgoEs GoogleMap
  printf "  Update ArgoEs GoogleMap\n"
  if [ $Verbose -eq 1 ]
  then
  $MatVersion -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebArgoEs;ArgoEsStatusGM;exit'
  else
  $MatVersion -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebArgoEs;ArgoEsStatusGM;exit' >> $DirLog/ActualizaPaginaWebArgoEs.log
  fi

 #Update ArgoEs figures
  printf "  Update ArgoEs figures\n"
  if [ $Verbose -eq 1 ]
  then
  $MatVersion -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebArgoEs;ArgoEsStatusGraficos;exit'
  else
  $MatVersion -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebArgoEs;ArgoEsStatusGraficos;exit' >> $DirLog/ActualizaPaginaWebArgoEs.log

#Update Update Argo Atlatic GoogleMap
  printf "  Update Argo Atlatic GoogleMap\n"
  if [ $Verbose -eq 1 ]
  then
  $MatVersion -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebArgoEs;ArgoStatus;exit'
  else
  $MatVersion -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebArgoEs;ArgoStatus;exit' >> $DirLog/ActualizaPaginaWebArgoEs.log
  fi

  fi
fi

#------------------------------------
# Upload status (html) files to the web server
#------------------------------------
#Ahora esto se hace desde los scripts
#printf "  Upload status files to the web server\n"
#/usr/local/bin/ncftpput -a OceanografiaES /html/argo/html_files  *.html
##Metodo antiguo usando ncftp
##cd $PaginaWebDir/Html
##/usr/local/bin/ncftp OceanografiaEs << ftpEOF >> $DirLog/ActualizaPaginaWebArgoEs_SubeficherosHtml.log
##  cd /html/argo/html_files
##  put -fa argoibstatusgm.html
##  put -fa argoesstatusgm.html
##  quit
##ftpEOF

#------------------------------------
# Upload file from ArgoEsGraficos to the web server
#------------------------------------
#Ahora esto se hace desde los scripts
#printf "  Upload files from ArgoEsGraficos to the web server\n"
#cd $PaginaWebDir/Html/ArgoEsGraficos
#/usr/local/bin/ncftpput OceanografiaES /html/argo/datos/ArgoEsGraficos *.png >> #$DirLog/ActualizaPaginaWebArgoEs.log
#/usr/local/bin/ncftpput -a OceanografiaES /html/argo/datos/ArgoEsGraficos *.html >> #$DirLog/ActualizaPaginaWebArgoEs.log

#Borra ficheros ArgoEsGraficos
if [ $SoloSube == 0 ]
then
  /bin/rm -f $PaginaWebDir/Html/ArgoEsGraficos/* >> $DirLog/ActualizaPaginaWebArgoEs.log
fi

#------------------------------------
# Send reports by email
#------------------------------------
printf "  Send reports by email \n"
if [ $SoloSube == 0 ]
then
  cd $PaginaWebDir
  if [ $Verbose -eq 1 ]
  then
  $MatVersion -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebArgoEs;ArgoEsEnviaInforme;exit'
  else
  $MatVersion -nodisplay -nosplash -r 'cd /Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebArgoEs;ArgoEsEnviaInforme;exit' >> $DirLog/ActualizaPaginaWebArgoEs.log
  fi
fi

#------------------------------------
# Copy data to the remote server
#------------------------------------
#printf "  Copy data to the remote server \n"
#if [ $SoloSube == 0 ]
#then
#  cp $PaginaWebDir/Data/DataArgoEs.mat /Volumes/GDOYE$/Proyectos/Argo/DelayedMode/Data
#fi

printf "<<<<< Updated PaginaWebArgoEs \n"
