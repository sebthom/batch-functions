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
  if "%result_var%" == "" (
    echo %value%
    exit /B 0
  )
  endlocal & set "%result_var%=%value%"
goto :eof


:get_windows_major_version  [<RESULT_VAR>]
  setlocal
  set result_var=%~1
  for /F "tokens=4-5 delims=. " %%i in ('ver') do set win_major_ver=%%i
  if "%result_var%" == "" (
    echo %win_major_ver%
    exit /B 0
  )
  endlocal & set "%result_var%=%win_major_ver%"
goto :eof
