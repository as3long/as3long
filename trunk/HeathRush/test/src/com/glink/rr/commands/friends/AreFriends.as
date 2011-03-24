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
package com.glink.rr.commands.friends {
	
	import com.glink.rr.RenRenCall;
	import com.glink.rr.renren_internal;
	import com.glink.rr.utils.RenRenDataUtils;

	use namespace renren_internal;
	
	public class AreFriends extends RenRenCall {

		
		public static const METHOD_NAME:String = 'friends.areFriends';
		public static const SCHEMA:Array = ['uids1', 'uids2'];
		
		public var uids1:Array;
		public var uids2:Array;
		
		public function AreFriends(uids1:Array, uids2:Array) {
			super(METHOD_NAME);
			
			this.uids1 = uids1;
			this.uids2 = uids2;
		}
		
		override renren_internal function initialize():void {
			applySchema(SCHEMA, RenRenDataUtils.toArrayString(uids1), RenRenDataUtils.toArrayString(uids2));
			super.renren_internal::initialize();
		}
	}
}