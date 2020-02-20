echo off

set SERVER_NAME=etm70
set CURRENT_INSTALLATION_DIRECTORY=C:\IBM\70RC35
set NEW_INSTALLATION_DIRECTORY=C:\IBM\70RC36
set FIREFOX_DIRECTORY="C:\Program Files (x86)\Mozilla Firefox"
set IM_DIRECTORY="C:\Program Files\IBM\Installation Manager\eclipse"

echo RQM upgrade script for %SERVER_NAME%.
echo For more information on these steps, see https://jazz.net/wiki/bin/view/Main/rqmx64bUpgrade.
echo. 
echo Confirm an email is sent to RATL-ASQ-RQM-DEV notifying the Team that %SERVER_NAME% is going down to install the latest RQM build.

pause

echo.
echo Confirm system properties:
echo 1. Old installation directory is %CURRENT_INSTALLATION_DIRECTORY%.
echo 2. New installation directory is %NEW_INSTALLATION_DIRECTORY%.
echo 3. Firefox directory is %FIREFOX_DIRECTORY%.
echo 4. Installation Manager directory is %IM_DIRECTORY%.

pause

echo. 
echo Note: 
echo The DB2 DB for the applications is located in the Database Info text file on the desktop.

pause

echo. 
echo Creating new installation directory:

mkdir %NEW_INSTALLATION_DIRECTORY%

echo. 
echo Confirm the new installation directory %NEW_INSTALLATION_DIRECTORY% is created.

pause a

echo. 
echo Install a new build:

start /B /D %FIREFOX_DIRECTORY% firefox.exe "https://jazz.net/jazz/web/projects/Jazz Collaborative ALM#action=com.ibm.team.build.viewDefinitionList"

echo. 
echo Open the latest good (tagged passed-bvt) calm.[release] build.
echo Click the 'External Links' tab.
echo Copy the link in 'IM Repository URL - for new Launchpad design (story 193114)' row.

pause

start /B /D %IM_DIRECTORY% IBMIM.exe

echo. 
echo Click 'File - Preferences.... - Repositories'.
echo Deselect all of the repositories.
echo Click 'Add Repositories...'.
echo Paste the link.
echo Click 'OK - OK'.
echo Click 'Install'.
echo Install the CCM, GC, JRS, JTS, QM, RELM, RM, LDX, and trial license key applications.
echo Install to %NEW_INSTALLATION_DIRECTORY%.
echo Install all translations.
echo Install Liberty (do NOT install Tomcat).

pause

echo. 
echo Stopping CLM.
cd /D %CURRENT_INSTALLATION_DIRECTORY%\server
call  server.shutdown.bat
pause

echo. 
echo STOP! Do not proceed until the previous steps are complete! 

pause


echo. 
echo Start the server:

cd /D %NEW_INSTALLATION_DIRECTORY%\server

echo.
echo Starting:
call server.startup.bat

pause


echo. 
echo Stopping CLM.
cd /D %NEW_INSTALLATION_DIRECTORY%\server        
call  server.shutdown.bat
pause


echo. 
echo Copying the conf:
rename %NEW_INSTALLATION_DIRECTORY%\server\liberty\servers\clm\conf conf_BACKUP
xcopy %CURRENT_INSTALLATION_DIRECTORY%\server\liberty\servers\clm\conf %NEW_INSTALLATION_DIRECTORY%\server\liberty\servers\clm\conf /E /I /K /Y

echo. 
echo Confirm the configuration files were copied for clm.
pause

