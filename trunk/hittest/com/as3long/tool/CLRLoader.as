package com.as3long.tool {
	import flash.display.*;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	/**
	 * SWF加载器
	 */
	public class CLRLoader extends EventDispatcher {
		private var m_loadinfo:LoaderInfo;
		public var this_mc:MovieClip = new MovieClip();
		/**
		 * 实例化加载器
		 */
		public function CLRLoader(){
		}

		//load swf
		/**
		 * 通过地址加载swf文件
		 * @param	url 要加载的swf文件的地址
		 */
		public function Load(url:String):void {
			var loader:Loader = new Loader();
			var request:URLRequest = new URLRequest(url);
			var context:LoaderContext = new LoaderContext();

			//loaded into the sub-domain
			context.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.load(request, context);
		}

		/**
		 * 获取当前ApplicationDomain内的类定义
		 * @param	name name类名称，必须包含完整的命名空间,如 Grave.Function.SWFLoader
		 * @return	获取的类定义，如果不存在返回null
		 */
		public function GetClass(name:String):Class {
			if (m_loadinfo.applicationDomain.hasDefinition(name)){
				return m_loadinfo.applicationDomain.getDefinition(name) as Class;
			}
			return null;
		}

		//load complete event
		private function onComplete(e:Event):void {
			e.currentTarget.removeEventListener(Event.COMPLETE, onComplete);
			this_mc = e.currentTarget.content;
			m_loadinfo = e.currentTarget as LoaderInfo;
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
