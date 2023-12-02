#!/bin/bash

Verbose=0
JustUpload=0 #Si es 1 solo sube los datos. Si es 0 actualiza y sube los datos

# Depending on the computer setup the folders
# And the path of the matlab application
strval=$(uname -a)
if [[ $strval == *Okapi* ]];
then
  MatVersion=/Applications/MATLAB_R2019b.app/bin/matlab
  DirRaiz=$HOME/Dropbox/Oceanografia
  DirArgoData=$DirRaiz/Oceanografia/Data/Argo
  DirArgoDataCopy=/data/shareddata/Argo
fi
if [[ $strval == *vibrio* ]];
then
  MatVersion=/home/pvb/Matlab/bin/matlab
  DirRaiz=$HOME/Dropbox/Oceanografia
  DirArgoData=$DirRaiz/Oceanografia/Data/Argo
  DirArgoDataCopy=/data/shareddata/Argo
fi
if [[ $strval == *rossby* ]];
then
  MatVersion=/usr/bin/matlab
  DirRaiz=$HOME
  DirArgoData=$DirRaiz/Data/Argo
  DirArgoDataCopy=/data/shareddata/Argo
fi

PaginaWebDir=$DirRaiz/Analisis/ArgoSpainWebpage
DirLog=$PaginaWebDir/log

#------------------------------------
# Inicio
#------------------------------------

/bin/rm -f $DirLog/ArgoSpainWebPage*.log

printf ">>>> Updating ArgoSpainWebArgo \n"
printf "  Verbose $Verbose JustUpload $JustUpload \n"
printf "  PaginaWebDir $PaginaWebDir \n"
printf "  DirLog       $DirLog \n"
printf "  DirRaiz      $DirRaiz \n"


#------------------------------------
#Convierte la ArgoGreyList a mat
#------------------------------------
 printf "  Updating argo grey list\n"
if [ $Verbose -eq 1 ]
then
   cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'getArgoGreyList2mat;exit'
else
   cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'getArgoGreyList2mat;exit' > $DirLog/getArgoGreyList2mat.log
fi

#------------------------------------
# Update the files for the web page
#------------------------------------
if [ $JustUpload == 0 ]
then
   /bin/rm -f $PaginaWebDir/log/ErrorArgoEsLeeDatos.mat
   /bin/rm -f $PaginaWebDir/data/dataArgoSpain.mat
   /bin/rm -f $PaginaWebDir/data/dataArgoInterest.mat

# Updating data sets
  printf "  Updating data sets, ArgoSpain and ArgoInterest\n"
  if [ $Verbose -eq 1 ]
  then
    cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'readArgoSpainData;exit'
  else
    cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'readArgoSpainData;exit' > $DirLog/readArgoSpainData.log
  fi

#Update Ib GoogleMap
#   printf "  Updating google map for Argo in the region\n"
#   if [ $Verbose -eq 1 ]
#   then
#     cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'createArgoRegionGMap;exit'
#   else
#     cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'createArgoRegionGMap;exit' > $DirLog/createArgoRegionGMap.log
#   fi
#Update ArgoEs GoogleMap
#   printf "  Updating google map for Argo Spain\n"
#   if [ $Verbose -eq 1 ]
#   then
#    cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'createArgoSpainGMap;exit'
#   else
#    cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'createArgoSpainGMap;exit' > $DirLog/createArgoSpainGMap.log
#   fi

#Updating leaflet map for Argo in the region
   printf "  Updating leaflet map for Argo in the region\n"
   if [ $Verbose -eq 1 ]
   then
     cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'createArgoRegionLLet;exit'
   else
     cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'createArgoRegionLLet;exit' > $DirLog/createArgoRegionLLet.log
   fi

#Updating leaflet map for Argo Spain
    printf "  Updating leaflet map for Argo Spain\n"
    if [ $Verbose -eq 1 ]
    then
     cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'createArgoSpainLLet;exit'
    else
     cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'createArgoSpainLLet;exit' > $DirLog/createArgoSpainLlet.log
    fi

#Updating table with the statistics of Argo Spain
  printf "  Updating table with the statistics of Argo Spain\n"
  if [ $Verbose -eq 1 ]
  then
   cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'createArgoSpainTable;exit'
  else
   cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'createArgoSpainTable;exit' > $DirLog/createArgoSpainTable.log
  fi

#Update ArgoEs figures
  printf "  Updating and upload webpages for the ArgoSpain and ArgoInterest figures\n"
  if [ $Verbose -eq 1 ]
  then
   cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'createArgoSpainStatus;exit'
  else
   cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'createArgoSpainStatus;exit' > $DirLog/createArgoSpainStatus.log
  fi
fi

#Update Update Argo Atlatic GoogleMap
#  printf "  Updating google map for Argo in the Atlantic\n"
#  if [ $Verbose -eq 1 ]
#  then
#     cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'createArgoRegionGMapFull;exit'
#  else
#     cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'createArgoRegionGMapFull;exit' > $DirLog/createArgoRegionGMapFull.log
#  fi

#------------------------------------
# Upload status (html) files to the web server
#------------------------------------
#Ahora esto se hace desde los scripts
#printf "  Upload status files to the web server\n"
#/usr/local/bin/ncftpput -a OceanografiaES /html/argo/html_files  *.html
##Metodo antiguo usando ncftp
##cd $PaginaWebDir/Html
##/usr/local/bin/ncftp OceanografiaEs << ftpEOF > $DirLog/ActualizaPaginaWebArgoEs_SubeficherosHtml.log
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
   /bin/rm -f $PaginaWebDir/html/ArgoEsGraficos/* > $DirLog/deleteFiles.log
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
    cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'sendArgoSpainReport;exit'
  else
    cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'sendArgoSpainReport;exit' > $DirLog/sendArgoSpainReport.log
  fi
fi

#------------------------------------
# Copy Argo data to a diferente location
#------------------------------------
#printf "  Copy data to a remote location \n"
#rsync -vrh $DirArgoData/ $DirArgoDataCopy/

#------------------------------------
# TelegramBot
#------------------------------------
source $HOME/.telegram

URL="https://api.telegram.org/bot$ArgoEsBotTOKEN/sendMessage"
MENSAJE=`cat $HOME/Analisis/ArgoSpainWebpage/data/report.txt`
curl -s -X POST $URL -d chat_id=$ArgoEsChannel -d text="$MENSAJE" -d parse_mode=html

printf "<<<<< Updated ArgoSpainWebArgo \n"
