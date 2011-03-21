package com.webBase.event 
{
	import flash.events.Event;
	
	/**
	 * 子文件事件，用于被加载的子SWF之中，更换栏目时，触发播放结束动画和清除自身垃圾。
	 * 等结束动画播放完成后，你再执行removeMe()方法来通知父级移除自己去加载新的页面。
	 * @author WZH(shch8.com)
	 * 
	 */
	public class ChildEvent extends Event 
	{
		/**
		 * 开始播放结束动画
		 */
		public static var END_PLAY:String = "endPlay";
		/**
		 * 移除时,先清除自身垃极
		 */
		public static var CLEAR:String = "clear";
		/**
		 * 使用指定参数创建新的 ChildEvent 对象。 
		 * @param	type 事件类型；该值指示引发事件的动作。 
		 */
		public function ChildEvent(type:String) 
		{ 
			super(type);
			
		} 
	}
	
}