package com.webBase.swfList.modules 
{
	import com.webBase.event.LoadModuleEvent;
	import com.webBase.event.LoadSwfEvent;
	import com.webBase.swfList.SwfCollect;
	import com.webBase.swfList.SwfFile;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	/**
	 * ...
	 * @author wzh (shch8.com)
	 */
	public class ModuleControl extends EventDispatcher implements IloadInfo
	{
		private var _path:String
		private var _loader:Loader;
		private var _error:Boolean = false;
		private var _loaded:Boolean = false;
		private var _cache:Boolean;
		private var filePool:FilePool = FilePool.getInstance();
		public function ModuleControl(path:String="",__cache:Boolean=false) 
		{
			cache = __cache;
			_path = path;
			load(path)
		}
		public function get cache():Boolean { return _cache };//是否使用文件池
		public function set cache(value:Boolean):void{_cache=value }
		public function get error():Boolean { return _error };
		public function get loaded():Boolean { return _loaded };
		public function get url():String { return _path };
		public function set url(value:String):void { _path = value };
		public function get content():DisplayObjectContainer { if (loader){return loader.content as DisplayObjectContainer}else{return null} };
		public function load(path:String="", context:LoaderContext = null):void
		{
			if (path != "")_path = path;
			if (_cache) {
				var swfFile:SwfFile = filePool.getSwf(_path);
				if (swfFile) {
					loader = swfFile.file;
					loadEnd(loader)
					return
				}
			}
			loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgress);
			loader.load(new URLRequest(_path),context);
		}
		public function unload():void
		{
			if (loader == null) return;
			if (_cache) {
				if (loader.parent != null) loader.parent.removeChild(loader);
			}else {
				filePool.unload(loader);
			}
			_loaded = false;
		}
		public function get loader():Loader { return _loader };
		public function set loader(value:Loader):void {_loader=value };
		
		public function close():void { loader.close() };
		private function loadProgress(e:ProgressEvent):void
		{
			dispatchEvent(new LoadSwfEvent(LoadSwfEvent.PROGRESS,e));
		}
		private function loadComplete(e:Event):void
		{
			if (_cache) {
				var swfFile:SwfFile = new SwfFile;
				swfFile.file = loader;
				swfFile.path = _path;
				swfFile.runState = SwfFile.COMPLETE;
				filePool.push(swfFile)
			}
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadProgress);
			loadEnd(loader);
		}
		private function loadEnd(content:Loader):void
		{
			this.dispatchEvent(new LoadModuleEvent(LoadModuleEvent.COMPLETE,content));
			_loaded = true;
			
		}
		private function loadError(e:IOErrorEvent):void
		{
			_error = true
			dispatchEvent(e);
		}
		
	}
	
}