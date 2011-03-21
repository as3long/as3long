// Copyright @ shch8.com All Rights Reserved At 2009-3-23 14:35
//开发：商创技术（www.shch8.com）望月狼
/*
进入全屏模式
 */
package com.webBase.activeBag.control
{
	import flash.events.MouseEvent;
	import flash.events.FullScreenEvent
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	public class FullScreen extends Sprite {
		private var _stage:Object
		public var intoFull:Function;
		public var exitFull:Function;
		private static var Instance:FullScreen = new FullScreen;
		/*使用本类前，先执行安装
		Instance(stage对象,是比例模式,对齐方式)*/
		public function Instance(__stage:Object):void {
			_stage = __stage;
			_stage.addEventListener(FullScreenEvent.FULL_SCREEN, eventFun)
		}
		public static function getInstance():FullScreen {
			return Instance;
		}
		private function eventFun(event:FullScreenEvent):void {
			if (_stage.displayState == "normal") {
				if (intoFull != null) exitFull();
				}else {
					if (exitFull != null) intoFull();
					}
		}
		public function displayState(event:*= null):void {
			if (_stage == null) return;
			if (_stage.displayState == "normal") {
				_stage.displayState = "fullScreen";
			} else {
				_stage.displayState = "normal";
			}
		}
	}
}