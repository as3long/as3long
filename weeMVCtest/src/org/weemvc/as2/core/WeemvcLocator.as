/**
 * WeeMVC - Copyright(c) 2008
 * Weemvc map
 * Controller、ModelLocator、ViewLocator、Notifier 都继承此类
 * @author	weemve.org
 * 2008-12-14 16:39
 */

/**
 * 字典类。用来保存类似 key-value 键值对的引用。
 * 
 * <p>
 * Controller、ModelLocator、ViewLocator、Notifier 都继承此类。
 * </p>
 * 
 * @see org.weemvc.as2.control.Controller	Controller
 * @see org.weemvc.as2.core.Notifier		Notifier
 * @see org.weemvc.as2.model.ModelLocator	ModelLocator
 * @see org.weemvc.as2.view.ViewLocator		ViewLocator
 */
class org.weemvc.as2.core.WeemvcLocator {
	/** @private **/
	private var m_weeMap:Object = {};
	
	/**
	 * 添加一个新的键值对。
	 * 
	 * @param	key		键
	 * @param	value	值
	 * @internal		因为这里 value 需要保存任何值，所以没有指定
	 * 变量类型，而在 AS3 中是可以指定 * 的
	 */
	private function add(key:Object, value):Void {
		m_weeMap[key] = value;
	}
	
	/**
	 * 移除指定的键值对。
	 * 
	 * @param	key		键
	 */
	private function remove(key:Object):Void {
		if (hasExists(key)){
			delete m_weeMap[key];
		}
	}
	
	/**
	 * 获取指定的键值对。
	 * 
	 * @param	key		键
	 * @return			根据键返回相应的值，这里没有指定类型是为了方便返回的实例直接使用
	 */
	private function retrieve(key:Object) {
		return m_weeMap[key];
	}
	
	/**
	 * 判断指定的键值对是否已经存在。
	 * 
	 * @param	key		键
	 * @return			是否存在
	 */
	private function hasExists(key:Object):Boolean {
		return (m_weeMap[key] != undefined);
	}
}
