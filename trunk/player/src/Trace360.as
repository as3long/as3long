package  
{
	/**
	 * ...
	 * @author 360rush
	 */
	import flash.external.ExternalInterface;
	public class Trace360 
	{
		
		public function Trace360() 
		{
			
		}
		
		public static function myTrace(...arg):void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.call("console.log", arg);
			}
			else
			{
				trace(arg);
			}
		}
	}

}