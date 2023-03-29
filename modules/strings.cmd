@echo off
:: SPDX-FileContributor: Sebastian Thomschke
:: SPDX-License-Identifier: CC0-1.0
:: SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/batch-functions

call :%* ""
goto :eof


:ends_with <SEARCH_IN> <SEARCH_FOR>
  echo %~1|findstr /E /L %2 >NUL
goto :eof


:has_substring <SEARCH_IN> <SEARCH_FOR>
  setlocal
  set search_in=%~1
  set search_for=%~2

  call :replace_substring "%search_in%" "%search_for%" "" result

  REM substring not found
  if "%searchIn%" == "%result%" exit /B 1
goto :eof


:replace_substrings <SEARCH_IN> <SEARCH_FOR> <REPLACE_WITH> [<RESULT_VAR>]
  :: replace all matching substrings
  setlocal
  set search_in=%~1
  set search_for=%~2
  set replace_with=%~3
  set result_var=%~4

  call set result=%%search_in:%search_for%=%replace_with%%%

  if "%result_var%" == "" (
    echo %result%
    exit /B 0
  )
  endlocal & set "%result_var%=%result%"
goto :eof


:substring_before <SEARCH_IN> <SEARCH_FOR> [<RESULT_VAR>]
  setlocal
  set search_in=%~1
  set separator=%~2
  set result_var=%~3

  if "%result_var%" == "" (
    echo %0 - Argument RESULT_VAR missing!
    exit /B 1
  )

  for /F "delims=%separator%" %%a in ("%search_in%") do (
    if "%result_var%" == "" (
      echo %result%
    ) else (
      endlocal & set "%result_var%=%%a"
    )
    exit /B 0
  )
goto :eof
