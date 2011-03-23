package com.rush360.manger 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import laan.xiaonei.*
	import flash.utils.*;
	import laan.smart.utils.JSONParser;
	/**
	 * ...
	 * @author 黄龙
	 */
	public class XiaoNeiManger extends Sprite
	{
		private var apiKey:String = "759e5af9a0d74d058be43f2c5be09828";
		private var secretKey:String = "ed8209a3ae7a43f2ab3a159879bc9686";
		private var uid:String = "233171457";
		public var api:XiaoNeiAPI;
		
		public var textField:TextField;
		
		public function XiaoNeiManger() 
		{
			textField = new TextField();
			textField.multiline = true;
			textField.wordWrap = true;
			textField.text = "1233";
			this.addChild(textField);
			api = new XiaoNeiAPI(apiKey, secretKey);//两个参数你在校内申请开发后会得到
			api.addEventListener(XiaoNeiAPIEvent.API_READY, apiReadyHandler);
			api.toLogin();
			api.getAllocation(callHandler);
		}
		
		private function callHandler(obj:Object):void {
			textField.appendText("\n"+JSONParser.encode(obj));
		}
		
		private function apiReadyHandler(event:Event):void {
			//api.initAPI(uid,api.session);
			/*if (event.target.session)
			{
				api.initAPI(uid,event.target.session);
			}
			trace(event)*/
			textField.appendText("\napi成功");
				
			api.getUserDetail(callHandler, uid);
			//api.getAppUsers(callHandler, true)
			//api.getSession(callHandler);
			//api.getAppUsers(callHandler, true)
			//trace("成功");
			//api.getSession(getSession);
			
		}
		
		/**
		 * 单例引用
		 */
		public static function get instance():XiaoNeiManger
		{
			if(_instance == null)
			{
				_instance = new XiaoNeiManger();
			}
			return _instance;
		}
		
		private static var _instance:XiaoNeiManger = null;
	}

}