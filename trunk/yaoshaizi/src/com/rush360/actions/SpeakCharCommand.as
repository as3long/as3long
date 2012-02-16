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
		private var  re:RegExp =  /\d+/g;
		private var checkReg:RegExp =/\d+ \d/g;
		private var arr:Array 
		public function SpeakCharCommand() 
		{
			
		}
		
		public override function execute(data:Object = null):void 
		{
			//trace(data);
			var str:String = String(data);
			str = CheckString.getInstance().check(str);
			/*if (str.search(' ')!=-1)
			{
<<<<<<< .mine
				if (checkReg.test(str))
				{
					arr = str.match(re);
					var len:int = arr.length;
					//trace(str.match(re));
					//trace(re.exec(str));
					str = '^&Num' + arr[0] + '^&Point' + arr[1];
					(modelLocator.getModel(CharModel) as CharModel).addString("我:" + arr[0] + '个' + arr[1] + '点');
					sendWee(ProxySendData, str);
				}
=======
				var  re:RegExp = new RegExp();
				//re.source = '\d+ ';
				var s1:String = str.match()[0];
				//re.source = ' \d';
				var s2:String = str.match()[0]
				
				trace(str);
>>>>>>> .r122
			}*/
			else
			{
				sendWee(ProxySendData, str);
				(modelLocator.getModel(CharModel) as CharModel).addString("我:" + str);
			}
		}
		
	}

}