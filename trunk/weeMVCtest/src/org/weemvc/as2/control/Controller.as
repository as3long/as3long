/**
 * WeeMVC - Copyright(c) 2008
 * 控制器--分发视图过来的操作
 * @author	weemve.org
 * 2009-1-11 21:36
 */
import org.weemvc.as2.Util;
import org.weemvc.as2.WeemvcError;
import org.weemvc.as2.PaperLogger;
import org.weemvc.as2.control.ICommand;
import org.weemvc.as2.control.IController;
import org.weemvc.as2.core.WeemvcLocator;
import org.weemvc.as2.core.Notifier;
import org.weemvc.as2.core.INotifier;
import org.weemvc.as2.core.Observer;
import org.weemvc.as2.core.IObserver;

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
 * @see org.weemvc.as2.control.IController		IController
 * @see org.weemvc.as2.control.ICommand			ICommand
 * @see org.weemvc.as2.control.MacroCommand		MacroCommand
 * @see org.weemvc.as2.control.SimpleCommand	SimpleCommand
 */
class org.weemvc.as2.control.Controller extends WeemvcLocator implements IController {
	/** @private **/
	static private var m_instance:IController = null;
	/** @private **/
	private var m_notifier:INotifier;
	
	/**
	 * 控制器类构造函数。
	 * 
	 * @throws org.weemvc.as2.WeemvcError 单件的<code>Controller</code>被实例化多次
	 */
	public function Controller() {
		if (m_instance) {
			throw new WeemvcError(WeemvcError.SINGLETON_CONTROLLER_MSG, "Controller", null);
		}else {
			m_instance = this;
			m_weeMap = {};
			m_notifier = Notifier.getInstance();
		}
	}
	
	/**
	 * 返回控制器类的实例，若没有创建则创建，若已创建，则返回该实例。
	 * 
	 * @return	当前的控制器类实例。
	 */
	static public function getInstance():IController{
		if (!m_instance) {
			m_instance = new Controller();
		}
		return m_instance;
	}
	
	/**
	 * <p><b>注意：如果要添加的命令类已经添加，WeeMVC 会发出<code>WeemvcError.ADD_COMMAND_MSG</code>警告。</b></p>
	 * @copy	org.weemvc.as2.control.IController#addCommand()
	 */
	public function addCommand(commandClass:Object):Void {
		var commandName:Object = Util.getProto(commandClass);
		var oberver:IObserver;
		if (!hasExists(commandName)) {
			oberver = new Observer(executeCommand, this);
			m_notifier.addObserver(commandName, oberver);
			add(commandName, commandClass);
		}else {
			PaperLogger.getInstance().log(WeemvcError.ADD_COMMAND_MSG, "Controller", [commandName]);
		}
	}
	
	/**
	 * <p><b>注意：如果此命令类不存在，WeeMVC 会发出<code>WeemvcError.COMMAND_NOT_FOUND</code>警告。</b></p>
	 * @copy	org.weemvc.as2.control.IController#removeCommand()
	 */
	public function hasCommand(commandClass:Object):Boolean {
		var commandName:Object = Util.getProto(commandClass);
		return hasExists(commandName);
	}
	
	/**
	 * @copy	org.weemvc.as2.control.IController#hasCommand()
	 */
	public function removeCommand(commandClass:Object):Void {
		var commandName:Object = Util.getProto(commandClass);
		if (hasExists(commandName)) {
			m_notifier.removeObserver(commandName, this);
			remove(commandName);
		}else {
			PaperLogger.getInstance().log(WeemvcError.COMMAND_NOT_FOUND, "Controller", [commandName]);
		}
	}
	
	/**
	 * <p><b>注意：如果此命令类不存在，WeeMVC 会发出<code>WeemvcError.COMMAND_NOT_FOUND</code>警告。</b></p>
	 * @copy	org.weemvc.as2.control.IController#executeCommand()
	 */
	public function executeCommand(commandClass:Object, data):Void {
		var commandName:Object = Util.getProto(commandClass);
		var commandClass:Object;
		var commandInstance:ICommand;
		if (hasExists(commandName)) {
			commandClass = retrieve(commandName);
			commandInstance = new commandClass();
			commandInstance.execute(data);
		}else {
			PaperLogger.getInstance().log(WeemvcError.COMMAND_NOT_FOUND, "Controller", [commandName]);
		}
	}
}