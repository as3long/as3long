/**
 * WeeMVC - Copyright(c) 2008
 * 模型基类
 * @author	weemve.org
 * 2009-5-11 20:45
 */
import org.weemvc.as2.core.Notifier;
import org.weemvc.as2.model.IModel;

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
 * @see org.weemvc.as2.model.IModel			IModel
 * @see org.weemvc.as2.model.ModelLocator	ModelLocator
 */
class org.weemvc.as2.model.Model implements IModel {
	
	/**
	 * @copy	org.weemvc.as2.core.INotifier#sendWee()
	 */
	public function sendWee(wee:Object, data):Void {
		Notifier.getInstance().sendWee(wee, data);
	}
	
	/**
	 * <p>返回当前模型类的名称
	 * <b>由于在 AS2 中不支持反射获得类型，所以在子类覆盖此函数
	 * 来获得此类的名称</b></p>
	 */
	public function toString():String {
		return "该模型类的名称";
	}
}