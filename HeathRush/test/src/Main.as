package
{
	//import com.rush360.manger.BlogManger;
	import asunit.textui.ResultPrinter;
	import com.rush360.manger.GameManger;
	import com.rush360.manger.RenrenManger;
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
			//trace(213);
			//var sharedFie:ResultPrinter = SharedFileExample.PRINTER = new ResultPrinter(true, false);
			//sharedFie.width = 800;
			//sharedFie.height = 600;
			//addChild(sharedFie);
			//var exp:Example = new Example();
			//addChild(BlogManger.instance);
			//trace(int(1.9));
			//GameManger.getThis()._stage = stage;
			//addChild(GameManger.getThis());
			//GameManger.getThis().init();
			//XiaoNeiManger.instance.stageObj = stage;
			//XiaoNeiManger.instance.init();
			//addChild(XiaoNeiManger.instance);
			//XiaoNeiManger.instance.addEventListener("sessionKey", login_success);
			
		}
		
		private function login_success(e:Event):void 
		{
			RenrenManger.instance.sessionKey = XiaoNeiManger.instance.sessionKey;
			RenrenManger.instance.stageObj = stage;
			RenrenManger.instance.init();
			addChild(RenrenManger.instance);
		}
		
	}
	
}