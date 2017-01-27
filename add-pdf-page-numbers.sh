#!/bin/bash -x

in=$1
out=$2
indent=10
pageNumberIndent=10
pageCountIndent=56
pageCountIndent=$pageNumberIndent
font=LiberationSerif-Italic
fontSize=9
bottomMargin=10
pageCount=`pdfinfo $in | grep "Pages:" | tr -s ' ' | cut -d" " -f2`
pagedesc=$( printf "$3" `pdfinfo $in | grep "Pages:" | tr -s ' ' | cut -d" " -f2` )
echo $pagedesc
pspdftool "number(x=$pageNumberIndent pt, y=$bottomMargin pt, start=1, size=$fontSize, font=\"$font\")" $in tmp.pdf; \
# pspdftool "text(x=$indent pt, y=$bottomMargin pt, size=$fontSize, font=\"$font\", text=\"\")" tmp.pdf tmp.pdf; \
pspdftool "text(x=$pageCountIndent pt, y=$bottomMargin pt, size=$fontSize, font=\"$font\", text=\"  $pagedesc\")" tmp.pdf $out; \
rm tmp.pdf;
