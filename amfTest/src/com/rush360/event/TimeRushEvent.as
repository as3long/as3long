package com.rush360.event 
{
	import com.rush360.i.IRushEvent;
	
	/**
	 * ...
	 * @author 360rush
	 */
	public class TimeRushEvent implements IRushEvent 
	{
		private var _name:String;= "Time.getTime";
		public function TimeRushEvent() 
		{
			
		}
		
		/* INTERFACE com.rush360.i.IRushEvent */
		
		public function get name():String 
		{
			return _name;
		}
	}

}