package com.webBase.activeBag.util.objectString {


	public class GbParseError extends Error 	{
	
		private var _location:int;
		
		private var _text:String;

		public function GbParseError( message:String = "", location:int = 0, text:String = "") {
			super( message );
			name = "GbParseError";
			_location = location;
			_text = text;
		}

		public function get location():int {
			return _location;
		}
		public function get text():String {
			return _text;
		}
	}
	
}