<html>
<head>
<meta   http-equiv="Content-Type"   content="text/html;   charset=utf-8"/>
<title></title>
</head>
<body>
<?php
class main extends spController
{
	function index(){ // 这里是首页
	echo "<p align=center><h2>我的留言本</h2></p>";
	$guestbook = spClass("guestbook"); // 用spClass来初始化留言本数据表对象（模型类对象）
		if( $result = $guestbook->findAll() ){ // 用findAll将全部的留言查出来
			foreach($result as $value){ // 循环输出留言信息
				$contentsurl = spUrl("main", "show", array('id'=>$value['id'])); // 用spUrl制造查看留言内容页面地址，请注意array('id'=>$value['id'])将传递ID到查看页面，由spArgs来接收。
				echo "<p>这里是第{$value['id']}条留言：<a href={$contentsurl} target=_blank>{$value['title']}</a>&nbsp;&nbsp;{$value['name']}</p>";
			}
		}
		$posturl = spUrl("main", "write"); // 用spUrl制造写留言的地址
		// 下面做一个表单来提交留言，请注意这些输入框的name属性，它们都对应了数据表guestbook的字段名！
		echo "<p>请写下您的留言：</p><form action={$posturl} method=POST><p>您的名字：<input type=text name=name></p><p>留言标题：<input type=text name=title></p><p>留言内容：<textarea name=contents></textarea></p><p><input type=submit value=提交></p></form>";
	}
	function show(){ // 这里是查看留言内容
		$id = $this->spArgs("id"); // 用spArgs接收spUrl传过来的ID
		$guestbook = spClass("guestbook");  // 还是用spClass
		$condition = array('id'=>$id); // 制造查找条件，这里是使用ID来查找属于ID的那条留言记录
		$result = $guestbook->find($condition);  // 这次是用find来查找，我们把$condition（条件）放了进去
		// 下面输出了该条留言内容
		echo "<p>留言标题：{$result['title']}</p>";
		echo "<p>留言者：{$result['name']}</p>";
		echo "<p>留言内容：{$result['contents']}</p>";
	}
	function write(){ // 这里是留言
		$guestbook = spClass("guestbook");
		print_r($this->spArgs());
		$newrow = array(
			'name' => $this->spArgs('name'),
			'title' => $this->spArgs('title'),
			'contents' => $this->spArgs('contents'),
		);
		$guestbook->create($newrow); // 这里用$this->spArgs()取得了表单的全部内容，然后增加了一条留言记录
		echo "留言成功，<a href=/speed/index.php>返回</a>";
	}
}
?>
</body>
</html>