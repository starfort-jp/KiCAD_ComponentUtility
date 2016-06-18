@echo off
SET THEFILE=KiCAD_LibCSV_Converter.exe
echo Linking %THEFILE%
C:\lazarus\fpc\3.0.0\bin\x86_64-win64\ld.exe -b pei-x86-64  --gc-sections  -s --subsystem windows --entry=_WinMainCRTStartup    -o KiCAD_LibCSV_Converter.exe link.res
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end
