#!/bin/bash

set -e; set -u

function MAKE_TEX {
    TGT=$1
    TEX=${TGT}.tex
    PDF=${TGT}.pdf
    TMP="/tmp"
    if [[ $TEX -nt $PDF ]]; then
      pdflatex    -interaction=nonstopmode -output-directory $TMP $TEX
  #    biber       --output_directory $TMP $TGT
      cp $TMP/$PDF .
    fi
}


PE="../problem-extractor/pe.py"
PROBLEMS="sana-problems.tex"
TMP="/tmp"


for KEYS in problems-??.txt; do
    NO=`echo ${KEYS:9:2} | bc`
    TEX=${KEYS/.txt/.tex}
    PDF=${KEYS/.txt/.pdf}

    if [[ $KEYS -nt $PDF  ]]; then
        $PE $KEYS $PROBLEMS | sed -r "s/SHEETNO/$NO/g" >> $TMP/$TEX
        pdflatex    -output-directory   $TMP $TMP/$TEX
        cp $TMP/${KEYS/.txt/.pdf} `pwd`
    fi
done


MAKE_TEX js-comments
