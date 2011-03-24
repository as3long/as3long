/**
 * Helper file for creating a Ren Ren session with Flash based applications.
 * 
 */
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
package com.glink.rr.utils {
	
	import com.glink.rr.RenRen;
	import com.glink.rr.events.RenRenEvent;
	import com.glink.rr.renren_internal;
	import com.glink.rr.session.IRenRenSession;
	import com.glink.rr.session.WebSession;
	
	import flash.display.LoaderInfo;
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;
	import flash.system.Capabilities;

	/**
	 * The RenRenSessionUtil class provides a convenient way to create
	 * or continue a RenRen session. This class handles many of the tasks that
	 * you would otherwise have to handle manually. The RenRenSessionUtil class
	 * constructor:
	 * <ul>
	 *   <li>Checks whether an existing session is stored as a SharedObject
	 *       on the user's computer and uses that session key if it exists.</li>
	 *   <li>Checks whether the Facebook server provided a new session key
	 *       and gives that session key precedence over the SharedObject session key.</li>
	 *   <li>Checks whether the Facebook server sends a session secret to
	 *       use in place of your application secret and uses the session
	 *       secret if it exists.</li>
	 *   <li>Attempts to determine what type of session you are using, either a 
	 *       DesktopSession, a WebSession, or a JSSession (JavaScript Bridge Session).
	 *       If it cannot determine the type of session,
	 *       it uses a DesktopSession.</li>
	 *   <li>Creates a session of the type determined in the previous step and
	 *       stores the session in the public property named <code>activeSession</code>.</li>
	 *   <li>Creates an instance of the Facebook class and stores the instance
	 *       in a public property named <code>facebook</code>.</li>
	 *   <li>Starts a session of the appropriate type.</li>
	 * </ul>
	 */
	public class RenRenSessionUtil extends EventDispatcher {
		
		/**
		 * The instance of the RenRen class created by the constructor.
		 */
		public var ren_ren:RenRen;
		
		protected var apiKey:String;
		protected var secret:String;
		protected var loaderInfo:LoaderInfo;
		protected var sessionKey:String;
		/** @private */
		protected var _activeSession:IRenRenSession;
		
		/**
		 * The constructor creates a new session of the appropriate type. 
		 * See the RenRenSessionUtil class description for detailed information
		 * about the constructor.
		 *
		 * @param api_key Your application's API key.
		 * @param secret Your application's secret key. If this parameter is passed
		 * a value of <code>null</code>, the constructor looks for a special
		 * session secret stored in the <code>xn_sig_ss</code> property of the
		 * <code>loaderInfo</code> object. For web sessions, even if you pass a 
		 * non-null value for this parameter, the constructor will always look
		 * for a session secret and use that instead of the value that you pass
		 * for this parameter.
		 * @param loaderInfo An object of type LoaderInfo that provides information
		 * about the loaded SWF file.
		 */ 
		
		public function RenRenSessionUtil(apiKey:String, secret:String, loaderInfo:LoaderInfo) {
			this.secret = secret;
			this.apiKey = apiKey;
			this.loaderInfo = loaderInfo;
			
			var savedCreds:SharedObject = getStoredSession();
			
			var flashVars:Object = loaderInfo != null?loaderInfo.parameters:{};
			//Use the session provided by Ren ren, if one exists
			if (flashVars.xn_sig_session_key != null) {
				sessionKey = flashVars.xn_sig_session_key; 
			}
			
			if (loaderInfo.url.slice(0, 5) == "file:" || Capabilities.playerType == "Desktop") {
				//desktop application
				//_activeSession = new DesktopSession(apiKey, this.secret);
			} else if(flashVars.xn_sig_api_key && flashVars.xn_sig_session_key) {
				//Web application
				_activeSession = new WebSession(flashVars.xn_sig_api_key, secret, flashVars.xn_sig_session_key);
				(_activeSession as WebSession).expires = new Date(flashVars.xn_sig_expires);
				(_activeSession as WebSession).renren_internal::_uid = flashVars.xn_sig_user;
			} else if(flashVars.as_app_name) {
				//jsBridge application
				//_activeSession = new JSSession(apiKey, flashVars.as_app_name);
			} else {
				//could not determine ren ren connection type, so just use DesktopSession
				//_activeSession = new DesktopSession(apiKey, secret);
			}
			_activeSession.sessionKey = sessionKey;
			
			_activeSession.addEventListener(RenRenEvent.VERIFYING_SESSION, onVerifyingSession);
			
			//Create our ren ren instance
			ren_ren = new RenRen();
			ren_ren.addEventListener(RenRenEvent.WAITING_FOR_LOGIN, handleWaitingForLogin);
			ren_ren.addEventListener(RenRenEvent.CONNECT, onRenRenReady);
			ren_ren.startSession(_activeSession);
		}
		/**
		 * Purges user login data.
		 * Cleans up sharedObject data. 
		 */
		public function logout():void {
			getStoredSession().clear();
			getStoredSession().flush();
			ren_ren.logout();
		}
		
		public function onVerifyingSession(event:RenRenEvent):void {
			dispatchEvent(event);
		}
		
		/**
		 * The active session created by the constructor.
		 */
		public function get activeSession():IRenRenSession { return _activeSession; }
		
		public function login(offline_access:Boolean = true):void {
			ren_ren.login(offline_access);
		}
		
		protected function handleWaitingForLogin(event:RenRenEvent):void {
			dispatchEvent(event);
		}
		
		/**
		 * Call first to check an established login. 
		 */ 
		public function verifySession():void {
			_activeSession.verifySession();
		}
		
		/**
		 * if there is no prior login session, validate create a new session 
		 */ 
		
		public function validateLogin():void {
			ren_ren.refreshSession();
		}
		
		protected function onVerifyLogin(event:RenRenEvent):void {
			_activeSession.removeEventListener(RenRenEvent.CONNECT, onVerifyLogin);
			if (event.success) {
				onRenRenReady(null);
				dispatchEvent(new RenRenEvent(RenRenEvent.CONNECT, false, false, true));
			} else {
				dispatchEvent(new RenRenEvent(RenRenEvent.CONNECT, false, false, false));
			}
		}
		
		/**
		 * get the stored session for the set api
		 */
		protected function getStoredSession():SharedObject {
			return SharedObject.getLocal(apiKey+"_stored_session");
		}
		
		protected function onWaitingForLogin(event:RenRenEvent):void {
			dispatchEvent(event);
		}
		
		/**
		 * Called when the facebook connection is ready.
		 */
		protected function onRenRenReady(event:RenRenEvent):void {
			if (ren_ren.sessionKey) {
				var storedSession:SharedObject = getStoredSession();
				storedSession.data.sessionKey = ren_ren.sessionKey;
				storedSession.data.storedSecret = ren_ren.secret;
				storedSession.flush(3000);
			}
			
			if (event) {
				dispatchEvent(event);
			}
		}
	}
}