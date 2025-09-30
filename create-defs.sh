#!/bin/bash
# create-defs.sh   -- creates the defs.tex file needed for the manual by running gle
#
# Extract version number
version=$(gle /info | grep "GLE version" | awk -F: '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//')
# Extract Cairo support status and convert to 1 or 0
cairo_raw=$(gle /info | grep "Cairo rendering support" | awk -F: '{print $2}' | xargs)
if [[ "$cairo_raw" == "Yes" ]]; then
  cairo=#1
else
  cairo=
fi

# Detect if running on macOS
# define the APPLE command to elimnate the countour plots for macOS in utilities\countour.tex
# the coutour figures cause a seg fault in GLE and this workaround eliminates
# them so the workflow finishes on GitHub.  Need to fix.
if [[ "$(uname)" == "Darwin" ]]; then
  apple="\\def\\APPLE{1}"
else
  apple=""
fi

# Write both commands to defs.tex
{
  echo "\\newcommand{\\gleversion}{$version}"
  echo "\\newcommand{\\hascairo}[1]{$cairo}"
  echo "$apple"
} > defs.tex

# Handle command-line argument for extrafont.tex
if [[ "$1" == "1" ]]; then
  echo "\\newcommand{\\extrafonts}[1]{#1}" > fonttest/extrafonts.tex
else
  echo "\\newcommand{\\extrafonts}[1]{}" > fonttest/extrafonts.tex
fi