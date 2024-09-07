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
  DirArgoDataCopy=/data/pvb/Argo
fi
if [[ $strval == *rossby* ]];
then
  MatVersion=/usr/bin/matlab
  DirRaiz=$HOME
  DirArgoData=/data/pvb/Argo
  DirArgoDataCopy=/data/pvb/Argo
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
    cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'createDataSet;exit'
  else
    cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'createDataSet;exit' > $DirLog/createDataSet.log
  fi
#Updating leaflet map for Argo in the region
   printf "  Updating leaflet map for Argo in the region\n"
   if [ $Verbose -eq 1 ]
   then
     cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'createRegionMapLLet;exit'
   else
     cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'createRegionMapLLet;exit' > $DirLog/createRegionMapLLet.log
   fi

#Updating leaflet map for Argo Spain
    printf "  Updating leaflet map for Argo Spain\n"
    if [ $Verbose -eq 1 ]
    then
     cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'createDataSetMapLLet;exit'
    else
     cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'createDataSetMapLLet;exit' > $DirLog/createDataSetMapLLet.log
    fi

#Updating table with the statistics of Argo Spain
  printf "  Updating table with the statistics of Argo Spain\n"
  if [ $Verbose -eq 1 ]
  then
   cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'createDataSetTable;exit'
  else
   cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'createDataSetTable;exit' > $DirLog/createDataSetTable.log
  fi

#Update ArgoEs figures
  printf "  Updating and upload webpages for the ArgoSpain and ArgoInterest figures\n"
  if [ $Verbose -eq 1 ]
  then
   cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'createDataSetStatus;exit'
  else
   cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'createDataSetStatus;exit' > $DirLog/createDataSetStatus.log
  fi
fi

#Borra ficheros DataSetGraficos
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
    cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'sendDataSetReport;exit'
  else
    cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'sendDataSetReport;exit' > $DirLog/sendDataSetReport.log
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