echo. 
echo Make the following changes to %NEW_INSTALLATION_DIRECTORY%\server\server.startup.bat:
echo. 
echo 1. Remove compressedrefs and heapbase JVM arg to eliminate a java.lang.OutOfMemoryError (native memory exhausted) when doing a loadClass after installing all CLM applications on one server:
echo     Comment: set JAVA_OPTS=%JAVA_OPTS% -Xcompressedrefs -Xgc:preferredHeapBase=0x100000000
echo 2. Enable repodebug:
echo     Add: set JAVA_OPTS=%JAVA_OPTS% -Dcom.ibm.team.repository.debug.enabled=true
echo     Add: set JAVA_OPTS=%JAVA_OPTS% -Dcom.ibm.team.repository.debug.users=*
echo 3. Activate Configuration Management (CM):
echo     Add: set JAVA_OPTS=%JAVA_OPTS% -Dcom.ibm.team.repository.vvc.activationKey=2f93e733-112e-3d24-a7b2-88a2ea502593
echo	Add: set JAVA_OPTS=%%JAVA_OPTS%% -Xmcrs1536M

echo. 
echo Confirm the above changes were made to %NEW_INSTALLATION_DIRECTORY%\server\server.startup.bat.
pause

echo. 
echo Copying the CCM:
rename %NEW_INSTALLATION_DIRECTORY%\server\conf\ccm\derby derby_BACKUP
mkdir %NEW_INSTALLATION_DIRECTORY%\server\conf\ccm\derby
xcopy %CURRENT_INSTALLATION_DIRECTORY%\server\conf\ccm\derby %NEW_INSTALLATION_DIRECTORY%\server\conf\ccm\derby /E /I /K /Y
rename %NEW_INSTALLATION_DIRECTORY%\server\conf\ccm\indices indices_BACKUP
mkdir %NEW_INSTALLATION_DIRECTORY%\server\conf\ccm\indices
xcopy %CURRENT_INSTALLATION_DIRECTORY%\server\conf\ccm\indices %NEW_INSTALLATION_DIRECTORY%\server\conf\ccm\indices /E /I /K /Y
rename %NEW_INSTALLATION_DIRECTORY%\server\conf\ccm\teamserver.properties teamserver.properties_BACKUP
xcopy %CURRENT_INSTALLATION_DIRECTORY%\server\conf\ccm\teamserver.properties %NEW_INSTALLATION_DIRECTORY%\server\conf\ccm /E /I /K /Y

echo. 
echo Confirm the configuration files were copied for CCM.
pause

echo. 
echo Copying the DCC:
rename %NEW_INSTALLATION_DIRECTORY%\server\conf\dcc\derby derby_BACKUP
mkdir %NEW_INSTALLATION_DIRECTORY%\server\conf\dcc\derby
xcopy %CURRENT_INSTALLATION_DIRECTORY%\server\conf\dcc\derby %NEW_INSTALLATION_DIRECTORY%\server\conf\dcc\derby /E /I /K /Y
rename %NEW_INSTALLATION_DIRECTORY%\server\conf\dcc\indices indices_BACKUP
mkdir %NEW_INSTALLATION_DIRECTORY%\server\conf\dcc\indices
xcopy %CURRENT_INSTALLATION_DIRECTORY%\server\conf\dcc\indices %NEW_INSTALLATION_DIRECTORY%\server\conf\dcc\indices /E /I /K /Y
rename %NEW_INSTALLATION_DIRECTORY%\server\conf\dcc\teamserver.properties teamserver.properties_BACKUP
xcopy %CURRENT_INSTALLATION_DIRECTORY%\server\conf\dcc\teamserver.properties %NEW_INSTALLATION_DIRECTORY%\server\conf\dcc /E /I /K /Y

echo. 
echo Confirm the configuration files were copied for DCC.
pause

