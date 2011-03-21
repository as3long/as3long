﻿package com.webBase.activeBag.util.objectString {


	import flash.utils.describeType;

	public class GbEncoder {

		private var jsonString:String;

		public function GbEncoder( value:* ) {
			jsonString = convertToString( value );
		
		}

		public function getString():String {
			return jsonString;
		}
		
		private function convertToString( value:* ):String {
			
			if ( value is String ) {
				return escapeString( value as String );
				
			} else if ( value is Number ) {
				
				return isFinite( value as Number) ? value.toString() : "null";

			} else if ( value is Boolean ) {
				
				return value ? "true" : "false";

			} else if ( value is Array ) {
			
				return arrayToString( value as Array );
			
			} else if ( value is Object && value != null ) {
			
				return objectToString( value );
			}
            return "null";
		}
		

		private function escapeString( str:String ):String {

			var s:String = "";
	
			var ch:String;
	
			var len:Number = str.length;
			
			for ( var i:int = 0; i < len; i++ ) {
			
				ch = str.charAt( i );
				switch ( ch ) {
				
					case '"':	
						s += "\\\"";
						break;

						
					case '\\':	
						s += "\\\\";
						break;
						
					case '\b':	
						s += "\\b";
						break;
						
					case '\f':	
						s += "\\f";
						break;
						
					case '\n':	
						s += "\\n";
						break;
						
					case '\r':	
						s += "\\r";
						break;
						
					case '\t':	
						s += "\\t";
						break;
						
					default:	
						
						if ( ch < ' ' ) {
							var hexCode:String = ch.charCodeAt( 0 ).toString( 16 );

							var zeroPad:String = hexCode.length == 2 ? "00" : "000";

							s += "\\u" + zeroPad + hexCode;
						} else {
						
							s += ch;
							
						}
				}
				
			}	
						
			return "\"" + s + "\"";
		}
		

		private function arrayToString( a:Array ):String {
			var s:String = "";

			for ( var i:int = 0; i < a.length; i++ ) {

				if ( s.length > 0 ) {

					s += ","
				}
				s += convertToString( a[i] );	
			}

			return "[" + s + "]";
		}
		

		private function objectToString( o:Object ):String
		{

			var s:String = "";
			
			var classInfo:XML = describeType( o );
			if ( classInfo.@name.toString() == "Object" )
			{

				var value:Object;
				
				for ( var key:String in o )
				{
					value = o[key];
					
					if ( value is Function )
					{

						continue;
					}
					if ( s.length > 0 ) {
						s += ","
					}
					
					s += escapeString( key ) + ":" + convertToString( value );
				}
			}
			else
			{
				for each ( var v:XML in classInfo..*.( name() == "variable" || name() == "accessor" ) )
				{

					if ( s.length > 0 ) {
						s += ","
					}
					
					s += escapeString( v.@name.toString() ) + ":" 
							+ convertToString( o[ v.@name ] );
				}
				
			}
			
			return "{" + s + "}";
		}

	}
	
}
