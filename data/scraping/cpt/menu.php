<?php 

header('Content-Type: application/json');

$result = shell_exec('sh ./menu.sh');

$rows = explode("\n", $result);

$array = [];

for ($i = 0; $i<count($rows)-1; $i++) {
  $array[] = str_replace('"', '', $rows[$i]);
}

echo json_encode($array, true);

?>