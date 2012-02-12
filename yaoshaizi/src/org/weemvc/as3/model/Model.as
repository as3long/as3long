/**
 * WeeMVC - Copyright(c) 2008
 * 模型基类
 * @author	weemve.org
 * 2009-5-11 20:45
 */
package org.weemvc.as3.model {
	import org.weemvc.as3.core.Notifier;
	import org.weemvc.as3.core.INotifier;
	
	/**
	 * 模型类。
	 * 
	 * <p>
	 * 在 WeeMVC 中模型类主要有以下作用：
	 * </p>
	 * <ul>
	 * <li>封装应用程序状态</li>
	 * <li>响应应用程序状态</li>
	 * <li>通知视图改变</li>
	 * </ul>
	 * <p>
	 * 模型类会通过 WeeMVC 事件将更新的数据通知给视图。
	 * </p>
	 * 
	 * @see org.weemvc.as3.model.IModel			IModel
	 * @see org.weemvc.as3.model.ModelLocator	ModelLocator
	 */
	public class Model implements IModel {
		/** @private **/
		protected var m_notifier:INotifier = Notifier.getInstance();
		
		 /**
		 * @copy	org.weemvc.as3.core.INotifier#sendWee()
		 */
		public function sendWee(wee:Object, data:Object = null):void {
			m_notifier.sendWee(wee, data);
		}
	}
}