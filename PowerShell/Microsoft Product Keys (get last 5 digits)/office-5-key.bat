@echo off

for /f "tokens=2 delims=:" %%G IN ('cscript "C:\Program Files\Microsoft Office\Office16\OSPP.VBS" /dstatus ^| findstr /C:"Last 5 characters of installed product key:"') do ( set "key=%%G" )
set "key=%key: =%"
echo %key%