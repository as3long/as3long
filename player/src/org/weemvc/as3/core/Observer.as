/**
 * WeeMVC - Copyright(c) 2008
 * 观察者
 * @author	weemve.org
 * 2009-5-11 19:01
 */
package org.weemvc.as3.core {
	
	/**
	 * 观察者类。
	 * 
	 * <p>
	 * WeeMVC 的事件通知都是采用观察者模式实现的。
	 * </p>
	 * 
	 * @see org.weemvc.as3.core.IObserver		IObserver
	 */
	public class Observer implements IObserver {
		/** @private **/
		protected var m_callBack:Function;
		/** @private **/
		protected var m_context:Object;
		
		/**
		 * 观察者类构造函数。
		 * 
		 * @param	notifyMethod	发生WeeMVC事件时的回调函数
		 * @param	notifyContext	当前观察者的作用域
		 */
		public function Observer(notifyMethod:Function, notifyContext:Object = null) {
			m_callBack = notifyMethod;
			m_context = notifyContext;
		}
		
		/**
		 * 设置此观察者的回调函数。
		 */
		public function set callBack(method:Function):void {
			m_callBack = method;
		}
		
		/**
		 * 获取此观察者的回调函数。
		 */
		public function get callBack():Function {
			return m_callBack;
		}
		
		/**
		 * 设置此观察者的作用域。
		 */
		public function set context(obj:Object):void {
			m_context = obj;
		}
		
		/**
		 * 获取此观察者的作用域。
		 */
		public function get context():Object {
			return m_context;
		}
		
		/**
		 * @copy	org.weemvc.as3.core.IObserver#notifyObserver()
		 */
		public function notifyObserver(wee:Object, data:Object = null):void {
			m_callBack.call(m_context, wee, data);
		}
		
		/**
		 * @copy	org.weemvc.as3.core.IObserver#compareContext()
		 */
		public function compareContext(object:Object):Boolean {
			return (m_context === object);
		}
	}
}