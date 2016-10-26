#!/bin/bash
#
CMD=$(basename $0)
WRKF1=./${CMD}_tmp1   # Orari delle fermate a $STOP_TEXT
WRKF2=./${CMD}_tmp2
WRKF3=./${CMD}_tmp3
WRKF4=./${CMD}_tmp4
OUTF=./cpt.json       # File .json dei risultati

# trap "rm -f $WRKF1 $WRKF2 $WRKF3 $WRKF4 2>/dev/null ; exit" 0 1 2 3 15

STOP_TEXT="Cnr"

STOP_ID=$(grep "$STOP_TEXT" stops.txt | cut -d"," -f1)

echo
echo "Estrazione degli orari delle fermate a \"$STOP_TEXT\" (STOP_ID=$STOP_ID)"

STOP_TIMES=$(grep "$STOP_ID" stop_times.txt)
grep "$STOP_ID" stop_times.txt >$WRKF1

>$WRKF2

echo
echo "Estrazione dei campi:
TRIP_ID DEPARTURE_TIME 
ROUTE_ID SERVICE_ID 
ROUTE_SHORT_NAME ROUTE_LONG_NAME"
echo

cat $WRKF1 | while read RIGA1
do

   TRIP_ID=$(echo $RIGA1 | cut -d"," -f1)
   DEPARTURE_TIME=$(echo $RIGA1 | cut -d"," -f3)
   echo -n "${TRIP_ID} " >>$WRKF2
   echo -n "${DEPARTURE_TIME} " >>$WRKF2

   ROUTE_ID=$(grep "$TRIP_ID" trips.txt | cut -d"," -f1)
   SERVICE_ID=$(grep "$TRIP_ID" trips.txt | cut -d"," -f2)
   echo -n "${SERVICE_ID} " >>$WRKF2
   echo -n "${ROUTE_ID} " >>$WRKF2

   ROUTE_SHORT_NAME=$(grep "$ROUTE_ID" routes.txt | cut -d"," -f3)
   ROUTE_LONG_NAME=$(grep "$ROUTE_ID" routes.txt | cut -d"," -f4)
   echo -n "${ROUTE_SHORT_NAME} " >>$WRKF2
   echo -n "${ROUTE_LONG_NAME} " >>$WRKF2
   echo >>$WRKF2

done

echo "Creazione del file .json"
echo

INC=0

CNTREC=0
echo "CNTREC=$CNTREC"

TOTREC=0
echo "TOTREC=$TOTREC"

echo "[" >$OUTF

while [ $INC -lt 7 ]

do

  # Ciclo sui 7 giorni di estrazione

  # CNTREC=0
  # echo "CNTREC=0"

  SEARCH_DATE=$(date '+%C%y%m%d' -d "+$INC days")
  echo "SEARCH_DATE=$SEARCH_DATE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
  echo "  {\"date\":\"$SEARCH_DATE\",\"timetable\":" >>$OUTF
  echo "  [" >>$OUTF

  grep $SEARCH_DATE calendar_dates.txt >$WRKF3

  cat $WRKF3 | while read RIGA3

  do

    SERVICE_ID=$(echo $RIGA3 | cut -d"," -f1) 

    # echo "SERVICE_ID = $SERVICE_ID"
    if [ -z $SERVICE_ID ]; then

       :

    else

       grep $SERVICE_ID $WRKF2 >$WRKF4
       NREC=$(wc -l $WRKF4 | cut -d" " -f1)

       # NREC = numero delle righe estratte.
       # Quando le righe vengono processate bisogna contarle
       # e omettere il carattere "," alla fine dell'ultima riga estratta.
       # Riga normale:
       #    echo "    {\"time\":$TIME,\"bus_name\":$BUS_NAME,\"end_station\":$END_STATION}," >>$OUTF
       # Ultima riga:
       #    echo "    {\"time\":$TIME,\"bus_name\":$BUS_NAME,\"end_station\":$END_STATION}" >>$OUTF

       TOTREC=$(( $TOTREC + $NREC ))

       if [ $NREC -ne 0 ]; then
    
          # CNTREC=0

          cat $WRKF4 | while read RIGA4

          do

            # echo $RIGA4
            # RIGA4=$(echo $RIGA4 | sed -e "s/LAM /LAM_/")
            # RIGA4=$(echo $RIGA4 | sed -e "s/Linea /Linea_/")

            # echo $RIGA4 | awk -F ' \"' '{print $1; print $5; print $6}'
            TIME=$(echo $RIGA4 | awk -F ' \"' '{print $2}')
            # echo "TIME=$TIME"
            BUS_NAME=$(echo $RIGA4 | awk -F ' \"' '{print $5}')
            # echo "BUS_NAME=$BUS_NAME"
            END_STATION=$(echo $RIGA4 | awk -F ' \"' '{print $6}')
            # echo "END_STATION=$END_STATION"

            # TIME=$(echo $RIGA4 | cut -d" " -f2) 
            # BUS_NAME=$(echo $RIGA4 | cut -d" " -f5) 
            # END_STATION=$(echo $RIGA4 | cut -d" " -f6)

            CNTREC=$(( $CNTREC + 1 ))
            echo "NREC=$NREC / CNTREC=$CNTREC / TOTREC=$TOTREC"
            
            if [ $CNTREC -ne $TOTREC ]; then
               echo "    {\"time\":\"$TIME,\"bus_name\":\"$BUS_NAME,\"end_station\":\"$END_STATION}," >>$OUTF
            else
               echo "    {\"time\":\"$TIME,\"bus_name\":\"$BUS_NAME,\"end_station\":\"$END_STATION}" >>$OUTF
            fi

          done

       fi

   fi

  done

  echo "  ]" >>$OUTF
  echo "  }," >>$OUTF

  INC=$(( $INC + 1 ))

done

echo "]" >>$OUTF

