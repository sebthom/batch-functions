@echo off
:: SPDX-FileContributor: Sebastian Thomschke
:: SPDX-License-Identifier: CC0-1.0
:: SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/batch-functions

call :%* ""
goto :eof


:has_arg <SEARCH_FOR> <ARG,...>
  setlocal
  set "search_for=%~1" & shift /1
  set empty_args=0

  REM not using "for %%a in (%*)" which automatically expands wildcard arguments
  :has_arg___CHECK_NEXT_ARG
    set "arg=%~1"
    if "%arg%" == "%search_for%" exit /B 0
    if "%arg%" == "" (
      REM stop looping if more than 6 empty args in a row were found. this is a workaround for the fact that one cannot
      REM distinguish between an empty "" argument and the end of the argument list
      if %empty_args% == 6 (
        exit /B 1
      ) else (
        set /a empty_args+=1
      )
    ) else (
      set empty_args=0
    )
    shift /1
    goto :has_arg___CHECK_NEXT_ARG


:get_1st_positional_arg <RESULT_VAR> <ARG,...>
  call :get_nth_positional_arg 1 %*
goto :eof


:get_2nd_positional_arg <RESULT_VAR> <ARG,...>
  call :get_nth_positional_arg 2 %*
goto :eof


:get_nth_positional_arg <ARG_INDEX> <RESULT_VAR> <ARG,...>
  setlocal EnableDelayedExpansion
  set "wanted_pos_arg_index=%~1" & shift /1
  set "result_var=%~1" & shift /1
  set current_pos_arg_index=0

  REM not using "for %%a in (%*)" which automatically expands wildcard arguments
  :get_nth_positional_arg___CHECK_NEXT_ARG
    set "arg=%~1"
    set first_char=%arg:~0,1%
    if not "%first_char%" == "-" (
      if not "%first_char%" == "/" (
         set /A current_pos_arg_index=%current_pos_arg_index%+1
         if !current_pos_arg_index! equ %wanted_pos_arg_index% (
           endlocal & set "%result_var%=%arg%"
           exit /B 0
         )
      )
    )
    shift /1
    goto :get_nth_positional_arg___CHECK_NEXT_ARG
