package com.webBase.activeBag.util.objectString {

	public class Object2String {
	
		public static function encode( o:Object ):String {
			
			var encoder:GbEncoder = new GbEncoder( o );
			return encoder.getString();
		}

		public static function decode( s:String ):* {
			
			var decoder:GbDecoder = new GbDecoder( s )
			return decoder.getValue();
		}
	}
}