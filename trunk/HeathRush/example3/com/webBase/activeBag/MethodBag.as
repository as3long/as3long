package com.webBase.activeBag 
{
	import com.webBase.activeBag.control.EnterFrameCom;
	import com.webBase.activeBag.net.GetUrl;
	import com.webBase.activeBag.control.ControlBag;
	import com.webBase.activeBag.effect.EffectBag;
	import com.webBase.activeBag.net.NetBag;
	import com.webBase.activeBag.style.PageBg;
	import com.webBase.activeBag.style.StyleBag;
	import com.webBase.activeBag.ui.UiBag;
	import com.webBase.activeBag.ui.WebTrace;
	import com.webBase.activeBag.util.UtilBag;
	import com.webBase.JSconnect.SWFAddress;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.ApplicationDomain;
	import flash.text.TextFormat;
	/**
	 * 方法包,WebBase将Flash全站开发中常用的方法封装在不同的包里，便于日后不断积累，丰富其内容形成更为强大的开发工具。
	 * <br>目前划分为六块，效果包(effect)、网络通信包(net)、控制包(control)、组件模块包(ui)、样式包(style)、常用工具包(util)，这些包的调用都可以使用包属性的方式调用，比如，执行控制包的关闭功能，control.closeWin()
	 * @author WZH(shch8.com)
	 */
	public class MethodBag extends MovieClip
	{
		private var _debugMode:Boolean = true;
		/*(1).效果包
		 * 所有样式效果的引用包,比如文字效果等*/
		private var _effect:EffectBag;
		/*(2).网络通信包
		 * 所有通信方法集成包,比如加载XML,图片,声音等方法*/
		private var _net:NetBag = new NetBag;
		/*(3).控制集成包
		 * 比如控制IE上一页下一页或者全屏,控制显示对象置顶等控制集成包*/
		private var _control:ControlBag;
		/*(4).组件包
		 * 比如下拉组件的调用等等*/
		private var _ui:UiBag;
		/*(5).样式包
		 * 各种样式控制方法集合,比如CSS样式控制等*/
		private var _style:StyleBag;
		/*(6).常用方法包
		 * 常用方法集合,比如字符处理,Email验证等*/
		private var _util:UtilBag;
		/**
		 * 是否进入deBug测试模式，默认是
		 */
		public final function get debugMode():Boolean { return _debugMode };
		public final function set debugMode(value:Boolean):void { _debugMode=value };
		/**效果包
		 * 所有样式效果的引用包,比如文字效果等*/
		public final function get effect():EffectBag
		{
			if (_effect == null)_effect = new EffectBag;
			return _effect;
		}
		/**网络通信包
		 * 所有通信方法集成包,比如加载XML,图片,声音等方法*/
		public final function get net():NetBag
		{
			if (_net == null)_net = new NetBag;
			return _net;
		}
		/**控制集成包
		 * 比如控制IE上一页下一页或者全屏,控制显示对象置顶等控制集成包*/
		public final function get control():ControlBag
		{
			if (_control == null) {
				_control = new ControlBag;
			}
			return _control;
		}
		/**组件包
		 * 比如下拉组件的调用等等*/
		public final function get ui():UiBag
		{
			if (_ui == null)_ui = new UiBag();
			return _ui;
		}
		/**样式包
		 * 各种样式控制方法集合,比如CSS样式控制等*/
		public final function get style():StyleBag
		{
			if (_style == null)_style = new StyleBag;
			return _style;
		}
		/**常用方法包
		 * 常用方法集合,比如字符处理,Email验证等*/
		public final function get util():UtilBag
		{
			if (_util == null)_util = new UtilBag;
			return _util;
		}
		
		/**
		 * 打开网址，将会自动判断用户所使用的浏览器，优先选用浏览器所支持的打开方式。
		 * @param	url		链接网址
		 * @param	window	浏览器窗口或 HTML 帧，其中显示 request 参数指示的文档.可以输入某个特定窗口的名称，或使用以下值之一：
					"_self" 指定当前窗口中的当前帧。 
					"_blank" 指定一个新窗口。 
					"_parent" 指定当前帧的父级。 
					"_top" 指定当前窗口中的顶级帧。 
					如果没有为此参数指定值，将创建一个新的空窗口。 在独立播放器中，可以指定新的 ("_blank") 窗口，也可以指定已命名的窗口。 其它值不适用。
		 */
		public function getURL(url:String,window:String="_blank"):void 
		{
			new GetUrl(url,window);
		}
		private function debugOutput(str:String):void {
			traceWin("webBase查错输出:")
			traceWin(str)
		}
		/**
		 * 运行JS的alert警告窗口
		 * @param	script	
		 */
		public function JSAlert(script:String):void 
		{
			getURL("javascript:alert('"+script+"')","_self");
		}
		/**
		 * 基于IE输出测试
		 * @param	value
		 */
		public final function traceWin(... arguments):void
		{
			if (!debugMode) return;
			if (stage) WebTrace.init(stage);
			var str:String = ""
			var obj:Object
			for (var i:* in arguments) {
				obj=arguments[i]
				if((obj is String)&&obj=="")obj="空字符串"
				if (obj == null) obj = "null";
				str+=" "+obj.toString()
			}
			WebTrace.trace(str, false);
		}
		private var pageBg:PageBg
		/**
		 * 设置背景
		 * @param	target	图片或图片路径
		 * @param	mode	显示模式，允许值：1 平埔(默认) 2 居中 3 拉伸
		 * @param	wid		宽度，默认为舞台宽度，默认时将与SWF大小自动调整
		 * @param	hei		高度，默认为舞台高度，默认时将与SWF大小自动调整
		 * @param	speed	速度
		 * @return
		 */
		public final function setPageBg(target:Object,mode:Object=1,wid:Number=0,hei:Number=0,speed:Number=0.8):Sprite {
			if (pageBg == null) {
				pageBg = new PageBg
				addChild(pageBg)
				this.setChildIndex(pageBg,0)
			}
			pageBg.mode = mode
			if (target is String) {
				pageBg.load(String(target))
				}else if(target is DisplayObject){
				pageBg.displayClip = target as DisplayObject
			}
			if (wid != 0 || hei != 0) {
				pageBg.setSize(wid, hei)
				pageBg.autoSize=false
			}
			return pageBg
		}
		/**
		 * 快速添加鼠标点击事件，不支持事件清除功能，请慎用
		 * @param	target  	需要添加事件的对象，可以是影片剪辑或者按钮
		 * @param	callBack	触发事件的回调函数
		 * @example
		 * onClick(but,butRe)
		 * function butRe(){
		 * 	trace("click")
		 * }
		 * 
		 */
		public function onClick(target:InteractiveObject,callBack:Function):void
		{
			target.addEventListener(MouseEvent.CLICK,release)
			function release(event:MouseEvent):void{
				if (callBack is Function) callBack();
			}
		}
		/**
		 * 快速添加鼠标滑入事件，不支持事件清除功能，请慎用
		 * @param	target  	需要添加事件的对象，可以是影片剪辑或者按钮
		 * @param	callBack	触发事件的回调函数
		 * @example
		 * onOver(but,butRe)
		 * function butRe(){
		 * 	trace("over")
		 * }
		 */
		public function onOver(target:InteractiveObject,callBack:Function):void
		{
			target.addEventListener(MouseEvent.MOUSE_OVER,release)
			function release(event:MouseEvent):void{
				if (callBack is Function) callBack();
			}
		}
		/**
		 * 快速添加鼠标滑出事件，不支持事件清除功能，请慎用
		 * @param	target  	需要添加事件的对象，可以是影片剪辑或者按钮
		 * @param	callBack	触发事件的回调函数
		 * @example
		 * onOut(but,butRe)
		 * function butRe(){
		 * 	trace("out")
		 * }
		 */
		public function onOut(target:InteractiveObject,callBack:Function):void
		{
			target.addEventListener(MouseEvent.MOUSE_OUT,release)
			function release(event:MouseEvent):void{
				if (callBack is Function) callBack();
			}
		}
		/**
		 * 添加进入每一帧时执行的函数
		 * @param	callBack 函数名，不加括号，不能有参数的函数
		 * @example
		 * addEnterFrame(run)
		 * function run(){
		  	trace(this.currentFrame)
			}
		 */
		public final function addEnterFrame(callBack:Function):void
		{
			EnterFrameCom.getInstance().push(callBack);
		}
		
		/**
		 * 删除进入每一帧时执行的函数，将删去使用addEventFrame添加的函数
		 * @param	callBack  函数名，不加括号，不能有参数的函数
		 * @example
		 * addEnterFrame(run)
		 * function run(){
		  	trace(this.currentFrame)
			}
		 * delEnterFrame(run)//将删除run()
		 */
		public final function delEnterFrame(callBack:Function):void
		{
			EnterFrameCom.getInstance().del(callBack);
		}
		/**
		 * 子页添加回调，相当于ParentEvent.ADD_CHILD事件
		 */
		public var callAddPage:Function
		
		/**
		 * 加载进度回调，相当于LoadSwfEvent.PROGRESS事件
		 */
		public var callProgress:Function
		
		/**
		 * 子页移除回调，相当于ParentEvent.REMOVE_CHILD事件
		 */
		public var callRemovePage:Function
		
		/**
		 * 页面调整回调，相当于PageSizeEvent.RESIZE事件
		 */
		public var callResize:Function
		
		/**
		 * 状态值获取回调，相当于StateEvent.GET_STATE事件
		 */
		public var callGetState:Function
		
		/**
		 * 播放结束动画回调，相当于ChildEvent.END_PLAY事件
		 */
		public var callPlayEnd:Function
		
		/**
		 * 拉圾清除回调，相当于ChildEvent.CLEAR事件
		 */
		public var callClear:Function
	}
	
}