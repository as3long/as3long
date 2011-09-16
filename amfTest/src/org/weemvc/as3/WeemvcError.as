/**
 * WeeMVC - Copyright(c) 2008
 * 错误处理
 * @author	weemve.org
 * 2009-1-9 14:31
 */
package org.weemvc.as3 {
	import org.weemvc.as3.Version;
	
	import flash.utils.getQualifiedClassName;
	
	/**
	 * WeeMVC 错误信息和警告信息。
	 * 
	 * <p>
	 * 此类主要记录因 WeeMVC 而引起的错误和警告。
	 * </p>
	 * <p>错误：</p>
	 * <ul>
	 * <li>多次实例化单件类</li>
	 * </ul>
	 * <p>警告：</p>
	 * <ul>
	 * <li>重复添加已添加过的命令类、视图类、模型类</li>
	 * <li>重复删除已删除过的命令类、视图类、模型类</li>
	 * <li>使用未添加的命令类、视图类、模型类</li>
	 * </ul>
	 * 
	 * @see org.weemvc.as3.model.ModelLocator	Controller
	 * @see org.weemvc.as3.view.ViewLocator		ViewLocator
	 * @see org.weemvc.as3.control.Controller	Controller
	 * @see org.weemvc.as3.core.Notifier		Notifier
	 */
	public class WeemvcError extends Error {
		/** WeeMVC 错误 **/
		public static const SINGLETON_CONTROLLER_MSG:String = "单件模式的 Controller 已经创建！";
		/** WeeMVC 错误 **/
		public static const SINGLETON_MODEL_MSG:String = "单件模式的 ModelLocator 已经创建！";
		/** WeeMVC 错误 **/
		public static const SINGLETON_VIEW_MSG:String = "单件模式的 ViewLocator 已经创建！";
		/** WeeMVC 错误 **/
		public static const SINGLETON_NOTIFIER_MSG:String = "单件模式的 Notifier 已经创建！";
		/** WeeMVC 错误 **/
		public static const SINGLETON_PAPERLOGGER_MSG:String = "单件模式的 PaperLogger 已经创建！";
		/** WeeMVC 警告 **/
		public static const ADD_COMMAND_MSG:String = "已经添加过此 Command：";
		/** WeeMVC 警告 **/
		public static const ADD_MODEL_MSG:String = "已经添加过此 Model：";
		/** WeeMVC 警告 **/
		public static const ADD_VIEW_MSG:String = "已经添加过此 View：";
		/** WeeMVC 警告 **/
		public static const COMMAND_NOT_FOUND:String = "没有找到此 Command：";
		/** WeeMVC 警告 **/
		public static const MODEL_NOT_FOUND:String = "没有找到此 Model：";
		/** WeeMVC 警告 **/
		public static const VIEW_NOT_FOUND:String = "没有找到此 View：";
		/** WeeMVC 警告 **/
		public static const CHILD_NOT_FOUND:String = "没有找到此显示对象：";
		/** WeeMVC 警告 **/
		public static const NOTIFICATION_NOT_FOUND:String = "没有找到此 Notification：";
		
		/**
		 * 错误信息类构造函数。
		 * 
		 * @param	errorMsg		错误信息
		 * @param	currentClass	发生此错误所在的类
		 * @param	... rest		其他的任何信息
		 */
		public function WeemvcError(errorMsg:String, currentClass:Class = null, ... rest){
			super(formatMessage("WeeMVC Error# ", errorMsg, currentClass, rest));
		}
		
		/**
		 * 格式化信息。
		 * 
		 * @param	type			信息类型。错误（Error）/警告（Warning）
		 * @param	info			信息
		 * @param	currentClass	所在的类
		 * @param	... rest		其他的任何信息
		 * @return					格式化之后的字符串
		 */
		public static function formatMessage(type:String, info:String, currentClass:Class, ... rest):String {
			var message:String = "WeeMVC 当前版本：" + Version.VERSION + "  最后更新：" + Version.LAST_UPDATE + "\n";
			if (currentClass) {
				var className:String = getQualifiedClassName(currentClass);
				message += type + "在 [" + className + "] 中，" + info + rest.toString();
			}else {
				message += type + info + rest.toString();
			}
			return message;
		}
	}
}