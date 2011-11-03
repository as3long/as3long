package 
{
	import org.flixel.FlxG;
	import org.flixel.FlxGame;
	
	/**
	 * ...
	 * @author zb
	 */
	
	[SWF(width = "640", height = "480", backgroundColor = "#000000")]
	public class FlixelGame extends FlxGame 
	{
		public function FlixelGame():void 
		{
			//参数1：游戏屏幕的原始宽度，参数2：游戏屏幕的原始高度
			//参数3：第一个游戏状态，也就是最初显示的画面。
			//参数4：缩放，将原始宽度高度缩放。
			super(640, 480, MenuState, 1);
			
			//想显示鼠标的话就用下面这句
			//FlxG.mouse.show();
		}
	}
	
}