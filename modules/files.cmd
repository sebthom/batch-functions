@echo off
:: SPDX-FileContributor: Sebastian Thomschke
:: SPDX-License-Identifier: CC0-1.0
:: SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/batch-functions

call :%* ""
goto :eof


:read_first_line_of_file <FILE_PATH> <RESULT_VAR>
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
