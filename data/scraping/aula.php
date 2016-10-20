<?php
  header("Access-Control-Allow-Origin: *");

  header('Content-type: application/json');

  $aula = $_REQUEST['aula'];

  $output = shell_exec('casperjs aula.js --ssl-protocol=any --aula='.$aula);

  echo($output);


?>