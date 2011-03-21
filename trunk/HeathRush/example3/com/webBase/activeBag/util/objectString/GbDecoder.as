package com.webBase.activeBag.util.objectString {
	public class GbDecoder {

		private var value:*;
		
		private var tokenizer:GbTokenizer;
		
		private var token:GbToken;
		

		public function GbDecoder( s:String ) {
			
			tokenizer = new GbTokenizer( s );
			
			nextToken();
			value = parseValue();
		}

		public function getValue():* {
			return value;
		}
		

		private function nextToken():GbToken {
			return token = tokenizer.getNextToken();
		}

		private function parseArray():Array {

			var a:Array = new Array();
			

			nextToken();
			
			
			if ( token.type == GbTokenType.RIGHT_BRACKET ) {
				
				return a;
			}
			
		
			while ( true ) {
				
				a.push ( parseValue() );
			
			
				nextToken();
				
				if ( token.type == GbTokenType.RIGHT_BRACKET ) {
					
					return a;
				} else if ( token.type == GbTokenType.COMMA ) {
					
					nextToken();
				} else {
					tokenizer.parseError( "Expecting ] or , but found " + token.value );
				}
			}
            return null;
		}

		private function parseObject():Object {

			var o:Object = new Object();
						

			var key:String
			
			nextToken();
			
			if ( token.type == GbTokenType.RIGHT_BRACE ) {
		
				return o;
			}
			

			while ( true ) {
			
				if ( token.type == GbTokenType.STRING ) {

					key = String( token.value );
					
				
					nextToken();
					
					
					if ( token.type == GbTokenType.COLON ) {
						
						
						nextToken();
						o[key] = parseValue();	
						
					
						nextToken();
						
						
						if ( token.type == GbTokenType.RIGHT_BRACE ) {
				
							return o;
							
						} else if ( token.type == GbTokenType.COMMA ) {
						
							nextToken();
						} else {
							tokenizer.parseError( "Expecting } or , but found " + token.value );
						}
					} else {
						tokenizer.parseError( "Expecting : but found " + token.value );
					}
				} else {
					tokenizer.parseError( "Expecting string but found " + token.value );
				}
			}
            return null;
		}
		

		private function parseValue():Object
		{
			if ( token == null )
			{
				tokenizer.parseError( "Unexpected end of input" );
			}
					
			switch ( token.type ) {
				case GbTokenType.LEFT_BRACE:
					return parseObject();
					
				case GbTokenType.LEFT_BRACKET:
					return parseArray();
					
				case GbTokenType.STRING:
				case GbTokenType.NUMBER:
				case GbTokenType.TRUE:
				case GbTokenType.FALSE:
				case GbTokenType.NULL:
					return token.value;

				default:
					tokenizer.parseError( "Unexpected " + token.value );
					
			}
            return null;
		}
	}
}
