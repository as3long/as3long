<?php

class main extends spController
{
	function index(){
	}
	
	/**
	* phpµÄ·´Éä
	*/
	function action($actionStr)
	{
		$class=new ReflectionClass($actionStr);
		$fuc=$class->newInstance();
		$fuc->action();
	}
}
