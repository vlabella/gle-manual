@echo off
:: create-defs.bat -- creates the defs.tex file needed for the manual by running gle
setlocal EnableDelayedExpansion

:: ---- Extract version (text after the first colon on the line containing 'version')
for /f "tokens=2 delims=:" %%A in ('gle /info ^| findstr /i "version"') do set "version=%%A"
call :trim version
echo %version%

:: ---- Extract Cairo rendering support (Yes/No)
for /f "tokens=2 delims=:" %%A in ('gle /info ^| findstr /i "Cairo rendering support"') do set "cairo_raw=%%A"
call :trim cairo_raw

set "cairo="
if /i "%cairo_raw%"=="Yes" set "cairo=#1"
:: echo %cairo%
:: ---- Optional argument: enable extrafonts if any arg is passed
set "extrafontflag="
if not "%~1"=="" set "extrafontflag=#1"
call :trim extrafontflag

:: ---- Write defs.tex
(
    echo %%
    echo %% -- defs.tex - Automatically generated. All changes will be lost.
    echo %%
    echo \newcommand{\gleversion}{%version%}
    echo \newcommand{\hascairo}[1]{%cairo%}
    echo \newcommand{\extrafonts}[1]{%extrafontflag%}
) > defs.tex

endlocal
echo Created defs.tex
goto :eof

:: =========================
:: Subroutine: :trim varName
:: Trims leading and trailing spaces from variable passed by name.
:trim
setlocal EnableDelayedExpansion
set "s=!%~1!"

:: Trim leading spaces
for /f "tokens=* delims= " %%L in ("!s!") do set "s=%%L"

:: Trim trailing spaces
:trim_tail
if "!s:~-1!"==" " (
    set "s=!s:~0,-1!"
    goto trim_tail
)

endlocal & set "%~1=%s%"
goto :eof
