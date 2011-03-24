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
	import com.glink.rr.commands.auth.CreateToken;
	import com.glink.rr.commands.auth.GetSession;
	import com.glink.rr.commands.users.GetLoggedInUser;
	import com.glink.rr.data.StringResultData;
	import com.glink.rr.data.auth.GetSessionData;
	import com.glink.rr.delegates.DesktopDelegate;
	import com.glink.rr.delegates.IRenRenCallDelegate;
	import com.glink.rr.errors.RenRenError;
	import com.glink.rr.events.RenRenEvent;
	import com.glink.rr.renren_internal;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class DesktopSession extends WebSession implements IRenRenSession
	{
		protected var _authToken:String;
		protected var _waitingForLogin:Boolean = false;
		protected var loginRequest:IRenRenCallDelegate;
		
		protected var _offlineAccess:Boolean = false;
		
		public function DesktopSession(apiKey:String, ss:String = null, sessionKey:String=null)
		{
			super(apiKey, null);
			this._connected = false;
			this._secret = ss;
			
			if (sessionKey) {
				this._sessionKey = sessionKey;
			}
		}
		
		override public function verifySession():void {
			if (_sessionKey) {
				var call:RenRenCall = new GetLoggedInUser();
				call.session = this;
				call.renren_internal::initialize();
				call.addEventListener(RenRenEvent.COMPLETE, onVerifyLogin, false, 0, true);
				post(call);
				dispatchEvent(new RenRenEvent(RenRenEvent.VERIFYING_SESSION));
			} else {
				_connected = false;
				dispatchEvent(new RenRenEvent(RenRenEvent.CONNECT));
			}
		}
		
		protected function onVerifyLogin(event:RenRenEvent):void {
			var successEvent:RenRenEvent = new RenRenEvent(RenRenEvent.CONNECT);
			successEvent.success = event.success;
			if (event.success) {
				renren_internal::_uid = (event.data as StringResultData).value;
				successEvent.data = event.data;
				_connected = true;
			} else {
				successEvent.error = event.error;
				_connected = false;
			}
			dispatchEvent(successEvent);
		}
		
		override public function login(offlineAccess:Boolean):void {
			_offlineAccess = offlineAccess;
			
			_sessionKey = null;
			
			var getSession:RenRenCall = new CreateToken();
			getSession.session = this;
			getSession.renren_internal::initialize();
			getSession.addEventListener(RenRenEvent.COMPLETE, onLogin);
			post(getSession);
		}
		
		override public function get waitingForLogin():Boolean { return _waitingForLogin; }
		
		override public function post(call:RenRenCall):IRenRenCallDelegate {
			restUrl = REST_URL; //reset the rest_url to default
			

			return new DesktopDelegate(call, this); 

		}
		
		protected function onLogin(event:RenRenEvent):void {
			event.target.removeEventListener(RenRenEvent.COMPLETE, onLogin);
			
			if (event.success) {
				_authToken = (event.data as StringResultData).value;
				refreshSession();
//				//now that we have an auth_token we need the user to login with it
//				var request:URLRequest = new URLRequest();
//				var loginParams:String = '?';
//				
//				if (_offlineAccess) {
//					loginParams += 'ext_perm=offline_access&';
//				}
//				
//				request.url = loginUrl+loginParams+"api_key="+apiKey+"&v="+apiVersion+"&auth_token="+_authToken;
//				
//				navigateToURL(request, "_blank");
//				
//				_waitingForLogin = true;
//				dispatchEvent(new RenRenEvent(RenRenEvent.WAITING_FOR_LOGIN));
			} else {
				onConnectionError(event.error);
			}
		}
		
		override public function refreshSession():void {
			_waitingForLogin = false;
			
			//validate the session
			var call:GetSession = new GetSession(_authToken);
			call.session = this;
			call.renren_internal::initialize();
			call.addEventListener(RenRenEvent.COMPLETE, validateSessionReply);
			
			post(call);
		}
		
		protected function validateSessionReply(event:RenRenEvent):void {
			if (event.success) {
				var result:GetSessionData = event.data as GetSessionData;
				renren_internal::_uid = result.uid;
				this._sessionKey = result.session_key;
				this._expires = result.expires;
				
				// Change Serect Key (if a new one exists).
				this._secret = result.secret == null || result.secret == ''?this._secret:result.secret;
				_connected = true;
				
				dispatchEvent(new RenRenEvent(RenRenEvent.CONNECT, false, false, true, result));
			} else {
				onConnectionError(event.error);
			}
		}
		
		protected function onConnectionError(error:RenRenError):void {
			_connected = false;
			dispatchEvent(new RenRenEvent(RenRenEvent.CONNECT, false, false, false, null, error));
		}
		
	}
}