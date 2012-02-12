/**
 * WeeMVC - Copyright(c) 2008
 * Weemvc map
 * Controller、ModelLocator、ViewLocator、Notifier 都继承此类
 * @author	weemve.org
 * 2008-12-14 16:39
 */
package org.weemvc.as3.core {
	import flash.utils.Dictionary;
	
	/**
	 * 字典类。用来保存类似 key-value 键值对的引用。
	 * 
	 * <p>
	 * Controller、ModelLocator、ViewLocator、Notifier 都继承此类。
	 * </p>
	 * 
	 * @see org.weemvc.as3.control.Controller	Controller
	 * @see org.weemvc.as3.core.Notifier		Notifier
	 * @see org.weemvc.as3.model.ModelLocator	ModelLocator
	 * @see org.weemvc.as3.view.ViewLocator		ViewLocator
	 */
	public class WeemvcLocator {
		/** @private **/
		protected var m_weeMap:Dictionary = new Dictionary();
		
		/**
		 * 添加一个新的键值对。
		 * 
		 * @param	key		键
		 * @param	value	值
		 */
		protected function add(key:Object, value:*):void {
			m_weeMap[key] = value;
		}
		
		/**
		 * 移除指定的键值对。
		 * 
		 * @param	key		键
		 */
		protected function remove(key:Object):void {
			if (hasExists(key)){
				delete m_weeMap[key];
			}
		}
		
		/**
		 * 获取指定的键值对。
		 * 
		 * @param	key		键
		 * @return			根据键返回相应的值
		 */
		protected function retrieve(key:Object):* {
			return m_weeMap[key];
		}
		
		/**
		 * 判断指定的键值对是否已经存在。
		 * 
		 * @param	key		键
		 * @return			是否存在
		 */
		protected function hasExists(key:Object):Boolean {
			return (m_weeMap[key] != undefined);
		}
	}
}