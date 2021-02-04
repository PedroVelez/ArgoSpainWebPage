#! /bin/bash

FtpArgoData=ftp://ftp.ifremer.fr/ifremer/argo

PaginaWebDir=/Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebArgoEs
DirArgoData=/data/shareddata/Argo

/bin/rm -f $DirArgoData/log/*.txt
/bin/rm -f $PaginaWebDir/log/GetArgo.log

#---------------------------------------
#Get Region
#---------------------------------------
basin=atlantic_ocean

/usr/bin/wget --passive -N -np -nH -r --cut-dirs 4 -P $DirArgoData/geo/$basin $FtpArgoData/geo/$basin/*

#---------------------------------------
#ArgoGreyList
#---------------------------------------
#Descarga grey list
/usr/bin/wget --passive -np -N -nH -r -Q602M --cut-dirs 4 -P $DirArgoData/ $FtpArgoData/ar_greylist.txt
