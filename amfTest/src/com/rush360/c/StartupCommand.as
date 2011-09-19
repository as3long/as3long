/**
 * 程序初始化命令
 * ibio-develop
 * 2009-10-21 18:46
 */
package com.rush360.c {
	//导入MVC的命令类包
	import com.rush360.v.VLogin;
	import org.weemvc.as3.control.ICommand;
	import org.weemvc.as3.control.SimpleCommand;
	
	import flash.display.MovieClip;
	
	public class StartupCommand extends SimpleCommand implements ICommand {
		
		public override function execute(data:Object = null):void {
			viewLocator.initialize(data as MovieClip);
			addViews();
			addModels();
			addCommands();
		}
		
		protected function addViews():void {
			viewLocator.addView(VLogin, "loginView");
		}
		
		protected function addModels():void {
			//modelLocator.addModel(DataProxy);	
		}
		
		protected function addCommands():void {
			controller.addCommand(ShowFirstCommand);
		}
	}
}