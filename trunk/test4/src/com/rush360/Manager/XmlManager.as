package com.rush360.Manager 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author 360rush
	 */
	public class XmlManager extends EventDispatcher
	{
		private static var _instance:XmlManager;
		public var urlLoader:URLLoader;
		public function XmlManager() 
		{
			
		}
		
		public function loadXml(urlString:String):void
		{
			urlLoader = new URLLoader();
			urlLoader.load(new URLRequest(urlString));
			urlLoader.addEventListener(Event.COMPLETE, loader_ok);
		}
		
		private function loader_ok(e:Event):void 
		{
			dispatchEvent(e);
		}
		/**
		 * 单例
		 */
		public static function get instance():XmlManager 
		{
			if (_instance == null)
			{
				_instance = new XmlManager();
			}
			return _instance;
		}
	}

}