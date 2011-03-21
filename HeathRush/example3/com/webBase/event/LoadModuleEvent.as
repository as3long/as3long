package com.webBase.event 
{
	import flash.display.Loader;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author wzh (shch8.com)
	 */
	public class LoadModuleEvent extends Event 
	{
		public static var COMPLETE:String = "complete";
		private var _target:Loader
		public function LoadModuleEvent(type:String,__target:Loader=null) 
		{ 
			super(type);
			_target = __target;
		} 
		public function get content():Loader { return _target; }
	}
	
}