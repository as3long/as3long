<?php
define("SP_PATH",dirname(__FILE__)."/SpeedPHP");
define("APP_PATH",dirname(__FILE__));
$spConfig = array(
		"db" => array( // ���ݿ�����
		'host' => '127.0.0.1',  // ���ݿ��ַ��һ�㶼������localhost
		'login' => 'root', // ���ݿ��û���
		'password' => '', // ���ݿ�����
		'database' => 'notepad', // ���ݿ�Ŀ�����
	),
);
require(SP_PATH."/SpeedPHP.php");
spRun();