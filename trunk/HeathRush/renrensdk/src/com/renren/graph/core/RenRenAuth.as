package com.renren.graph.core {
	
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONParseError;
	import com.renren.graph.conf.AppConfig;
	import com.renren.graph.conf.RenRenConfig;
	import com.renren.graph.data.RenRenSession;
	import com.renren.graph.net.RenRenRequest;
	
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	import flash.net.URLVariables;
	import flash.system.Security;
	
	public class RenRenAuth {

		private var session:RenRenSession;
		
		private var localConnection:LocalConnection;
		
		private var callback:Function;
		
		public function RenRenAuth(callback:Function) {
			session = new RenRenSession();
			this.callback = callback;
		}
		
		//弹出验证窗口
		public function auth(scope:String):void {
			var localConnectionId:String = openLocalConnection();
			var params:URLVariables = new URLVariables();
			params.client_id = AppConfig.API_KEY;
			params.response_type = "token";
			params.redirect_uri = escape(AppConfig.REDIRECT_URI + 
				"?local_connection=" + localConnectionId + 
				"&callback_method=handleAccessTokenLoad");
			if(scope != null && scope != "") {
				params.scope = scope;
			}
			var url:String = RenRenConfig.OAUTH_AUTH_URL + "?" + params.toString();
			
			if(ExternalInterface.available) {
				ExternalInterface.call("window.open", url,'newwindow','height=420,width=500,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no, z-look=yes, alwaysRaised=yes');
			}
		}
		
		//用于传递access_token的回调函数
		/*如果验证过程正确
		access_token
		expires_in
		如果验证过程发生了错误，返回对象的结构为
		error: login_denied
		error_uri: http://graph.renren.com/errorpage?error=login_denied&error_description=The+end-user+denied+logon.
		error_description: The end-user denied logon.
		*/
		public function handleAccessTokenLoad(result:Object):void {
			closeLocalConnection();
			if(result.error != null) {
				callback(false, {error:"auth_error", error_code:result.error, error_message:result.error_description});
			} else {
				session.accessToken = result["access_token"];
				session.expiresIn = result["expires_in"];
				session.scope = result["scope"];
				loadSessionKey();
			}
		}
		
		public function loadSessionKey():void {
			var request:RenRenRequest = new RenRenRequest();
			Security.loadPolicyFile(RenRenConfig.API_SESSION_KEY_POLICY_FILE_URL);
			request.send(RenRenConfig.API_SESSION_KEY_URL, {oauth_token:session.accessToken}, handleSessionKeyLoad);
		}
		
		private function handleSessionKeyLoad(request:RenRenRequest):void {
			if(request.success) {
				try {
					var data:Object = JSON.decode(request.data as String);
					if(data.error != null) {
						callback(false, {error:"auth_error", error_code:data.error, error_message:data.error_description});
					} else {
						session.sessionKey = data["renren_token"]["session_key"];
						session.sessionSecret =data["renren_token"]["session_secret"];
						session.userId = data["user"]["id"];
						callback(true, session);
					}
				} catch(e:JSONParseError) {
					callback(false, {error:"json_decode_error", error_message:e.text});
				}
			} else {
				callback(false, request.data);
			}
		}
		
		private function openLocalConnection():String {
			var localConnectionId:String =  "_" + AppConfig.API_KEY + Math.round(Math.random() * 1000000);
			localConnection = new LocalConnection();
			localConnection.client = this;
			localConnection.connect(localConnectionId);
			localConnection.allowDomain("*");
			return localConnectionId;
		}
		
		private function closeLocalConnection():void {
			try {
				localConnection.close();
			} catch (e:*) { }
			
			localConnection = null;
		}
	}
}