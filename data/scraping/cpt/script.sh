#!/bin/bash
#
#wget http://dati.toscana.it/dataset/rt-oraritb/resource/70d34dbc-259e-4051-b51e-979ace4fcc9b -O - 2>/dev/null | grep -oP 'href="\Khttp:.+?"' | sed 's/"//' | grep gtfs | sed '2d' >url.txt
wget http://dati.toscana.it/dataset/rt-oraritb/resource/e596c8fa-3c8b-4a2d-862e-26f52691a113 -O - 2>/dev/null | grep -oP 'href="\Khttp:.+?"' | sed 's/"//' | grep gtfs | sed '2d' >url.txt
URL="$(grep 'http' url.txt)"
wget "${URL}"
unzip cpt.gtfs*
sh cpt.sh
echo
rm -v cpt.gtfs* *.txt

