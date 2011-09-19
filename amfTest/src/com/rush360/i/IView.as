package com.rush360.i 
{
	
	/**
	 * ...
	 * @author 360rush
	 */
	public interface IView 
	{
		/**
		 * 初始化视图
		 */
		function init():void;
		
		/**
		 * 通知控制类
		 * @param msg 通知消息
		 */
		function notify(msg:String):void;
	}
	
}