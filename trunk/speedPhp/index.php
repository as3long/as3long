<?php
define("APP_PATH",dirname(__FILE__));
define("SP_PATH",dirname(__FILE__).'/SpeedPHP');
$spConfig = array(
	'db'=>array(
		'driver'=>'mysql',
		'host'=>'localhost',
		'login'=>'root',
		'password'=>'root',
		'database'=>'rush360',
		'prefix' => '' 
	)

);
require(SP_PATH."/SpeedPHP.php");
spRun();