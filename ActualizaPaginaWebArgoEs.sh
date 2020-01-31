#!/bin/bash

Verbose=0
SoloSube=0 #Si es 1 solo sube los datos. Si es 0 actualiza y sube los datos

PaginaWebDir=$HOME/Dropbox/Oceanografia/Proyectos/PaginaWebArgoEs
DirLog=$PaginaWebDir/Log

strval=$(uname -a)
if [[ $strval == *Okapi* ]];
then
  MatVersion=/Applications/MATLAB_R2019b.app/bin/matlab
else
  MatVersion=matlab
fi

#------------------------------------
#Inicio
#------------------------------------

/bin/rm -f $DirLog/ActualizaPaginaWebArgoEs*.log

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
   $MatVersion -nodisplay -nosplash -r 'cd $PaginaWebDir;GetArgoGreyList2mat;exit'
 else
   $MatVersion -nodisplay -nosplash -r 'cd $PaginaWebDir;GetArgoGreyList2mat;exit' >> $DirLog/ActualizaPaginaWebArgoEsGreyList.log
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
  $MatVersion -nodisplay -nosplash -r 'cd $PaginaWebDir;ArgoEsLeeDatos;exit'
  else
  $MatVersion -nodisplay -nosplash -r 'cd $PaginaWebDir;ArgoEsLeeDatos;exit' >> $DirLog/ActualizaPaginaWebArgoEsLeeDatos.log
  fi

#Update Ib GoogleMap
  printf "  Update Ib GoogleMap\n"
  if [ $Verbose -eq 1 ]
  then
  $MatVersion -nodisplay -nosplash -r 'cd $PaginaWebDir;ArgoIbStatusGM;exit'
  else
  $MatVersion -nodisplay -nosplash -r 'cd $PaginaWebDir;ArgoIbStatusGM;exit' >> $DirLog/ActualizaPaginaWebArgoEsIBGM.log
  fi

#Update ArgoEs GoogleMap
  printf "  Update ArgoEs GoogleMap\n"
  if [ $Verbose -eq 1 ]
  then
  $MatVersion -nodisplay -nosplash -r 'cd $PaginaWebDir;ArgoEsStatusGM;exit'
  else
  $MatVersion -nodisplay -nosplash -r 'cd $PaginaWebDir;ArgoEsStatusGM;exit' >> $DirLog/ActualizaPaginaWebArgoEsAEGM.log
  fi

  #Update Update Argo Atlatic GoogleMap
    printf "  Update Argo Atlatic GoogleMap\n"
    if [ $Verbose -eq 1 ]
    then
    $MatVersion -nodisplay -nosplash -r 'cd $PaginaWebDir;ArgoStatus;exit'
    else
    $MatVersion -nodisplay -nosplash -r 'cd $PaginaWebDir;ArgoStatus;exit' >> $DirLog/ActualizaPaginaWebArgoEsATGM.log
    fi

 #Update ArgoEs figures
  printf "  Update ArgoEs figures\n"
  if [ $Verbose -eq 1 ]
  then
  $MatVersion -nodisplay -nosplash -r 'cd $PaginaWebDir;ArgoEsStatusGraficos;exit'
  else
  $MatVersion -nodisplay -nosplash -r 'cd $PaginaWebDir;ArgoEsStatusGraficos;exit' >> $DirLog/ActualizaPaginaWebArgoEsAEFigures.log
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
  /bin/rm -f $PaginaWebDir/Html/ArgoEsGraficos/* >> $DirLog/ActualizaPaginaWebArgoEsBorra.log
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
  $MatVersion -nodisplay -nosplash -r 'cd $PaginaWebDir;ArgoEsEnviaInforme;exit'
  else
  $MatVersion -nodisplay -nosplash -r 'cd $PaginaWebDir;ArgoEsEnviaInforme;exit' >> $DirLog/ActualizaPaginaWebArgoEsEnvioMail.log
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
