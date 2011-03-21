package com.mySite.imgbrow
{
	import com.webBase.activeBag.MethodBag;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	/**
	 * ...
	 * @author WZH(shch8.com)
	 */
	public class ImgView extends Sprite
	{
		private var loader:Loader;
		public var imgWid:uint=470
		public var imgHei:uint = 350
		private var setX:Number;
		private var setY:Number;
		private var pb:MethodBag=new MethodBag
		public function ImgView() 
		{
			closeBtn.addEventListener(MouseEvent.CLICK, close)
			addEventListener(Event.REMOVED_FROM_STAGE, remove)
		}
		public function get linkBtn():SimpleButton { return getChildByName("bt") as SimpleButton };
		private function remove(e:Event):void {
			closeBtn.removeEventListener(MouseEvent.CLICK, close)
		}
		public function close(e:MouseEvent = null):void {
			setX = x
			setY = y
			pb.effect.tweener(this,{alpha:0,scaleX:0.3,x:x + imgWid / 2,y:y + imgHei / 2,scaleY:0.3,time:0.5,onComplete:closeEvent})
			}

		private function closeEvent():void {
			this.visible = false;
			scaleX = scaleY = 1
			x = setX
			y = setY
			dispatchEvent(new Event(Event.CLOSE))
		}
		public function set title(value:String):void {
			_title.htmlText=value
		}
		public function set source(value:String):void {
			if (loader) {
				loader.unload()
				content.removeChild(loader)
				loader=null
				}
			pb.net.loadFile(value,getLoader)
			this.visible=true
			this.alpha = 0;
			this.scaleX = this.scaleY = 0.3
			setX = x
			setY = y
			this.x = setX + imgWid / 2
			this.y=setY+imgHei/2
			pb.effect.tweener(this,{alpha:1,scaleX:1,x:setX,y:setY,scaleY:1,time:0.7})
		}
		private function getLoader(value:Loader):void {
			loader = value
			content.mouseChildren=false
			resizeImg(loader,imgWid,imgHei)
			content.addChild(loader)
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