<?php  
  header('Content-Type: application/json');
  
  include('connect.php');

  $room_name = $_REQUEST['room_name'];
  $room_name = str_replace('-', '', $room_name);

  $db = "mongodb://matteo:iitabrate@gru.isti.cnr.it:27017/energia";
  
  $c = new MongoClient( $db );

  // Getting MongoDB
  $db = $c->energia;
  $d3_array = array();
  // Getting MongoCollection
  $collection = $db->data;

  $IdR = $dbmysqli->query("SELECT IdRoom FROM rooms WHERE Name = '$room_name'");

  if(mysqli_num_rows($IdR) > 0) {
    $room_id = $IdR->fetch_array(MYSQLI_ASSOC);
    $room_id = $room_id['IdRoom'];
    
    $services = $dbmysqli->query("SELECT * FROM sensors WHERE IdR = $room_id ORDER BY SensorType");
    while ($rowService = $services->fetch_array(MYSQLI_ASSOC)) {
      $cursor = $collection->find(['serviceId' => $rowService['MacAddress']])->sort(array("timestamp" => -1))->limit(1);
      
      foreach($cursor as $document){
        //echo json_encode($document['values'][$rowService['ValueType']]);
        if ($rowService['ValueType'] == 'Power') {
          // transformation to kW
          $rowService['value'] = intval($document['values'][$rowService['ValueType']])/1000;
        } else {
          $rowService['value'] = $document['values'][$rowService['ValueType']];  
        }
        
      }
      
      $d3_array[] = $rowService;
    }
  
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

