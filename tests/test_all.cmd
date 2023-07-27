@echo off
:: SPDX-FileContributor: Sebastian Thomschke
:: SPDX-License-Identifier: CC0-1.0
:: SPDX-ArtifactOfProjectHomePage: https://github.com/sebthom/batch-functions

for %%f in ( %~dp0test_*.cmd) do (
  if not "%%f" == "%~f0" (
    echo ###########################################
    echo # Executing [%%~nxf]...
    echo ###########################################
    call %%f || exit /B 1
    echo.
  )
)
