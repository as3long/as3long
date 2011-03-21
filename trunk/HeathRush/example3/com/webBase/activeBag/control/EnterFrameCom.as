package com.webBase.activeBag.control 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...2010-4-30 8:50
	 * @author WZH(shch8.com)
	 */
	public class EnterFrameCom
	{
		
		private static var Instance:EnterFrameCom =new EnterFrameCom;
		public static function getInstance():EnterFrameCom {
			return Instance;
		}
		private var frameAry:Array = new Array;
		private var eFrameChild:Sprite = new Sprite;
		
		public function push(callBack:Function):void
		{
			if (some(callBack)) return;
			frameAry.push(callBack);
			if(!eFrameChild.hasEventListener(Event.ENTER_FRAME)){
			eFrameChild.addEventListener(Event.ENTER_FRAME, enterFrame);
			}
		}
		public function del(callBack:Function):void
		{
			for (var i:uint; i < frameAry.length; i++ ) {
				if (frameAry[i] == callBack) {
					frameAry.splice(i, 1);
					if (frameAry.length == 0) {
						eFrameChild.removeEventListener(Event.ENTER_FRAME, enterFrame);
					}
				}
			}
		}
		private function enterFrame(event:Event):void
		{
			for (var i:uint; i < frameAry.length; i++ ) {
				if (frameAry[i] is Function) {
						frameAry[i]();
					}else {
						frameAry.splice(i, 1);
						return
					}
				}
		}
		public function some(callBack:Function):Boolean
		{
			for (var i:uint; i < frameAry.length; i++ ) {
				if (frameAry[i] == callBack) return true;
				}
			return false;
		}
	}
	
}