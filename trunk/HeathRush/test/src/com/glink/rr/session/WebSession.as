/*
  Copyright (c) 2010, Global Link Software Technology Centre
  All rights reserved.

  Redistribution and use in source and binary forms, with or without 
  modification, are permitted provided that the following conditions are
  met:

  * Redistributions of source code must retain the above copyright notice, 
    this list of conditions and the following disclaimer.
  
  * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the 
    documentation and/or other materials provided with the distribution.
  
  * Neither the name of Global Link Software Technology Centre nor the names of its 
    contributors may be used to endorse or promote products derived from 
    this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package com.glink.rr.session
{
	import com.glink.rr.RenRenCall;
	import com.glink.rr.delegates.IRenRenCallDelegate;
	import com.glink.rr.delegates.WebDelegate;
	import com.glink.rr.events.RenRenEvent;
	import com.glink.rr.renren_internal;
	
	import flash.events.EventDispatcher;

	public class WebSession extends EventDispatcher implements IRenRenSession
	{
		public static const REST_URL:String = "http://api.xiaonei.com/restserver.do";
		public static const VIDEO_URL:String = "http://api-video.xiaonei.com/restserver.do";
		
		/** @private */
		protected var _apiKey:String; 
		
		/** @private */
		protected var _secret:String;
		/** @private */
		protected var _sessionKey:String;
		/** @private */
		renren_internal var _uid:String;
		/** @private */
		protected var _expires:Date;
		/** @private */
		protected var _apiVersion:String = "1.0";
		/** @private */
		protected var _connected:Boolean = false;
		/** @private */
		protected var _restUrl:String = REST_URL;
		
		/**
		 * The URL of the login page a user will be directed to (for desktop applications)
		 * The default will work fine but you can set it to something else.
		 */
		public var loginUrl:String = "http://www.xiaonei.com/PLogin.do";
		
		public function WebSession(apiKey:String, ss:String, sessionKey:String = null)
		{
			super();
			
			this._apiKey = apiKey;
			this._sessionKey = sessionKey;
			this.secret = ss;
		}
		
		public function get connected():Boolean
		{
			return _connected;
		}
		
		public function get waitingForLogin():Boolean
		{
			return false;
		}
		
		/** 
		 * Your application's API key.
		 */
		public function get apiKey():String
		{
			return _apiKey;
		}
		
		/**
		 * Your application's secret. If you call the WebSession constructor
		 * manually, you must use your application's secret. However, RenRen 
		 * recommends that you use a more secure technique that involves a session
		 * secret. To use a session secret, use the RenRenSessionUtil
		 * class to create your web session.
		 */
		public function get secret():String
		{
			return _secret;
		}
		
		public function set secret(value:String):void
		{
			_secret = value;
		}
		
		/**
		 * The URL of the REST server that you will be using.
		 * The default value is "http://api.xiaonei.com/restserver.do".
		 */
		public function get restUrl():String
		{
			return _restUrl;
		}
		
		public function set restUrl(value:String):void
		{
			_restUrl = value;
		}
		
		public function get sessionKey():String
		{
			return _sessionKey;
		}
		
		public function set sessionKey(value:String):void
		{
			_sessionKey = value;
		}
		
		public function get expires():Date
		{
			return _expires;
		}
		
		public function set expires(value:Date):void
		{
			_expires = value;
		}
		
		public function get uid():String
		{
			return renren_internal::_uid;
		}
		
		public function get apiVersion():String
		{
			return _apiVersion;
		}
		
		public function verifySession():void
		{
			if (_sessionKey) {
				_connected = true;
				dispatchEvent(new RenRenEvent(RenRenEvent.CONNECT, false, false, true));
			} else {
				_connected = false;
				dispatchEvent(new RenRenEvent(RenRenEvent.CONNECT, false, false, false));
			}
		}
		
		public function login(offlineAccess:Boolean):void
		{
			//Theres no need to call login here, since the user is alredy in renren.
			//You should pop a dialog or something similar to notify the user they're not logged into renren.
			//Maybe we want to direct the user to login.php here?
		}
		
		public function refreshSession():void
		{
			//Theres no need to call login here (since the user is already logged into renren);
		}
		
		public function post(call:RenRenCall):IRenRenCallDelegate
		{
			restUrl = REST_URL; //reset the rest_url to default. (video uses a different one);
			
			
			return new WebDelegate(call, this); 
			
		}
		
	}
}