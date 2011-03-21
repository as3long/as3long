package com.mySite 
{
	import com.webBase.event.PageSizeEvent;
	import com.webBase.event.ParentEvent;
	import com.webBase.Menu;
	import com.webBase.ParentBase;
	import flash.display.*
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author wzh (shch8.com)
	 */
	public class Main extends ParentBase
	{
		private var menuBox:Sprite
		private var content:MovieClip
		private var soundBtn:Sprite
		public function Main() 
		{
			//playerVersion = 10//设置播放器版本
			//childPlayEnd = true;//当页面被移除时,如果被移除页面有子页是否播放其子页结束动画
			//cache = true;//是否使用缓存
			stop();
			callProgress = function():void {//子页与当前页的加载进度
				loadBar.gotoAndStop(loadPct);//0~100
				loadBar.txt.text = "load:"+loadPct + "%";
				if (loadPct == 100) {
					/*当前页(主SWF页面) 与所加载子页进度事件都是从这里判断, 所以加个判断.
					如果当前帧不在"show"标签上, 说明是主页的加载, 第一次进入, 则用play() 播放入站动画.
					再用control.frameScript()向"show"帧标签中添加代码,如果播放到"show",执行install()*/
					if(currentLabel!="show"){
					control.frameScript(this, "show", install)//添加回调帧事件
					play();
					}
					loadBar.visible = false;
				}
			}
		}
		private function install():void
		{			
			
			defaultPage=Menu.about//默放页设置
			gotoAndStop("show")
			menuBox = getChildByName("_menuBox") as Sprite
			content = getChildByName("_content") as MovieClip
			soundBtn = menuBox.getChildByName("soundBtn") as Sprite
			if (soundBtn) {
				soundBtn.addEventListener(MouseEvent.CLICK,soundClick)
				}
			this.addEventListener(PageSizeEvent.RESIZE, resize)//舞台大小被调整时
			this.addEventListener(ParentEvent.ADD_CHILD, addPage);
			fullBut.addEventListener(MouseEvent.CLICK, fullClick);
			
			ui.tip(fullBut,"全屏切换")
			var btn:MovieClip
			for (var i:uint=0; i < Menu.menuList.length; i++ ) {
				btn = menuBox.getChildByName(Menu.menuList[i]) as MovieClip
				if (btn) {
					btn.addEventListener(MouseEvent.CLICK, butClick);
					btn.buttonMode = true;
					effect.movieBtn(btn)
				}
			}
			net.bgSound.path = "mp3/music.mp3";//使用背景音乐
			net.bgSound.soundEffect = true;//使用声音渐渐式播放
			net.bgSound.cycle = 5;//播放次数,默认值是-1,为循环播放
			net.bgSound.play()
			ui.tip(soundBtn, "音乐正在播放")
		}
		//背景音乐控制
		private function soundClick(e:MouseEvent):void {
			var soundShape:Sprite = soundBtn.getChildByName("soundShape") as Sprite
			if (soundShape.visible) {
				soundShape.visible = false;
				net.bgSound.stop()
				ui.tip(soundBtn,"音乐已关闭")
				}else {
					ui.tip(soundBtn,"音乐正在播放")
					soundShape.visible = true;
					net.bgSound.play()
					}
					
		}
		
		private function fullClick(e:MouseEvent):void {
			control.fullScreen()
		}
		//菜单按钮点击时,打开所对应的页面
		private function butClick(e:MouseEvent):void
		{
			openPage(e.target.name, BLANK, true, 1000);//使用按钮名打开页面
			effectTab.gotoAndPlay(2);//过渡光晕播放
		}
		//执行了openPage打开页面,加载完成后触发添加到舞台的事件,也可以用callAddPage回调函数
		private function addPage(e:ParentEvent):void
		{
			var btn:MovieClip = menuBox.getChildByName(currentSel) as MovieClip
			selectedBtn(currentSel)//设置按钮的选中状态
			content.addChild(e.loader);
			switch(currentSel) {//判断当前所选栏目设置背景
				case Menu.about:
				setPageBg(new Bg1(),3);
				break
				case Menu.work:
				setPageBg("img/bg1.jpg", 3);
				break
				case Menu.blog:
				setPageBg("img/bg2.jpg", 1);
				break
				case Menu.contact:
				setPageBg(new Bg2(), 3);
				break
				}
		}
		//设置按钮的选中状态
		private function selectedBtn(btnName:String):void {
			var btn:MovieClip
			for (var i:uint = 0; i < Menu.menuList.length; i++ ) {//先清除已选中的
				btn = menuBox.getChildByName(Menu.menuList[i]) as MovieClip
				if (btn) {
				btn.mouseEnabled = true
				btn.gotoAndStop(1)
				}
			}
			btn=menuBox.getChildByName(btnName) as MovieClip
			if (btn) {
				btn.mouseEnabled = false;
				btn.gotoAndStop("tag")
				}
			
		}
		//页面改变大小时,调整各对象,也可以使用回调函数callResize
		private function resize(event:PageSizeEvent = null):void {
			var wid:Number = event.width
			var hei:Number = event.height
			effect.tweener(fullBut,{x:wid-40})
			menuBox.getChildByName("bg").width = wid
			effect.tweener(content,{x:(wid-800)/2})
			menuBox.y = hei - 40
			if(soundBtn)soundBtn.x=wid-50
			}
	}
	
}