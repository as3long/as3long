package com.rush360.view 
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author 360rush
	 */
	public class PicView extends Sprite 
	{
		private var _url:String;
		private var _loader:Loader;
		private var imageObj:DisplayObject;
		public function PicView() 
		{
		}
		
		public function set url(picUrl:String):void
		{
			_url = picUrl;
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_ok);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loader_err);
			_loader.load(new URLRequest(_url));
		}
		
		private function loader_err(e:IOErrorEvent):void 
		{
			dispatchEvent(e);
		}
		
		private function loader_ok(e:Event):void 
		{
			imageObj = _loader.contentLoaderInfo.content;
			var _width:Number = imageObj.width;
			var _height:Number = imageObj.height;
			addChild(imageObj);
			if (_width / 650 > _height / 500)
			{
				imageObj.scaleX = imageObj.scaleY =650/_width;
			}
			else
			{
				imageObj.scaleX = imageObj.scaleY = 500/_height;
			}
			imageObj.y = 250 - imageObj.height / 2;
		}
		
	}

}