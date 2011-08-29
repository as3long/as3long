package  
{
	import com.rush360.manger.PukeManger;
	import flash.display.Sprite;
	import uk.co.bigroom.utils.ObjectPool;
	
	/**
	 * ...
	 * @author 黄龙
	 */
	public class PukeMain extends Sprite
	{
		public var pukeSprite:Sprite;
		public var anniuSpritr:Sprite;
		public function PukeMain() 
		{
			
			pukeSprite = ObjectPool.getObject(Sprite);
			addChild(pukeSprite);
			
			anniuSpritr = ObjectPool.getObject(Sprite);
			addChild(anniuSpritr);
			
			PukeManger.instance.mainSprite = this;
			PukeManger.instance.stageObj = stage;
			PukeManger.instance.puke_init();
		}
	}

}