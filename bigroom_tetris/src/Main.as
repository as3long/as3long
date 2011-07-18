package 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 黄龙
	 */
	public class Main extends Sprite 
	{
		public var spr:Sprite = new Sprite();
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			sprInit();
		}
		
		public function sprInit():void
		{
			var _graphice:Graphics = spr.graphics;
			_graphice.beginFill(0xFF0000);
			_graphice.drawEllipse(50, 50, 60, 60);
			_graphice.endFill();
			addChild(spr);
			//stage.focus = spr;
		}
	}
	
}