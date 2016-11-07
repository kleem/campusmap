<?php  
  header('Content-Type: application/json');
  
  include('connect.php');

  $room_name = $_REQUEST['room_name'];
  $room_name = str_replace('-', '', $room_name);

  $db = "mongodb://matteo:iitabrate@gru.isti.cnr.it:27017/energia";
  
  $c = new MongoClient( $db );

  // Getting MongoDB
  $db = $c->energia;

  // Getting MongoCollection
  $collection = $db->data;

  $IdR = $dbmysqli->query("SELECT IdRoom FROM rooms WHERE Name = '$room_name'");

  
  if(mysqli_num_rows($IdR) > 0) {
    $room_id = $IdR->fetch_array(MYSQLI_ASSOC);
    $room_id = $room_id['IdRoom'];
    
    $services = $dbmysqli->query("SELECT * FROM sensors WHERE IdR = $room_id");
    $sensors = array();
    while ($rowService = $services->fetch_array(MYSQLI_ASSOC)) {
      //echo json_encode($rowService);
      $sensors[] = $rowService;
    }
    $light_sensor = $sensors[6]["MacAddress"];
    
   
    //$start = new MongoDate(strtotime("$year-$month-$day 00:00:00"));
    $end = strtotime('last Monday');
    // andiamo indietro di 10 minuti per essere sicuri di rednere l'istante subito precedente allo stato iniziale
    $start = strtotime('last Monday') - (60*60*24*7) - 60*15;
    
    //echo "start: $start";
    //echo "end: $end";
    $days_name = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat','Sun'];
    $hours_name = ['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23'];
    $s = (intval($start) + 60*10)*1000;
    //echo "s: $s";
    $result = array();
    $d3_array = array();
    // Room C69 sensor "SensorType":"PowerMeter","MonitoredFeature":"LightPower","ValueType":"Power"
    $cursor = $collection->find(['serviceId' => $light_sensor,'timestamp' => array('$gt' => new MongoDate($start), '$lte' => new MongoDate($end)) ]);
    $sum = 0;
    $n_samples = 0;
    $hour = 0;
    foreach($cursor as $document){
      //echo "index: $index";
      $e = $s + 60*60*1000;
      //echo json_encode($document);
      //echo "\n";
      //echo $document['timestamp'];
      //echo " ";
      $sec = explode(' ', $document['timestamp'])[1]*1000;
      $usec = explode(' ', $document['timestamp'])[0];
      //echo $sec;
      //echo "\n";
      //echo $usec;
      //echo "s: $s";
      //echo " ";
      $timestamp = $sec+$usec;
      //echo "timestamp: $timestamp";
      //echo " ";
      //echo $s;
      //echo "e: $e";
      if ($timestamp > $s) {
        if($timestamp > $s && $timestamp < $e) {
          //echo "timestamp: $timestamp";
          //echo $document['values']['Power'];
          $sum += $document['values']['Power'];
          $n_samples +=1;
           

        } else {
          //$date = new DateTime($s/1000);
          $index_day = date('N', $s/1000)-1;
          $index_hour = date('G', $s/1000);
          //$index_day = $date->format('N');
          //echo $index_day;
          //echo " else\n ";
          $d3_array[] = array('day'=>$days_name[$index_day],'hour'=>$hours_name[$index_hour],'power'=>$sum/1000/$n_samples);
          $result["$s"] = $sum/1000/$n_samples;
          $n_samples = 0;
          $sum = 0;
          $hour +=1;
          $s = $e;
          $e = $s + 60*60*1000;

        }

      }
          
      
      //$result[] = array('timestamp' => $document['timestamp'], 'values' => $document['values']['Power']);
    }
    //echo count($result);
    echo json_encode($d3_array);
  } else {
    echo null;
  }

/*

+--------+-----------+
| IdRoom | Name      |
+--------+-----------+
|      1 | C69       |
|      2 | C70       |
|      5 | C70a      |
|      6 | C71       |
|      7 | C73       |
|      8 | C62       |
|      9 | C63       |
|     10 | C64       |
|     11 | C66       |
|     12 | IIT1      |
|     13 | IIT2      |
|     15 | DemoRoom  |
|     17 | DemoRoom2 |
+--------+-----------+

*/




?>

