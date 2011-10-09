package 
{
	import com.rush360.ui.Player;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.weemvc.as3.control.Controller;
	import com.rush360.controll.StartupCommand;
	/**
	 * ...
	 * @author 360rush
	 */
	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite 
	{
		public var _mainMc:MovieClip;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			_mainMc = new Player();
			addChild(_mainMc);
			var parm:Object = root.loaderInfo.parameters;
			var url:String = root.loaderInfo.parameters["url"];
			var sname:String = root.loaderInfo.parameters["sname"];
			//_mainMc._mcSongName._txtName.text = sname + "___";
			//Trace360.myTrace(parm);
			//trace(url);
			if (url == null || url == "")
			{
				url = "http://ohmyrock.net/wp-content/uploads/2011/06/Moves%20Like%20Jagger%20OHMYROCK.NET.mp3";
				sname = "这是一首测试歌曲";
			}
			
			_mainMc._mcSongName._abcurl = url;
			_mainMc._mcSongName._abcSname = sname;
			Controller.getInstance().addCommand(StartupCommand);
			Controller.getInstance().executeCommand(StartupCommand, _mainMc);
		}

	}

}