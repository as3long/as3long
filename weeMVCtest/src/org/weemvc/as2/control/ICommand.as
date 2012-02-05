/**
 * WeeMVC - Copyright(c) 2008
 * 命令接口
 * @author	weemve.org
 * 2009-1-11 21:37
 */

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
 * @see org.weemvc.as2.control.MacroCommand		MacroCommand
 * @see org.weemvc.as2.control.SimpleCommand	SimpleCommand
 */
interface org.weemvc.as2.control.ICommand {
	
	/**
	 * 执行命令类。
	 * 
	 * @param	data	实例化命令类时所带的参数，因为参数类型是不固定的，所以这里未加变量类型
	 */
	function execute(data):Void;
	
	/**
	 * @internal	注意：在 AS2 中，由于不能声明 setter/getter 的接口，所以 function get modelLocator():IModelLocator 等未声明
	 */
}