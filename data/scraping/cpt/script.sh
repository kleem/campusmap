#!/bin/bash
#
rm -v cpt.gtfs* *.txt
wget http://dati.toscana.it/dataset/8bb8f8fe-fe7d-41d0-90dc-49f2456180d1/resource/ab89083e-b240-46fc-8e07-6e534b24c458/download/cpt.gtfs
unzip cpt.gtfs*
sh cpt.sh
# rm -v cpt.gtfs* *.txt
