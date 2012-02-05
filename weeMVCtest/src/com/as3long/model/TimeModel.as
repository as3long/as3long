package com.as3long.model 
{
	import com.as3long.event.TimeEvent;
	import org.weemvc.as3.model.Model;
	
	/**
	 * ...
	 * @author huanglong
	 */
	public class TimeModel extends Model 
	{
		private var _time:String='10:27:15'
		public function TimeModel() 
		{
			
		}
		
		public function get time():String 
		{
			return _time;
		}
		
		public function set time(value:String):void 
		{
			_time = value;
			sendWee(TimeEvent.TIME_CHANGE, _time);
		}
	}

}