<?php
class number extends spController
{
	function show()
	{
		$num = 3.1415;
		echo "ԭ��������$num";
		echo "<br>";
		$num = round($num);
		echo "������������󣬽���ǣ�$num";
	}
}
?>