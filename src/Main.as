package 
{
	import flash.display.*;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	/**
	 * ...
	 * @author huanglong
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
		}
		
		private function as3Socketjs_init():void
		{
			//设置对齐的方式
			stage.align = StageAlign.TOP;
			//设置flash的缩放模式
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			ExternalInterface.addCallback(
		}
	}
	
}