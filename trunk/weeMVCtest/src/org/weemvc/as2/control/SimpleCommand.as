/**
 * WeeMVC - Copyright(c) 2008
 * 简单命令基类
 * @author	weemve.org
 * 2009-1-11 21:38
 */
import org.weemvc.as2.view.ViewLocator;
import org.weemvc.as2.view.IViewLocator;
import org.weemvc.as2.model.ModelLocator;
import org.weemvc.as2.model.IModelLocator;
import org.weemvc.as2.control.Controller;
import org.weemvc.as2.control.IController;
import org.weemvc.as2.control.ICommand;
import org.weemvc.as2.core.Notifier;
import org.weemvc.as2.core.INotifier;

/**
 * 简单命令类。
 * 
 * <p>
 * 需要实现<code>ICommand</code>接口。
 * </p>
 * 
 * @see org.weemvc.as2.control.ICommand	ICommand
 */
class org.weemvc.as2.control.SimpleCommand implements ICommand {
	
	/**
	 * @copy	org.weemvc.as2.control.ICommand#execute()
	 */
	public function execute(data):Void {
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
	 * @copy	org.weemvc.as2.core.INotifier#sendWee()
	 */
	public function sendWee(wee:String, data):Void {
		Notifier.getInstance().sendWee(wee, data);
	}
	
	/**
	 * <p>返回当前命令类的名称
	 * <b>由于在 AS2 中不支持反射获得类型，所以在子类覆盖此函数
	 * 来获得此类的名称</b></p>
	 */
	public function toString():String {
		return "该命令类的名称";
	}
}