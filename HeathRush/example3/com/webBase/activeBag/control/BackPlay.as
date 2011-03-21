package com.webBase.activeBag.control 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * MC动画回放
	 * @author WZH(shch8.com)
	 */
	public class BackPlay 
	{
		private var _mc:MovieClip
		private var _to:Object
		private var _from:Object
		private var isBack:Boolean
		public function BackPlay(mc:MovieClip) 
		{
			_mc=mc
		}
		/**
		 * 播放到
		 * @param	to		播放结束点，可以是帧数或帧标签，为空表示播放到最后一帧
		 * @param	from	播放开始点，可以是帧数或帧标签，为空表示从当前帧开始
		 */
		public function backTo(to:Object=null, from:Object = null):void {
			this.to = to
			this.from = from
			isBack = true
			for (var i:* in _mc.currentLabels) {
				if (_mc.currentLabels[i].name == to) { this.to = _mc.currentLabels[i].frame; break; }
			}
			if (from) _mc.gotoAndStop(from)
			_mc.addEventListener(Event.ENTER_FRAME,enterFrame)
		}
		/**
		 * 播放到
		 * @param	to		播放结束点，可以是帧数或帧标签，为空表示播放到最后一帧
		 * @param	from	播放开始点，可以是帧数或帧标签，为空表示从当前帧开始
		 */
		public function playTo(to:Object=null, from:Object = null):void {
			this.to = to
			this.from = from
			isBack=false
			if (from) {
				_mc.gotoAndPlay(from)
				}else {
					_mc.play()
					}
			_mc.addEventListener(Event.ENTER_FRAME,enterFrame)
		}
		
		private function get to():Object { return _to }
		private function set to(value:Object):void { _to = value==""?null:value; }
		
		private function get from():Object { return _from }
		private function set from(value:Object):void { _from = value == ""?null:value; }
		
		private function enterFrame(e:Event):void {
			if(isBack){
				backing()
			}else {
				playing()
				}
		}
		private function backing():void {
			if (_to) {
				if (_to is String) {
						if (_mc.currentLabel == String(_to)) stop();
						}else {
							if (_mc.currentFrame == uint(_to)) stop();
						}
			}else {//未设置结束点
				if (_mc.currentFrame ==1) stop();
			}
			_mc.gotoAndStop(_mc.currentFrame-1)
		}
		private function playing():void {
			if (_to) {
					if (_to is String) {
						if (_mc.currentLabel == String(_to)) stop();
						}else {
							if (_mc.currentFrame == uint(_to)) stop();
							}
			}else {//未设置结束点
				if (_mc.currentFrame == _mc.totalFrames) stop();
			}
		}
		public function stop():void {
			_mc.stop()
			_mc.removeEventListener(Event.ENTER_FRAME,enterFrame)
		}
	}
	
}