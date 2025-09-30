#!/bin/bash
# create-defs.sh   -- creates the defs.tex file needed for the manual by running gle
# Extract version number
version=$(gle /info | grep "GLE version" | awk -F: '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//')
# Extract Cairo support status and convert to 1 or 0
cairo_raw=$(gle /info | grep "Cairo rendering support" | awk -F: '{print $2}' | xargs)
if [[ "$cairo_raw" == "Yes" ]]; then
  cairo=#1
else
  cairo=
fi
# Write both commands to defs.tex
{
  echo "\\newcommand{\\gleversion}{$version}"
  echo "\\newcommand{\\hascairo}[1]{$cairo}"
} > defs.tex