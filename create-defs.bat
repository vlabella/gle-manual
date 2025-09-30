@echo off
:: create-defs.bat -- creates the defs.tex file needed for the manual by running gle
setlocal enabledelayedexpansion

:: Initialize variables
set "version="
set "cairo="
:: Default to 0 if no argument is provided
set "extrafontflag="
if not "%~1"=="" (
    set "extrafontflag=#1"
)

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
    echo "%"
    echo "% defs.tex - automatically generated.  All changes will be lost."
    echo "%"
    echo \newcommand{\gleversion}{%version%}
    echo \newcommand{\hascairo}[1]{%cairo%}
    echo \newcommand{\extrafonts}[1]{%extrafontflag%}
) > defs.tex

endlocal
