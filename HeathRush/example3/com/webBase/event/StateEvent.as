package com.webBase.event 
{
	import flash.events.Event;
	
	/**
	 * <b>状态值处理事件</b><br>
	 * 为什么要使用状态值？<br>
	 * 比如，我们在产品展示中查看了一件商品，地址栏可以记录起来，如果你把这个地址发给朋友同样能够看到这个商品，
	 * <br>状态值的使用可以弥补单个SWF中无法实现历史记录与动态地址的问题，地址形式如:http://www.shch8.com/case/webbase/#/about-tag2
	 * <br>“-”后的tag2就是状态值，你可以使用多个状态值每次使用addState()可以新添加一个状态值，如果已经存在一样的状态值，将不再重复添加
	 * 
	 * @author WZH(shch8.com)
	 */
	public class StateEvent extends Event
	{
		/**
		 * 从地址栏获取状态值
		 */
		public static var GET_STATE:String = "getState";
		/**
		 * 使用了addState()方法添加状态值
		 */
		public static var ADD_STATE:String = "addState";
		/**
		 * 使用了delState()方法删除状态值
		 */
		public static var DEL_STATE:String = "delState";
		/**
		 * 使用了delState()方法删除状态值
		 */
		public static var CLEAR_STATE:String = "clearState";
		private var _states:Array;
		/**
		 * 使用指定参数创建新的 StateEvent 对象。
		 * @param	type		事件的类型
		 * @param	__states	所有状态值数组，每个值都是一个状态值字符D
		 */
		public function StateEvent(type:String,__states:Array=null)
		{
			super(type);
			_states = __states;
		}
		/**
		 * 状态值数组
		 */
		public function get states():Array {
			return _states;
			}
		
	}
	
}