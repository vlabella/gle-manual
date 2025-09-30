@echo off
:: create-defs.bat -- creates the defs.tex file needed for the manual by running gle
setlocal enabledelayedexpansion

:: Default to 0 if no argument is provided
set "extrafontflag=0"
if not "%~1"=="" (
    set "extrafontflag=%~1"
)

:: Initialize variables
set "version="
set "cairo="

:: Run gle /info and parse output
for /f "tokens=1,* delims=:" %%A in ('gle /info') do (
    set "line=%%A"
    set "value=%%B"
    set "line=!line:~0,20!"
    set "value=!value:~1!"

    :: Trim leading/trailing whitespace
    for /f "tokens=* delims= " %%C in ("!value!") do set "value=%%C"

    if /i "!line!"=="GLE version" (
        set "version=!value!"
    )

    if /i "!line!"=="Cairo rendering supp" (
        if /i "!value!"=="Yes" (
            set "cairo=#1"
        ) else (
            set "cairo="
        )
    )
)

:: Write to defs.tex
(
    echo \newcommand{\gleversion}{%version%}
    echo \newcommand{\hascairo}[1]{%cairo%}
) > defs.tex

:: Create extrafont.tex

if "%extrafontflag%"=="1" (
    echo \newcommand{\extrafonts}[1]{#1} > "fonttest\extrafonts.tex"
) else (
    echo \newcommand{\extrafonts}[1]{} > "fonttest\extrafonts.tex"
)

endlocal
