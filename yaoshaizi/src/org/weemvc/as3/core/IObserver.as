/**
 * WeeMVC - Copyright(c) 2008
 * 观察者接口
 * @author	weemve.org
 * 2009-5-11 19:19
 */
package org.weemvc.as3.core {
	
	/**
	 * 观察者类接口。
	 * 
	 * <p>
	 * WeeMVC 的观察者。
	 * </p>
	 * 
	 * @see org.weemvc.as3.core.Observer	Observer
	 */
	public interface IObserver {
		
		/**
		 * 设置此观察者的回调函数。
		 */
		function set callBack(method:Function):void;
		
		/**
		 * 获取此观察者的回调函数。
		 */
		function get callBack():Function;
		
		/**
		 * 设置此观察者的作用域。
		 */
		function set context(obj:Object):void;
		
		/**
		 * 获取此观察者的作用域。
		 */
		function get context():Object;
		
		/**
		 * 执行通知。call回调函数，并且传递参数。
		 * 
		 * @param	wee		WeeMVC 事件（命令类/在<code>View</code>的 getWeeList() 列表中的事件名称）
		 * @param	data	传递的参数
		 */
		function notifyObserver(wee:Object, data:Object = null):void;
		
		/**
		 * 比较函数域是否为当前传递进来的一致。
		 * 
		 * @param	object	一个函数域
		 * @return 			是否一致
		 */
		function compareContext(object:Object):Boolean;
	}
}