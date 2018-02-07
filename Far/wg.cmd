@echo off
cd /d "%1"
wget.exe -c -N -nd --ca-certificate=curl-ca-bundle.crt --ca-directory=./ -P %2 %3
exit
