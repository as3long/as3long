/**
 * WeeMVC - Copyright(c) 2008
 * 控制器接口
 * @author	weemve.org
 * 2009-5-11 17:45
 */
package org.weemvc.as3.control {
	
	/**
	 * 控制器类接口。
	 * 
	 * @see org.weemvc.as3.control.Controller	Controller
	 */
	public interface IController {
		
		/**
		 * 添加命令类。
		 * 
		 * @param	commandClass	要添加的命令类，都要实现<code>ICommand</code>接口
		 */
		function addCommand(commandClass:Class):void;
		
		/**
		 * 移除命令类。
		 * 
		 * @param	commandClass	要移除的命令类，都要实现<code>ICommand</code>接口
		 */
		function removeCommand(commandClass:Class):void;
		
		/**
		 * 判断此命令类是否已经存在。
		 * 
		 * @param	commandClass	要判断的命令类，都要实现<code>ICommand</code>接口
		 * @return 					是否存在
		 */
		function hasCommand(commandClass:Class):Boolean;
		
		/**
		 * 执行此命令类。
		 * 
		 * @param	commandClass	要执行的命令类，都要实现<code>ICommand</code>接口
		 * @param	data			实例化此命令类时所带的参数
		 */
		function executeCommand(commandClass:Class, data:Object = null):void;
	}
}