echo. 
echo Copying the GC:
rename %NEW_INSTALLATION_DIRECTORY%\server\conf\gc\derby derby_BACKUP
mkdir %NEW_INSTALLATION_DIRECTORY%\server\conf\gc\derby
xcopy %CURRENT_INSTALLATION_DIRECTORY%\server\conf\gc\derby %NEW_INSTALLATION_DIRECTORY%\server\conf\gc\derby /E /I /K /Y
rename %NEW_INSTALLATION_DIRECTORY%\server\conf\gc\indices indices_BACKUP
mkdir %NEW_INSTALLATION_DIRECTORY%\server\conf\gc\indices
xcopy %CURRENT_INSTALLATION_DIRECTORY%\server\conf\gc\indices %NEW_INSTALLATION_DIRECTORY%\server\conf\gc\indices /E /I /K /Y
rename %NEW_INSTALLATION_DIRECTORY%\server\conf\gc\teamserver.properties teamserver.properties_BACKUP
xcopy %CURRENT_INSTALLATION_DIRECTORY%\server\conf\gc\teamserver.properties %NEW_INSTALLATION_DIRECTORY%\server\conf\gc /E /I /K /Y

echo. 
echo Confirm the configuration files were copied for GC.
pause

echo. 
echo Copying the JTS:
rename %NEW_INSTALLATION_DIRECTORY%\server\conf\jts\derby derby_BACKUP
mkdir %NEW_INSTALLATION_DIRECTORY%\server\conf\jts\derby
xcopy %CURRENT_INSTALLATION_DIRECTORY%\server\conf\jts\derby %NEW_INSTALLATION_DIRECTORY%\server\conf\jts\derby /E /I /K /Y
rename %NEW_INSTALLATION_DIRECTORY%\server\conf\jts\indices indices_BACKUP
mkdir %NEW_INSTALLATION_DIRECTORY%\server\conf\jts\indices
xcopy %CURRENT_INSTALLATION_DIRECTORY%\server\conf\jts\indices %NEW_INSTALLATION_DIRECTORY%\server\conf\jts\indices /E /I /K /Y
rename %NEW_INSTALLATION_DIRECTORY%\server\conf\jts\teamserver.properties teamserver.properties_BACKUP
xcopy %CURRENT_INSTALLATION_DIRECTORY%\server\conf\jts\teamserver.properties %NEW_INSTALLATION_DIRECTORY%\server\conf\jts /E /I /K /Y

echo. 
echo Confirm the configuration files were copied for JTS.
pause

echo. 
echo Copying the QM:
rename %NEW_INSTALLATION_DIRECTORY%\server\conf\qm\derby derby_BACKUP
mkdir %NEW_INSTALLATION_DIRECTORY%\server\conf\qm\derby
xcopy %CURRENT_INSTALLATION_DIRECTORY%\server\conf\qm\derby %NEW_INSTALLATION_DIRECTORY%\server\conf\qm\derby /E /I /K /Y
rename %NEW_INSTALLATION_DIRECTORY%\server\conf\qm\indices indices_BACKUP
mkdir %NEW_INSTALLATION_DIRECTORY%\server\conf\qm\indices
xcopy %CURRENT_INSTALLATION_DIRECTORY%\server\conf\qm\indices %NEW_INSTALLATION_DIRECTORY%\server\conf\qm\indices /E /I /K /Y
rename %NEW_INSTALLATION_DIRECTORY%\server\conf\qm\teamserver.properties teamserver.properties_BACKUP
xcopy %CURRENT_INSTALLATION_DIRECTORY%\server\conf\qm\teamserver.properties %NEW_INSTALLATION_DIRECTORY%\server\conf\qm /E /I /K /Y

echo. 
echo Confirm the configuration files were copied for QM.
pause

rem echo. 
rem echo Copying the RELM:
rem rename %NEW_INSTALLATION_DIRECTORY%\server\conf\relm\derby derby_BACKUP
rem mkdir %NEW_INSTALLATION_DIRECTORY%\server\conf\relm\derby
rem xcopy %CURRENT_INSTALLATION_DIRECTORY%\server\conf\relm\derby %NEW_INSTALLATION_DIRECTORY%\server\conf\relm\derby /E /I /K /Y
rem rename %NEW_INSTALLATION_DIRECTORY%\server\conf\relm\indices indices_BACKUP
rem mkdir %NEW_INSTALLATION_DIRECTORY%\server\conf\relm\indices
rem xcopy %CURRENT_INSTALLATION_DIRECTORY%\server\conf\relm\indices %NEW_INSTALLATION_DIRECTORY%\server\conf\relm\indices /E /I /K /Y
rem rename %NEW_INSTALLATION_DIRECTORY%\server\conf\relm\teamserver.properties teamserver.properties_BACKUP
rem xcopy %CURRENT_INSTALLATION_DIRECTORY%\server\conf\relm\teamserver.properties %NEW_INSTALLATION_DIRECTORY%\server\conf\relm /E /I /K /Y

