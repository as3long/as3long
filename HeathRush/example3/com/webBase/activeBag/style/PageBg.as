package com.webBase.activeBag.style 
{
	import com.webBase.activeBag.effect.transitions.Tweener;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author WZH(shch8.com)
	 */
	public class PageBg extends Sprite
	{
		public static const STRETCH:String = "stretch";//拉伸
		public static const CENTER:String = "center";//居中
		public static const MATRIX:String = "matrix";//平埔
		private var _wid:Number
		private var _hei:Number
		public var _mode:String = MATRIX;
		private var _displayClip:DisplayObject
		private var imgBox:Sprite
		private var _autoSize:Boolean = true
		public var speed:Number=0.6
		public function PageBg(wid:Number=500,hei:Number=400) 
		{
			width = wid
			height = hei;
		}
		public function set displayClip(value:DisplayObject):void {
			if (value == null) return
			_displayClip = value;
			imgBox = new Sprite
			addChild(imgBox)
			imgBox.alpha = 0
			if (_mode != MATRIX) {
				imgBox.addChild(_displayClip)
				}
			Tweener.addTween(imgBox, { alpha:1, time:speed,onComplete:changeEvent})
			autoSize = _autoSize;
		}
		public function set mode(value:Object):void {
			if (value is String) {
				_mode = String(value);
				return;
			}
			switch(uint(value)) {
				case 1:
				_mode = MATRIX;
				break
				case 2:
				_mode = CENTER;
				break
				case 3:
				_mode = STRETCH;
				break
				}
		}
		//是否跟据舞台大小自动调整大小
		public function set autoSize(value:Boolean):void {
			_autoSize = value;
			if (value) {
				stage.addEventListener(Event.RESIZE, sizeEvent)
				sizeEvent(null)
				}else {
					stage.removeEventListener(Event.RESIZE,sizeEvent)
					}
		}
		private function sizeEvent(e:Event):void {
			setSize(stage.stageWidth,stage.stage.stageHeight)
		}
		//切换移除
		private function changeEvent():void {
			var getObj:DisplayObject
			for (var i:uint; i < this.numChildren-1; i++ ) {
				getObj = getChildAt(i) as DisplayObject
				if (getObj) removeChild(getObj);
				}
		}
		
		public function get displayClip():DisplayObject {
			return _displayClip
		}
		public function load(filePath:String):void {
				var loadimg:Loader = new Loader;
				loadimg.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoadComplete);
				loadimg.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
				loadimg.load(new URLRequest(filePath));
		}
		private function imgLoadComplete(event:Event):void {
				var bgMap:Bitmap =event.target.content as Bitmap
				bgMap.smoothing = true;
				displayClip = event.target.content as DisplayObject;
				imgBox.dispatchEvent(new Event(Event.COMPLETE));
			}
		public function setSize(wid:Number, hei:Number):void {
			switch(_mode) {
						case MATRIX:
							var img:BitmapData =  new BitmapData(_displayClip.width, _displayClip.height, true, 0);
							img.draw(_displayClip);
							imgBox.graphics.clear()
							imgBox.graphics.beginBitmapFill(img);
							imgBox.graphics.drawRect(0, 0, wid, hei);
							imgBox.graphics.endFill();
						break;
						case CENTER:
							_displayClip.x = (wid - _displayClip.width) / 2;
							_displayClip.y = (hei - _displayClip.height) / 2;
						break
						case STRETCH:
						_displayClip.x=_displayClip.y=0
							_displayClip.width = wid;
							_displayClip.height = hei;
						break
						
					}
		}
		private function loadError(event:IOErrorEvent):void {
			throw new Error("背景加载失败，请检查您的文件路径！");
		}
		override public function get width():Number { return _wid; }
		
		override public function set width(value:Number):void 
		{
			_wid = value;
		}
		override public function get height():Number { return _hei; }
		
		override public function set height(value:Number):void 
		{
			_hei = value;
		}
	}
	
}