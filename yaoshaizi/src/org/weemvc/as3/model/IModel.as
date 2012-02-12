/**
 * WeeMVC - Copyright(c) 2008
 * 模型接口
 * @author	weemve.org
 * 2009-5-11 20:46
 */
package org.weemvc.as3.model {
	
	/**
	 * 模型类接口。
	 * 
	 * <p>
	 * WeeMVC 的模型。
	 * </p>
	 * 
	 * @see org.weemvc.as3.model.Model	Model
	 */
	public interface IModel {
		
		/**
		 * @copy	org.weemvc.as3.core.INotifier#sendWee()
		 */
		function sendWee(wee:Object, data:Object = null):void;
	}
}