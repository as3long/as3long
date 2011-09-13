package
{
	import com.rush360.event.RushEvent;
	import com.rush360.net.RushRemoting;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.rush360.proxy.ObjectProxy;
	
	/**
	 * ...
	 * @author 360rush
	 */
	public class Main extends Sprite
	{
		
		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			RushRemoting.i.baseUrl = "http://360rushgame.sinaapp.com/Amfphp/";
			RushRemoting.i.gateway(RushEvent.TIME_GETTIME);
			
			var o:Object = {};
			o.hi = function(name:*, age:*):void
			{
				trace('hi ', name, '!', age);
			}
			//
			var op:ObjectProxy = new ObjectProxy(o);
			var obj:Object = {y: 3};
			//
			op.bind(obj, 'x');
			op.bind(obj, 'y');
			op.bindFun(fun, 'hi');
			op.y = 4;
			op.hi('rod', 23);
			op.x = 2;
			trace(obj.y);
			trace(op.x);
			trace(obj.x);
		}
		
		public function fun(v:*, v1:*):void
		{
			trace('call==', v, v1);
		}
	
	}

}