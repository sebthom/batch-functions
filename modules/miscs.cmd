@echo off
:: SPDX-FileContributor: Sebastian Thomschke
:: SPDX-License-Identifier: CC0-1.0
:: SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/batch-functions

call :%* ""
goto :eof


:getx  [<RESULT_VAR>] [/M]
  :: counterpart to setx command
  setlocal
  if "%~1" == "/M" (
    set result_var=%~2
    set system_wide=%~1
  ) else (
    set result_var=%~1
    set system_wide=%~2
  )
  if /I "%system_wide%" == "/M" (
    set "reg_path=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
  ) else (
    set "reg_path=HKEY_CURRENT_USER\Environment"
  )
  for /F "tokens=2* skip=2" %%a in ('reg query "%reg_path%" /v Path') do (
    set "value=%%b"
  )
  if not defined result_var (
    echo %value%
    exit /B 0
  )
  endlocal & set "%result_var%=%value%"
goto :eof


:get_windows_major_version  [<RESULT_VAR>]
  setlocal
  set result_var=%~1
  for /F "tokens=4-5 delims=. " %%i in ('ver') do set win_major_ver=%%i
  if not defined result_var (
    echo %win_major_ver%
    exit /B 0
  )
  endlocal & set "%result_var%=%win_major_ver%"
goto :eof


:print <MESSAGE>
  :: outputs the message to the console without trailing new line characters
  echo|set /p="%~1"
goto :eof


:capture <CMD> [<RESULT_VAR>] [<LINE_SEPARATOR>]
  :: captures the output of a command in a variable
  setlocal EnableDelayedExpansion
  set cmd=%~1
  set result_var=%~2
  set line_separator=%~3
  if not defined line_separator (
    set line_separator=^& echo.
  )
  set stdout=
  for /F "delims=" %%f in ('%cmd%') do (
    if defined stdout (
      set "stdout=!stdout!!line_separator!%%f"
    ) else (
      set "stdout=%%f"
    )
  )
  if not defined result_var (
    echo %stdout%
    exit /B 0
  )
  endlocal & set "%result_var%=%stdout%"
goto :eof
