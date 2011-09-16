/**
 * WeeMVC - Copyright(c) 2008
 * 视图基类
 * @author	weemve.org
 * 2008-12-14 16:42
 */
package org.weemvc.as3.view {
	import org.weemvc.as3.core.Notifier;
	import org.weemvc.as3.core.INotifier;
	
	import flash.display.Sprite;
	/**
	 * 视图类。WeeMVC 的视图。
	 * 
	 * <p>
	 * <b>注意：这里没有继承 FLASH API 中任何一个显示对象（例如 Sprite），
	 * 是因为这里的 view 将是以一个中介者存在，会将舞台上的相关实例引用通过构造函数传到此
	 * view 的子类中。而此 view 的子类本身将不会显示到 FLASH 的 stage 中。</b>
	 * </p>
	 * <p>
	 * 构造函数 public function View(panel:Sprite) 这里 panel 指舞台上的相关实例的引用，
	 * 因为此类中构造函数未做实质性的内容，所以为方便使用，这里不实现此构造函数。
	 * </p>
	 * 
	 * @see org.weemvc.as3.view.IView	IView
	 */
	public class View implements IView {
		/** @private **/
		//此视图需要监听的消息列表
		protected var m_notifications:Array = [];
		/** @private **/
		protected var m_notifier:INotifier = Notifier.getInstance();
		
		/**
		 * @copy	org.weemvc.as3.core.INotifier#sendWee()
		 */
		public function sendWee(wee:Object, data:Object = null):void {
			m_notifier.sendWee(wee, data);
		}
		
		/**
		 * 设置当前视图需要监听的 wee 列表。
		 * 
		 * <p>当系统发出此列表中包含的事件（名称）时，当前视图中的 onDataChanged 
		 * 能够立即监听到此事件，且形参 wee 就是当前事件的名称
		 * <b>注意：这里个列表中的每个元素为 String 类型，即和 onDataChanged
		 * 中形参 wee 的数据类型一致</b></p>
		 * 
		 * @param	list	当前视图需要监听的“WeeMVC 事件”（String）列表
		 */
		public function setWeeList(list:Array):void {
			m_notifications = list;
		}
		
		/**
		 * 返回当前监听的“WeeMVC 事件”列表。
		 */
		public function getWeeList():Array {
			return m_notifications;
		}
		
		/**
		 * @copy	org.weemvc.as3.view.IView#onDataChanged()
		 */
		public function onDataChanged(wee:String, data:Object = null):void {
			//在子类覆盖此函数
		}
	}
}