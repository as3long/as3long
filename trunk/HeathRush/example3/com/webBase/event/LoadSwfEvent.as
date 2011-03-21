package com.webBase.event 
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	/**
	 * SWF加载事件
	 * @author WZH(shch8.com)
	 * 
	 */
	public class LoadSwfEvent extends Event 
	{
		/**
		 * 正在加载触发事件
		 */
		public static var PROGRESS:String = "progress";
		/**
		 * 加载出错
		 */
		public static var ERROR:String = "error";
		private var _progressEvent:ProgressEvent
		/**
		 * 使用指定参数创建新的 LoadSwfEvent 对象。 
		 * @param	type 事件类型；该值指示引发事件的动作。
		 * @param   progressEvent
		 */
		public function LoadSwfEvent(type:String,progressEvent:ProgressEvent=null) 
		{ 
			super(type);
			_progressEvent = progressEvent;
			
		} 
		/**
		 * 当前已经加载完成的值
		 */
		public function get bytesLoaded():Number{
			return _progressEvent.bytesLoaded;
			}
		/**
		 * 需要加载的文件总大小
		 */
		public function get bytesTotal():Number{
			return _progressEvent.bytesTotal;
			}
		/*取百加载百分数，四舍五入到小数点后两位*/
		public function get bytesPct():Number{
			return Math.round((_progressEvent.bytesLoaded/_progressEvent.bytesTotal)*10000)/100;
			}
		
	}
	
}