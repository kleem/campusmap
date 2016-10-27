#!/bin/bash
#
wget http://dati.toscana.it/dataset/8bb8f8fe-fe7d-41d0-90dc-49f2456180d1/resource/70d34dbc-259e-4051-b51e-979ace4fcc9b/download/cpt.gtfs
unzip cpt.gtfs*
sh cpt.sh
rm -v cpt.gtfs* *.txt

