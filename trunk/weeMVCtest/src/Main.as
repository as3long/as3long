package
{
	import com.as3long.actions.StartupCommand;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.weemvc.as3.control.Controller;
	
	/**
	 * 程序入口
	 * @author huanglong
	 */
	[Frame(factoryClass="Preloader")]
	
	public class Main extends MovieClip
	{
		
		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			run();
		}
		
		private function run():void
		{
			Controller.getInstance().addCommand(StartupCommand);
			Controller.getInstance().executeCommand(StartupCommand,this);
		}
	}

}