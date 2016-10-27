#!/bin/bash
#
DATA=$( date '+%B')
case $DATA in
  "January") DATA="gennaio"
;;
  "February") DATA="febbraio"
;;
  "March") DATA="marzo"
;;
  "April") DATA="aprile"
;;
  "May") DATA="maggio"
;;
  "June") DATA="giugno"
;;
  "July") DATA="luglio"
;;
  "August") DATA="agosto"
;;
  "September") DATA="settembre"
;;
  "October") DATA="ottobre"
;;
  "November") DATA="novembre"
;;
  "December") DATA="novembre"
;;
esac
wget http://www.area.pi.cnr.it/index.php/mensa/menu-del-mese -O - 2>/dev/null | grep -oP 'src="/images/'$DATA'.+?"' | cut -d'=' -f2
