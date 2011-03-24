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
package com.glink.rr
{
	import com.glink.rr.delegates.IRenRenCallDelegate;
	import com.glink.rr.events.RenRenEvent;
	import com.glink.rr.session.IRenRenSession;
	
	import flash.events.EventDispatcher;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	/**
	 * Top level class for the ActionScript 3.0 Client Library for RenRen Platform.
	 * The RenRen class provides access not only to information about the current 
	 * RenRen session, but also to session management methods, such as logging
	 * in, starting, posting commands, refreshing, and logging out of a session. 
	 * The RenRen class also provides access to application-level management
	 * methods that ask users for normal and extended permissions for your application.
	 */
	public class RenRen extends EventDispatcher {
		
		public var connectionErrorMessage:String;
		public var waitingForLogin:Boolean;
		/** @private */
		protected var _currentSession:IRenRenSession;
		
		public function RenRen():void { }
		
		//Setters / Getters
		/**
		 * Indicates whether the current session is active, and therefore connected to the RenRen server.
		 */
		public function get connected():Boolean  { return _currentSession ? this._currentSession.connected : false; }
		/**
		 * Your application's API key, which identifies your application on the RenRen platform.
		 */
		public function get apiKey():String  { return _currentSession ? this._currentSession.apiKey : null; }
		/**
		 * Your RenRen application secret, which RenRen uses to authenticate calls from your application.
		 * Note, however, that this property can sometimes contain the session secret rather than the
		 * application secret, depending on the context. For more information about session secrets, see the
		 */
		public function get secret():String { return _currentSession ? this._currentSession.secret : null; } 
		/**
		 * The current session's session key, which identifies the current session on the RenRen platform.
		 */
		public function get sessionKey():String  { return _currentSession ? this._currentSession.sessionKey : null; }
		/**
		 * The time when the current session will expire. More precisely, this is a value returned by
		 * the RenRen server&#x2014;the <code>fb_sig_expires</code> parameter&#x2014;that indicates when the current 
		 * session key will expire. 
		 */
		public function get expires():Date  { return _currentSession ? this._currentSession.expires : new Date(); }
		/**
		 * The RenRen User ID for the user involved in the current session.
		 */
		public function get uid():String { return _currentSession ? this._currentSession.uid : null; }
		public function get apiVersion():String  { return _currentSession ? this._currentSession.apiVersion : null; }
		
		public function startSession(session:IRenRenSession):void {
			_currentSession = session;
			if (_currentSession.connected) {
				dispatchEvent(new RenRenEvent(RenRenEvent.CONNECT, false, false, true));
			} else {
				_currentSession.addEventListener(RenRenEvent.CONNECT, onSessionConnected);
				_currentSession.addEventListener(RenRenEvent.WAITING_FOR_LOGIN, onWaitingForLogin);
			}
		}
		
		public function post(call:RenRenCall):RenRenCall {
			if (_currentSession) {
				call.session = _currentSession;
				call.renren_internal::initialize();
				
				var delegate:IRenRenCallDelegate = _currentSession.post(call);
				call.delegate = delegate;
			} else {
				throw new Error("Cannot post a call; no session has been set.");
			}
			return call;
		}
		
		/**
		 * Navigates to a RenRen URL that prompts the user to grant extended permissions for your application.
		 * <p>The "offline access" permission is an example of an extended permission that a user can grant
		 * to your application. This permission allows your application to access a user's profile even if the
		 * user is offline or does not have an active session. 
		 */
		public function grantExtendedPermission(perm:String):void {
			navigateToURL(new URLRequest('http://www.xiaonei.com/authorize.do?api_key='+apiKey+'&v='+apiVersion+'&ext_perm='+perm), '_blank');
		}
		
		/**
		 * Navigates to a RenRen URL that checks whether the user has granted your application access
		 * to the user's profile and if not, prompts the user to grant basic authorization.
		 */
		public function grantPermission(returnSession:Boolean):void {
			var authUrl:String = 'http://www.xiaonei.com/login.do?return_session=' + (returnSession?1:0) + '&api_key=' + apiKey;
			navigateToURL(new URLRequest(authUrl), '_blank');
		}
		
		public function login(offlineAccess:Boolean):void {
			_currentSession.login(offlineAccess);
		}
		
		/**
		 * Send a logout request to RenRen.
		 * 
		 */
		public function logout():void {
//			var call:ExpireSession = new ExpireSession();
//			call.addEventListener(FacebookEvent.COMPLETE, onLoggedOut, false, 0, true);
//			post(call);
		}
		
		public function refreshSession():void {
			_currentSession.refreshSession();
		}
		
		/**
		 * Helper function.  Called when the connection is ready.
		 * 
		 */
		protected function onSessionConnected(event:RenRenEvent):void {
			var session:IRenRenSession = event.target as IRenRenSession;
			dispatchEvent(event);
		}
		
		protected function onWaitingForLogin(event:RenRenEvent):void {
			waitingForLogin = true;
			dispatchEvent(new RenRenEvent(RenRenEvent.WAITING_FOR_LOGIN));
		}
		
		protected function onLoggedOut(event:RenRenEvent):void {
			if (event.success == true) {
				_currentSession.sessionKey = null;
			}
			
			dispatchEvent(new RenRenEvent(RenRenEvent.LOGOUT, false, false, event.success, event.data, event.error));
		}
		
	}
}