/**
 * WeeMVC - Copyright(c) 2008
 * 视图集合类的接口
 * @author	weemve.org
 * 2009-5-11 17:50
 */
package org.weemvc.as3.view {
	import flash.display.Sprite;
	/**
	 * 视图集合类接口。
	 * 
	 * <p>
	 * 通过它,你可以找到你想要的视图。
	 * </p>
	 * 
	 * @see org.weemvc.as3.view.ViewLocator	ViewLocator
	 */
	public interface IViewLocator {
		/**
		 * 初始化舞台，将根显示对象（root）实例传递给 WeeMVC。
		 * 
		 * @param	main	舞台（root）的引用
		 */
		function initialize(main:Sprite):void;
		/**
		 * 获得指定的视图类。
		 * 
		 * @param	viewName	指定要获得的视图类，都要实现<code>IView</code>接口
		 * @return				当前的视图类实例
		 */
		function getView(viewName:Class):*;
		/**
		 * 添加视图类。
		 * 
		 * @param	viewName		要添加的视图类，都要实现<code>IView</code>接口
		 * @param	stageInstance	当前的视图构造函数的参数（当前在舞台上对应的实例名）
		 */
		function addView(viewName:Class, stageInstance:String = null):void;
		/**
		 * 移除视图类。
		 * 
		 * @param	viewName	要移除的视图类，都要实现<code>IView</code>接口
		 */
		function removeView(viewName:Class):void;
		/**
		 * 判断当前视图类是否存在。
		 * 
		 * @param	viewName	指定的视图类，都要实现<code>IView</code>接口
		 * @return				是否存在
		 */
		function hasView(viewName:Class):Boolean;
	}
}