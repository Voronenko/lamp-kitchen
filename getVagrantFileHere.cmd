@echo off
setlocal enabledelayedexpansion
set INTEXTFILE=.kitchen\kitchen-vagrant\default-precise32-vsdev\Vagrantfile
set OUTTEXTFILE=Vagrantfile
set SEARCHTEXT=../../../
set REPLACETEXT=
set OUTPUTLINE=

for /f "tokens=1,* delims=¶" %%A in ( '"type %INTEXTFILE%"') do (
SET string=%%A
SET modified=!string:%SEARCHTEXT%=%REPLACETEXT%!

echo !modified! >> %OUTTEXTFILE%
)