package com.mySite.imgbrow
{
	import com.webBase.activeBag.MethodBag;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author WZH(shch8.com)
	 */
	public class ImgItem extends Sprite
	{
		private var _wid:Number
		private var _hei:Number
		private var loader:Loader
		private var maskMc:Sprite
		private var _id:uint
		public function ImgItem() 
		{
			selTag.visible = false
			width = getChildByName("selTag").width
			height=getChildByName("selTag").height
		}
		public function set selected(value:Boolean):void {
			selTag.visible = value
			this.mouseChildren = !value
			this.mouseEnabled = !value
		}
		public function get selected():Boolean{
			return selTag.visible
		}
		public function set id(value:uint):void {
			_id=value
		}
		public function get id():uint{return _id}
		public function set title(value:String):void {
			if(_title)_title.text=value
		}
		public function set source(value:String):void {
			var pb:MethodBag=new MethodBag
			pb.net.loadFile(value, getLoader)
			
		}
		private function getLoader(value:Loader):void {
			if (loader) loader.unload();
			
			loader = value
			content.mouseChildren=false
			//resizeImg(loader,width,height)
			content.addChild(loader)
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
		private function resizeImg(img:DisplayObjectContainer,wid:Number,hei:Number):void
		{
			var widthProportion:Number = img.height / img.width;
			var heightProportion:Number = img.width / img.height;
			var _stageProportion:Number = hei / wid;
			if (widthProportion > _stageProportion){
			img.width = wid;
			img.height = widthProportion * wid;
			}else{
			img.width = heightProportion * hei;
			img.height = hei;
			}
		}
	}
	
}