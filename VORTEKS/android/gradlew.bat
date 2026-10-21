@echo off
setlocal
set DIR=%~dp0
if "%DIR%"=="" set DIR=.
set APP_BASE_NAME=%~n0
set CLASSPATH=%DIR%gradle\wrapper\gradle-wrapper.jar

if defined JAVA_HOME goto findJavaFromJavaHome
set JAVA_EXE=java.exe
%JAVA_EXE% -version >NUL 2>&1
if "%ERRORLEVEL%"=="0" goto execute
echo ERROR: JAVA_HOME is not set and no java command could be found in PATH.
goto fail

:findJavaFromJavaHome
set JAVA_HOME=%JAVA_HOME:"=%
set JAVA_EXE=%JAVA_HOME%\bin\java.exe
if exist "%JAVA_EXE%" goto execute
echo ERROR: JAVA_HOME points to an invalid Java installation: %JAVA_HOME%
goto fail

:execute
"%JAVA_EXE%" %DEFAULT_JVM_OPTS% %JAVA_OPTS% %GRADLE_OPTS% "-Dorg.gradle.appname=%APP_BASE_NAME%" -classpath "%CLASSPATH%" org.gradle.wrapper.GradleWrapperMain %*
if "%ERRORLEVEL%"=="0" goto end

:fail
exit /b 1

:end
endlocal
