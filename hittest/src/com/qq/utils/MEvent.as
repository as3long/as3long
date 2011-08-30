package com.qq.utils
{
	import flash.events.Event;

	public class MEvent extends Event
	{
		public function MEvent(type:String, data:Object = null, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			mData = data;
		}
		
		public function get data():Object { return mData; }

		private var mData:Object;
	}
}
