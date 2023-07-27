@echo off
:: SPDX-FileContributor: Sebastian Thomschke
:: SPDX-License-Identifier: CC0-1.0
:: SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/batch-functions

setlocal

pushd %~dp0..\modules\

set failures=0

::::::::::::::::::::::::::::::::
:: test has_arg
::::::::::::::::::::::::::::::::
call :assert_exec_ok has_arg foo foo
call :assert_exec_ok has_arg foo foo bar
call :assert_exec_ok has_arg foo bar foo
call :assert_exec_ok has_arg foo "" foo
call :assert_exec_ok has_arg foo "" "" "" "" "" "" foo
call :assert_exec_ok has_arg foo "foo"
call :assert_exec_ok has_arg "foo" foo
call :assert_exec_ok has_arg * foo *
call :assert_exec_ok has_arg * foo "*"
call :assert_exec_nok has_arg foo
call :assert_exec_nok has_arg foo bar
call :assert_exec_nok has_arg *


::::::::::::::::::::::::::::::::
:: test get_1st_positional_arg
::::::::::::::::::::::::::::::::
call :exec get_1st_positional_arg OUTPUT foo bar
call :assert_OUTPUT_equals foo

call :exec get_1st_positional_arg OUTPUT * foo bar
call :assert_OUTPUT_equals *

call :exec get_1st_positional_arg OUTPUT "foo foo" "bar bar"
call :assert_OUTPUT_equals "foo foo"

call :exec get_1st_positional_arg OUTPUT /a "foo foo" -b "bar bar"
call :assert_OUTPUT_equals "foo foo"

call :exec get_1st_positional_arg OUTPUT
call :assert_OUTPUT_equals ""

call :exec get_1st_positional_arg OUTPUT "" foo bar
call :assert_OUTPUT_equals ""


::::::::::::::::::::::::::::::::
:: test get_2nd_positional_arg
::::::::::::::::::::::::::::::::
call :exec get_2nd_positional_arg OUTPUT foo bar
call :assert_OUTPUT_equals bar

call :exec get_2nd_positional_arg OUTPUT foo * bar
call :assert_OUTPUT_equals *

call :exec get_2nd_positional_arg OUTPUT /a "foo foo" -b "bar bar"
call :assert_OUTPUT_equals "bar bar"

call :exec get_2nd_positional_arg OUTPUT
call :assert_OUTPUT_equals ""

call :exec get_2nd_positional_arg OUTPUT foo "" bar
call :assert_OUTPUT_equals ""


::::::::::::::::::::::::::::::::
:: test get_nth_positional_arg
::::::::::::::::::::::::::::::::
call :exec get_nth_positional_arg 5 OUTPUT arg1 arg2 arg3 arg4 arg5 arg6
call :assert_OUTPUT_equals arg5

call :exec get_nth_positional_arg 5 OUTPUT arg1 arg2 arg3 arg4 * arg6
call :assert_OUTPUT_equals *

call :exec get_nth_positional_arg 5 OUTPUT /a /b /c -d "" "" "" "arg4 arg4" /e /f -g "arg5 arg5" "arg6 arg6"
call :assert_OUTPUT_equals "arg5 arg5"

call :exec get_nth_positional_arg 5 OUTPUT
call :assert_OUTPUT_equals ""

call :exec get_nth_positional_arg 5 OUTPUT arg1 arg2 arg3 arg4 "" arg6
call :assert_OUTPUT_equals ""

popd

exit /b %failures%


::::::::::::::::::::::::::::::::
:: utilities
::::::::::::::::::::::::::::::::
:exec
  echo Testing: args.cmd %*
  call args.cmd %*
goto :eof


:assert_exec_ok
  echo Testing: args.cmd %*
  call args.cmd %* || (
    echo   -^> FAILED
    set /a failures+=1
    exit /b 1
  )
  echo   -^> OK
goto :eof


:assert_exec_nok
  echo Testing: args.cmd %*
  call args.cmd %* && (
    set /a failures+=1
    echo   -^> FAILED
    exit /b 1
  )
  echo   -^> OK
goto :eof

:assert_OUTPUT_equals
  if not "%OUTPUT%" == "%~1" (
    echo   -^> FAILED (OUTPUT is not "%~1" but "%OUTPUT%"^)
    set /a failures+=1
    exit /b 1
  )
  echo   -^> OK (OUTPUT == "%OUTPUT%"^)
goto :eof


:assert_OUTPUT_not_equals
  if "%OUTPUT%" == "%~1" (
    echo   -^> FAILED (OUTPUT == "%~1" but should not be^)
    set /a failures+=1
    exit /b 1
  )
  echo   -^> OK (OUTPUT != "%OUTPUT%"^)
goto :eof
