<?php
class number extends spController
{
	function show()
	{
		$num = 3.1415;
		echo "原来数字是$num";
		echo "<br>";
		$num = round($num);
		echo "经过四舍五入后，结果是：$num";
	}
}
?>