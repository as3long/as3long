<?php

class main extends spController
{
	function index(){
	}
	
	/**
	* php�ķ���
	*/
	function action($actionStr)
	{
		$class=new ReflectionClass($actionStr);
		$fuc=$class->newInstance();
		$fuc->action();
	}
}
