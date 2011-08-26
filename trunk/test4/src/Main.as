package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;

	/**
	 * ...
	 * @author 360rush
	 */
	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite 
	{
		private var loader:URLLoader;
		private var traceTxt:TextField;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			traceTxt = new TextField();
			traceTxt.width = 800;
			traceTxt.height = 600;
			addChild(traceTxt);
			traceTxt.text = "正在加载...";
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, load_ok);
			loader.load(new URLRequest("http://www.360rush.com"));
		}
		
		private function load_ok(e:Event):void 
		{
			traceTxt.text = loader.data;
		}

	}

}