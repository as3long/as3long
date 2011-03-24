package com.rush360.manger 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.text.TextField;
	import laan.xiaonei.*
	import flash.utils.*;
	import com.rush360.model.UserModel;
	import ui.Human;
	import laan.smart.utils.JSONParser;
	//import com.adobe.serialization.json.JSON;
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
		
		public var stageObj:Stage;
		
		public var textField:TextField;
		
		public var sessionKey:String;
		
		public function XiaoNeiManger() 
		{
			
		}
		
		public function init():void
		{
			textField = new TextField();
			textField.multiline = true;
			textField.wordWrap = true;
			textField.width = stageObj.stageWidth;
			textField.height = stageObj.stageHeight;
			textField.text = "1233";
			this.addChild(textField);
			api = new XiaoNeiAPI(apiKey, secretKey);//两个参数你在校内申请开发后会得到
			api.addEventListener(XiaoNeiAPIEvent.API_READY, apiReadyHandler);
			api.toLogin();
			//api.initAPI(uid, "2.bf3329fec7b5518a79b4edb8101f6bc4.3600.1300978800-233171457");
			api.getAllocation(get_Allocation);
		}
		
		private function get_FriendsDetail(obj:Array):void 
		{
			UserModel.instance.friendDetail = obj;
			var length:int = obj.length;
			for (var i:int = 0; i < length; i++)
			{
				var human:Human = new Human();
				human._name.text = obj[i].name;
				human._image.source = obj[i].headurl;
				human.y = 220+120*Math.floor(i/8);
				human.x = int(i%8) * 100;
				this.addChild(human);
			}
			api.sendFeed(send_feed,0, "测试", "这是一段测试数据");
		}
		
		private function send_feed(obj:Object):void 
		{
			callHandler(obj);
		}
		
		private function get_Allocation(obj:Object):void 
		{
			UserModel.instance.allocation = obj;
			callHandler(obj);
		}
		
		
		
		private function callHandler(obj:Object):void {
			textField.appendText("\n" + JSONParser.encode(obj));
		}
		
		private function apiReadyHandler(event:Event):void {
			//textField.appendText("\napi成功");
			api.removeEventListener(XiaoNeiAPIEvent.API_READY, apiReadyHandler);
			trace(api.session);
			sessionKey = api.session;
			dispatchEvent(new Event("sessionKey"));
			//api.getUserDetail(get_UserDetail, uid);
			//api.getFriendsDetail(get_FriendsDetail);
		}
		
		private function get_UserDetail(obj:Array):void 
		{
			UserModel.instance.userDetail = obj[0];
			var human:Human = new Human();
			human._name.text = UserModel.instance.userDetail.name;
			human._image.source = UserModel.instance.userDetail.headurl;
			human.y = 100;
			this.addChild(human);
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