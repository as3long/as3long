package com.as3long.actions 
{
	import com.as3long.event.FindLightEvent;
	import com.as3long.model.FindLightModel;
	import org.weemvc.as3.control.IController;
	import org.weemvc.as3.PaperLogger;
	import org.weemvc.as3.view.IViewLocator;
	import org.weemvc.as3.control.ICommand;
	import org.weemvc.as3.control.SimpleCommand;
	import org.weemvc.as3.model.IModelLocator;
	
	/**
	 * 找亮点控制器
	 * @author huanglong
	 */
	public class FindLightCommand extends SimpleCommand implements ICommand 
	{
		
		public function FindLightCommand() 
		{
			
		}
		
		override public function execute(data:Object = null):void 
		{
			var findLightModel:FindLightModel = modelLocator.getModel(FindLightModel);
			if (data == FindLightEvent.REMOVE_ALLLIGHT)
			{
				findLightModel.removeAllLight();
			}
			else
			{
				//trace('控制器', data.toString());
				findLightModel.addLight(data.x, data.y, data.width, data.height);
			}
		}
		
	}

}