rem echo. 
rem echo Confirm the configuration files were copied for RELM.
rem pause

echo. 
echo Copying the RM:
rename %NEW_INSTALLATION_DIRECTORY%\server\conf\rm\derby derby_BACKUP
mkdir %NEW_INSTALLATION_DIRECTORY%\server\conf\rm\derby
xcopy %CURRENT_INSTALLATION_DIRECTORY%\server\conf\rm\derby %NEW_INSTALLATION_DIRECTORY%\server\conf\rm\derby /E /I /K /Y
rename %NEW_INSTALLATION_DIRECTORY%\server\conf\rm\indices indices_BACKUP
mkdir %NEW_INSTALLATION_DIRECTORY%\server\conf\rm\indices
xcopy %CURRENT_INSTALLATION_DIRECTORY%\server\conf\rm\indices %NEW_INSTALLATION_DIRECTORY%\server\conf\rm\indices /E /I /K /Y
rename %NEW_INSTALLATION_DIRECTORY%\server\conf\rm\teamserver.properties teamserver.properties_BACKUP
xcopy %CURRENT_INSTALLATION_DIRECTORY%\server\conf\rm\teamserver.properties %NEW_INSTALLATION_DIRECTORY%\server\conf\rm /E /I /K /Y

echo. 
echo Confirm the configuration files were copied for RM.
pause

echo. 
echo Copying the LDX:
rename %NEW_INSTALLATION_DIRECTORY%\server\conf\ldx ldx_BACKUP
mkdir %NEW_INSTALLATION_DIRECTORY%\server\conf\ldx
xcopy %CURRENT_INSTALLATION_DIRECTORY%\server\conf\ldx %NEW_INSTALLATION_DIRECTORY%\server\conf\ldx /E /I /K /Y

echo. 
echo Confirm the configuration files were copied for LDX.
pause

echo. 
echo Copying the LQE:
rename %NEW_INSTALLATION_DIRECTORY%\server\conf\lqe lqe_BACKUP
mkdir %NEW_INSTALLATION_DIRECTORY%\server\conf\lqe
xcopy %CURRENT_INSTALLATION_DIRECTORY%\server\conf\lqe %NEW_INSTALLATION_DIRECTORY%\server\conf\lqe /E /I /K /Y

echo. 
echo Confirm the configuration files were copied for LQE.
pause

echo. 
echo Copying the RS:
rename %NEW_INSTALLATION_DIRECTORY%\server\conf\rs rs_BACKUP
mkdir %NEW_INSTALLATION_DIRECTORY%\server\conf\rs
xcopy %CURRENT_INSTALLATION_DIRECTORY%\server\conf\rs %NEW_INSTALLATION_DIRECTORY%\server\conf\rs /E /I /K /Y

echo. 
echo Confirm the configuration files were copied for RS.
pause

echo. 
echo STOP! Proceeding to the next steps will modify the DB!

pause

echo.
echo STOP! log on to qmdb2.rtp.raleigh.ibm.com and make a backup of the databases.
echo database information is located in the database info text file on the desktop
echo you can make a backup using the 'BACKUP DATABASE database_name' command
pause

echo.
echo STOP! make sure you made a backup of the databases.
pause

