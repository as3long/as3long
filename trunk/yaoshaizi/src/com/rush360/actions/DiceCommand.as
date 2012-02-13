package com.rush360.actions 
{
	import com.rush360.models.DiceModel;
	import org.weemvc.as3.control.ICommand;
	import org.weemvc.as3.control.SimpleCommand;
	
	/**
	 * 骰子控制器
	 * @author huanglong
	 */
	public class DiceCommand extends SimpleCommand implements ICommand 
	{
		
		public function DiceCommand() 
		{
			
		}
		
		override public function execute(data:Object = null):void 
		{
			super.execute(data);
			var arr:Array = new Array();
			for (var i:int = 0; i < 6; i++)
			{
				arr.push(Math.ceil(Math.random() * 6));
			}
			(modelLocator.getModel(DiceModel) as DiceModel).numArr = arr;
		}
	}

}