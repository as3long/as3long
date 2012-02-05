/**
 * WeeMVC - Copyright(c) 2008
 * 模型接口
 * @author	weemve.org
 * 2009-5-11 20:46
 */

/**
 * 模型类接口。
 * 
 * <p>
 * WeeMVC 的模型。
 * </p>
 * 
 * @see org.weemvc.as2.model.Model	Model
 */
interface org.weemvc.as2.model.IModel {
	
	/**
	 * @copy	org.weemvc.as2.core.INotifier#sendWee()
	 */
	function sendWee(wee:Object, data):Void;
}