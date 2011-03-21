// Copyright @ shch8.com All Rights Reserved At 2008-3-6
//开发：商创技术（www.shch8.com）望月狼
/*
·数据加载

 例：
 NetLoad.getInstance().loadXML("room.xml", getXML)
 //getXML为接收XML的函数
 function getXML(xml:XML):void {
 trace(xml)
 }

 */
package com.webBase.activeBag.net 
{	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	public class NetLoad {
		private var filePath:String;
		private var getXML:Function;
		private var getFile:Function;
		private var useXML:Boolean;
		public static function getInstance():NetLoad {
			return new NetLoad;
		}
		/*加载XML文件,(路径，XML接收函数，是否使用中文编码)*/
		public function loadXML(_filePath:String, _getXML:Function = null,gbCode:Boolean=true,_useXML:Boolean=true):URLLoader {
			getXML = _getXML;
			useXML=_useXML;
			var myLoader:URLLoader = new URLLoader();
			System.useCodePage = gbCode;
				myLoader.addEventListener(Event.COMPLETE,xmlLoadComplete);
				myLoader.addEventListener(IOErrorEvent.IO_ERROR,loadError);
				myLoader.load(new URLRequest(_filePath));
				return myLoader;
		}
		/*加载外部文件，jpg,png,gif图片及SWF文件*/
		public function loadFile(_filePath:String, _getFile:Function = null):Loader {
			getFile = _getFile;
			var loadimg:Loader = new Loader();
			loadimg.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoadComplete);
			loadimg.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
			loadimg.load(new URLRequest(_filePath));
			function imgLoadComplete(event:Event):void {
				loadimg.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoadComplete);
				  if (getFile != null) getFile(loadimg);
				}
			return loadimg;
			}
		private function xmlLoadComplete(event:Event):void {
			var urlLoader:URLLoader = event.target as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, xmlLoadComplete);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,loadError);
			  XML.ignoreWhitespace = true;
			  var loadStr:String = event.target.data;
			  if(useXML){
			  loadStr = loadStr.slice(0, loadStr.lastIndexOf(">") + 1);
			  if (getXML != null) {
				  var _xml:XML = new XML(loadStr);
				  
				  getXML(_xml);
			  }
			  }else{
			  if (getXML != null) getXML(loadStr);
			  }
			}
		private function loadError(event:IOErrorEvent):void {
					//throw new Error("加载失败");
				}
	}
}