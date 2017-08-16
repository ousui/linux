@echo off

rem 指定各个命令的执行路径
set CURL="C:\Program Files\Git\mingw64\bin\curl.exe"
set MD5="C:\Program Files\Git\usr\bin\md5sum.exe"
set AWK="C:\Program Files\Git\usr\bin\awk.exe"
set RM="C:\Program Files\Git\usr\bin\rm.exe"

rem 指定 response 的路径
set OUT="%tmp%/~check~.resp"

rem 设置检测状态处事值
set PASSED=0


rem 脚本开始运行的时候，无需检测状态，直接再次启动更新服务，避免程序无法使用。
net start TPlusProUpgradeService1220

rem 请求 local url 并保存结果到 out
%CURL% -m 5 -d "{\"AccountNum\":\"314\",\"UserName\":\"admin\",\"Password\":\"d41d8cd98f00b204e9800998ecf8427e\",\"rdpYear\":\"2017\",\"rdpMonth\":\"5\",\"rdpDate\":\"18\",\"webServiceProcessID\":\"admin\",\"aqdKey\":\"\"}" "127.0.0.1/tplus/ajaxpro/Ufida.T.SM.Login.UIP.LoginManager,Ufida.T.SM.Login.UIP.ashx?method=CheckPassword" -o %OUT%

rem md5 验证结果，如果成功，设置passed值
%MD5% %OUT% | findstr /i "2916c677afaa072c718ed8929047114 dae8be36e9dfc819f3486870f8434d3"  && set PASSED=1
rem 删除 resp 临时文件
%RM% -f %OUT%
if %PASSED%==1 goto passed
if %PASSED%==0 goto unpassed

rem 如果成功则退出
:passed
rem echo passed
rem call log.cmd "service is running."
exit 0

rem 如果检测失败，重起服务
:unpassed
echo unpassed
net stop w3svc
net stop TPlusProAppService1220
net stop TPlusProTaskService1220
net stop TPlusProUpgradeService1220

net start TPlusProUpgradeService1220
net start TPlusProTaskService1220
net start TPlusProAppService1220
net start w3svc
call log.cmd "service restart done!"
exit 0
