/**
 * WeeMVC - Copyright(c) 2008
 * 视图基类
 * @author	weemve.org
 * 2008-12-14 16:42
 */
package org.weemvc.as3.view {
	/**
	 * 视图类接口。
	 * 
	 * <p>
	 * WeeMVC 的视图。
	 * </p>
	 * 
	 * @see org.weemvc.as3.model.View	View
	 */
	public interface IView {
		/**
		 * @copy	org.weemvc.as3.core.INotifier#sendWee()
		 */
		function sendWee(wee:Object, data:Object = null):void;
		
		/**
		 * 设置当前视图需要监听的“WeeMVC 事件”列表。
		 * 
		 * <p>当系统发出此列表中包含的事件（名称）时，当前视图中的 onDataChanged
		 * 能够立即监听到此事件，且形参 wee 就是当前事件的名称。
		 * </p>
		 * <p><b>注意：这里个列表中的每个元素为 String 类型，即和 onDataChanged
		 * 中形参 wee 的数据类型一致</b></p>
		 * 
		 * @param	list	当前视图需要监听的“WeeMVC 事件”（String）列表
		 */
		function setWeeList(list:Array):void;
		
		/**
		 * 返回当前监听的“WeeMVC 事件”列表。
		 */
		function getWeeList():Array;
		
		/**
		 * 当发送的 WeeMVC 事件包含在<code>setWeeList()</code>里时，这个函数将被执行。
		 * 
		 * @param	wee		当前发生的事件的名称，一定是<code>getWeeList()</code>里的某个元素
		 * @param	data	此事件一起传递的参数
		 */
		function onDataChanged(wee:String, data:Object = null):void;
	}
}