package com.rush360.i 
{
	/**
	 * 观察者管理者接口
	 * @author 360rush
	 */
	public interface IObservable 
	{
		/**
		 * 添加观察者
		 * @param	obServer 观察者
		 */
		function addObServer(obServer:IobServer):void
		
		/**
		 * 移除观察者
		 * @param	obServer 观察者
		 */
		function removeObServer(obServer:IobServer):void
		
		/**
		 * 通知所有观察者
		 * @param	msg 通知的消息
		 */
		function notifyObServers(msg:String):void
	}
	
}