echo. 
echo Run repotools to update the DB tables:
echo. 
echo Note: May take longer (e.g. 10+ minutes) for the following tasks:
echo Running post addTables for "com.ibm.team.reports"... 
echo Running post addTables for "com.ibm.team.workitem"...

pause

cd /D %NEW_INSTALLATION_DIRECTORY%\server

echo. 
echo Running repotools for the CCM application:
call repotools-ccm -addTables noPrompt

echo. 
echo Confirm the repotools for the CCM application was successful.
pause

echo. 
echo Running repotools for the DCC application:
call repotools-dcc -addTables noPrompt

echo. 
echo Confirm the repotools for the DCC application was successful.
pause

echo. 
echo Running repotools for the GC application:
call repotools-gc -addTables noPrompt

echo. 
echo Confirm the repotools for the GC application was successful.
pause

echo. 
echo Running repotools for the JTS application:
call repotools-jts -addTables noPrompt

echo. 
echo Confirm the repotools for the JTS application was successful.
pause

echo. 
echo Running repotools for the QM application:
call repotools-qm -addTables noPrompt

echo. 
echo Confirm the repotools for the QM application was successful.
pause

rem echo. 
rem echo Running repotools for the RELM application:
rem call repotools-relm -addTables noPrompt

rem echo. 
rem echo Confirm the repotools for the RELM application was successful.
rem pause

echo. 
echo Running repotools for the RM application:
call repotools-rm -addTables noPrompt

echo. 
echo Confirm the repotools for the RM application was successful.
pause

echo. 
echo Running repotools for the Data warehouse:
call repotools-jts -upgradeWarehouse noPrompt 

echo. 
echo Confirm the repotools for the Data warehouse was successful.
pause

echo. 
echo Start the server:

cd /D %NEW_INSTALLATION_DIRECTORY%\server

echo.
echo Starting:
call server.startup.bat

pause

echo. 
echo Verify the server is up:
 
start /B /D %FIREFOX_DIRECTORY% firefox.exe https://%SERVER_NAME%.rtp.raleigh.ibm.com:9443/jts/admin#action=com.ibm.team.repository.admin.serverDiagnostics https://%SERVER_NAME%.rtp.raleigh.ibm.com:9443/qm/admin#action=com.ibm.team.repository.admin.serverDiagnostics https://%SERVER_NAME%.rtp.raleigh.ibm.com:9443/ccm/admin#action=com.ibm.team.repository.admin.serverDiagnostics https://%SERVER_NAME%.rtp.raleigh.ibm.com:9443/rm/admin#action=com.ibm.team.repository.admin.serverDiagnostics https://%SERVER_NAME%.rtp.raleigh.ibm.com:9443/lqe/web/admin/home https://%SERVER_NAME%.rtp.raleigh.ibm.com:9443/ldx/web/admin/home

echo Log in with qmadmin/qmadmin.
echo Check the build version (Help - About) is correct for the CCM, GC, JRS, JTS, QM, RELM, RM, and LDX applications (see the 'Contributing Builds' section of the 'External Links' tab of the calm.[release] build).
echo Check for service startup errors, DB issues, and failing diagnostics (other than unreachable Friends).
echo Check for LQE/LDX indexing warnings/errors.

pause 

start /B /D %FIREFOX_DIRECTORY% firefox.exe https://%SERVER_NAME%.rtp.raleigh.ibm.com:9443/qm/web/console

echo Log in with qmuser/qmuser.
echo Note: You MUST use the qmuser user account for these steps.
echo Create a test plan.
echo Link a development plan from CCM.
echo Link a requirement collection from RM.
echo Edit some other data and save the plan.
echo Reconcile the requirement collection, generating test cases.
echo Open the rich hover for a requirement collection and plan item.
echo Switch to/from a Global Configuration (GC).

pause 

echo. 
echo Confirm an email is sent to RATL-ASQ-RQM-DEV notifying the Team that rqmx64b is running after the upgrade to latest RQM build.

pause

echo. 
echo Done!

pause