@echo off
:: SPDX-FileContributor: Sebastian Thomschke
:: SPDX-License-Identifier: CC0-1.0
:: SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/batch-functions

call :%* ""
goto :eof


:abspath <RELATIVE_PATH> [<RESULT_VAR>]
  setlocal
  set abs_path=%~f1
  set result_var=%~2
  if "%result_var%" == "" (
    echo %abs_path%
    exit /B 0
  )
  endlocal & set "%result_var%=%abs_path%"
goto :eof


:basename <PATH> [<RESULT_VAR>]
  setlocal
  set basename=%~nx1
  set result_var=%~2
  if "%result_var%" == "" (
    echo %basename%
    exit /B 0
  )
  endlocal & set "%result_var%=%basename%"


:basename_without_extension <PATH> <RESULT_VAR>
  setlocal
  set basename=%~n1
  set result_var=%~2
  if "%result_var%" == "" (
    echo %basename%
    exit /B 0
  )
  endlocal & set "%result_var%=%basename%"


:read_first_line_of_file <FILE_PATH> [<RESULT_VAR>]
  setlocal
  set file_path=%~1
  set result_var=%~2
  set /P content=<"%file_path%"
  if "%result_var%" == "" (
    echo %content%
    exit /B 0
  )
  endlocal & set "%result_var%=%content%"
goto :eof


:mkdirs <PATH>
  :: like "mkdir -p" on Linux
  setlocal enableextensions
  if not exist %1 md %1
goto :eof
