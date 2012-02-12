/**
 * WeeMVC - Copyright(c) 2008
 * 发送通知
 * @author	weemve.org
 * 2009-5-11 18:32
 */
import org.weemvc.as2.Util;
import org.weemvc.as2.core.WeemvcLocator;
import org.weemvc.as2.core.INotifier;
import org.weemvc.as2.core.IObserver;
import org.weemvc.as2.WeemvcError;
import org.weemvc.as2.PaperLogger;
/**
 * WeeMVC 事件类。
 * 
 * <p>
 * WeeMVC 的事件通知都是采用观察者模式实现的。
 * </p>
 * 
 * @see org.weemvc.as2.core.INotifier	INotifier
 */
class org.weemvc.as2.core.Notifier extends WeemvcLocator implements INotifier {
	/** @private **/
	static private var m_instance:Notifier = null;
	
	/**
	 * 通知类构造函数。
	 * 
	 * @throws org.weemvc.as2.WeemvcError 单件的<code>Notifier</code>被实例化多次
	 */
	public function Notifier() {
		if (m_instance) {
			throw new WeemvcError(WeemvcError.SINGLETON_NOTIFIER_MSG, "Notifier", null);
		}else {
			m_instance = this;
			//因为在 AS2 中，继承时会将该属性之前的值也继承过来，所以这里需要清空
			m_weeMap = {};
		}
	}
	
	/**
	 * 返回通知类的实例，若没有创建则创建，若已创建，则返回该实例。
	 * 
	 * @return	当前的通知类实例。
	 */
	static public function getInstance():INotifier {
		if (!m_instance) {
			m_instance = new Notifier();
		}
		return m_instance;
	}
	
	/**
	 * @copy	org.weemvc.as2.core.INotifier#addObserver()
	 */
	public function addObserver(wee:Object, observer:IObserver):Void {
		var observers:Array = retrieve(wee);
		//若已经存在，则追加；否则新建
		if (observers) {
			observers.push(observer);
		} else {
			observers = [observer];
		}
		add(wee, observers);
	}
	
	/**
	 * @copy	org.weemvc.as2.core.INotifier#removeObserver()
	 */
	public function removeObserver(wee:Object, notifyContext:Object):Void {
		var observers:Array = retrieve(wee);
		var observer:IObserver;
		if (observers) {
			for (var i:Number = 0; i < observers.length; i++) {
				observer = IObserver(observers[i]);
				//如果函数作用域和传递进来的一致，则删除
				//一个 observer 只可能对应一个作用域，所以要 break
				if (observer.compareContext(notifyContext)) {
					observers.splice(i, 1);
					break;
				}
			}
			if (observers.length <= 0) {
				remove(wee);
			}
		}
	}
	
	/**
	 * <p><b>注意：如果此命令类不存在，WeeMVC 会发出<code>WeemvcError.NOTIFICATION_NOT_FOUND</code>警告。</b></p>
	 * @copy	org.weemvc.as2.core.INotifier#sendWee()
	 */
	public function sendWee(wee:Object, data):Void {
		var newWee:Object = Util.getProto(wee);
		var observers:Array;
		var observer:IObserver;
		if (hasExists(newWee)) {
			//取回当前通知的 list
			observers = retrieve(newWee);
			//
			for (var i:Number = 0; i < observers.length; i++) {
				observer = observers[i];
				observer.notifyObserver(newWee, data);
			}
		}else {
			PaperLogger.getInstance().log(WeemvcError.NOTIFICATION_NOT_FOUND, "Notifier", [newWee]);
		}
	}
}