<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta   http-equiv="Content-Type"   content="text/html;   charset=utf-8"/>
    <meta http-equiv="Content-Style-Type" content="text/css" />
    <meta name="keywords" content="javascript framework, RIA, SPA, client SOA, linb, jsLinb, RAD, IDE, Web IDE, widgets, javascript OOP, opensource, open-source, Ajax, cross-browser, prototype, web2.0, platform-independent, language-independent" />
    <meta name="description" content="Web application created by Visual JS, powered by LINB framework" />
    <meta name="copyright" content="copyright@www.linb.net" />
    <meta http-equiv="imagetoolbar" content="no" />
    <meta content="IE=EmulateIE7" http-equiv="X-UA-Compatible">
    <title>留言版</title>
</head>
    <body>
        <div id='loading'><img src="http://www.linb.net/runtime/loading.gif" alt="Loading..." /></div>
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
		/*echo "<p>请写下您的留言：</p><form action={$posturl} method=POST><p>您的名字：<input type=text name=name></p><p>留言标题：<input type=text name=title></p><p>留言内容：<textarea name=contents></textarea></p><p><input type=submit value=提交></p></form>";
		*/
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
		//print_r($this->spArgs());
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
        <script type="text/javascript" src="http://www.linb.net/runtime/jsLinb/js/linb-all.js"></script>
        <script type="text/javascript" src="http://www.linb.net/runtime/jsLinb/js/adv-all.js"></script>
        <script type="text/javascript">
// 默认的代码是一个从 linb.Com 派生来的的类
Class('App', 'linb.Com',{
    // 要确保键值对的值不能包含外部引用
    Instance:{
        // 实例的属性要在此函数中初始化，不要直接放在Instance下
        initialize : function(){
            // 本Com是否随着第一个控件的销毁而销毁
            this.autoDestroy = true;
            // 初始化属性
            this.properties = {};
        },
        // 初始化内部控件（通过界面编辑器生成的代码，大部分是界面控件）
        // *** 如果您不是非常熟悉linb框架，请慎重手工改变本函数的代码 ***
        iniComponents : function(){
            // [[code created by jsLinb UI Builder
            var host=this, children=[], append=function(child){children.push(child.get(0))};
            
            append(
                (new linb.UI.Dialog)
                .setHost(host,"ctl_dialog2")
                .setLeft(190)
                .setTop(90)
                .setCaption("留言")
				.setHtml("<p>请写下您的留言：</p><form action=index.php?c=main&a=write method=POST><p>您的名字：<input type=text name=name></p><p>留言标题：<input type=text name=title></p><p>留言内容：<textarea name=contents></textarea></p><p><input type=submit value=提交></p></form>")
            );            

            return children;
            // ]]code created by jsLinb UI Builder
        },
        // 加载其他Com可以用本函数
        iniExComs : function(com, threadid){
        },
        // 可以自定义哪些界面控件将会被加到父容器中
        customAppend : function(parent, subId, left, top){
            // "return false" 表示默认情况下所有的第一层内部界面控件会被加入到父容器
            return false;
        },
        // Com本身的事件映射
        events : {},
        // 例子：button 的 click 事件函数
        _ctl_sbutton1_onclick : function (profile, e, src, value) {
            var uictrl = profile.boxing();
            linb.alert("我是 " + uictrl.getAlias());
        }
    }
});

//linb.setAppLangKey('app');
linb.UI.setTheme('default');
linb.Com.load('App', function(){linb('loading').remove()}, 'cn');
        </script>
</body>
</html>