// Copyright @ shch8.com All Rights Reserved At 2008-11-17 11:48
//开发：商创技术（www.shch8.com）望月狼
//加载字体
/*
LoadFont(字体包路径:String,加载完成调用函数:Function=null,正在加载事件:Function=null) {

*/
/*
new LoadFont("images/FontPackage.swf",loadEnd,loading);
function loadEnd() {
	LoadFont.loadFont="kt_font";
	LoadFont.loadFont="CAI978_951";
	var fontList:Array=LoadFont.getFont;
	var tf=new TextFormat(fontList[1].fontName,20,0x666666);
	var txt:TextField=new TextField();
	txt.text="字体调用";
	txt.embedFonts=true;
	txt.type="input";
	txt.setTextFormat(tf);
	addChild(txt);
}
function loading(num:Number) {
	trace(num);
}
}
 */
package com.webBase.activeBag.style{
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.system.ApplicationDomain;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.Font;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	public class LoadFont {
		private var loadComp:Function;
		private var loading:Function;
		public static  var getApp:ApplicationDomain;
		public function LoadFont(fontSource:String, _loadComp:Function=null, _loading:Function=null) {
			loadComp = _loadComp;
			loading = _loading ;
			var loader:Loader=new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS ,progressFun);
			loader.load(new URLRequest(fontSource));
		}
		public static function set loadFont(fontName:String):void {
			if (getApp!=null) {
				var fontLibrary:Class=getApp.getDefinition(fontName) as Class;
				Font.registerFont(fontLibrary);
			} else {
				trace("字体包未加载完！");
			}
		}
		/*
		 *读取字体包里的字体loadFont(链接名:String)
		 *Example:LoadFont.loadFont="kt_font";
		 */
		public static function get getFont():Array {
			return Font.enumerateFonts(false);
		}
		/*
		 * 获取所有的嵌入字体,数组按loadFont加载顺序
		 * Example:LoadFont.getFont[0].fontName
		 */
		public static function get getFontAll():Array {
			return Font.enumerateFonts(true);
		}
		/*
		 * 获取用户计算机上所有的字体
		 * Example:LoadFontAll.getFont[0].fontName
		 */
		private function completeHandler(event:Event):void {
			if (loadComp != null) {
				getApp=event.target.applicationDomain;
				loadComp();
			}
		}
		private function progressFun(event:ProgressEvent):void {
			if (loading != null) {
				var kbLoaded:String = Number(event.bytesLoaded / 1024).toFixed(1);
				var kbTotal:String = Number(event.bytesTotal / 1024).toFixed(1);
				var loadNum:Number =event.bytesLoaded / event.bytesTotal;
				loading(loadNum);
			}
		}
	}
}