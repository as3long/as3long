package com.webBase.event 
{
	import flash.events.Event;
	
	/**
	 * IE页面滚动事件，支持中国常用的浏览器
	 * @author WZH(shch8.com)
	 */
	public class PageScrollEvent extends Event 
	{
		/**
		 * 滚动事件
		 */
		public static var SCROLL:String = "scroll";
		private var _top:Number;
		private var _left:Number;
		/**
		 * 使用指定参数创建新的 PageScrollEvent 对象。 
		 * @param	type	事件的类型
		 * @param	__left	滚动条顶部距离
		 * @param	__top	滚动条左边距离
		 */
		public function PageScrollEvent(type:String,__left:Number=0, __top:Number=0) 
		{ 
			super(type);
			_top = __top;
			_left = __left;
		} 
		/**
		 * 滚动条顶部距离
		 */
		public function get top():Number {
			return _top;
			}
		/**
		 * 滚动条左边距离
		 */
		public function get left():Number {
			return _left;
			}
		
	}
	
}