package com.as3long.utils 
{
	/**
	 * ...
	 * @author 黄龙
	 */
	public class Base64Url
	{
		
		public function Base64Url() 
		{
			
		}
		
		public static function encode(str : String, utf8encode : Boolean = true) : String 
		{
			var dataStr:String = Base64.encode(str, utf8encode);
			while (dataStr.charAt(dataStr.length - 1) == "=")
			{
				dataStr = dataStr.substring(0, dataStr.length - 1);
			}
			var myPattern:RegExp = /\+/g;
			dataStr =dataStr.replace(myPattern, "-")
			var myPattern2:RegExp = /\//g;
			dataStr = dataStr.replace(myPattern2, "_")
			return dataStr;
		}
		
		public static function decode(str : String, utf8decode : Boolean = true) : String
		{
			var dataStr:String = str;
			var complementNum:int = dataStr.length % 4;
			for (var i:int = 0; i < complementNum; i++)
			{
				dataStr += "=";
			}
			var myPattern:RegExp = /\-/g;
			dataStr =dataStr.replace(myPattern, "+")
			var myPattern2:RegExp = /\_/g;
			dataStr = dataStr.replace(myPattern2, "/")
			dataStr = Base64.decode(dataStr, utf8decode);
			return dataStr;
		}
	}

}