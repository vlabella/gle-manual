#!/bin/bash
#
# create-defs.sh -- creates the defs.tex file needed for the manual by running gle
#
# Capture and decolorize GLE info
gle_info="$(gle -info 2>/dev/null || true)"
# Strip ANSI color codes (common sequences ending with 'm', but also handle other terminators)
gle_info_nocolor="$(printf '%s\n' "$gle_info" | sed -r 's/\x1B\[[0-9;]*[A-Za-z]//g')"
#
# -- Extract version number
#
version="$(printf '%s\n' "$gle_info_nocolor" | awk -F: '/GLE version/ {gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2; exit}')"
echo $version
#
# -- Cairo (from "Cairo rendering support: Yes")
#
cairo_raw="$(printf '%s\n' "$gle_info_nocolor" | awk -F: '/Cairo rendering support/ {gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2; exit}')"
cairo=
if [[ "$cairo_raw" == "Yes" ]]; then
  cairo=#1
fi
#
# -- Detect if running on macOS
# define the APPLE command to elimnate the countour plots for macOS in utilities\countour.tex
# the coutour figures cause a seg fault in GLE and this workaround eliminates
# them so the workflow finishes on GitHub.  Need to fix.
#
apple=""
if [[ "$(uname)" == "Darwin" ]]; then
  apple="\\def\\APPLE{1}"
fi
#
# -- Handle command-line argument for extrafont.tex
#
extrafonts=
if [[ "$1" == "1" ]]; then
  extrafonts=#1
fi
#
# -- Write commands to defs.tex
#
{
  echo "%"
  echo "% -- defs.tex  Automatically generated.  All changes will be lost."
  echo "%"
  echo "\\newcommand{\\gleversion}{$version}"
  echo "\\newcommand{\\hascairo}[1]{$cairo}"
  echo "\\newcommand{\\extrafonts}[1]{$extrafonts}"
  echo "$apple"
} > defs.tex
echo Created defs.tex