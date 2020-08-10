#! /bin/bash

FtpArgoData=ftp://ftp.ifremer.fr/ifremer/argo
#FtpArgoData=ftp://usgodae1.fnmoc.navy.mil/pub/outgoing/argo

PaginaWebDir=$HOME/Dropbox/Oceanografia/Proyectos/ArgoSpainWebpage
DirArgoData=$HOME/Dropbox/Oceanografia/Data/Argo

/bin/rm -f $PaginaWebDir/log/*.log

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

wget --passive -N -np -nH -r -Q601M --cut-dirs 4 -o $PaginaWebDir/Log/GetArgoGeoMonth.log -P $DirArgoData/geo/$basin $FtpArgoData/geo/$basin/20$year/$month/*
wget --passive -N -np -nH -r -Q601M --cut-dirs 4 -o $PaginaWebDir/Log/GetArgoGeoMonth1.log -P $DirArgoData/geo/$basin $FtpArgoData/geo/$basin/20$year/$monthb/*
wget --passive -N -np -nH -r -Q601M --cut-dirs 4 -o $PaginaWebDir/Log/GetArgoGeoMonth2.log -P $DirArgoData/geo/$basin $FtpArgoData/geo/$basin/20$year/$montha/*

#---------------------------------------
#Crea listas de Argo a apartir del google spreadsheets
#---------------------------------------
#En python
#/Users/pvb/anaconda3/bin/python /Users/pvb/Dropbox/Oceanografia/LibreriasMatlab/Programas/Argo/GetData/GetArgoEsInIDs.py
#En Matlab
#/Applications/MATLAB_R2016b.app/bin/matlab -nodisplay -nosplash -nojvm -r 'cd /Users/pvb/Dropbox/Oceanografia/LibreriasMatlab/Programas/Argo/GetData/;GetArgoEsInIDs;exit' > $DirArgoData/log/GetArgoEsInIDs.txt

#---------------------------------------
#Descarga boyas
#---------------------------------------
#Argo Espana
#No se hace en background para no abrir multiples instacinas de FTP
for dacboya in $(cat $PaginaWebDir/floatsArgoSpain.dat)
do
  dacboyaT=`echo "$dacboya" | sed 's/\//\-/g'`
  echo $dacboyaT
  wget --passive -N -np -nH -r -Q500M --cut-dirs 4 -o $PaginaWebDir/Log/GetArgoFloatsArgoES.log -P $DirArgoData/Floats $FtpArgoData/dac/$dacboya"/*"
done

#Boyas Interest
#No se hace en background para noabrir multiples instacinas de FTP
for dacboya in $(cat $PaginaWebDir/floatsArgoInterest.dat)
do
  dacboyaT=`echo "$dacboya" | sed 's/\//\-/g'`
  wget --passive -N -np -nH -r -Q500M --cut-dirs 4 -o $PaginaWebDir/Log/GetArgoFloatsArgoIN.log -P $DirArgoData/Floats $FtpArgoData/dac/$dacboya"/*"
done

#Boyas Argo Espana
#for dacboya in $(cat $PaginaWebDir/FloatsArgoEs.dat)
#do
#  dacboyaT=`echo "$dacboya" | sed 's/\//\-/g'`
#  echo $dacboyaT
#  /usr/local/bin/wget --passive -N -np -nH -r -Q500M -a  $DirArgoData/log/GetArgoFloats$dacboyaT.txt -b --cut-dirs 4 -P $DirArgoData/Floats $FtpArgoData/dac/$dacboya"/*" >> $PaginaWebDir/Log/GetArgo.log
#done
#
#Boyas Interest
#for dacboya in $(cat $PaginaWebDir/FloatsArgoIn.dat)
#do
#  dacboyaT=`echo "$dacboya" | sed 's/\//\-/g'`
#  /usr/local/bin/wget --passive -N -np -nH -r -Q500M -a  $DirArgoData/log/GetArgoFloats$dacboyaT.txt -b --cut-dirs 4 -P $DirArgoData/Floats $FtpArgoData/dac/$dacboya"/*" >> $PaginaWebDir/Log/GetArgo.log
#done

#---------------------------------------
#ArgoGreyList
#---------------------------------------
#Descarga grey list
wget --passive -np -N -nH -r -Q602M --cut-dirs 4 -o $PaginaWebDir/Log/GetArgoGreyList.log -P $DirArgoData/ $FtpArgoData/ar_greylist.txt
