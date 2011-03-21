package com.webBase.activeBag.effect 
{
	import flash.display.FrameLabel;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 影片按钮事件处理
	 * @author WZH(shch8.com)
	 */
	public class MovieBtn 
	{
		private var _target:MovieClip
		private var _endTag:String
		private var _hitArea:InteractiveObject
		public var callClick:Function
		public function MovieBtn(target:MovieClip,hitArea:InteractiveObject=null,endTag:String="tag") 
		{
			_target = target
			_endTag = endTag
			//_target.gotoAndStop(1)
			_hitArea = hitArea == null?target:hitArea
			_hitArea.addEventListener(MouseEvent.MOUSE_OVER, mouseEvent)
			_hitArea.addEventListener(MouseEvent.MOUSE_OUT, mouseEvent)
			_hitArea.addEventListener(MouseEvent.ROLL_OUT, mouseEvent)
			_hitArea.addEventListener(MouseEvent.ROLL_OVER, mouseEvent)
			_hitArea.addEventListener(MouseEvent.CLICK, mouseEvent)
		}
		public function get target():MovieClip { return _target };
		public function get hitArea():InteractiveObject { return _hitArea };
		private function mouseEvent(e:MouseEvent):void {
			if(!_hitArea.mouseEnabled)return
			switch(e.type) {
				case MouseEvent.MOUSE_OVER || MouseEvent.ROLL_OVER:
				_target.gotoAndPlay(2)
				break
				case MouseEvent.MOUSE_OUT || MouseEvent.ROLL_OUT:
				_target.gotoAndPlay(_endTag)
				break
				case MouseEvent.CLICK:
				if(callClick is Function)callClick(this)
				break
				}
		}
		/*清除*/
		public function clear():void {
			_hitArea.removeEventListener(MouseEvent.MOUSE_OVER, mouseEvent)
			_hitArea.removeEventListener(MouseEvent.MOUSE_OUT, mouseEvent)
			_hitArea.removeEventListener(MouseEvent.CLICK, mouseEvent)
			_hitArea.removeEventListener(MouseEvent.ROLL_OUT, mouseEvent)
			_hitArea.removeEventListener(MouseEvent.ROLL_OVER, mouseEvent)
			_target = null
			_hitArea=null
		}
		
	}
	
}