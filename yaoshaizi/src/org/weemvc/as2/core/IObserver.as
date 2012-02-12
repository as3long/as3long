/**
 * WeeMVC - Copyright(c) 2008
 * 观察者接口
 * @author	weemve.org
 * 2009-5-11 19:19
 */

/**
 * 观察者类接口。
 * 
 * <p>
 * WeeMVC 的观察者。
 * </p>
 * 
 * @see org.weemvc.as2.core.Observer	Observer
 */
interface org.weemvc.as2.core.IObserver {
	
	/**
	 * 设置此观察者的回调函数。
	 */
	function setCallBack(method:Function):Void;
	
	/**
	 * 获取此观察者的回调函数。
	 */
	function getCallBack():Function;
	
	/**
	 * 设置此观察者的作用域。
	 */
	function setContext(obj:Object):Void;
	
	/**
	 * 获取此观察者的作用域。
	 */
	function getContext():Object;
	
	/**
	 * 执行通知。call回调函数，并且传递参数。
	 * 
	 * @param	wee		事件（命令类/在<code>View</code>的 getWeeList() 列表中的事件名称）
	 * @param	data	传递的参数
	 * <b>注意：因为传递的参数可以是任何类型，且如果为 Object 的话，则找不回原来的类型。所以这里不指定参数类型。</b>
	 */
	function notifyObserver(wee:Object, data):Void;
	
	/**
	 * 比较函数域是否为当前传递进来的一致。
	 * 
	 * @param	object	一个函数域
	 * @return 			是否一致
	 */
	function compareContext(object:Object):Boolean;
}