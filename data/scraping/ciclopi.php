<?php
header('Content-Type: application/json');


$command ="wget -q -O -  http://www.ciclopi.eu/frmLeStazioni.aspx | grep \"wcPGoogle_radRotStazioni_i23_label23\" | sed -e '1,$ s/                                                <span id=\"wcPGoogle_radRotStazioni_i23_label23\" class=\"Red\">//' | sed -e '1,$ s/ bici libere<br>/,/' | sed -e '1,$ s/ bici libera<br>/,/' | sed -e '1,$ s/ posti disponibili<\/span>//' | sed -e '1,$ s/ posto disponibile<\/span>//'";
// wget -q -O -  http://www.ciclopi.eu/frmLeStazioni.aspx | grep "wcPGoogle_radRotStazioni_i23_label23" | sed -e '1,$ s/                                                <span id="wcPGoogle_radRotStazioni_i23_label23" class="Red">//' | sed -e '1,$ s/ bici libere<br>/,/' | sed -e '1,$ s/ posti disponibili<\/span>//'

$output = shell_exec($command);
echo json_encode($output);



?>