@echo off

setlocal enabledelayedexpansion

set CURRENT_DIR=!cd!
set WORKING_DIR=%1%
set MAKE_TARGET=

shift
:targets_loop
if "%1"=="" goto end_targets_loop 
set MAKE_TARGET=!MAKE_TARGET! %1
shift
goto targets_loop

:end_targets_loop

cd %WORKING_DIR%

:loop
echo ...searching for Makefile in !cd!
if exist Makefile (
	echo Makefile found in !cd!
	make %MAKE_TARGET%
	goto end
) else (
	set CWD=!cd!
	cd ..
	if !CWD!==!cd! (
		echo Makefile not found.
		goto end 
	) else ( goto loop )
)


:end
cd %CURRENT_DIR%
