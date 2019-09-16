#!/bin/bash

Verbose=0
SoloSube=0 #Si es 1 solo sube los datos. Si es 0 actualiza y sube los datos

PaginaWebDir=/Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebArgoEs
DataDir=/Volumes/Ocean$/Data/Copernicus/pedro
DirLog=$PaginaWebDir/Log

/bin/rm -f $DirLog/*.log

printf ">>>> Updating PaginaWebTunidos \n"
printf "  Verbose $Verbose SoloSube $SoloSube \n"
printf "  PaginaWebDir $PaginaWebDir \n"
printf "  DirLog      $DirLog \n"


#------------------------------------
# Upload status (html) files to the web server
#------------------------------------
printf " Upload status files to the web server\n"
#/usr/local/bin/ncftpput -a OceanografiaES /html/argo/html_files  *.html
##Metodo antiguo usando ncftp

cd $DataDir
/usr/local/bin/ncftp OceanografiaEs << ftpEOF >> $DirLog/ActualizaPaginaWebTunidos_SubeficherosHtml.log
  cd /html
  put -fa dailySST.png
  quit
ftpEOF

printf "<<<<< Updated PaginaWebTunidos\n"
