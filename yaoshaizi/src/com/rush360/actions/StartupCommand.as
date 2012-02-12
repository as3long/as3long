package com.rush360.actions 
{
	import com.rush360.Main;
	import com.rush360.models.*;
	import com.rush360.tool.CheckString;
	import com.rush360.views.*;
	import com.rush360.actions.*;
	import org.weemvc.as3.control.ICommand;
	import org.weemvc.as3.control.SimpleCommand;
	
	/**
	 * 程序初始化命令
	 * 注册所有的命令、模型、视图
	 * @author huanglong
	 */
	public class StartupCommand extends SimpleCommand implements ICommand 
	{
		
		public function StartupCommand() 
		{
			
		}
		
		public override function execute(data:Object = null):void {
			viewLocator.initialize(data as Main);
			addViews();
			addModels();
			addCommands();
			CheckString.getInstance().init();
		}
		
		protected function addViews():void {
			viewLocator.addView(MainView);
			viewLocator.addView(CharView);
			viewLocator.addView(SprakCharView);
			//viewLocator.addView(BigImagePlayer, "mc_bigImagePlayer");
			//viewLocator.addView(ThumbList, "mc_thumbList");
		}
		
		protected function addModels():void {
			modelLocator.addModel(CharModel);
			//modelLocator.addModel(FindLightModel);
			//modelLocator.addModel(LoadDataModel);
		}
		
		protected function addCommands():void {
			//controller.addCommand();
			controller.addCommand(ProxyGetData);
			controller.executeCommand(ProxyGetData);
			controller.addCommand(ProxySendData);
			controller.addCommand(SpeakCharCommand);
		}
	}

}