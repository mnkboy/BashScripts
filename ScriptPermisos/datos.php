
<?php
$fichero = 'datos.txt';
$_configuration['db_host'] = '108.175.5.131';
$_configuration['db_port'] = '3306';
$_configuration['main_database'] = 'ceib';
$_configuration['db_user'] = 'ce1bUs3r';
$_configuration['db_password'] = 'tv64JxzaFkVzbwWwc2CTq';
  echo "Este es el db_host: ".$_configuration["db_host"]."\n";
  echo "Este es el db_port: ".$_configuration["db_port"]."\n";
  echo "Este es el main_database: ".$_configuration["main_database"]."\n";
  echo "Este es el db_user: ".$_configuration["db_user"]."\n";
  echo "Este es el db_password: ".$_configuration["db_password"]."\n";
  $txt = "============ PERMISOS ceib ============\n";
  $txt .= "GRANT USAGE ON *.* TO '".$_configuration['db_user']."'@'".$_configuration['db_host']."' \n";
  $txt .= "IDENTIFIED BY '".$_configuration['db_password']."' \n";
  $txt .= "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, \n";
  $txt .= "ALTER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, CREATE VIEW, SHOW VIEW, \n";
  $txt .= "CREATE ROUTINE, ALTER ROUTINE, EVENT, TRIGGER ON '".$_configuration["main_database"]."'.* TO '".$_configuration["db_user"]."'@'".$_configuration['db_host']."'; \n";
  $txt .= "============ MIGRACION ceib DB============\n";
  $txt .= "mysqldump -h ".$_configuration['db_host']." -u ".$_configuration['db_user']." -p --".$_configuration['main_database']."  ceib > ".$_configuration['main_database'].".sql\n";
  file_put_contents($fichero, $txt, FILE_APPEND | LOCK_EX);
?>
