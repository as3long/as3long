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
package com.glink.rr.data.users
{
	[Bindable]
	public class GetInfoFieldValues
	{

		public static const UID:String = "uid";
		public static const NAME:String = "name";
		public static const SEX:String = "sex";
		public static const STAR:String = "star";
		public static const ZIDOU:String = "zidou";
		public static const VIP:String = "vip";
		public static const BIRTHDAY:String = "birthday";
		public static const EMAIL_HASH:String = "email_hash";
		public static const TINY_URL:String = "tinyurl";
		public static const HEAD_URL:String = "headurl";
		public static const MAIN_URL:String = "mainurl";
		public static const HOMETWON_LOCATION:String = "hometown_location";
		public static const WORK_HISTORY:String = "work_history";
		public static const UNIVERSITY_HISTORY:String = "university_history";
		public static const HIGH_SCHOOL_HISTORY:String = "hs_history";
		
		/**
		 * Special value that contains all the values that do-not require a session key.
		 * 
		 */
		public static const NO_SESSION_VALUES:Array = [UID, NAME, TINY_URL, HEAD_URL, ZIDOU, STAR];
		
		/**
		 * Special value that contains all the values in this class.
		 * 
		 */
		public static const ALL_VALUES:Array = [UID, NAME, SEX, STAR, ZIDOU, VIP, BIRTHDAY, EMAIL_HASH,
												TINY_URL, HEAD_URL, MAIN_URL, HOMETWON_LOCATION, WORK_HISTORY, UNIVERSITY_HISTORY, HIGH_SCHOOL_HISTORY];
	}

}