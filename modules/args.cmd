@echo off
:: SPDX-FileContributor: Sebastian Thomschke
:: SPDX-License-Identifier: CC0-1.0
:: SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/batch-functions

call :%* ""
goto :eof


:has_arg <SEARCH_FOR> <ARG,...>
  setlocal
  set search_for=%~1
  for %%a in (ignoreFirstArg%*) do (
    if "%%~a"=="%search_for%" exit /B 0
  )
exit /B 1


:get_1st_positional_arg <RESULT_VAR> <ARG,...>
  call :get_nth_positional_arg 1 %*
goto :eof


:get_2nd_positional_arg <RESULT_VAR> <ARG,...>
  call :get_nth_positional_arg 2 %*
goto :eof


:get_nth_positional_arg <ARG_INDEX> <RESULT_VAR> <ARG,...>
  setlocal EnableDelayedExpansion
  set wanted_pos_arg_index=%~1
  set result_var=%~2
  set current_pos_arg_index=-2

  for %%a in (%*) do (
    set a=%%~a
    set first_char=!a:~0,1!
    if not "!first_char!" == "-" (
      if not "!first_char!" == "/" (
        set /A current_pos_arg_index=!current_pos_arg_index!+1
        if !current_pos_arg_index! equ %wanted_pos_arg_index% (
          endlocal & set "%result_var%=%%a"
          exit /B 0
        )
      )
    )
  )
goto :eof
