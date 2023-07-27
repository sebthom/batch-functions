@echo off
:: SPDX-FileContributor: Sebastian Thomschke
:: SPDX-License-Identifier: CC0-1.0
:: SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/batch-functions

setlocal

pushd %~dp0..\modules\

set failures=0

::::::::::::::::::::::::::::::::
:: test ends_with
::::::::::::::::::::::::::::::::
call :assert_exec_ok ends_with foobar bar
call :assert_exec_ok ends_with foobar ""
call :assert_exec_nok ends_with foobar foo
call :assert_exec_nok ends_with "" foo
call :assert_exec_ok ends_with "foo bar" bar
call :assert_exec_ok ends_with "foo bar ..." "bar ..."


::::::::::::::::::::::::::::::::
:: test ends_with
::::::::::::::::::::::::::::::::
call :assert_exec_ok has_substring foobar bar
call :assert_exec_ok has_substring foobar ""
call :assert_exec_ok has_substring " " ""
call :assert_exec_ok has_substring "" ""
call :assert_exec_nok has_substring "" foo


::::::::::::::::::::::::::::::::
:: test replace_substrings
::::::::::::::::::::::::::::::::
call :exec replace_substrings "foobar" "oo" "00" OUTPUT
call :assert_OUTPUT_equals f00bar

call :exec replace_substrings "foobar" "oo" "" OUTPUT
call :assert_OUTPUT_equals fbar

call :exec replace_substrings "foobar" "" "xx" OUTPUT
call :assert_OUTPUT_equals foobar


::::::::::::::::::::::::::::::::
:: test substring_before
::::::::::::::::::::::::::::::::
call :exec substring_before "foobar" "bar" OUTPUT
call :assert_OUTPUT_equals foo

call :exec substring_before "foobar" "oo" OUTPUT
call :assert_OUTPUT_equals f

call :exec substring_before "foobar" "" OUTPUT
call :assert_OUTPUT_equals foobar

call :exec substring_before "" "foo" OUTPUT
call :assert_OUTPUT_equals ""

exit /b %failures%


::::::::::::::::::::::::::::::::
:: utilities
::::::::::::::::::::::::::::::::
:exec
  echo Testing: strings.cmd %*
  call strings.cmd %*
goto :eof


:assert_exec_ok
  echo Testing: strings.cmd %*
  call strings.cmd %* || (
    echo   -^> FAILED
    set /a failures+=1
    exit /b 1
  )
  echo   -^> OK
goto :eof


:assert_exec_nok
  echo Testing: strings.cmd %*
  call strings.cmd %* && (
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
