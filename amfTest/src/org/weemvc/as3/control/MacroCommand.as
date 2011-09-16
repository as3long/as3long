/**
 * WeeMVC - Copyright(c) 2008
 * 宏命令基类
 * @author	weemve.org
 * 2009-1-11 1:28
 */
package org.weemvc.as3.control {
	import org.weemvc.as3.control.SimpleCommand;
	import org.weemvc.as3.control.ICommand;
	
	/**
	 * 宏命令类。
	 * 
	 * <p>
	 * 此类继承自<code>SimpleCommand</code>。它和<code>SimpleCommand</code>区别是：它可以同时执行多个命令，而
	 * <code>SimpleCommand</code>一次只能执行一个命令。
	 * </p>
	 * <p>
	 * 此宏命令类也需要实现<code>ICommand</code>接口。
	 * </p>
	 * @see org.weemvc.as3.control.ICommand			ICommand
	 * @see org.weemvc.as3.control.SimpleCommand	SimpleCommand
	 */
	public class MacroCommand extends SimpleCommand implements ICommand {
		/** @private **/
		protected var m_subCommands:Array;
		
		/**
		 * 控制器类构造函数。
		 */
		public function MacroCommand() {
			m_subCommands = [];
			initialize();
		}
		
		/**
		 * 初始化宏命令类。
		 * 
		 * @example 下面例子说明通常初始化的做法。
		 * <listing version="3.0">
		 * package {
		 * 	import org.weemvc.as3.control.MacroCommand;
		 * 	public class DemoMacroCommand extends MacroCommand {
		 *		override protected function initialize():void {
		 * 			//这里的 OneCommand、TwoCommand、ThreeCommand 都是继承自 SimpleCommand 的命令类
		 *			addSubCommand(OneCommand);
		 *			addSubCommand(TwoCommand);
		 *			addSubCommand(ThreeCommand);
		 *		}
		 *	}
		 * }
		 * </listing>
		 */
		protected function initialize():void {
			//在子类覆盖此函数
		}
		
		/**
		 * 添加将要同时执行的命令类。
		 * 
		 * @param	commandName	要添加的命令类，都要实现<code>ICommand</code>接口，
		 * 通常这里是 SimpleCommand 的子类
		 */
		protected function addSubCommand(commandName:Class):void {
			m_subCommands.push(commandName);
		}
		
		/**
		 * 执行宏命令类。
		 * 
		 * @param	data	实例化命令类时所带的参数，这里每个子命令类的参数都一样
		 */
		final override public function execute(data:Object = null):void {
			var commandClass:Class;
			var commandInstance:ICommand;
			while (m_subCommands.length > 0) {
				commandClass = m_subCommands.shift();
				commandInstance = new commandClass();
				commandInstance.execute(data);
			}
		}
	}
}