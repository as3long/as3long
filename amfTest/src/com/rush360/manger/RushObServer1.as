package com.rush360.manger 
{
	import com.rush360.i.IobServer;
	
	/**
	 * ...
	 * @author 360rush
	 */
	public class RushObServer1 implements IobServer 
	{
		public var ob_name:String = "观察者1";
		public function RushObServer1() 
		{
			
		}
		
		/* INTERFACE com.rush360.i.IobServer */
		
		public function notify(msg:String):void 
		{
			trace(ob_name, msg);
		}
		
	}

}