package com.webBase.event 
{
	import flash.events.Event;
	
	/**
	 * 菜单事件
	 * @author WZH(shch8.com)
	 */
	public class MenuEvent extends Event 
	{
		/**
		 * 使用installMenu()安装菜单后，安装完成事件
		 */
		public static var INIT:String = "init";
		/**
		 * 使用指定参数创建新的 MenuEvent 对象。 
		 * @param	type 事件类型；该值指示引发事件的动作。
		 * @param	bubbles 确定 Event 对象是否参与事件流的冒泡阶段。 默认值为 false。
		 * @param	cancelable 确定是否可以取消 Event 对象。 默认值为 false
		 */
		public function MenuEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
	}
	
}