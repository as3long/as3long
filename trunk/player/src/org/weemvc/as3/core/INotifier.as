/**
 * WeeMVC - Copyright(c) 2008
 * 发送事件接口
 * @author	weemve.org
 * 2009-5-11 18:30
 */
package org.weemvc.as3.core {
	
	/**
	 * WeeMVC 事件类接口。
	 * 
	 * <p>
	 * WeeMVC 的事件通知都是采用观察者模式实现的。
	 * </p>
	 * 
	 * @see org.weemvc.as3.core.Notifier	Notifier
	 */
	public interface INotifier {
		
		/**
		 * 添加观察者类。
		 *
		 * @param	wee				事件（命令类/在<code>View</code>的 getWeeList() 列表中的事件名称）
		 * @param	observer		观察者
		 */
		function addObserver(wee:Object, observer:IObserver):void;
		
		/**
		 * 移除观察者类。
		 *
		 * @param	wee				事件
		 * @param	notifyContext	当前观察者的作用域
		 */
		function removeObserver(wee:Object, notifyContext:Object):void;
		
		/**
		 * 发送 WeeMVC 事件。
		 * 
		 * @param	wee				事件（命令类/在<code>View</code>的 getWeeList() 列表中的事件名称）
		 * @param	data			需要传递的参数
		 */
		function sendWee(wee:Object, data:Object = null):void;
	}
}