package com.rush360.net{
 /*
  * by Silva http://uh.actionscript3.cn/?13495
  * */
 import flash.display.Bitmap;
 import flash.display.BitmapData;
 import flash.display.Loader;
 import flash.display.LoaderInfo;
 import flash.events.Event;
 import flash.events.EventDispatcher;
 import flash.events.IOErrorEvent;
 import flash.events.ProgressEvent;
 import flash.events.SecurityErrorEvent;
 import flash.net.URLRequest;
 import flash.system.ApplicationDomain;
 import flash.system.LoaderContext;
 
	public class Ku_Loader extends EventDispatcher 
	{
		private var ku_loader:Loader;
		private var loadInfo:LoaderInfo
		public function Ku_Loader() { };
		
		public function load(_swf_path:String):void 
		{
		   //加载swf
		   ku_loader = new Loader();
		   var context:LoaderContext = new LoaderContext();
		   context.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
		   InitLoadEvent(ku_loader.contentLoaderInfo);
		   //写入事件
		   ku_loader.load(new URLRequest(_swf_path),context);
		}
	  
		public function getClass(_className:String = null):Class 
		{
		   try 
		   {
			if (loadInfo == null) 
			{
				trace("没有找到该类");
				return null;
			}
			return loadInfo.applicationDomain.getDefinition(_className)  as  Class;
		   }
		   catch (e:ReferenceError) 
		   {
			   trace("加载出错"+e.getStackTrace());
			   return null;
		   }
		   return null;
		}
		
		public function getObject(_className:String = null):*
		{
			var tmp:*= getClass(_className);
			if (tmp == null)
			{
				return null;
			}
			return new tmp();
		}
	  
		public function getPng(_className:String = null, _width:int = 0, _height:int = 0):Bitmap
		{
			//加载位图
			var pngClass:Class = loadInfo.applicationDomain.getDefinition(_className)  as  Class;
			var bmpdata:BitmapData = new pngClass(_width, _height);
			var bmp:Bitmap = new Bitmap(bmpdata);
			return bmp;
		}
	  
		private function InitLoadEvent(_loaderInfo:LoaderInfo):void
		{
			_loaderInfo.addEventListener(Event.COMPLETE, loadCompele);
			//加载完成
			_loaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			//加载进度
			_loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			//加载出错
			_loaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			//异步操作出错
		}
	  
		private function RemoveLoadEvent(info:LoaderInfo):void
		{
			//删除所有侦听
		   info.removeEventListener(Event.COMPLETE,loadCompele);
		   info.removeEventListener(ProgressEvent.PROGRESS,onProgress);
		   info.removeEventListener(IOErrorEvent.IO_ERROR,onError);
		   info.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onError);
		}
	  
		private function loadCompele(e:Event):void
		{
		   var info:LoaderInfo = e.currentTarget as LoaderInfo;
		   RemoveLoadEvent(info);
		   loadInfo = info;
		   this.dispatchEvent(e);
		   //广播出去
		};
	  
		private function onProgress(e:Event):void 
		{
			this.dispatchEvent(e);
			//广播出去
		}
	  
		private function onError(e:Event):void
		{
			this.dispatchEvent(e);
			//广播出去
		}
	}
}