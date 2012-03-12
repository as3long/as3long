package com.rush360.events 
{
	import com.rush360.i.IRushEvent;
	/**
	 * ...
	 * @author 360rush
	 */
	public class RushEvent implements IRushEvent
	{
		
		public static const TIME_GETTIME:String = "Time.getTime";
		private var _name:String = "Time.getTime";
		public function RushEvent()
		{
			
		}
		
		public function get name():String 
		{
			return _name;
		}
	}

}