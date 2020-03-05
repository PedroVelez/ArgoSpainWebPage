#!/bin/bash

Verbose=0
JustUpload=0 #Si es 1 solo sube los datos. Si es 0 actualiza y sube los datos

PaginaWebDir=$HOME/Dropbox/Oceanografia/Proyectos/ArgoSpainWebpage
DirLog=$PaginaWebDir/Log

strval=$(uname -a)
if [[ $strval == *Okapi* ]];
then
  MatVersion=/Applications/MATLAB_R2019b.app/bin/matlab
fi
if [[ $strval == *vibrio* ]];
then
  MatVersion=/home/pvb/Matlab/Matlab2019b/bin/matlab
fi

#------------------------------------
#Inicio
#------------------------------------

/bin/rm -f $DirLog/ArgoSpainWebPage*.log

printf ">>>> Updating ArgoSpainWebArgo \n"
printf "  Verbose $Verbose JustUpload $JustUpload \n"
printf "  PaginaWebDir $PaginaWebDir \n"
printf "  DirLog       $DirLog \n"


#------------------------------------
#Convierte la ArgoGreyList a mat
#------------------------------------
 printf "  Updating grey list\n"
if [ $Verbose -eq 1 ]
then
   cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'GetArgoGreyList2mat;exit'
else
   cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'GetArgoGreyList2mat;exit' >> $DirLog/ArgoSpainWebPage_GreyList.log
fi

#------------------------------------
# Update the files for the web page
#------------------------------------
if [ $JustUpload == 0 ]
then
   /bin/rm -f $PaginaWebDir/Log/ErrorArgoEsLeeDatos.mat
   /bin/rm -f $PaginaWebDir/Data/DataArgoEs.mat
   /bin/rm -f $PaginaWebDir/Data/DataArgoIn.mat

# Updating data sets
  printf "  Updating data sets\n"
  if [ $Verbose -eq 1 ]
  then
    cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'ArgoEsReadData;exit'
  else
    cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'ArgoEsReadData;exit' >> $DirLog/ArgoSpainWebPage_ReadData.log
  fi

#Update Ib GoogleMap
   printf "  Updating Ib GoogleMap\n"
   if [ $Verbose -eq 1 ]
   then
     cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'ArgoIbStatusGM;exit'
   else
     cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'ArgoIbStatusGM;exit' >> $DirLog/ArgoSpainWebPage_IbStatusGM.log
   fi

#Update ArgoEs GoogleMap
   printf "  Updating ArgoEs GoogleMap\n"
   if [ $Verbose -eq 1 ]
   then
    cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'ArgoEsStatusGM;exit'
   else
    cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'ArgoEsStatusGM;exit' >> $DirLog/ArgoSpainWebPage_EsAEGM.log
   fi

#Update Update Argo Atlatic GoogleMap
  printf "  Updating Argo Atlatic GoogleMap\n"
  if [ $Verbose -eq 1 ]
  then
     cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'ArgoStatus;exit'
  else
     cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'ArgoStatus;exit' >> $DirLog/ArgoSpainWebPage_StatusGM.log
   fi

#Update ArgoEs figures
  printf "  Updating and upload ArgoEs figures\n"
   if [ $Verbose -eq 1 ]
   then
    cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'ArgoEsStatus;exit'
   else
    cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'ArgoEsStatus;exit' >> $DirLog/ArgoSpainWebPage_EsStatus.log
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
if [ $JustUpload == 0 ]
then
   printf "  Deleting local copy of ArgoEs figures\n"
   /bin/rm -f $PaginaWebDir/Html/ArgoEsGraficos/* >> $DirLog/ActualizaPaginaWebArgoEsBorra.log
fi

#------------------------------------
# Send reports by email
#------------------------------------
printf "  Send reports by email \n"
if [ $JustUpload == 0 ]
then
  cd $PaginaWebDir
  if [ $Verbose -eq 1 ]
  then
    cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'ArgoEsSendReport;exit'
  else
    cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'ArgoEsSendReport;exit' >> $DirLog/ArgoSpainWebPage_EsSendReport.log
  fi
fi

#------------------------------------
# Copy data to the remote server
#------------------------------------
#printf "  Copy data to the remote server \n"
#if [ $JustUpload == 0 ]
#then
#  cp $PaginaWebDir/Data/DataArgoEs.mat /Volumes/GDOYE$/Proyectos/Argo/DelayedMode/Data
#fi

printf "<<<<< Updated PaginaWebArgoEs \n"
