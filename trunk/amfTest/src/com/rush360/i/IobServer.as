package com.rush360.i 
{
	
	/**
	 * 观察者接口
	 * @author 360rush
	 */
	public interface IobServer 
	{
		/**
		 * 通知观察者
		 * @param	msg 通知的消息
		 */
		function notify(msg:String):void;
	}
	
}