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
package com.glink.rr.delegates
{
	import com.glink.rr.RenRenCall;
	import com.glink.rr.data.RenRenData;
	import com.glink.rr.errors.RenRenError;
	import com.glink.rr.errors.RenRenErrorCodes;
	import com.glink.rr.errors.RenRenErrorReason;
	import com.glink.rr.events.RenRenEvent;
	import com.glink.rr.renren_internal;
	import com.glink.rr.session.IRenRenSession;
	import com.glink.rr.session.WebSession;
	import com.glink.rr.utils.RequestHelper;
	import com.glink.rr.utils.XMLDataParser;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	
	use namespace renren_internal;

	public class WebDelegate extends EventDispatcher implements IRenRenCallDelegate
	{
		protected var parser:XMLDataParser;
		
		protected var connectTimer:Timer;
		protected var loadTimer:Timer;
		
		protected var _call:RenRenCall;
		protected var _session:WebSession;
		
		protected var loader:URLLoader;
		protected var fileRef:FileReference;
		
		public function WebDelegate(call:RenRenCall, session:WebSession)
		{
			super();
			
			this.call = call;
			this.session = session;
			
			parser = new XMLDataParser();
			
			connectTimer = new Timer(call.connectTimeout, 1);
			connectTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onConnectTimeout, false, 0, true);
			
			loadTimer = new Timer(call.loadTimeout, 1);
			loadTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onLoadTimeOut, false, 0, true);
			
			execute();
		}
		
		public function close():void
		{
			try {
				loader.close();
			} catch (e:*) { }
			
			connectTimer.stop();
			loadTimer.stop();
		}
		
		public function get call():RenRenCall
		{
			return _call;
		}
		
		public function set call(newVal:RenRenCall):void
		{
			_call = newVal;
		}
		
		public function get session():IRenRenSession
		{
			return _session;
		}
		
		public function set session(newVal:IRenRenSession):void
		{
			_session = newVal as WebSession;
		}
		
		protected function onConnectTimeout(p_event:TimerEvent):void {
			var rrError:RenRenError = new RenRenError();
			rrError.errorCode = RenRenErrorCodes.SERVER_ERROR;
			rrError.reason = RenRenErrorReason.CONNECT_TIMEOUT;
			_call.handleError(rrError);
			dispatchEvent(new RenRenEvent(RenRenEvent.COMPLETE, false, false, false, null, rrError));
			
			loadTimer.stop();
			close();
		}
		
		protected function onLoadTimeOut(p_event:TimerEvent):void {
			connectTimer.stop();
			
			close();
			
			var rrError:RenRenError = new RenRenError();
			rrError.errorCode = RenRenErrorCodes.SERVER_ERROR;
			rrError.reason = RenRenErrorReason.LOAD_TIMEOUT;
			_call.handleError(rrError);
			dispatchEvent(new RenRenEvent(RenRenEvent.COMPLETE, false, false, false, null, rrError));
		}
		
		protected function execute():void {
			if (call == null) { throw new Error('No call defined.'); }
			
			post();
		}
		
		/**
		 * Helper function for sending the call straight to the server
		 */
		protected function post():void {
			addOptionalArguments();
			
			RequestHelper.formatRequest(call);
			
			//Have a seperate method so sub classes can override this if need be (WebImageUploadDelegate, is an example)
			sendRequest();
			
			connectTimer.start();
		}
		
		/**
		 * Add arguments here that might be class session-type specific
		 */
		protected function addOptionalArguments():void {
			//setting thes 'ss' argument to true
			//since that's what we should be using for a web session
			call.setRequestArgument("ss", true);
		}
		
		protected function sendRequest():void {
			//construct the loader
			createURLLoader();
			
			//create the service request for normal calls
			var req:URLRequest = new URLRequest(_session.restUrl);
			req.contentType = "application/x-www-form-urlencoded";
			req.method = URLRequestMethod.POST;
			
			req.data = call.args;
			
			trace(req.url + '?' + unescape(call.args.toString()));
			
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(req);
		}
		
		protected function createURLLoader():void {
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onDataComplete);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			loader.addEventListener(Event.OPEN, onOpen);
		}
		
		protected function onHTTPStatus(p_event:HTTPStatusEvent):void { }
		
		protected function onOpen(p_event:Event):void {
			connectTimer.stop();
			loadTimer.start();
		}
		
		
		// Event Handlers
		protected function onDataComplete(p_event:Event):void {
			trace(_call.method, p_event);
			handleResult(p_event.target.data.toString());
		}
		
		protected function onError(p_event:ErrorEvent):void {
			trace(_call.method, p_event);
			clean();
			
			var rrError:RenRenError = parser.createRenRenError(p_event, loader.data); 
			
			call.handleError(rrError);
			
			dispatchEvent(new RenRenEvent(RenRenEvent.COMPLETE, false, false, false, null, rrError));
		}
		
		protected function handleResult(result:String):void {
			clean();
			
			var error:RenRenError = parser.validateResponce(result);
			var rrData:RenRenData;
			
			if (error == null) {
				rrData = parser.parse(result, call.method);
				call.handleResult(rrData);
			} else {
				call.handleError(error);
			}
		}
		
		protected function clean():void {
			connectTimer.stop();
			loadTimer.stop();
			
			if (loader == null) { return; }
			
			loader.removeEventListener(Event.COMPLETE, onDataComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			loader.removeEventListener(Event.OPEN, onOpen);
		}
	}
}