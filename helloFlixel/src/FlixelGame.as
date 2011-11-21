package 
{
	import com.abdulqabiz.net.HTTPURLLoader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.net.Socket;
	import flash.net.URLRequest;
	import flash.sampler.NewObjectSample;
	import flash.system.Security;
	import org.flixel.FlxG;
	import org.flixel.FlxGame;
	
	/**
	 * ...
	 * @author zb
	 */
	
	[SWF(width = "640", height = "480", backgroundColor = "#000000")]
	public class FlixelGame extends Sprite// extends FlxGame 
	{
		private var loader:HTTPURLLoader;
		private var socket:Socket;
		public function FlixelGame():void 
		{
			//参数1：游戏屏幕的原始宽度，参数2：游戏屏幕的原始高度
			//参数3：第一个游戏状态，也就是最初显示的画面。
			//参数4：缩放，将原始宽度高度缩放。
			//super(640, 480, MenuState, 1);
			
			//想显示鼠标的话就用下面这句
			//FlxG.mouse.show();
			socket = new Socket();
			socket.addEventListener( "connect" , onEvent , false , 0 );				
			socket.addEventListener( "close" , onEvent , false, 0 );
			socket.addEventListener( "ioError" , onEvent , false, 0 );
			socket.addEventListener( "securityError" , onEvent , false, 0 );
			socket.addEventListener( "socketData" , onEvent , false , 0 );
			socket.connect("127.0.0.1", 843);
			//socket.writeUTF("你好啊");
			//loader = new HTTPURLLoader();
			//loader.addEventListener(Event.COMPLETE, loader_ok);
			//loader.load(new URLRequest("http://74.91.19.133/"));
		}
		
		private function onEvent(e:Event):void 
		{
			trace(e.toString());
		}
		
		
		private function loader_ok(e:Event):void 
		{
			trace(loader.data);
		}
	}
	
}