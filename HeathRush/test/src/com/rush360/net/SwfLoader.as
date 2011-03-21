package com.rush360.net 
{
	import as3isolib.graphics.BitmapFill;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.net.*;
	
	/**
	 * ...
	 * @author 黄龙
	 */
	public class SwfLoader extends EventDispatcher
	{
		private var _loader:Loader = null;		// 载入器
		private var _loadInfo:LoaderInfo = null;
		private var _url:String = "";			// 载入地址
		
		private var _decodeFunc:Function = null;	// 解码函数
		private var _urlLoader:URLLoader = null;
		private var _domain:ApplicationDomain = null;		// 所在域
		
		/**
		 * 构造函数
		 * 
		 * @param	isSameDomain		是否同域,默认为同域
		 * @param	decodeFunc			解码函数,默认null,不解码
		 */
		public function SwfLoader(domain:ApplicationDomain = null, decodeFunc:Function = null) 
		{
			_decodeFunc = decodeFunc;
			_domain = domain;
		}
		
		/**
		 * 获取loader
		 * @return
		 */
		public function getLoader():Loader
		{
			return _loader;
		}
		
		private function getClass(_className:String=null):Class
		{
			try 
			{
				if (_loadInfo == null) 
				{
					return null;
				}
				return _loadInfo.applicationDomain.getDefinition(_className)  as  Class;
			}
			catch (e:ReferenceError)
			{
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
		
		/**
		 * 关闭连接
		 */
		public function close():void
		{
			_loader.close();
		}
		
		/**
		 * 加载
		 */
		public function load(url:String):void
		{
			_url = url;
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(ProgressEvent.PROGRESS , onProgress);
			_urlLoader.addEventListener(Event.COMPLETE , onComplete);
			_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlLoader.load(new URLRequest(url));
		}
		
		// 进度事件
		private function onProgress(e:ProgressEvent):void 
		{
			dispatchEvent(e);
		}
		
		// 读取完成
		private function onComplete(e:Event):void 
		{
			_urlLoader.removeEventListener(ProgressEvent.PROGRESS , onProgress);
			_urlLoader.removeEventListener(Event.COMPLETE , onComplete);
			
			/// 载入字节
			loadBytes(_urlLoader.data);
		}
		
		
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		
		
		/**
		 * 载入字节 , 用于swf载入
		 * @param	data
		 */
		public function loadBytes(data:ByteArray):void
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE , onLoadByteComplete);
			var bytes:ByteArray = (_decodeFunc != null) ? _decodeFunc(data) : data;
			var context:LoaderContext = new LoaderContext();
			context.applicationDomain = _domain;
			_loadInfo = _loader.loaderInfo;
			_loader.loadBytes(bytes , context);
		}
		
		/// 载入完成
		private function onLoadByteComplete(e:Event):void 
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE , onLoadByteComplete);
			complete();
		}
		
		// 发出完成事件
		private function complete():void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}

}