/**
 * WeeMVC - Copyright(c) 2008
 * 保存注册的视图类
 * 通过它,你可以找到你想要的视图
 * @author	weemve.org
 * 2009-1-11 23:47
 */
import org.weemvc.as2.Util;
import org.weemvc.as2.core.WeemvcLocator;
import org.weemvc.as2.core.Notifier;
import org.weemvc.as2.core.INotifier;
import org.weemvc.as2.core.Observer;
import org.weemvc.as2.core.IObserver;
import org.weemvc.as2.control.Controller;
import org.weemvc.as2.view.IViewLocator;
import org.weemvc.as2.view.IView;
import org.weemvc.as2.WeemvcError;
import org.weemvc.as2.PaperLogger;

/**
 * 视图集合类。
 * 
 * <p>
 * 保存所有的视图类。通过它,你可以找到你想要的视图。
 * </p>
 * 
 * @see org.weemvc.as2.view.IViewLocator	IViewLocator
 */
class org.weemvc.as2.view.ViewLocator extends WeemvcLocator implements IViewLocator {
	/** @private **/
	static private var m_instance:IViewLocator = null;
	/** @private **/
	private var m_main:MovieClip;
	/** @private **/
	private var m_notifier:INotifier;
	
	/**
	 * 视图集合类构造函数。
	 * 
	 * @throws org.weemvc.as2.WeemvcError 单件的<code>ViewLocator</code>被实例化多次
	 */
	public function ViewLocator() {
		if (m_instance) {
			throw new WeemvcError(WeemvcError.SINGLETON_VIEW_MSG, "ViewLocator");
		}else {
			m_instance = this;
			m_weeMap = {};
			m_notifier = Notifier.getInstance();
		}
	}
	
	/**
	 * 返回视图集合类的实例，若没有创建则创建，若已创建，则返回该实例。
	 * 
	 * @return	当前的视图集合类实例。
	 */
	static public function getInstance():IViewLocator{
		if(!m_instance){
			m_instance = new ViewLocator();
		}
		return m_instance;
	}
	
	/**
	 * 这里是构造所有的 view 的地方
	 * <b>注意不要直接在本类（ViewLocator）里使用 main 以及 main 里的实例</b>
	 * 应该使用每个 view 的句柄
	 * @param	stage	舞台（root）的引用
	 */
	public function initialize(main:MovieClip):Void {
		m_main = main;
	}
	
	/**
	 * <p><b>注意：如果此视图类不存在，WeeMVC 会发出<code>WeemvcError.VIEW_NOT_FOUND</code>警告。</b></p>
	 * @copy	org.weemvc.as2.view.IViewLocator#getView()
	 */
	public function getView(viewClass:Object) {
		var viewName:Object = Util.getProto(viewClass);
		if (!hasView(viewName)) {
			PaperLogger.getInstance().log(WeemvcError.VIEW_NOT_FOUND, "ViewLocator", [viewName]);
		}
		return retrieve(viewName);
	}
	
	/**
	 * <p><b>注意：如果要添加视图类已经添加，WeeMVC 会发出<code>WeemvcError.ADD_VIEW_MSG</code>警告。</b></p>
	 * @copy	org.weemvc.as2.view.IViewLocator#addView()
	 */
	public function addView(viewClass:Object, stageInstance:String):Void {
		var viewName:Object = Util.getProto(viewClass);
		var container:MovieClip;
		var viewInstance:IView;
		var notifications:Array;
		var oberver:IObserver;
		if (!hasExists(viewName)) {
			container = getContainer(m_main, stageInstance);
			viewInstance = new viewClass(container);
			notifications = viewInstance.getWeeList();
			if (notifications.length > 0) {
				for (var i:Number = 0; i < notifications.length; i++) {
					oberver = new Observer(viewInstance.onDataChanged, viewInstance);
					/**
					 * 如果当前的“WeeMVC事件”不是命令类，则添加到视图的通知列表
					 * 此操作意在过滤掉所有 view 对命令类型“WeeMVC事件”的侦听
					 */
					if (typeof(notifications[i]) == "string") {
						m_notifier.addObserver(notifications[i], oberver);
					}
				}
			}
			add(viewName, viewInstance);
		}else {
			PaperLogger.getInstance().log(WeemvcError.ADD_VIEW_MSG, "ViewLocator", [viewName]);
		}
	}
	
	/**
	 * @copy	org.weemvc.as2.view.IViewLocator#hasView()
	 */
	public function hasView(viewClass:Object):Boolean {
		var viewName:Object = Util.getProto(viewClass);
		return hasExists(viewName);
	}
	
	/**
	 * <p><b>注意：如果要添加视图类已经添加，WeeMVC 会发出<code>WeemvcError.VIEW_NOT_FOUND</code>警告。</b></p>
	 * @copy	org.weemvc.as2.view.IViewLocator#removeView()
	 */
	public function removeView(viewClass:Object):Void {
		var viewName:Object = Util.getProto(viewClass);
		var viewInstance:IView;
		var notifications:Array;
		if (hasExists(viewName)) {
			viewInstance = getView(viewName);
			if (viewInstance) {
				notifications = viewInstance.getWeeList();
				//移除该视图里面所有的通知
				for ( var i:Number = 0; i < notifications.length; i++ ) {
					m_notifier.removeObserver(notifications[i], viewInstance);
				}
			}
			remove(viewName);
		}else {
			PaperLogger.getInstance().log(WeemvcError.VIEW_NOT_FOUND, "ViewLocator", [viewName]);
		}
	}
	
	/** @private **/
	//递归获得舞台上相应的 MC
	private function getContainer(main:MovieClip, param:String):MovieClip {
		var container:MovieClip = main;
		var temp:Array;
		if (!param) {
			return container;
		}
		temp = param.split(".");
		if (temp && (temp.length > 0)) {
			for (var i:Number = 0; i < temp.length; i++) {
				if (!container[temp[i]]) {
					throw new WeemvcError(WeemvcError.MC_NOT_FOUND, "ViewLocator", [getFullPath(container) + " 容器内的 " +  temp[i]]);
				}else {
					container = container[temp[i]];
				}
			}
		}
		return container;
	}
	
	/** @private **/
	private function getFullPath(data:MovieClip):String {
		var path:String = data._name;
		while (m_main && (data._parent != m_main)) {
			data = MovieClip(data._parent);
			path = data._name + "." + path;
		}
		return path;
	}
}