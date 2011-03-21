package com.webBase.event 
{
	import com.webBase.parts.ChildFile;
	import flash.events.Event;
	
	/**
	 * 参数传送事件
	 * @author WZH(shch8.com)
	 * 
	 */
	public class ParamEvent extends Event 
	{
		private var _param:ChildFile;
		public static var GET_PARAM:String = "getParam";//子页加载参数事件
		/**
		 * 参数传送事件
		 * @param	type	事件类型；该值指示引发事件的动作。 
		 * @param	param	获取的子页对象
		 */
		public function ParamEvent(type:String,param:ChildFile) 
		{ 
			super(type);
			_param=param
		} 
		public function get param():ChildFile {
			return _param;
			}
		
	}
	
}