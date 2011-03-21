package com.webBase.event 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author WZH(shch8.com)
	 */
	public class ScorllEvent extends Event 
	{
		private var _hei:Number;
		private var _wid:Number;
		public function ScorllEvent(type:String,wid:Number,hei:Number) 
		{ 
			super(type);
			_hei = hei;
			_wid = wid;
			
		} 
		public function get width():Number
		{
			return _wid;
		}
		public function get height():Number
		{
			return _hei;
		}
	}
	
}