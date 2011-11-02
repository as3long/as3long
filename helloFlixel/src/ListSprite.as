package  
{
	import flash.display.Sprite;
	import flash.text.TextField;
	/**
	 * ...
	 * @author 360rush
	 */
	public class ListSprite extends Sprite
	{
		private var user:TextField;
		private var useTime:TextField;
		private var say:TextField;
		public function ListSprite(data:Object) 
		{
			user = new TextField();
			user.height = 20;
			useTime = new TextField();
			useTime.height = 20;
			useTime.x = 100;
			say = new TextField();
			say.height = 20;
			say.width = 300;
			say.x = 200;
			addChild(user);
			addChild(useTime);
			addChild(say);
			user.text = data.guser;
			useTime.text = data.gusetime;
			say.text = data.gsay;
		}
		
	}

}