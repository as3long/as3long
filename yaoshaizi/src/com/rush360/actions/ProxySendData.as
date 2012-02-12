package com.rush360.actions 
{
	import com.rush360.tool.GameDataProxy;
	import org.weemvc.as3.control.ICommand;
	import org.weemvc.as3.control.IController;
	import org.weemvc.as3.control.SimpleCommand;
	
	/**
	 * ...
	 * @author huanglong
	 */
	public class ProxySendData extends SimpleCommand implements ICommand 
	{
		
		public function ProxySendData() 
		{
			
		}
		
		public override function execute(data:Object = null):void 
		{
			trace('处理发送数据', data);
			GameDataProxy.getInstance().channel.sendMessageToAll(data);
		}
		
	}

}