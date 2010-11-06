<?php
define("SP_PATH",dirname(__FILE__)."/SpeedPHP");
define("APP_PATH",dirname(__FILE__));
$spConfig = array(
		"db" => array( // 数据库设置
		'host' => '127.0.0.1',  // 数据库地址，一般都可以是localhost
		'login' => 'root', // 数据库用户名
		'password' => '', // 数据库密码
		'database' => 'notepad', // 数据库的库名称
	),
);
require(SP_PATH."/SpeedPHP.php");
spRun();