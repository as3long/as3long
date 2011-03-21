package com.webBase.event 
{
	import flash.events.Event;
	
	/**
	 * 页面调整事件，发布后，由根级对象接收触发<br>
	 * 请把这个事件当作Event.RESIZE事件来用，会比官方的事件更精确、更敏感
	 * @author WZH(shch8.com)
	 * 
	 */
	public class PageSizeEvent extends Event 
	{
		/**
		 * 页面改变了大小
		 */
		public static var RESIZE:String = "reSize";
		private var _height:Number;
		private var _width:Number;
		/**
		 * 使用指定参数创建新的 PageSizeEvent 对象。
		 * @param	type	事件的类型
		 * @param	_wid	宽度
		 * @param	_hei	高度
		 * @param	bubbles	确定 Event 对象是否参与事件流的冒泡阶段。 默认值为 false。
		 * @param	cancelable 确定是否可以取消 Event 对象。 默认值为 false
		 */
		public function PageSizeEvent(type:String,_wid:Number=0, _hei:Number=0,bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type);
			_height = _hei;
			_width = _wid;
		} 
		/**
		 * 页面高
		 */
		public function get height():Number {
			return _height;
			}
		/**
		 * 页面宽
		 */
		public function get width():Number {
			return _width;
			}
	}
	
}