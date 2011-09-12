package 
{
	import com.rush360.event.RushEvent;
	import com.rush360.net.RushRemoting;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 360rush
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			RushRemoting.i.baseUrl = "http://360rushgame.sinaapp.com/Amfphp/";
			RushRemoting.i.gateway(RushEvent.TIME_GETTIME);
		}
		
	}
	
}