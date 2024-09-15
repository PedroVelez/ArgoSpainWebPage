#! /bin/bash

FtpArgoData=ftp://ftp.ifremer.fr/ifremer/argo
#FtpArgoData=ftp://usgodae1.fnmoc.navy.mil/pub/outgoing/argo

# Depending on the computer setup the folders
# And the path of the matlab application
strval=$(uname -a)
if [[ $strval == *Okapi* ]];
then
  MatVersion=/Applications/MATLAB_R2019b.app/bin/matlab
  DirRaiz=$HOME/Dropbox/Oceanografia
  DirArgoData=$DirRaiz/Oceanografia/Data/Argo
fi
if [[ $strval == *rossby* ]];
then
  MatVersion=/usr/bin/matlab
  DirRaiz=$HOME
  DirArgoData=/data/pvb/Argo
fi

PaginaWebDir=$DirRaiz/Analisis/ArgoSpainWebpage

/bin/rm -f $PaginaWebDir/log/*.log

#---------------------------------------
#Crea listas de Argo a apartir del google spreadsheets
#---------------------------------------
printf "  Crea listas de Argo a apartir del google spreadsheets\n"
cd $PaginaWebDir;$MatVersion -nodisplay -nosplash -r 'createLists;exit'


#---------------------------------------
#Get Region
#---------------------------------------
basin=atlantic_ocean

month=`date "+%m"`
year=`date "+%y"`
montha=`expr $month - 2`
monthb=`expr $month - 1`
if [ "$montha" -lt 10 ]; then
    montha=0$montha
fi
if [ "$monthb" -lt 10 ]; then
    monthb=0$monthb
fi

wget --passive -N -np -nH -r -Q601M --cut-dirs 4 -o $PaginaWebDir/log/GetArgoGeoMonth.log -P $DirArgoData/geo/$basin $FtpArgoData/geo/$basin/20$year/$month/*
wget --passive -N -np -nH -r -Q601M --cut-dirs 4 -o $PaginaWebDir/log/GetArgoGeoMonth1.log -P $DirArgoData/geo/$basin $FtpArgoData/geo/$basin/20$year/$monthb/*
wget --passive -N -np -nH -r -Q601M --cut-dirs 4 -o $PaginaWebDir/log/GetArgoGeoMonth2.log -P $DirArgoData/geo/$basin $FtpArgoData/geo/$basin/20$year/$montha/*

#---------------------------------------
#Descarga boyas
#---------------------------------------
#Argo Espana
#No se hace en background para no abrir multiples instacinas de FTP
for dacboya in $(cat $PaginaWebDir/floatsArgoSpain.dat)
do
  dacboyaT=`echo "$dacboya" | sed 's/\//\-/g'`
  echo $dacboyaT
  wget --passive -N -np -nH -r -Q500M --cut-dirs 4 -o $PaginaWebDir/log/GetArgoFloatsArgoES.log -P $DirArgoData/Floats $FtpArgoData/dac/$dacboya"/*"
done

#Boyas Interest
#No se hace en background para noabrir multiples instacinas de FTP
for dacboya in $(cat $PaginaWebDir/floatsArgoInterest.dat)
do
  dacboyaT=`echo "$dacboya" | sed 's/\//\-/g'`
  wget --passive -N -np -nH -r -Q500M --cut-dirs 4 -o $PaginaWebDir/log/GetArgoFloatsArgoIN.log -P $DirArgoData/Floats $FtpArgoData/dac/$dacboya"/*"
done

#---------------------------------------
#ArgoGreyList
#---------------------------------------
#Descarga grey list
wget --passive -np -N -nH -r -Q602M --cut-dirs 4 -o $PaginaWebDir/log/GetArgoGreyList.log -P $DirArgoData/ $FtpArgoData/ar_greylist.txt
