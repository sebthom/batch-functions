@echo off
:: SPDX-FileContributor: Sebastian Thomschke
:: SPDX-License-Identifier: CC0-1.0
:: SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/batch-functions

call :%* ""
goto :eof


:ends_with <SEARCH_IN> <SEARCH_FOR>
  set search_in=%~1
  set search_for=%~2
  if "%search_for%" == "" exit /B 0
  if "%search_in%" == "%search_for%" exit /B 0

  echo %search_in%|findstr /E /L "%search_for%" >NUL
goto :eof


:has_substring <SEARCH_IN> <SEARCH_FOR>
  setlocal
  set search_in=%~1
  set search_for=%~2
  if "%search_for%" == "" exit /B 0
  if "%search_in%" == "%search_for%" exit /B 0

  call :replace_substrings "%search_in%" "%search_for%" "" result

  :: substring not found
  if "%searchIn%" == "%result%" exit /B 1
goto :eof


:replace_substrings <SEARCH_IN> <SEARCH_FOR> <REPLACE_WITH> [<RESULT_VAR>]
  :: replace all matching substrings
  setlocal
  set search_in=%~1
  set search_for=%~2
  set replace_with=%~3
  set result_var=%~4

  if "%search_in%" == "" (
    set result=%search_in%
  ) else if "%search_for%" == "" (
    set result=%search_in%
  ) else (
    call set result=%%search_in:%search_for%=%replace_with%%%
  )

  if not defined result_var (
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

  for /F "delims=%separator%" %%a in ("%search_in%") do (
    if not defined result_var (
      echo %result%
    ) else (
      endlocal & set "%result_var%=%%a"
    )
    exit /B 0
  )
  endlocal & set "%result_var%=%search_in%"
goto :eof
