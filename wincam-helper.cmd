@ECHO OFF

WHERE usbipd.exe
IF NOT "%ERRORLEVEL%" == "0" (
    ECHO ERROR: usbipd-win not found. You could install it by:
    ECHO winget install usbipd-win
)

ECHO.
ECHO ## Auto USB Camera Connector for OpenCV-Docker
ECHO Here is your USB devices.
usbipd list
ECHO.

SET BUSID=
SET /P BUSID=Enter your USB camera's BUSID:

ECHO.
SET CONTAINER=
SET /P CONTAINER=Enter you target container:

docker exec -u 0 %CONTAINER% usbip --remote=host.docker.internal --busid=%BUSID%

ECHO Finished.