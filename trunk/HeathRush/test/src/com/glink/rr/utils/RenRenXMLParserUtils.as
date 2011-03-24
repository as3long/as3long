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
package com.glink.rr.utils
{
	import com.glink.rr.data.RenRenLocation;
	
	import flash.net.URLVariables;
	
	public class RenRenXMLParserUtils
	{
		public static function toArray(value:XML):Array {
			if (value == null) { return null; }
			return value.toString().split(',');
		}
		
		public static function toNumber(value:XML):Number{
			if (value == null) { return NaN; }
			return Number(value.toString());
		}
		
		public static function toStringValue(value:XML):String {
			if (value == null) { return null; }
			return value.toString();
		}
		
		public static function toDate(value:String):Date {
			if (value == null) { return null; }
			var startDate:String = value;
			while (startDate.length < 13) { startDate = startDate + '0'; }
			
			var newDate:Date = new Date(Number(startDate));
			return newDate;
		}
		
		public static function toBoolean(value:XML):Boolean {
			if (value == null) { return false; } 
			return value.toString() == '1';
		}
		
		public static function toUIDArray(xml:XML):Array {
			var arr:Array =  [];
			if (xml == null) { return arr; }
			
			var uids:XMLList = xml.children();
			var l:uint = uids.length();
			
			for (var i:uint = 0;i<l;i++) {
				arr.push(toNumber(uids[i]));
			}
			
			return arr;
		}
		
		public static function xmlToUrlVariables(p_xml:XMLList):URLVariables {
			var vars:URLVariables = new URLVariables();
			
			for each(var xml:XML in p_xml) {
				vars[xml.key.valueOf()] = xml.value.valueOf(); 
			}
			
			return vars;
		}
		
		public static function xmlListToObjectArray(xList:XMLList):Array {
			var arr:Array = [];
			if (xList == null) { return arr; }
			
			var l:uint = xList.length();
			for (var i:uint=0;i<l;i++) {
				arr.push(xmlToObject(xList[i]));
			}
			
			return arr;
		}
		
		public static function xmlToObject(p_xml:XML):Object {
			var vars:Object = {};
			var children:XMLList = p_xml.children();
			var l:uint = children.length();
			for (var i:uint=0;i<l;i++) {
				var xml:XML = children[i];
				vars[xml.localName()] = xml.toString(); 
			}
			
			return vars;
		}
		
		public static function nodeToObject(p_xml:XMLList):Object {
			var vars:Object = {};
			
			for each(var xml:XML in p_xml) {
				vars[xml.key.valueOf()] = xml.value.valueOf(); 
			}
			
			return vars;
		}
		
		public static function createLocation(xml:XML, ns:Namespace):RenRenLocation {
			var location:RenRenLocation = new RenRenLocation();
			if (xml == null) { return location; }
			
			location.city = String(xml.ns::city);
			location.province = String(xml.ns::province);
			location.country = String(xml.ns::country);
			
			return location;
		}
	}
}