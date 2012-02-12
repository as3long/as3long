/**
 * WeeMVC - Copyright(c) 2008
 * 观察者
 * @author	weemve.org
 * 2009-5-11 19:01
 */
import org.weemvc.as2.core.IObserver;

/**
 * 观察者类。
 * 
 * <p>
 * WeeMVC 的事件通知都是采用观察者模式实现的。
 * </p>
 * 
 * @see org.weemvc.as2.core.IObserver		IObserver
 */
class org.weemvc.as2.core.Observer implements IObserver {
	/** @private **/
	private var m_callBack:Function;
	/** @private **/
	private var m_context:Object;
	
	/**
	 * 观察者类构造函数。
	 * 
	 * @param	notifyMethod	发生WeeMVC事件时的回调函数
	 * @param	notifyContext	当前观察者的作用域
	 */
	public function Observer(notifyMethod:Function, notifyContext:Object) {
		m_callBack = notifyMethod;
		m_context = notifyContext;
	}
	
	/**
	 * 设置此观察者的回调函数。
	 */
	public function setCallBack(method:Function):Void {
		m_callBack = method;
	}
	
	/**
	 * 获取此观察者的回调函数。
	 */
	public function getCallBack():Function {
		return m_callBack;
	}
	
	/**
	 * 设置此观察者的作用域。
	 */
	public function setContext(obj:Object):Void {
		m_context = obj;
	}
	
	/**
	 * 获取此观察者的作用域。
	 */
	public function getContext():Object {
		return m_context;
	}
	
	/**
	 * @copy	org.weemvc.as2.core.IObserver#notifyObserver()
	 */
	public function notifyObserver(wee:Object, data):Void {
		m_callBack.call(m_context, wee, data);
	}
	
	/**
	 * @copy	org.weemvc.as2.core.IObserver#compareContext()
	 */
	public function compareContext(object:Object):Boolean {
		return (m_context === object);
	}
}