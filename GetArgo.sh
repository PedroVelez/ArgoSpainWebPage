#! /bin/bash

FtpArgoData=ftp://ftp.ifremer.fr/ifremer/argo
#FtpArgoData=ftp://usgodae1.fnmoc.navy.mil/pub/outgoing/argo

PaginaWebDir=/Users/pvb/Dropbox/Oceanografia/Proyectos/PaginaWebArgoEs
DirArgoData=/Users/pvb/Dropbox/Oceanografia/Data/Argo

/bin/rm -f $DirArgoData/log/*.txt
/bin/rm -f $PaginaWebDir/Log/GetArgo.log

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

/usr/local/bin/wget --passive -N -np -nH -r -Q601M --cut-dirs 4 -P $DirArgoData/geo/$basin $FtpArgoData/geo/$basin/20$year/$month/*
/usr/local/bin/wget --passive -N -np -nH -r -Q601M --cut-dirs 4 -P $DirArgoData/geo/$basin $FtpArgoData/geo/$basin/20$year/$monthb/*
/usr/local/bin/wget --passive -N -np -nH -r -Q601M --cut-dirs 4 -P $DirArgoData/geo/$basin $FtpArgoData/geo/$basin/20$year/$montha/*

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
for dacboya in $(cat $PaginaWebDir/FloatsArgoEs.dat)
do
  dacboyaT=`echo "$dacboya" | sed 's/\//\-/g'`
  echo $dacboyaT
  /usr/local/bin/wget --passive -N -np -nH -r -Q500M --cut-dirs 4 -P $DirArgoData/Floats $FtpArgoData/dac/$dacboya"/*"
done
#Boyas Interest
#No se hace en background para noabrir multiples instacinas de FTP
for dacboya in $(cat $PaginaWebDir/FloatsArgoIn.dat)
do
  dacboyaT=`echo "$dacboya" | sed 's/\//\-/g'`
  /usr/local/bin/wget --passive -N -np -nH -r -Q500M --cut-dirs 4 -P $DirArgoData/Floats $FtpArgoData/dac/$dacboya"/*"
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
/usr/local/bin/wget --passive -np -N -nH -r -Q602M --cut-dirs 4 -P $DirArgoData/ $FtpArgoData/ar_greylist.txt
#/usr/local/bin/wget --passive -np -N -nH -r -Q602M -a $DirArgoData/log/GetArgoGreyList.txt -b --cut-dirs 4 -P $DirArgoData/ $FtpArgoData/ar_greylist.txt >> $PaginaWebDir/Log/GetArgo.log
