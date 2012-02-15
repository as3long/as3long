package com.rush360.actions 
{
	import com.rush360.models.CharModel;
	import com.rush360.tool.CheckString;
	import org.weemvc.as3.control.IController;
	import org.weemvc.as3.view.IViewLocator;
	import org.weemvc.as3.control.ICommand;
	import org.weemvc.as3.control.SimpleCommand;
	import org.weemvc.as3.model.IModelLocator;
	
	/**
	 * ...
	 * @author huanglong
	 */
	public class SpeakCharCommand extends SimpleCommand implements ICommand 
	{
		public function SpeakCharCommand() 
		{
			
		}
		
		public override function execute(data:Object = null):void 
		{
			//trace(data);
			var str:String = String(data);
			str = CheckString.getInstance().check(str);
			if (str.search(' ')!=-1)
			{
				var  re:RegExp = new RegExp();
				re.source = '\d+ ';
				var s1:String = str.match()[0];
				re.source = ' \d';
				var s2:String = str.match()[0]
				
				trace(str);
			}
			sendWee(ProxySendData, str);
			(modelLocator.getModel(CharModel) as CharModel).addString("我:" + str);
		}
		
	}

}