/**
 * WeeMVC - Copyright(c) 2008
 * 控制器--分发视图过来的操作
 * @author	weemve.org
 * 2008-12-14 16:39
 */
package org.weemvc.as3.control {
	import org.weemvc.as3.core.WeemvcLocator;
	import org.weemvc.as3.core.Notifier;
	import org.weemvc.as3.core.INotifier;
	import org.weemvc.as3.core.Observer;
	import org.weemvc.as3.core.IObserver;
	import org.weemvc.as3.WeemvcError;
	import org.weemvc.as3.PaperLogger;
	
	/**
	 * 控制器类。
	 * 
	 * <p>
	 * 此类是采用命令模式实现的。主要有以下作用。例如：
	 * </p>
	 * <ul>
	 * <li>添加命令类</li>
	 * <li>删除命令类</li>
	 * <li>执行命令类</li>
	 * <li>检查指定的命令类是否存在</li>
	 * </ul>
	 * <p>
	 * 通常是由观察者模式来出发此控制器来执行命令类。当然，您也可以自己来执行一个命令类。
	 * </p>
	 * 
	 * @see org.weemvc.as3.control.IController		IController
	 * @see org.weemvc.as3.control.ICommand			ICommand
	 * @see org.weemvc.as3.control.MacroCommand		MacroCommand
	 * @see org.weemvc.as3.control.SimpleCommand	SimpleCommand
	 */
	public class Controller extends WeemvcLocator implements IController {
		/** @private **/
		static private var m_instance:Controller = null;
		/** @private **/
		protected var m_notifier:INotifier = Notifier.getInstance();
		
		/**
		 * 控制器类构造函数。
		 * 
		 * @throws org.weemvc.as3.WeemvcError 单件的<code>Controller</code>被实例化多次
		 */
		public function Controller() {
			if (m_instance) {
				throw new WeemvcError(WeemvcError.SINGLETON_CONTROLLER_MSG, Controller);
			}else {
				m_instance = this;
			}
		}
		
		/**
		 * 返回控制器类的实例，若没有创建则创建，若已创建，则返回该实例。
		 * 
		 * @return	当前的控制器类实例。
		 */
		static public function getInstance():IController {
			if (!m_instance) {
				m_instance = new Controller();
			}
			return m_instance;
		}
		
		/**
		 * <p><b>注意：如果要添加的命令类已经添加，WeeMVC 会发出<code>WeemvcError.ADD_COMMAND_MSG</code>警告。</b></p>
		 * @copy	org.weemvc.as3.control.IController#addCommand()
		 */
		public function addCommand(commandClass:Class):void {
			var oberver:IObserver;
			if (!hasCommand(commandClass)) {
				oberver = new Observer(executeCommand, this);
				m_notifier.addObserver(commandClass, oberver);
				add(commandClass, commandClass);
			}else {
				PaperLogger.getInstance().log(WeemvcError.ADD_COMMAND_MSG, Controller, commandClass);
			}
		}
		
		/**
		 * <p><b>注意：如果此命令类不存在，WeeMVC 会发出<code>WeemvcError.COMMAND_NOT_FOUND</code>警告。</b></p>
		 * @copy	org.weemvc.as3.control.IController#removeCommand()
		 */
		public function removeCommand(commandClass:Class):void {
			if (hasCommand(commandClass)) {
				m_notifier.removeObserver(commandClass, this);
				remove(commandClass);
			}else {
				PaperLogger.getInstance().log(WeemvcError.COMMAND_NOT_FOUND, Controller, commandClass);
			}
		}
		
		/**
		 * @copy	org.weemvc.as3.control.IController#hasCommand()
		 */
		public function hasCommand(commandClass:Class):Boolean {
			return hasExists(commandClass);
		}
		
		/**
		 * <p><b>注意：如果此命令类不存在，WeeMVC 会发出<code>WeemvcError.COMMAND_NOT_FOUND</code>警告。</b></p>
		 * @copy	org.weemvc.as3.control.IController#executeCommand()
		 */
		public function executeCommand(commandClass:Class, data:Object = null):void {
			var commandClass:Class;
			var commandInstance:ICommand;
			if (hasCommand(commandClass)) {
				commandClass = retrieve(commandClass);
				commandInstance = new commandClass();
				commandInstance.execute(data);
			}else {
				PaperLogger.getInstance().log(WeemvcError.COMMAND_NOT_FOUND, Controller, commandClass);
			}
		}
	}
}