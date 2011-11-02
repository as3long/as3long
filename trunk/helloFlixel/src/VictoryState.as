package 
{
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author zb
	 */
	public class VictoryState extends FlxState 
	{
		//胜利画面的等待时间计数
		private var _time:Number;
		override public function create():void 
		{
			_time = 0;
			//flash 这里是指，从某个颜色开始过度到透明
			//参数1：起初显示的颜色
			//参数2：过度的时间
			FlxG.flash.start(0xffffffff, 1);
			
			//添加一个文本
			add(new FlxText(100, 50, 100, 'Victory!'));
		}
		
		override public function update():void 
		{
			//elapsed，该值是指，每一帧所经过的时间
			_time += FlxG.elapsed;
			if (_time>5) 
			{
				//fade，是指从 透明 过度到 想要的颜色
				//参数1：想要过度的颜色
				//参数2：经过的时间
				//参数3：过度结束后，调用的方法
				FlxG.fade.start(0xffffffff, 1, onPlay);
			}
			super.update();
		}
		
		private function onPlay():void
		{
			//转跳到 GameState
			FlxG.state = new GameState;
		}
	}
	
}