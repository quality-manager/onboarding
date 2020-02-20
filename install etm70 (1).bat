echo off

set SERVER_NAME=etm70
set CURRENT_INSTALLATION_DIRECTORY=
set NEW_INSTALLATION_DIRECTORY=C:\IBM\70RC2L
set FIREFOX_DIRECTORY="C:\Program Files (x86)\Mozilla Firefox"
set IM_DIRECTORY="C:\Program Files\IBM\Installation Manager\eclipse"

echo RQM install script for %SERVER_NAME%.
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
echo Creating new installation directory:

mkdir %NEW_INSTALLATION_DIRECTORY%

echo. 
echo Confirm the new installation directory %NEW_INSTALLATION_DIRECTORY% is created.

pause 

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
echo Stopping the old sever.

cd /D %CURRENT_INSTALLATION_DIRECTORY%\server

echo.
echo Stopping:
call server.shutdown.bat

pause

echo.
echo login to db2qm70.rtp.raleigh.ibm.com and create databases.
echo database info can be found on the desktop with the Database Info text document

pause

echo. 
echo Start the new server:

cd /D %NEW_INSTALLATION_DIRECTORY%\server

echo.
echo Starting:
call server.startup.bat

pause

echo. 
echo Configure the server:
 
start /B /D %FIREFOX_DIRECTORY% firefox.exe https://%SERVER_NAME%.rtp.raleigh.ibm.com:9443/jts/setup

echo Log in with ADMIN/ADMIN.
echo Run the custom setup.
echo Accept all defaults.
echo For the admin user, create qmadmin/qmadmin.

pause

echo. 
echo Stopping the sever.

cd /D %NEW_INSTALLATION_DIRECTORY%\server

echo.
echo Stopping:
call server.shutdown.bat

pause

echo. 
echo Make make the following changes to %NEW_INSTALLATION_DIRECTORY%\server\server.startup.bat:
echo. 
echo 1. Remove compressedrefs and heapbase JVM arg to eliminate a java.lang.OutOfMemoryError (native memory exhausted) when doing a loadClass after installing all CLM applications on one server:
echo     Comment: set JAVA_OPTS=%%JAVA_OPTS%% -Xcompressedrefs -Xgc:preferredHeapBase=0x100000000
echo 2. Enable repodebug:
echo     Add: set JAVA_OPTS=%%JAVA_OPTS%% -Dcom.ibm.team.repository.debug.enabled=true
echo     Add: set JAVA_OPTS=%%JAVA_OPTS%% -Dcom.ibm.team.repository.debug.users=*
echo 3. Activate Configuration Management (CM):
echo     Add: set JAVA_OPTS=%%JAVA_OPTS%% -Dcom.ibm.team.repository.vvc.activationKey=2f93e733-112e-3d24-a7b2-88a2ea502593
echo	Add: set JAVA_OPTS=%%JAVA_OPTS%% -Xmcrs1536M

echo. 
echo Confirm the above changes were made to %NEW_INSTALLATION_DIRECTORY%\server\server.startup.bat.

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

echo. 
echo Create the qmuser user:
 
start /B /D %FIREFOX_DIRECTORY% firefox.exe https://%SERVER_NAME%.rtp.raleigh.ibm.com:9443/jts/admin#action=com.ibm.team.repository.manageUsers

echo Log in with qmadmin/qmadmin.
echo Click 'Users - Create User'.
echo Use qmuser for the name and user ID.
echo Assign the following repository permissions:
echo -JazzUser
echo Assign the following permissions (You may need to active trials first):
echo -Rational DOORS Next Generation - Analyst 
echo -Rational Quality Manager - Quality Professional 
echo -Rational Team Concert - Developer 
echo Click 'Save'.

pause 

echo. 
echo Create the MTM sample (non-CM-enabled):
 
start /B /D %FIREFOX_DIRECTORY% firefox.exe https://%SERVER_NAME%.rtp.raleigh.ibm.com:9443/jts/lpa/sample

echo Log in with qmadmin/qmadmin.
echo Click 'Create'.
echo Accept all defaults.
echo Click 'Members'.
echo Add the qmuser user to all three MTM sample projects with all process roles.

pause 

echo. 
echo Smoke test the server:

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
echo Confirm an email is sent to RATL-ASQ-RQM-DEV notifying the Team that %SERVER_NAME% is running after installing the latest RQM build.

pause

echo. 
echo Done!

pause