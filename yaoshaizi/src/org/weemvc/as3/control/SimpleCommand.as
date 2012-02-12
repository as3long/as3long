/**
 * WeeMVC - Copyright(c) 2008
 * 简单命令基类
 * @author	weemve.org
 * 2009-1-11 1:28
 */
package org.weemvc.as3.control {
	import org.weemvc.as3.model.ModelLocator;
	import org.weemvc.as3.model.IModelLocator;
	import org.weemvc.as3.view.ViewLocator;
	import org.weemvc.as3.view.IViewLocator;
	import org.weemvc.as3.control.Controller;
	import org.weemvc.as3.control.IController;
	import org.weemvc.as3.core.Notifier;
	
	/**
	 * 简单命令类。
	 * 
	 * <p>
	 * 需要实现<code>ICommand</code>接口。
	 * </p>
	 * 
	 * @see org.weemvc.as3.control.ICommand	ICommand
	 */
	public class SimpleCommand implements ICommand {
		
		/**
		 * @copy	org.weemvc.as3.control.ICommand#execute()
		 */
		public function execute(data:Object = null):void{
			//在子类覆盖此函数
		}
		
		/** WeeMVC modelLocator 句柄 **/
		public function get modelLocator():IModelLocator {
			return ModelLocator.getInstance();
		}
		
		/** WeeMVC viewLocator 句柄 **/
		public function get viewLocator():IViewLocator {
			return ViewLocator.getInstance();
		}
		
		/** WeeMVC controller 句柄 **/
		public function get controller():IController {
			return Controller.getInstance();
		}
		
		/**
		 * @copy	org.weemvc.as3.core.INotifier#sendWee()
		 */
		public function sendWee(wee:Object, data:Object = null):void {
			Notifier.getInstance().sendWee(wee, data);
		}
	}
}