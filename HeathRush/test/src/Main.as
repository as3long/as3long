package 
{
	//import com.rush360.manger.BlogManger;
	import com.rush360.manger.GameManger;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.rush360.manger.XiaoNeiManger;
	/**
	 * ...
	 * @author 黄龙
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
			//GameManger.getThis()._stage = stage;
			//addChild(GameManger.getThis());
			//GameManger.getThis().init();
			//addChild(BlogManger.instance);
			addChild(XiaoNeiManger.instance);
			XiaoNeiManger.instance.textField.width = stage.stageWidth;
			XiaoNeiManger.instance.textField.height = stage.stageHeight;
		}
		
	}
	
}