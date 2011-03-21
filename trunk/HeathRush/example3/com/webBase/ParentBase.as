/*
@@@@@  @@               @           @   @       @           @@@@                    
@       @               @           @   @       @           @   @                   
@       @    @@@   @@@@ @@@@        @ @ @  @@@  @@@@        @   @  @@@   @@@@  @@@  
@@@@    @       @ @     @   @       @ @ @ @   @ @   @       @@@@      @ @     @   @ 
@       @    @@@@  @@@  @   @       @ @ @ @@@@@ @   @       @   @  @@@@  @@@  @@@@@ 
@       @   @   @     @ @   @       @ @ @ @     @   @       @   @ @   @     @ @     
@     @@@@@  @@@@ @@@@  @   @        @ @   @@@@ @@@@        @@@@   @@@@ @@@@   @@@@ 
------------------------------------------------------------------------------------------->>
VERSION: 2.1
DATE: 2010/3/12
ACTIONSCRIPT VERSION: 3.0
FLASH VERSION: CS3 CS4 or up
ADDRESS:Fuzhou Fujian China.
Email:wzh3847@sina.com
BY WZH
 * 
 * */

package com.webBase{
	
	import com.webBase.activeBag.ui.WebTrace;
	import com.webBase.event.*;
	import com.webBase.activeBag.PageBase;
	import com.webBase.activeBag.baseName;
	import com.webBase.JSconnect.*;
	import com.webBase.parts.*;
	import com.webBase.activeBag.net.pack.*;
	import com.webBase.swfList.SwfFile;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	
	/**
	 * 

<p><strong><font size="5" face="黑体">Flash全站框架FlashWebBase</font></strong><br>
  <br>
  <br>
更多使用帮助与最新版本下载，请查看：http://www.shch8.com/webBase 开发：望月狼<br>
 <p class="MsoNormal" style="margin: 0cm 0cm 0pt; text-indent: 21pt; text-align: center">&nbsp;&nbsp;<img alt="" src="images/bann.jpg" /></p>
<div style="text-align: left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;基于<span>ActiveScrpt3.0开发环境的Flash全站框架WebBase，用于协助Flash全站创作，以简单、自由、高效和稳定为开发标准，最大化地发挥设计师的创造能力，尽量减轻开发过程中去编写不必要的代码，为Flash全站创作量体打造的开源框架。</span></div>
<div style="text-align: left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Flash全站可以将品牌特征、功能与外观等形象逼真地演绎出来，很灵活地实现艺术体验与用户交互，为企业形象、品牌推广建立全新的互动媒介平台，因此受到各大企业与爱好者的青睐。但相比于所有计算机开发工作，<span>Flash全站制作比较特殊，其包揽程序与艺术开发的技能要求，是艺术编程、视觉交互、情节策划与网络技术的综合挑战。</span></div>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;所以我们需要一种框架来完成那些繁锁的工作，把有限的精力放在创作上面，能解决多个<span>SWF之间的通信实现，层次管理及对IE的控制与兼容</span>等问题，这种框架就是<span>WebBase。</span></p>
<div><b>&nbsp;</b><b>一．<span>WebBase适合于哪类人群？</span></b></div>
<div>1．喜欢靠<span>AS2的自由性开发Flash全站或善未完成AS3技术蜕变的人。</span></div>
<div>2．工作喜欢&ldquo;偷懒&rdquo;又追求原创与细节的设计师。</div>
<div>3．<span>Flash艺术高手并略懂AS编程的技术贵族。</span></div>
<div>4．纯<span>AS开发高手，用于WEB应用项目的开发。</span></div>
<div>&nbsp;</div>
<div><b>二．</b><b>WebBase</b><b>能做什么？</b></div>
<div>1．可以实现动态地址与标题。打开每一个页面都会在地址栏中产生一个伪地址并堆栈到<span>IE的历史记录中，地址形式如：<span><a target="_blank" href="http://www.shch8.com/case/webbase/#/blog">http://www.shch8.com/case/webbase/#/blog</a></span>，我们可以使用这个地址来进入指定的动画页面。</span></div>
<div>2．可以实现状态值的记录。比如，我们在产品展示中查看了一件商品，地址栏可以记录起来，如果你把这个地址发给朋友同样能够看到这个商品，状态值的使用可以弥补单个<span>SWF中无法实现历史记录与动态地址的问题，地址形式如:</span></div>
<div><a target="_blank" href="http://www.shch8.com/case/webbase/#/about-tag2"><span>http://www.shch8.com/case/webbase/#/about-tag2</span></a></div>
<div>3．可以很方便地实现更换页面时的过渡动画。在进入另一个子页面时，会通知当前页面先播放结束动画，当结束动画播放完成了，再加载新的<span>SWF文件。使用结束动画是开发Flash全站应该考虑的细节，也是区别于普通网页的一大亮点。</span></div>
<div>4．垃圾回收机制。切换栏目时，会自动卸载旧的<span>SWF文件，并提供卸载事件机制用于清除特定垃圾，如声音或视频数据。</span></div>
<div>5．<span> Flash尺寸控制。也许会有这样的需求，我们每个子页面使用的页面高度可能不一样，你可以很轻松地设置各个子页面应该使用的宽度或高度，也就是改变IE的宽高，支持目前使用的绝大多数浏览器。</span></div>
<div>6．互访功能。如果我们用了多级子<span>SWF，各个页面之间的相互访问会是一个头疼的事，在一些偏向应用型的Flash全站中更是需要有个灵活的访问功能，WebBase提供了三种访问属性供你直接调用，分别为：主页面(rootPage)，父页面（parentPage）和子页面（childPage）。</span></div>
<div>7．<span>IE控制能力。WebBase已经通过测试，兼容于目前使用的不同IE，而且可以方便IE的各种形为，如：历史控制，标题控制，</span>IE页面滚动事件等等。</div>
<div>8．辅助工具。<span>WebBase提供了Flash全站开发中常用的方法，比如数据加载、JS警告窗、提示工具、样式处理、中文字体显示、图形效果及基于WEB的trace功能等等。</span></div>
<div>&nbsp;</div>
<div>&nbsp;</div>
<div><b>三．如何使用？</b></div>
<div>1．实现原理。<span>WebBase是一个基类包，不管是子页还是主页都看成是一个父级页面，所以实现了无限子级的交互控制，你的Flash全站主框架页必须继承这个包，当然，这个包也是继承MovieClip编写的，因此，你不用当心在文档类中能否使用gotoAndPlay()的问题，架构继承原理如图1-1所示：</span></div>
<div style="text-align: center"><span><img alt="" src="images/j1.jpg" /></span></div>
<div align="center">图<span>1-1 </span></div>
<div align="left">2.不管是主页还是子页，一律继承包里的<span>ParentBase基类，当然，如果子页不需要使用webBase提供的方法也可以不继承这个类。</span></div>
<div align="left">继承<span>ParentBase以后，你可以很自由地使用WebBase提供的方法了，先在主页中执行installMenu(&quot;config/menu.xml&quot;)方法，安装菜单配置的XML文件，如果你没有改变XML的路径，程序默认会安装&ldquo;webbase/config/menu.xml&rdquo;菜单。</span></div>
<div>WebBase提供了一个懒人方法包<span>MethodBag，集成了Flash全站开发中常用的方法，如图1-2所示：</span></div>
<div style="text-align: center"><span><img alt="" src="images/j2.jpg" /></span></div>
<div align="center">图<span>1-2</span></div>
<div align="left">
  <p>3．使用配置工具来配置你的主页与XML菜单，执行<SPAN>WebBase包里“webbase\配置程序\配置.exe”，启动配置工具</SPAN>跟据向导进行配置，如图1-3所示：</p>
  <p align="center"><span><img src="images/s1.jpg" alt="" width="583" height="320" /></span></p>
  <p align="center">图<span>1-3</span></p>
  <p>4．由于使用<span>JS 辅助控制,程序运行中AS 与JS 交互会受到播放器的安全限制,如果你在本地直接打开可能会受到阻拦,所以要挂在IIS之类的服务器上测试。也可以到官方网站上做全局安全性设置添加你要测试的地址。官方设置地址:<br />
http://www.macromedia.com/support/documentation/cn/flashplayer/help/settings_manager04.html<br/>
  </span></p>
</div>
<div>&nbsp;</div>
<div><b>四．声明</b></div>
<div>WebBase集于各方力量开发而成，目前框架中使用到的开源代码在此处声明，有些虽然进行过二次开发，但版权最终归开发者所有，分别如下：</div>
<div><span lang="EN-US" style="mso-fareast-font-family: Calibri; mso-bidi-font-family: Calibri"><span style="mso-list: Ignore"><font face="Calibri">1.</font><span style="font: 7pt &quot;Times New Roman&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span></span><span lang="EN-US" style="mso-fareast-font-family: 黑体"><font face="Calibri">swfaddress<o:p></o:p></font></span>
<p class="MsoNormal" style="margin: 0cm 0cm 0pt 18pt; text-indent: -18pt; mso-list: l0 level1 lfo1"><span lang="EN-US" style="mso-fareast-font-family: Calibri; mso-bidi-font-family: Calibri"><span style="mso-list: Ignore"><font face="Calibri">2.</font><span style="font: 7pt &quot;Times New Roman&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span></span><span lang="EN-US" style="mso-fareast-font-family: 黑体"><font face="Calibri">swfobject<o:p></o:p></font></span></p>
<p class="MsoNormal" style="margin: 0cm 0cm 0pt 18pt; text-indent: -18pt; mso-list: l0 level1 lfo1"><span lang="EN-US" style="mso-fareast-font-family: Calibri; mso-bidi-font-family: Calibri"><span style="mso-list: Ignore"><font face="Calibri">3.</font><span style="font: 7pt &quot;Times New Roman&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span></span><span lang="EN-US" style="mso-fareast-font-family: 黑体"><font face="Calibri">Tweener<o:p></o:p></font></span></p>
</div>
  
	 * @author WZH(shch8.com)
	 * 请把所有的主页(SWF)和子页(SWF)都继承这个页面。
	 */
	public class ParentBase extends PageBase {
		private var _currentSel:String = "";//当前所选栏目
		private var _currentSwf:Loader;//当前所加载的子文件loader
		private var _waitTime:uint;//切换栏目时的等待时间
		private var _param:ChildFile;//栏目切换时，先移除再加载而用的参数全局寄存器
		private var _states:Array;//栏目切换时，用于等待结束动画的转存
		private var _loadPct:uint;
		/**
		 * @private
		 */
		private var _menuXML:XML;
		private var _menuPath:String="";
		private var installEnd:Boolean;
		private var _defaultTitle:String="";
		private var defaultTimer:Timer;//load default page of timer
		/**
		 * 从主页根目录打开 
		 **/
		public static const TOP:String = "top";
		/**
		 * 从上层页面打开
		 * */
		public static const PARENT:String = "parent";
		/**
		 * 从当前页面打开
		 * */
		public static const BLANK:String = "blank";
		/**IE地址栏中切换时，是否选播放结束动画
		 * @default false;
		 * */
		private var _usePlayEnd:Boolean;
		private var _stateFile:StateFile = new StateFile;
		private var pageUrl:String = "";
		private var openPageCatch:Object;
		/*是否使用伪地址*/
		private var _shamUrl:Boolean = true;
		private var _overlapLoad:Boolean = true
		private var _defaultPage:String = ""
		use namespace baseName;
		/**
		 * 默认加载页面
		 * */
		public function get defaultPage():String { return _defaultPage; };
		public function set defaultPage(value:String):void { _defaultPage = value; if (intoGetDefault && _currentSel == "") openPage(value); };
		/**
		 * 是否重叠加载，如果之前的子页没有加载完，是否允许加载新的页面
		 * */
		public function get overlapLoad():Boolean { return _overlapLoad; };
		public function set overlapLoad(value:Boolean):void { _overlapLoad = value; };
		
		/**
		 * 是否使用伪地址
		 * */
		public function get shamUrl():Boolean { return _shamUrl; };
		public function set shamUrl(value:Boolean):void { _shamUrl = value; };
		/**
		 * @private
		 *当前SWF文件*/
		public function get usePlayEnd():Boolean { return _usePlayEnd; };
		public function set usePlayEnd(value:Boolean):void { _usePlayEnd = value; };
		/**
		 * @private
		 */
		baseName function get stateFile():StateFile { return _stateFile; };
		/**
		 * 当前所加载的SWF文件名，获取XML中的ID标签值
		 **/
		public function get currentSel():String { return _currentSel; };
		public function set currentSel(value:String):void { _currentSel = value; };
		
		/** 
		 * 当前所加载的SWF的Loader对象
		 **/
		public override function get currentSwf():Loader { return _currentSwf; };
		public override function set currentSwf(value:Loader):void {_currentSwf=value };
		
		/**
		 * 菜单的XML文件
		 **/
		public function get menuData():XML {if (menuXML == null)if (rootPage.menuXML != null) return rootPage.menuXML; return menuXML;};
		public function set menuData(value:XML):void { menuXML = value; };
		/**
		 * @private
		 */
		public function get menuXML():XML {return _menuXML;};
		public function set menuXML(value:XML):void { _menuXML = value; };
		/**
		 * 菜单配置路径
		 **/
		public function get menuPath():String { return _menuPath; };
		public function set menuPath(value:String):void { _menuPath = value; };
		
		
		/**
		 * @private
		 */
		protected function get defaultTitle():String { return _defaultTitle };
		/**
		 * @private
		 */
		public function get pagePath():String {
			var parSwf:ParentBase = parentPage;
			var thisSwf:ParentBase = this;
			var pushStr:String = "";
			if (parSwf == null) {
				pushStr=_stateFile.stateStr;
				if (pushStr != "") pushStr = "-" + pushStr;
				return pushStr;
				}
			
			var urlAry:Array = new Array;
			
			while (parSwf != null){
					pushStr=thisSwf.stateFile.stateStr;
					if (pushStr != "") {
						pushStr=parSwf.currentSel+"-"+pushStr
						}else {
							pushStr = parSwf.currentSel;
							}
					urlAry.push(pushStr);
					thisSwf = parSwf;
					parSwf = parSwf.parentPage;
			};
			urlAry.reverse();
			var urlPath:String =""
			for (var i:uint; i < urlAry.length; i++) {
				urlPath += urlAry[i]
				if (i != urlAry.length-1) {
					urlPath+="/"
					}
				}		
			var rootStates:String = rootPage.stateFile.stateStr
			if (rootStates != "") urlPath = "-" + rootStates + "/" + urlPath;
			return urlPath;
			}
		/**
		 * 获取子级SWF文件
		 */
		public function get childPage():ParentBase {
			if (_currentSel != null) {
				var getSwf:SwfFile=swfCollect.getSwf(getPath(_currentSel))
				var parBase:ParentBase = getSwf.file.content as ParentBase;
				if (parBase != null) return parBase;
				}
			return null;
			}
		/**
		 * 获取主SWF页面
		 */
		public function get rootPage():ParentBase { if (stage) return stage.getChildAt(0) as ParentBase; return this; };
		/**
		 * 获取父级SWF文件
		 */
		public function get parentPage():ParentBase {
			var parBase:ParentBase = parentSwf as ParentBase;
			return parBase;
			}
		public function ParentBase() {
			this.addEventListener(ParamEvent.GET_PARAM, getParam);
			this.addEventListener(ChildEvent.CLEAR, clearFun);
			this.addEventListener(StateEvent.GET_STATE, getStates)
			defaultTimer= new Timer(500,1)
			defaultTimer.addEventListener(TimerEvent.TIMER, loadDefaultPageEvent);
			defaultTimer.start()
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);//load of progress currently
			loaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			if (_defaultTitle == "") {
				_defaultTitle = SWFAddress.getTitle();
				_defaultTitle=_defaultTitle.slice(0,_defaultTitle.indexOf("#"))
			}
		}
		private function progress(event:ProgressEvent):void { _loadPct = int(event.bytesLoaded / event.bytesTotal * 100);loadProgress(event) };
		private function loadComplete(event:Event):void
		{
			_loadPct = 100;
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(Event.COMPLETE, loadComplete);
			if (isRoot) {
				if (rootPage.menuXML == null) {
					if (menuPath != "") {//Only have main page
						installMenu(menuPath);
					}else {
						installMenu("webbase/config/menu.xml")//default menu loading
						}
				}
			}
		}
		/**
		 * 获取当前已加载的百分比，值为0~100
		 */
		public function get loadPct():uint { return _loadPct };
	
		private function scrollFun(left:Number,top:Number):void
		{
			this.dispatchEvent(new PageScrollEvent(PageScrollEvent.SCROLL, left, top));
		}
		/**
		 * 当前状态值
		 */
		public function get states():Array {
			return _stateFile.array;
		}
		/**
		 *添加状态值 
		 * @param	value 状态值名称
		 **/
		public function addState(value:Object):void {
			var str:String=value.toString()
			if (str.indexOf("-") != -1) throw("标签不允许带有“-”线！");
			if (str.indexOf("/")!=-1) throw("标签不允许带有“/”线！");
			if (_stateFile.isExist(str)) return;
			var endAdd:String = SWFAddress.getPath();
			var pPage:String = pagePath
			
			if (shamUrl)SWFAddress.setValue(pPage + "-" + str + endAdd.slice(pPage.length + 1));
			this.dispatchEvent(new StateEvent(StateEvent.ADD_STATE, str.split("-")));
			_stateFile.add(str)
			}
		/**
		 * 删除状态值 
		 * @param	value 状态值名称
		 **/
		public function delState(value:String):void {
			var endAdd:String = SWFAddress.getPath();
			endAdd = endAdd.slice(pagePath.length + 1);
			_stateFile.del(value);
			if (shamUrl)SWFAddress.setValue(pagePath + endAdd);
			this.dispatchEvent(new StateEvent(StateEvent.DEL_STATE, value.split("-")));
			}
		/**
		 * 清除所有状态值 
		 **/
		public function clearState():void {
			_stateFile.clear();
			if (shamUrl)SWFAddress.setValue(pagePath);
			this.dispatchEvent(new StateEvent(StateEvent.CLEAR_STATE));
		}
		private function handleSWFAddress(event:SWFAddressEvent):void {
			if (event.path != "/") {
			pageUrl = event.path;
			var _pageUrl:String = pageUrl.slice(1)
			if (pageUrl) {
				if (pageUrl.slice(1, 2) == "-") {//状态检测
					pageUrl = pageUrl.slice(2, pageUrl.length);
					if (isRoot) {
						var stateStr:String=pageUrl;
						if (stateStr.indexOf("/") != -1) {
							stateStr=stateStr.slice(0,stateStr.indexOf("/"));
							}
						dispatchState(rootPage as ParentBase, stateStr.split("-"))//引导页使用状态值
					}
					if (pageUrl.indexOf("/") == -1) {
						pageUrl = "";
						}else{
						pageUrl = pageUrl.slice(pageUrl.indexOf("/") + 1, pageUrl.length);
						}
				}
				if(pageUrl!=""){
					var childFile:ChildFile = getChildFile(pageUrl);
					if (childFile) {
						loadChildFile(childFile);
					}
				}
			}
			}
			if (menuData && !installEnd && isRoot) {
				installEnd = true;
				new UpdateFwb(this);
				InviteEventSen.sen(this, new MenuEvent(MenuEvent.INIT));
			}
		}
	
		/**菜单安装，只能在主SWF中执行
		 * 而且一个Flash全站项目只能安装一次XML菜单列表，SWF一但执行了这个方法来安装菜单，系统始终会把这个SWF当作是主SWF。
		 * 也许你的子SWF中还有菜单列表，你可以把所有菜单列表都做进同一张表之中，由主SWF统一安装，安装后你也可以在子SWF中执行openPage用XML的ID来打开
		 * @param	path  xml菜单路径
		 * @example
		 **/
		public function installMenu(path:String):void {
			if (rootPage.menuPath == path) return;
			rootPage.menuPath = path;
			if (loadPct != 100) return;
			net.loadXML(path, getXML);
		}
		/**
		 * 打开页面
		 * @param	path		要打开的页面，使用XML菜单中的ID值
		 * @param   target		加载的目标，值可以是BLANK,TOP,PARENT
		 * @param	usePlayEnd	使用尾动画
		 * @param	waitTime	加载等待时间（单位：毫秒），旧SWF移除后可能还要等待别的动画执行完毕再加载新的SWF
		 */
		public function openPage(path:String, target:String = "blank", __usePlayEnd:Boolean = false, waitTime:uint = 0):void {
			
			if (isLoading && !overlapLoad) return
			if (rootPage.menuXML == null) {
				openPageCatch = new Object()
				openPageCatch.path = path;
				openPageCatch.usePlayEnd = __usePlayEnd;
				openPageCatch.waitTime = waitTime;
				return;
				}
			isLoading=true
			_waitTime = waitTime;
			path = path.toLocaleLowerCase();
			var pathStr:String = pagePath;
			if (pathStr.slice(0, 1) == "/") pathStr = pathStr.slice(1);
			
			if (!shamUrl){
			//===========149
			if (target == TOP) {
				rootPage.openPage(path, BLANK, __usePlayEnd, waitTime);
				return;
			}
			if (target == PARENT) {
				parentPage.openPage(path, BLANK, __usePlayEnd, waitTime);
				return
			}
			
			var childFile:ChildFile = getChildFile(path);
					if (childFile) {
						usePlayEnd = __usePlayEnd;
						loadChildFile(childFile);
					}
			return
			//===========
			}
			
			switch(target){
				case PARENT://From previous page opens
				var parSwf:ParentBase = parentPage;
				if (parSwf != null&&pathStr!="") {
				parSwf.usePlayEnd = __usePlayEnd;
				if(pathStr.indexOf("/")!=-1)
				path = pathStr.slice(0, pathStr.lastIndexOf("/")) +"/" +path;
				}else {
					rootPage.usePlayEnd = __usePlayEnd;	
					}
				break;
				case TOP://From top page opens
				rootPage.usePlayEnd = __usePlayEnd;	
				break;
				case BLANK://open new page from current
				usePlayEnd = __usePlayEnd;
				path = pathStr +"/" +path;
				break;
			}
			SWFAddress.setValue(path);
			}
		/**
		 * 切换菜单
		 * @param	menuName	菜单ID名
		 * @param	usePlayEnd	是否先播放结束动画
		 * @param	childFile	要加载的下级SWF参数信息
		 * @param   stas		状态数组
		 */
		private function changMenu(menuName:String,usePlayEnd:Boolean=true,childFile:ChildFile=null,stas:Array=null):void {
			if (menuData == null) {
				return;
			}
			menuName = menuName.toLocaleLowerCase();
			if (_currentSel == menuName) {
				var getSwf:SwfFile = swfCollect.getSwf(getPath(menuName));
				if (stas) {
					if (getSwf) dispatchState(getSwf.file.content as ParentBase, stas);
					}
				if (childFile != null) {//当前已经有这个子页了，获取子页
					if (getSwf) getSwf.file.content.dispatchEvent(new ParamEvent(ParamEvent.GET_PARAM, childFile));
				}else {//无子栏目，删去已经显示的子SWF
					setTitleXML(menuName)
					var parBase:ParentBase = getSwf.file.content as ParentBase;
					if(parBase!=null){
					parBase.removeSwf(getPath(parBase.currentSel));
					parBase.currentSel = "";
					}
					}
				return;
				}
			if (_currentSel != "") {
				if (getSwfFile(getPath(_currentSel)) == null) {
					removeSwf(getPath(__currSel));
				} else {
					addEventListener(ParentEvent.REMOVE_CHILD, removeSwfFile);
					var __currSel:String = _currentSel;
					_currentSel = menuName;
					_param = childFile;
					_states = stas;
					removeSwf(getPath(__currSel), usePlayEnd);
					return;
				}
			}
			/*解析地址符，分切成可识别对象，参数为下一个子页ID，子页参数与子页里的子页地址
			 * 如：/all/new-intr/showbox
			 * 
			 * */
			setTitleXML(menuName)
			_currentSel = menuName;
			loadSwf(getPath(menuName), childFile, stas);
		}
		//结束动画播放完成并删去了旧SWF，从新进入切换菜单
		private function removeSwfFile(event:ParentEvent):void {
				removeEventListener(ParentEvent.REMOVE_CHILD, removeSwfFile);
				var menuName:String = _currentSel;
				_currentSel = "";
				setTimeout(runChangMenu,_waitTime)
				function runChangMenu():void{
					changMenu(menuName, usePlayEnd, _param,_states);
					_waitTime = 0;
					usePlayEnd = false;
				}
			}
		private function dispatchState(pageBase:ParentBase,value:Array):void
		{
			if (!pageBase.stateFile.isSame(value))pageBase.dispatchEvent(new StateEvent(StateEvent.GET_STATE, value));
		}
		private function clearFun(value:ChildEvent):void {
			this.removeEventListener(ParamEvent.GET_PARAM, getParam);
			this.removeEventListener(ChildEvent.CLEAR, clearFun);
			this.removeEventListener(StateEvent.GET_STATE, getStates)
			SWFAddress.removeEventListener(SWFAddressEvent.CHANGE, handleSWFAddress);
			if(callClear is Function)callClear()
		}
		//在页面加载时，获取状态值
		private function getStates(event:StateEvent):void {
			_stateFile.clear();
			_stateFile.adds(event.states);
			if (callGetState is Function) callGetState();
			}
		//获得页面跳转参数，执行子页加载
		private function getParam(event:ParamEvent):void {
			_param= event.param as ChildFile;
			if (!_param)return;
			if(defaultTimer){
			defaultTimer.stop();
			defaultTimer.removeEventListener(TimerEvent.TIMER, loadDefaultPageEvent);
			defaultTimer = null;
			}
			menuData = _param.menuXml;
			if(stage){
			loadChildFile(_param);
			}else {
				addEventListener(Event.ADDED_TO_STAGE,addStage)
				}
		}
		//获取了新的状态值
		private function getNewState(stateAry:Array):void {
			var newState:String = "";
			if (stateAry) {
				for (var i:uint; i < stateAry.length; i++ ) {
					if (!stateFile.isExist(stateAry[i])) {
						if (newState != "") {
							newState+="-"
							}
						newState += stateAry[i];
						}
					}
				if (newState != "") addState(newState);
			}
			}
		private function addStage(event:Event):void {
			if (_param != null) { loadChildFile(_param); } else { defaultEventSen() };
			removeEventListener(Event.ADDED_TO_STAGE,addStage)
			}
		private function loadDefaultPageEvent(event:TimerEvent):void {
			if(stage){//加载默认页，说明没有子页了
			defaultEventSen()
			}else {
				addEventListener(Event.ADDED_TO_STAGE,addStage)
				}
		}
		private var intoGetDefault:Boolean
		private function defaultEventSen():void
		{
			intoGetDefault = true
			InviteEventSen.sen(this, new DefaultPageEvent(DefaultPageEvent.DEFAULT_PAGE), null, eventSenOr )
			if(defaultPage!=""&&eventSenOr())openPage(defaultPage)
			function eventSenOr():Boolean
			{
				if (currentSel == "") return true
				return false
			}
		}
		//加载子页
		private function loadChildFile(childFile:ChildFile):void {
			if (childFile == null) {
				return;
			}
			if (childFile.childFile == null) return;
			var getSwfChildFile:ChildFile;
			if (childFile.fileStrs!=null) {
				getSwfChildFile = getChildFile(childFile.fileStrs);
			}
			changMenu(childFile.childFile,usePlayEnd, getSwfChildFile,childFile.stateArray);
		}
		
		private function getXML(xml:XML):void {
			rootPage.menuData = xml;
			if (shamUrl){
				ExternalInterface.addCallback('scorllEvent', scrollFun);     
				SWFAddress.addEventListener(SWFAddressEvent.CHANGE, handleSWFAddress);
			}
			if (openPageCatch != null) {
				openPage(openPageCatch.path, openPageCatch.target, openPageCatch.usePlayEnd, openPageCatch.waitTime);
				openPageCatch = null;
				}
			if(stage)InviteEventSen.sen(rootPage, new PageSizeEvent(PageSizeEvent.RESIZE, stage.stageWidth,stage.stageHeight));
		}
		private function setTitleXML(id:String,setSize:Boolean=true):void {
			var hei:Number;
			var wid:Number;
			var title:String
			var menuList:XMLList = menuData.child("*").(@id.toLocaleLowerCase() == id.toLocaleLowerCase())
				if (menuList.length()==1) {
					title =menuList.@title;
					if (title != null && title != "" && title != " ") {
						SWFAddress.setTitle(title);
					}else {
						SWFAddress.setTitle(rootPage.defaultTitle);
						}
					if(setSize){
						hei = Number(menuList.@height)
						if (hei >0) {
							SWFAddress.setHeight(hei);
							}
						wid = Number(menuList.@width)
						if (wid >0) {
							SWFAddress.setWidth(wid);
							}
					if (hei > 0 || wid > 0) {//若未设置宽度，则都不调整
						if (hei == 0||!hei) if (stage) hei = stage.stageHeight;
						if (wid == 0||!wid) if (stage) wid = stage.stageWidth;
						InviteEventSen.sen(rootPage, new PageSizeEvent(PageSizeEvent.RESIZE, wid, hei));
						}
					}
					return;
				}
		}
		private function getPath(id:String):String {
			if (menuData == null)return "";
			for (var i:uint; i < menuData.child("*").length(); i++) {
				if (id == menuData.child(i).@id.toLocaleLowerCase()) {
					return menuData.child(i).@file;
				}
			}
			return "";
		}
		/**
		 * 解析地址
		 * 地址格式为：http://localhost/gbWeb/#home_1-all/
		 * home_1为子页ID
		 * all为状态值，可多个，用"-"隔开
		 * @private
		 * @param	str
		 * @return ChildFile
		 * 
		 * */
		 public function getChildFile(str:String):ChildFile {
			 if (str == "" || str == null) return null;
			str = str.slice(str.indexOf("#") + 1);
			if(str.slice(0,1)=="/")str = str.slice(str.indexOf("/") + 1);
			var swfFile:ChildFile = new ChildFile;
			var loadStr:String = str.slice(0, str.indexOf("/") == -1?str.length:str.indexOf("/"));//loadStr:"home_1-a-b-c"
			swfFile.childFile = loadStr.slice(0, str.indexOf("-") == -1?str.length:str.indexOf("-"));
			if(loadStr.indexOf("-")!=-1)
			swfFile.stateArray = loadStr.slice(loadStr.indexOf("-") + 1).split("-");
			if(str.indexOf("/")!=-1)//no found.load at end page
			swfFile.fileStrs = str.slice(str.indexOf("/") + 1);
			swfFile.menuXml = menuData;
			return swfFile;
		}
		/**
		 * @private
		 */
		public function get swfURL():String { if (stage) return stage.loaderInfo.url; return "未找到地址！"; };
	}
}