package com.as3long.actions 
{
	import com.as3long.actions.TimeCommand;
	import com.as3long.model.FindLightModel;
	import com.as3long.model.LoadDataModel;
	import com.as3long.model.TimeModel;
	import com.as3long.view.FindLightView;
	import com.as3long.view.TimeView;
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
		}
		
		protected function addViews():void {
			viewLocator.addView(FindLightView);
			//viewLocator.addView(BigImagePlayer, "mc_bigImagePlayer");
			//viewLocator.addView(ThumbList, "mc_thumbList");
		}
		
		protected function addModels():void {
			modelLocator.addModel(FindLightModel);
			modelLocator.addModel(LoadDataModel);
		}
		
		protected function addCommands():void {
			controller.addCommand(FindLightCommand);
			controller.addCommand(LoadDataCommand);
			controller.executeCommand(LoadDataCommand);
			//controller.executeCommand(FindLightCommand);
			//controller.addCommand(ShowImageCommand);
		}
	}

}