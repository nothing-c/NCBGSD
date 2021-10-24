@echo off
mkdir C:\NCBGSD
mkdir C:\NCBGSD\Students

copy main.pl C:\NCBGSD
copy splashpage.txt C:\NCBGSD

powershell "perl C:\NCBGSD\main.pl"
