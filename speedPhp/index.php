<?php
define("SP_PATH",dirname(__FILE__)."/SpeedPHP");
define("APP_PATH",dirname(__FILE__));
$spConfig = array(                                                              //数据库配置
		"db" => array(
		'host' => '127.0.0.1',
		'login' => 'root',
		'password' =>'root',
		'database' => 'notepad',
	),
);
require(SP_PATH."/SpeedPHP.php");
spRun();