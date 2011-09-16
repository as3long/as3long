/**
 * WeeMVC - Copyright(c) 2008
 * 视图集合类
 * @author	weemve.org
 * 2009-1-5 14:06
 */
package org.weemvc.as3.view {
	import org.weemvc.as3.core.WeemvcLocator;
	import org.weemvc.as3.core.Notifier;
	import org.weemvc.as3.core.INotifier;
	import org.weemvc.as3.core.Observer;
	import org.weemvc.as3.core.IObserver;
	import org.weemvc.as3.WeemvcError;
	import org.weemvc.as3.PaperLogger;
	
	import flash.display.Sprite;
	/**
	 * 视图集合类。
	 * 
	 * <p>
	 * 保存所有的视图类。通过它,你可以找到你想要的视图。
	 * </p>
	 * 
	 * @see org.weemvc.as3.view.IViewLocator	IViewLocator
	 */
	public class ViewLocator extends WeemvcLocator implements IViewLocator {
		/** @private **/
		static private var m_instance:ViewLocator = null;
		/** @private **/
		protected var m_main:Sprite;
		/** @private **/
		protected var m_notifier:INotifier = Notifier.getInstance();
		
		/**
		 * 视图集合类构造函数。
		 * 
		 * @throws org.weemvc.as3.WeemvcError 单件的<code>ViewLocator</code>被实例化多次
		 */
		public function ViewLocator() {
			if (m_instance) {
				throw new WeemvcError(WeemvcError.SINGLETON_VIEW_MSG, ViewLocator);
			}else {
				m_instance = this;
			}
		}
		
		/**
		 * 返回视图集合类的实例，若没有创建则创建，若已创建，则返回该实例。
		 * 
		 * @return	当前的视图集合类实例。
		 */
		static public function getInstance():IViewLocator {
			if (!m_instance) {
				m_instance = new ViewLocator();
			}
			return m_instance;
		}
		
		/**
		 * 视图初始化，将显示对象（root）实例传递给 WeeMVC。
		 * 
		 * @param	main	根显示对象（root）的引用
		 */
		public function initialize(main:Sprite):void {
			m_main = main;
		}
		
		/**
		 * <p><b>注意：如果此视图类不存在，WeeMVC 会发出<code>WeemvcError.VIEW_NOT_FOUND</code>警告。</b></p>
		 * @copy	org.weemvc.as3.view.IViewLocator#getView()
		 */
		public function getView(viewClass:Class):* {
			if (!hasView(viewClass)) {
				PaperLogger.getInstance().log(WeemvcError.VIEW_NOT_FOUND, ViewLocator, viewClass);
			}
			return retrieve(viewClass);
		}
		
		/**
		 * <p><b>注意：如果要添加视图类已经添加，WeeMVC 会发出<code>WeemvcError.ADD_VIEW_MSG</code>警告。</b></p>
		 * @copy	org.weemvc.as3.view.IViewLocator#addView()
		 */
		public function addView(viewClass:Class, stageInstance:String = null):void {
			var container:Sprite;
			var viewInstance:IView;
			var notifications:Array;
			var oberver:IObserver;
			if (!hasView(viewClass)) {
				container = getContainer(m_main, stageInstance);
				viewInstance = new viewClass(container);
				notifications = viewInstance.getWeeList();
				if (notifications.length > 0) {
					for (var i:uint = 0; i < notifications.length; i++) {
						oberver = new Observer(viewInstance.onDataChanged, viewInstance);
						/**
						 * 如果当前的“WeeMVC事件”不是命令类，则添加到视图的通知列表
						 * 此操作意在过滤掉所有 view 对命令类型“WeeMVC事件”的侦听
						 */
						if (notifications[i] is String) {
							m_notifier.addObserver(notifications[i], oberver);
						}
					}
				}
				add(viewClass, viewInstance);
			}else {
				PaperLogger.getInstance().log(WeemvcError.ADD_VIEW_MSG, ViewLocator, viewClass);
			}
		}
		
		/**
		 * @copy	org.weemvc.as3.view.IViewLocator#hasView()
		 */
		public function hasView(viewClass:Class):Boolean {
			return hasExists(viewClass);
		}
		
		/**
		 * <p><b>注意：如果要添加视图类已经添加，WeeMVC 会发出<code>WeemvcError.VIEW_NOT_FOUND</code>警告。</b></p>
		 * @copy	org.weemvc.as3.view.IViewLocator#removeView()
		 */
		public function removeView(viewClass:Class):void {
			if (hasView(viewClass)) {
				var viewInstance:IView = getView(viewClass);
				if (viewInstance) {
					var notifications:Array = viewInstance.getWeeList();
					//移除该视图里面所有的通知
					for ( var i:Number = 0; i < notifications.length; i++ ) {
						m_notifier.removeObserver(notifications[i], viewInstance);
					}
				}
				remove(viewClass);
			}else {
				PaperLogger.getInstance().log(WeemvcError.VIEW_NOT_FOUND, ViewLocator, viewClass);
			}
		}
		
		/** @private **/
		//递归获得舞台上相应的显示对象
		protected function getContainer(main:Sprite, param:String):Sprite {
			var container:Sprite = main;
			var reg:RegExp = /[\w]+/ig;
			var temp:Array;
			if (!param) {
				return container;
			}
			temp = param.match(reg);
			if (temp && (temp.length > 0)) {
				for (var i:uint = 0; i < temp.length; i++) {
					if (!container[temp[i]]) {
						throw new WeemvcError(WeemvcError.CHILD_NOT_FOUND, ViewLocator, getFullPath(container) + " 容器内的 " +  temp[i]);
					}else {
						container = container[temp[i]];
					}
				}
			}
			return container;
		}
		
		/** @private **/
		protected function getFullPath(data:Sprite):String {
			var path:String = data.name;
			while (data.stage && (data.parent != data.stage)) {
				data = data.parent as Sprite;
				path = data.name + "." + path;
			}
			return path;
		}
	}
}