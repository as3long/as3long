/**
 * WeeMVC - Copyright(c) 2008
 * 命令接口
 * @author	weemve.org
 * 2008-12-14 16:40
 */
package org.weemvc.as3.control {
	import org.weemvc.as3.model.IModelLocator;
	import org.weemvc.as3.view.IViewLocator;
	import org.weemvc.as3.control.IController;
	
	/**
	 * 命令类接口。
	 * 
	 * <p>
	 * 所有的 WeeMVC 命令类都要实现此接口。然而，您不必重新自己全部实现它，因为 WeeMVC
	 * 已经帮您实现好，您只需要继承以下类即可：
	 * </p>
	 * <ul>
	 * <li>SimpleCommand--在单个命令时可以继承此类。</li>
	 * <li>MacroCommand--需要同时执行多个命令时，可以继承此类。</li>
	 * </ul>
	 * 
	 * @see org.weemvc.as3.control.MacroCommand		MacroCommand
	 * @see org.weemvc.as3.control.SimpleCommand	SimpleCommand
	 */
	public interface ICommand {
		
		/**
		 * 执行命令类。
		 * 
		 * @param	data	实例化命令类时所带的参数
		 */
		function execute(data:Object = null):void;
		/** WeeMVC modelLocator 句柄 **/
		function get modelLocator():IModelLocator;
		/** WeeMVC viewLocator 句柄 **/
		function get viewLocator():IViewLocator;
		/** WeeMVC controller 句柄 **/
		function get controller():IController;
	}
}