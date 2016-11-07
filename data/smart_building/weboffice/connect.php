<?php
  define("DBHOST", "gallina.isti.cnr.it"); // E' il server a cui ti vuoi connettere.
  define("DBUSER", "matteo"); // E' l'utente con cui ti collegherai al DB.
  define("DBPASSWORD", "iitabrate"); // Password di accesso al DB.
  define("DBDATABASE", "weboffice"); // Nome del database.
  $dbmysqli = new mysqli(DBHOST, DBUSER, DBPASSWORD, DBDATABASE);
  if (mysqli_connect_errno()) { echo "Errore in connessione al DBMS: ".mysqli_connect_error(); exit(); }
?>