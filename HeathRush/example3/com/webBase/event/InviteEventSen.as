package com.webBase.event 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * 事件异步发送，框架内部使用，不见意用户使用
	 * @author WZH(shch8.com)
	 * 
	 */
	public class InviteEventSen 
	{
		
		private static var inviteEvent:InviteEventSen;
		/**
		 * @private
		 * @param	eventDispatch
		 * @param	event
		 * @param	dispatchCallBack
		 * @param	checkFun
		 */
		public static function sen(eventDispatch:EventDispatcher,event:Event,dispatchCallBack:Function=null,checkFun:Function=null):void
		{
			if(!dispatch()){
			var timer:Timer = new Timer(10);
			timer.addEventListener(TimerEvent.TIMER, timerEvent);
			timer.start();
			}
			function timerEvent(e:TimerEvent):void
			{
					if(dispatch()){
						timer.removeEventListener(TimerEvent.TIMER, timerEvent);
						timer.stop();
						timer = null;
						}
			}
			function dispatch():Boolean
			{
				if (isTrue()) {
					eventDispatch.dispatchEvent(event);
					if (dispatchCallBack != null) dispatchCallBack();
					return true;
					}
				return false;
			}
			function isTrue():Boolean {
				var re:Boolean=eventDispatch.hasEventListener(event.type)
				if (checkFun is Function) re = re || checkFun();
				return re;
			}
		}
	}
	
}