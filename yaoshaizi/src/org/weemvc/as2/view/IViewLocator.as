/**
 * WeeMVC - Copyright(c) 2008
 * 视图集合类的接口
 * @author	weemve.org
 * 2009-5-11 17:50
 */

 /**
 * 视图集合类接口。
 * 
 * <p>
 * 通过它,你可以找到你想要的视图。
 * </p>
 * 
 * @see org.weemvc.as2.view.ViewLocator	ViewLocator
 */
interface org.weemvc.as2.view.IViewLocator {
	/**
	 * 初始化舞台，将舞台 MovieClip（root）实例传递给 WeeMVC。
	 * 
	 * @param	main	舞台（root）的引用
	 */
	function initialize(mc:MovieClip):Void;
	/**
	 * 获得指定的视图类。
	 * 
	 * @param	viewClass	指定要获得的视图类名，都要实现<code>IView</code>接口
	 * @return				当前的视图类实例
	 */
	function getView(viewClass:Object);
	/**
	 * 添加视图类。
	 * 
	 * @param	viewClass		要添加的视图类名
	 * @param	viewClass		要添加的视图类，都要实现<code>IView</code>接口
	 * @param	stageInstance	当前的视图构造函数的参数（当前在舞台上对应的实例名）
	 */
	function addView(viewClass:Object, stageInstance:String):Void;
	/**
	 * 移除视图类。
	 * 
	 * @param	viewClass	要移除的视图类名，都要实现<code>IView</code>接口
	 */
	function removeView(viewClass:Object):Void;
	/**
	 * 判断当前视图类是否存在。
	 * 
	 * @param	viewClass	指定的视图类名，都要实现<code>IView</code>接口
	 * @return				是否存在
	 */
	function hasView(viewClass:Object):Boolean;
}