#!/usr/bin/bash
#
CMD=$(basename $0)
WRKF1=./${CMD}_tmp1   # Orari delle fermate a $STOP_TEXT
WRKF2=./${CMD}_tmp2
WRKF3=./${CMD}_tmp3
WRKF4=./${CMD}_tmp4
OUTF=./cpt.json       # File .json dei risultati

#trap "rm -f $WRKF1 $WRKF2 $WRKF3 $WRKF4 2>/dev/null ; exit" 0 1 2 3 15

STOP_TEXT="Pisa V.Volpi Cnr"

STOP_ID=$(grep "$STOP_TEXT" stops.txt | cut -d"," -f1)

echo
echo "Estrazione degli orari delle fermate a $STOP_TEXT (STOP_ID=$STOP_ID)"

STOP_TIMES=$(grep "$STOP_ID" stop_times.txt)
grep "$STOP_ID" stop_times.txt >$WRKF1

>$WRKF2

echo -e "\nEstrazione dei campi:
TRIP_ID DEPARTURE_TIME 
ROUTE_ID SERVICE_ID 
ROUTE_SHORT_NAME ROUTE_LONG_NAME\n"

cat $WRKF1 | while read RIGA1
do

   TRIP_ID=$(echo $RIGA1 | cut -d"," -f1)
   DEPARTURE_TIME=$(echo $RIGA1 | cut -d"," -f3)
   echo -e "$TRIP_ID \c" >>$WRKF2
   echo -e "$DEPARTURE_TIME \c" >>$WRKF2

   #--- grep "$TRIP_ID" trips.txt | cut -d"," -f4
   ROUTE_ID=$(grep "$TRIP_ID" trips.txt | cut -d"," -f1)
   SERVICE_ID=$(grep "$TRIP_ID" trips.txt | cut -d"," -f2)
   echo -e "$SERVICE_ID \c" >>$WRKF2
   echo -e "$ROUTE_ID \c" >>$WRKF2

   ROUTE_SHORT_NAME=$(grep "$ROUTE_ID" routes.txt | cut -d"," -f3)
   ROUTE_LONG_NAME=$(grep "$ROUTE_ID" routes.txt | cut -d"," -f4)
   echo -e "$ROUTE_SHORT_NAME \c" >>$WRKF2
   echo -e "$ROUTE_LONG_NAME \c" >>$WRKF2
   echo >>$WRKF2

done

echo -e "\nCreazione del file .json"

INC=0

echo "[" >$OUTF

while [ $INC -lt 6 ]

do

  SEARCH_DATE=$(date '+%C%y%m%d' -d "+$INC days")
  echo "SEARCH_DATE=$SEARCH_DATE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
  echo "	{\"date\":\"$SEARCH_DATE\",\"timetable\":" >>$OUTF
  echo "	[" >>$OUTF

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

       # NREC è il numero delle righe estratte
       # Quando le righe vengono processate bisogna contarle
       # e omettere il carattere "," alla fine dell'ultima riga estratta.
       # Riga normale:
       #    echo "		{\"time\":$TIME,\"bus_name\":$BUS_NAME,\"end_station\":$END_STATION}," >>$OUTF
       # Rltima riga:
       #    echo "		{\"time\":$TIME,\"bus_name\":$BUS_NAME,\"end_station\":$END_STATION}" >>$OUTF

       if [ $NREC -ne 0 ]; then
    
          cat $WRKF4 | while read RIGA4

          do

            TIME=$(echo $RIGA4 | cut -d" " -f2) 
            BUS_NAME=$(echo $RIGA4 | cut -d" " -f5) 
            END_STATION=$(echo $RIGA4 | cut -d" " -f6)
            echo "		{\"time\":$TIME,\"bus_name\":$BUS_NAME,\"end_station\":$END_STATION}," >>$OUTF

          done

       fi

   fi

  done

  echo "	]" >>$OUTF
  echo "	}," >>$OUTF

  INC=$(( $INC + 1 ))

done

echo "]" >>$OUTF

