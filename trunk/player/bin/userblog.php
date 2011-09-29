<?php
/////////////////////////////////////////////////////////////////
//云边开源轻博, Copyright (C)   2010 - 2011  qing.thinksaas.cn 
//EMAIL:nxfte@qq.com QQ:234027573                              
//$Id: userblog.php 14 2011-09-22 06:00:43Z anythink $ 

//访问用户博客首页
class userblog extends top
{
	private $user_data = ''; //初始化当前用户的信息
	private $user_skin = ''; //初始化当前用户的主题
	private $user_domain = '';//


	/*显示用户首页 index 采取domain方式显示*/
	public function index()
	{
		$this->getUserSkin(); //获取用户的基本信息，必须头条处理，判断用户是否存在
		$this->follow = spClass('db_follow')->spLinker()->spCache(3600)->findAll(array('uid'=>$this->user_data['uid']),'time desc','','20');  //显示我关注的20个
		$this->blogs = spClass('db_blog')->spLinker()->spPager($this->spArgs('page',1),4)->findAll(array('uid'=>$this->user_data['uid'],'open'=>1),'top desc,bid desc');
		if($this->user_data['domain'] == 'home' || $this->user_data['domain'] == '')
		{ 
			$pg = array('domain'=>'home','uid'=>$this->user_data['uid']); 
		}else{
			$pg = array('domain'=>$this->user_data['domain'],'uid'=>$this->user_data['uid']);
		}
			
		
			

		$this->pager = spClass('db_blog')->spPager()->pagerHtml('userblog','index',$pg);
	
		$this->display('index.html');
	}
	

	
	/*显示某一条记录*/
	public function show()
	{
		$this->getUserSkin($this->spArgs('bid'));
		$this->d = spClass('db_blog')->spLinker()->spPager($this->spArgs('page',1),4)->find(array('uid'=>$this->user_data['uid'],'bid'=>$this->spArgs('bid')));
		if(is_array($this->d))
		{
			spClass('db_blog')->incrField(array('bid'=>$this->spArgs('bid')), 'hitcount'); 
			$this->display('list.html',$this->result);
		}else{
			err404('您查看的内容可能已经修改或者删除。');	
		}
	}
	
	
	/*获取用户的skin and base info
	  读取 domain 或者 uid,或者从$bid 读取
	*/
	private function getUserSkin($bid=0)
	{
	
		if($this->spArgs('domain') != 'home' && $this->spArgs('domain') != '')
		{
			$rs = spClass('db_theme')->getByDomain($this->spArgs('domain'));
		}elseif($this->spArgs('uid') != ''){
			$rs = spClass('db_theme')->getByUid($this->spArgs('uid'));
		}else{
			$rs = spClass('db_theme')->getByBid($this->spArgs('bid'));
		}
		if(!is_array($rs)) {err404('您访问的用户不存在,用户可能已经更改了个性域名');}
		
		$skin = spClass('db_theme')->find(array('uid'=>$rs['uid']));
		$this->user_data = $rs;
		$this->user_skin = $skin;   //将数据赋值给全局变量
	}



	/*覆盖原始display*/
	public function display($tplname,$rs)
	{

		// 模板内引用文件的路径
		$site_uri = trim(dirname($GLOBALS['G_SP']['url']["url_path_base"]),"\/\\");
		if( '' == $site_uri ){ $site_uri = 'http://'.$_SERVER["HTTP_HOST"]; 	}else{ $site_uri = 'http://'.$_SERVER["HTTP_HOST"].'/'.$site_uri; }
		$this->site_uri = $site_uri;
		
		$this->user_skin['theme'] == '' ? $theme = 'default' : $theme = $this->user_skin['theme'];   //获取我选择的风格
		$this->user_skin['css'] == '' ? $css = '' : $css = $this->user_skin['css'];   //获取我选择的风格
		
		$this->themes_path = $site_uri.'/tpl/theme/'.$theme.'/';
		$this->global_path = $site_uri.'/tpl/';
		$this->custom_css = $css;
		
		$this->username = $this->user_data['username'];
		$this->usertag = $this->user_data['blogtag'];
		$this->domain = ($this->user_data['domain'] == '') ? 'home' : $this->user_data['domain'];  //如果没定义domain 就是home
		
	
		$this->uid = $this->user_data['uid'];
		$this->usersign =strip_tags($this->user_data['sign']);//strip_tags
		$this->signhtml =strip_tags($this->user_data['sign'],'<b><font><p></span>');//strip_tags
		$this->user = $this->user_data;

	
		$appPath = APP_PATH.'/tpl/theme/default/'.$tplname;
		if($theme != 'default'){ 
			$appPath = APP_PATH.'/tpl/theme/'.$theme.'/'.$tplname;
			if(!file_exists($appPath)){
				$appPath = APP_PATH.'/tpl/theme/default/'.$tplname;  //如果模板不存在则加载默认模板
			}  
		}
	
		parent::display($appPath,TRUE);
	}

}
