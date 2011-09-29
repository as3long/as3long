/**
 * 程序初始化命令
 * ibio-develop
 * 2009-10-21 18:46
 */
package com.rush360.controll {
	//导入MVC的命令类包
	import com.rush360.model.SoundModel;
	import com.rush360.view.McBtnView;
	import com.rush360.view.McSongNameView;
	import flash.utils.setTimeout;
	import org.weemvc.as3.control.ICommand;
	import org.weemvc.as3.control.SimpleCommand;
	
	import flash.display.MovieClip;
	
	public class StartupCommand extends SimpleCommand implements ICommand {
		
		public override function execute(data:Object = null):void {
			viewLocator.initialize(data as MovieClip);
			addViews();
			addModels();
			addCommands();
			//controller.executeCommand(SoundUrlCommand);
		}
		
		protected function addViews():void {
			viewLocator.addView(McBtnView, "_mcBtn");
			viewLocator.addView(McSongNameView, "_mcSongName");
		}
		
		protected function addModels():void {
			//modelLocator.addModel(SoundModel);	
		}
		
		protected function addCommands():void {
			controller.addCommand(SoundCommand);
			//controller.addCommand(SoundUrlCommand);
		}
	}
}