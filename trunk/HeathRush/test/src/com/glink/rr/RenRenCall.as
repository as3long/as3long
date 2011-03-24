/**
 * Makes the call to the Xiaonei REST service.
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
package com.glink.rr
{
	import com.glink.rr.data.RenRenData;
	import com.glink.rr.delegates.IRenRenCallDelegate;
	import com.glink.rr.errors.RenRenError;
	import com.glink.rr.events.RenRenEvent;
	import com.glink.rr.session.IRenRenSession;
	
	import flash.events.EventDispatcher;
	import flash.net.URLVariables;
	
	use namespace renren_internal;
	
	public class RenRenCall extends EventDispatcher
	{
		public var args:URLVariables;
		public var method:String;
		
		public var result:RenRenData;
		public var error:RenRenError;
		public var delegate:IRenRenCallDelegate;
		public var session:IRenRenSession;
		public var success:Boolean = false;
		
		
		/**
		 * Time before an Connect timeout occurs, in milliseconds. 
		 * @default 8000
		 * 
		 */
		public var connectTimeout:uint = 1000*8;
		
		/**
		 * Time before an Load timeout occurs, in milliseconds. 
		 * @default 8000
		 * 
		 */
		public var loadTimeout:uint = 1000*30;
		
		/**
		 * Set this if you do-not want to pass a session.
		 * For example set to false if you want to use friends.get to load another users friends.
		 * 
		 */
		public var useSession:Boolean = true;
		
		public function RenRenCall(method:String="no_method_required", args:URLVariables=null)
		{
			this.method = method;
			this.args = args != null ? args : new URLVariables();
		}
		
		/**
		 * Set a name value pair to be sent in request postdata.  
		 * You could of course set these directly on the args variable 
		 * but this method proves handy too.
		 * 
		 * @param name String the name of the argument
		 * @param value * the value of the argument
		 */
		renren_internal function setRequestArgument(name:String, value:Object):void {
			if (value is Number && isNaN(value as Number)) { return; }
			
			if (name && value != null && String(value).length > 0) {
				this.args[name] = value;
			}
		}
		
		/**
		 * Clear the values out the the .args object.  Sometiles useful
		 * in the initialize() method.
		 */
		renren_internal function clearRequestArguments():void {
			this.args = new URLVariables();
		}
		
		/** 
		 * Initialize the renren call.
		 * This will normally be used to convert class variables into arg values.
		 * Because a call can be used over and over if desired this method will
		 * be called so that child classes can re-initialize the .arg values.
		 */
		renren_internal function initialize():void {
			//override in case something needs to be initialized prior to execution
		}
		
		/**
		 * Called from the IRenRenCallDelegate when the communication 
		 * has been completed. This method will determine the success, 
		 * parse out any errors, call the handleSuccess method on successful
		 * calls (so that extended classes can easily handle the success of
		 * the call) and inform any listeners/callbacks that the call is
		 * complete.
		 * 
		 * @param result Object the result object provided from the Xiaonei 
		 * REST services
		 */
		renren_internal function handleResult(result:RenRenData):void {
			this.result = result;
			success = true;
			dispatchEvent(new RenRenEvent(RenRenEvent.COMPLETE, false, false, true, result));
		}
		
		/**
		 * A utility method used by extended classes.  The exception is
		 * passed to this method from the handleResult method.
		 * This method should NOT be called directly.
		 */
		renren_internal function handleError(error:RenRenError):void {
			this.error = error;
			success = false;
			dispatchEvent(new RenRenEvent(RenRenEvent.COMPLETE, false, false, false, null, error));
		}
		
		protected function applySchema(p_shema:Array, ...p_args:Array):void {
			var l:uint = p_shema.length;
			
			for (var i:uint=0;i<l;i++) {
				setRequestArgument(p_shema[i], p_args[i]);
			}
		}

	}
}