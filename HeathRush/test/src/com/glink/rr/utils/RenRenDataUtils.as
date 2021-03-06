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
	import com.adobe.serialization.json.JSON;
	
	public class RenRenDataUtils
	{
		public static function formatDate(string:String):Date  {
			if (string == "" || string == null) { return null; }

			var date:Date = new Date();

			var dateParts:Array = string.split( "-" );

			date.setFullYear( dateParts[0] );
			date.setMonth( dateParts[1] - 1 ); // subtract 1 (Jan == 0)
			if (dateParts.length > 2) {
				date.setDate( dateParts[2] );
			} else {
				date.setDate(1);
			}

			return date;

		}
		
		public static function toDateString(date:Date):String {
			if (date == null) { return null; }
			
			date.setDate(date.date+1);
			return date == null?null:date.getTime().toString().slice(0,10);

		}
		
		public static function toArrayString(array:Array):String {
			return array == null?null:array.join(',')
		}
		
		public static function supplantString(string:String, replaceObj:Object):String {
			var str:String = string;
			for (var n:String in replaceObj) {
				str = str.replace(new RegExp('\\{'+n+'\\}', 'g'), replaceObj[n]);
			}
			return str;
		}
		
		public static function toJSONArray(value:RenRenArrayCollection):String {
			if (value == null) { return null; }
			
			return JSON.encode(value.toArray());

		}

		

		public static function toJSONValuesArray(array:Array):String {
			if (array == null) { return null; }
			
			var newArray:Array = [];

			var l:Number = array.length;

			for(var i:Number=0;i<l;i++) {

				newArray.push(JSON.encode(array[i]));

			}

			return newArray.join(',');

		} 
	}
}