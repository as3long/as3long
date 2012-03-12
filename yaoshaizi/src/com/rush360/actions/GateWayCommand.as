package com.rush360.actions 
{
	import com.rush360.net.RushRemoting;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import ghostcat.operation.server.RemoteOper;
	import ghostcat.operation.server.RemotingProxy;
	import org.weemvc.as3.control.SimpleCommand;
	
	/**
	 * 网关
	 * @author huanglong
	 */
	public class GateWayCommand extends SimpleCommand 
	{
		private var remotingProxy:RemotingProxy;
		public function GateWayCommand() 
		{
			
		}
		
		override public function execute(data:Object = null):void 
		{
			super.execute(data);
			//remotingProxy = new RemotingProxy('http://spfangwei.sinaapp.com/amfphp/','ExampleService');
			//remotingProxy.operate('returnOneParam',[123], getGroupListOK, getGroupListErr);
		}
		
		private function getGroupListErr(e:Event):void 
		{
			trace(e);
		}
		
		private function getGroupListOK(e:Event):void 
		{
			trace(e);
		}
		
	}

}