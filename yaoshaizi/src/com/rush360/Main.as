package com.rush360
{
	import com.rush360.actions.StartupCommand;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import org.aswing.AsWingManager;
	import org.weemvc.as3.control.Controller;

	/**
	 * 程序入口
	 * @author huanglong
	 */
	[Frame(factoryClass="com.rush360.Preloader")]
	public class Main extends MovieClip 
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
			run();
		}
		
		private function run():void
		{
			AsWingManager.initAsStandard(this);
			Controller.getInstance().addCommand(StartupCommand)
			Controller.getInstance().executeCommand(StartupCommand, this);
		}
	}

}