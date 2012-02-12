/**
 * WeeMVC - Copyright(c) 2008
 * 视图基类
 * @author	weemve.org
 * 2009-1-11 23:47
 */
import org.weemvc.as2.core.Notifier;
import org.weemvc.as2.view.IView;

/**
 * 视图类。WeeMVC 的视图。
 * 
 * <p>
 * <b>注意：这里没有继承 FLASH API 中任何一个显示对象（例如 Sprite），
 * 是因为这里的 view 将是以一个中介者存在，会将舞台上的相关实例引用通过构造函数传到此
 * view 的子类中。而此 view 的子类本身将不会显示到 FLASH 的 stage 中。</b>
 * </p>
 * <p>
 * 构造函数 public function View(panel:MovieClip) 这里 panel 指舞台上的相关实例的引用，
 * 因为此类中构造函数未做实质性的内容，所以为方便使用，这里不实现此构造函数。
 * </p>
 * 
 * @see org.weemvc.as2.view.IView	IView
 */
class org.weemvc.as2.view.View implements IView {
	/** @private **/
	//此视图需要监听的消息列表
	private var m_notifications:Array = [];
	
	/**
	 * @copy	org.weemvc.as2.core.INotifier#sendWee()
	 */
	public function sendWee(wee:Object, data):Void {
		Notifier.getInstance().sendWee(wee, data);
	}
	
	/**
	 * 设置当前视图需要监听的“WeeMVC事件”列表。
	 * 
	 * <p>当系统发出此列表中包含的“WeeMVC事件”（名称）时，当前视图中的 onDataChanged 
	 * 能够立即监听到此事件，且形参 wee 就是当前事件的名称
	 * <b>注意：这里个列表中的每个元素为 String 类型，即和 onDataChanged
	 * 中形参 wee 的数据类型一致</b></p>
	 * 
	 * @param	list	当前视图需要监听的“WeeMVC事件”（String）列表
	 */
	public function setWeeList(list:Array):Void {
		m_notifications = list;
	}
	
	/**
	 * 返回当前监听的“WeeMVC事件”列表。
	 */
	public function getWeeList():Array {
		return m_notifications;
	}
	
	/**
	 * @copy	org.weemvc.as2.view.IView#onDataChanged()
	 */
	public function onDataChanged(wee:String, data):Void {
		//在子类覆盖此函数
	}
	
	/**
	 * <p>返回当前视图类的名称
	 * <b>由于在 AS2 中不支持反射获得类型，所以在子类覆盖此函数
	 * 来获得此类的名称</b></p>
	 */
	public function toString():String {
		return "该视图类的名称";
	}
}