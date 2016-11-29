<?php
  header("Access-Control-Allow-Origin: *");

  header('Content-type: application/json');

  $url = 'http://www.weatherlink.com/xml.php?user=pi01e&pass=050pi01';

  $xmlinfo = simplexml_load_file($url);

  //$output2 = shell_exec('wget http://www.weatherlink.com/xml.php?user=pi01e&pass=050pi01');

  print_r(json_encode($xmlinfo));
  //echo "ciao";

?>