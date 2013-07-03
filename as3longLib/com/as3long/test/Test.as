package com.as3long.test 
{
	import com.as3long.operation.server.SocketProxy;
	import com.as3long.utils.*;
	import flash.display.*;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.net.*;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.utils.*;
	import ghostcat.debug.Debug;
	import ghostcat.debug.DebugPanel;
	import ghostcat.operation.server.HTTPOper;
	import ghostcat.operation.server.HttpServiceProxy;
	import ui.View;
	
	/**
	 * 测试类
	 * @author 黄龙
	 */
	public class Test extends Sprite 
	{
		private var view:View = new View();
		/*private var httpProxy:HttpServiceProxy = new HttpServiceProxy("");
		private var httpOper:HTTPOper;
		private var view:View = new View();
		private var socketProxy:SocketProxy = new SocketProxy('121.14.117.106', 9990);*/
		//private var socketProxy:SocketProxy = new SocketProxy('192.168.69.181',9990);
		public function Test() 
		{
			//trace(PinYinUtil.toPinyin('大盗二十八'));
			//addChild(view);
			//view.btn1.addEventListener(MouseEvent.CLICK, onClick);
			//trace(PinYinUtil.toLuoMa('大盗二十八'));
			//httpOper = httpProxy.operate("123.txt", "get", null, rHander);
			Security.allowDomain("*");
			new DebugPanel(stage)
			Debug.DEBUG = true;
			DebugPanel.instance.show();
			/*var byteArr:ByteArray = new ByteArray();
			byteArr.writeUTFBytes("username=");
			byteArr.writeMultiByte("黄龙", "utf8");
			//byteArr.writeUTFBytes("黄龙");
			byteArr.position = 0;
			trace(byteArr.readMultiByte(byteArr.length,"utf8"));
			byteArr.position = 0;
			socketProxy.operate(893,byteArr);*/
			
			AddJsCallBack.addCallBack("haha", haha);
			AddJsCallBack.addCallBack("haha1", haha);
			AddJsCallBack.addCallBack("haha2", haha);
			AddJsCallBack.addCallBack("haha3", haha);
			haha();
			
		}
		
		private function haha():void 
		{
			Debug.trace("haha");
		}
		
		
	}

}