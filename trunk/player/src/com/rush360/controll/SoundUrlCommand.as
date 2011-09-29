package com.rush360.controll 
{
	import com.rush360.model.SoundModel;
	import org.weemvc.as3.control.SimpleCommand;
	
	/**
	 * ...
	 * @author 360rush
	 */
	public class SoundUrlCommand extends SimpleCommand 
	{
		
		public function SoundUrlCommand() 
		{
			
		}
		
		override public function execute(data:Object = null):void 
		{
			var model:SoundModel = modelLocator.getModel(SoundModel);
			model.sendData(String(data));
		}
		
	}

}