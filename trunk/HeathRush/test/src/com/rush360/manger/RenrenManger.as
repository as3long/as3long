package com.rush360.manger 
{
	import com.glink.rr.commands.friends.GetFriends;
	import com.glink.rr.commands.users.GetInfo;
	import com.glink.rr.data.friends.GetData;
	import com.glink.rr.data.friends.GetFriendsData;
	import com.glink.rr.data.users.GetInfoData;
	import com.glink.rr.errors.RenRenError;
	import com.glink.rr.events.RenRenEvent;
	import com.glink.rr.RenRen;
	import com.glink.rr.RenRenCall;
	import com.glink.rr.utils.RenRenSessionUtil;
	import com.rush360.model.UserModel;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.text.TextField;
	import ui.Human;
	
	/**
	 * ...
	 * @author 黄龙
	 */
	public class RenrenManger extends Sprite
	{
		private var apiKey:String = "759e5af9a0d74d058be43f2c5be09828";
		private var secretKey:String = "ed8209a3ae7a43f2ab3a159879bc9686";
		public var sessionKey:String = "2.bf3329fec7b5518a79b4edb8101f6bc4.3600.1300978800-233171457";
		private var uid:String = "233171457";
		private var webSession:RenRenSessionUtil;
		public var stageObj:Stage;
		public var ren_ren:RenRen;
		private var call:RenRenCall;
		private var textField:TextField;
		
		public function RenrenManger() 
		{
		}
		
		public function init():void
		{
			textField = new TextField();
			textField.multiline = true;
			textField.wordWrap = true;
			textField.text = "1233";
			textField.y = 300;
			textField.width = stageObj.stageWidth;
			textField.height = stageObj.stageHeight;
			addChild(textField);
			webSession = new RenRenSessionUtil(apiKey, secretKey, stageObj.loaderInfo);
			ren_ren = webSession.ren_ren;
			//ren_ren.login(true);
			login_success(null);
			//ren_ren.addEventListener(RenRenEvent.CONNECT, );
		}
			
		private function error(e:RenRenEvent):void 
		{
			textField.appendText("\n" + e.data);	
		}
		
		private function onComplete(e:RenRenEvent):void 
		{
			call.removeEventListener(RenRenEvent.COMPLETE, onComplete);
			textField.appendText("\n" + e.data);
			UserModel.instance.userDetail = (e.data as GetInfoData).userCollection.source[0];
			var human:Human = new Human();
			human._name.text = UserModel.instance.userDetail.name;
			human._image.source = UserModel.instance.userDetail.headurl;
			human.y = 100;
			this.addChild(human);
			call = new GetFriends(sessionKey);
			call.addEventListener(RenRenEvent.COMPLETE, get_friend);
			ren_ren.post(call);
			//trace(e.data);
		}
		
		private function get_friend(e:RenRenEvent):void 
		{
			trace(e);
			if (e.data)
			{
				textField.appendText("\n" + e.data);
				UserModel.instance.friendDetail = (e.data as GetFriendsData).friends.source;
				var length:int = UserModel.instance.friendDetail.length;
				for (var i:int = 0; i < length; i++)
				{
					var human:Human = new Human();
					human._name.text = UserModel.instance.friendDetail[i].name;
					human._image.source = UserModel.instance.friendDetail[i].headurl;
					human.y = 220+120*Math.floor(i/8);
					human.x = int(i%8) * 100;
					this.addChild(human);
				}
			}
			else
			{
				textField.appendText("\n" + (e.error as RenRenError).rawResult);
			}
		}
		
		private function login_success(e:Event):void 
		{
			//ren_ren.sessionKey = e.data;
			call = new GetInfo([uid],null);
			//call.addEventListener(RenRenEvent.ERROR, error);
			call.addEventListener(RenRenEvent.COMPLETE, onComplete);
			ren_ren.post(call);
			//trace(e.data);
		}
		
		/**
		 * 单例引用
		 */
		public static function get instance():RenrenManger
		{
			if(_instance == null)
			{
				_instance = new RenrenManger();
			}
			return _instance;
		}
		
		private static var _instance:RenrenManger = null;
	}
}