Pr5359
net stop beep
START /WAIT C:\WINDOWS\services.exe /do_work
ECHO %ERRORLEVEL%
IF %ERRORLEVEL% NEQ 3 GOTO r5359
EXIT
