@echo off

set content=%1
if defined content (
	rem null line
) else exit 1


set ymd=%date:~0,4%-%date:~5,2%-%date:~8,2%
set ymd_t=%ymd% %time:~0,2%:%time:~3,2%:%time:~6,2%
rem eet ymd_t=%ymd_t: =0%
@for /f "tokens=2 delims=[]" %%a in ('nbtstat -A x^|find "[172"') do @set LOCAL_IP=%%a


mkdir logs
echo [%ymd_t%] %content% - %computername% >> logs\\%ymd%~%LOCAL_IP%.txt
