package 
{
	import com.rush360.manage.MManage;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	
	/**
	 * ...
	 * @author zb
	 */
	public class MenuState extends FlxState 
	{
		//这里是嵌入的图片资源，基本上flixel的资源都这么做吧。
		//对于flash来开发的话，其实这么做也行了。
		[Embed(source='media/title.png')]
		protected var menuImg:Class;
		public function MenuState():void 
		{
			//这里别写了
		}
		
		//重写create方法，相当于构造方法
		//但是注意，对于所有的 State，最好用重写该方法来进行初始化
		override public function create():void 
		{
			//这里加入了一个 sprite，并且使用菜单图片
			//FlxSprite的参数
			//参数1：该sprite的X坐标
			//参数2：该sprite的Y坐标
			//参数3：该sprite的背景图片的类
			add(new FlxSprite(0, 0, menuImg));
		}
		
		//update，画面更新渲染的方法，类似于Enter_Frame时调用的方法
		//一些控制操作也是放在这里进行的,比如按键
		override public function update():void 
		{
			//这里使用了按下 X 键，然后转跳到 下一个 状态
			if (FlxG.keys.justPressed('X')) 
			{
				//转跳是这么做的，Gamestate 就是我们的游戏状态了
				//FlxG 提供了一些该引擎的游戏控制方面的方法，可以看看API查看具体功能
				FlxG.state = MManage.instance.gameState;
				MManage.instance.gameStartTime = new Date();
			}
			super.update();
		}
	}
	
}