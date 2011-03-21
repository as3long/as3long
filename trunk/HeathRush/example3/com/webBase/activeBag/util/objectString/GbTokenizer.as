package com.webBase.activeBag.util.objectString {


	public class GbTokenizer {
	

		private var obj:Object;
		

		private var gbString:String;
		

		private var loc:int;
		

		private var ch:String;
		


		public function GbTokenizer( s:String ) {
			gbString = s;
			loc = 0;
			
			nextChar();
		}
		

		public function getNextToken():GbToken {
			var token:GbToken = new GbToken();
			

			skipIgnored();
						
			switch ( ch ) {
				
				case '{':
					token.type = GbTokenType.LEFT_BRACE;
					token.value = '{';
					nextChar();
					break
					
				case '}':
					token.type = GbTokenType.RIGHT_BRACE;
					token.value = '}';
					nextChar();
					break
					
				case '[':
					token.type = GbTokenType.LEFT_BRACKET;
					token.value = '[';
					nextChar();
					break
					
				case ']':
					token.type = GbTokenType.RIGHT_BRACKET;
					token.value = ']';
					nextChar();
					break
				
				case ',':
					token.type = GbTokenType.COMMA;
					token.value = ',';
					nextChar();
					break
					
				case ':':
					token.type = GbTokenType.COLON;
					token.value = ':';
					nextChar();
					break;
					
				case 't': 
					var possibleTrue:String = "t" + nextChar() + nextChar() + nextChar();
					
					if ( possibleTrue == "true" ) {
						token.type = GbTokenType.TRUE;
						token.value = true;
						nextChar();
					} else {
						parseError( "Expecting 'true' but found " + possibleTrue );
					}
					
					break;
					
				case 'f': 
					var possibleFalse:String = "f" + nextChar() + nextChar() + nextChar() + nextChar();
					
					if ( possibleFalse == "false" ) {
						token.type = GbTokenType.FALSE;
						token.value = false;
						nextChar();
					} else {
						parseError( "Expecting 'false' but found " + possibleFalse );
					}
					
					break;
					
				case 'n': 
				
					var possibleNull:String = "n" + nextChar() + nextChar() + nextChar();
					
					if ( possibleNull == "null" ) {
						token.type = GbTokenType.NULL;
						token.value = null;
						nextChar();
					} else {
						parseError( "Expecting 'null' but found " + possibleNull );
					}
					
					break;
					
				case '"': 
					token = readString();
					break;
					
				default: 
					if ( isDigit( ch ) || ch == '-' ) {
						token = readNumber();
					} else if ( ch == '' ) {

						return null;
					} else {						

						parseError( "Unexpected " + ch + " encountered" );
					}
			}
			
			return token;
		}
		
		private function readString():GbToken {

			var token:GbToken = new GbToken();
			token.type = GbTokenType.STRING;
			

			var string:String = "";
			
			nextChar();
			
			while ( ch != '"' && ch != '' ) {
								
				if ( ch == '\\' ) {

					nextChar();
					
					switch ( ch ) {
						
						case '"': 
							string += '"';
							break;
						
						case '/':	
							string += "/";
							break;
							
						case '\\':	
							string += '\\';
							break;
							
						case 'b':	
							string += '\b';
							break;
							
						case 'f':	
							string += '\f';
							break;
							
						case 'n':
							string += '\n';
							break;
							
						case 'r':	
							string += '\r';
							break;
							
						case 't':	
							string += '\t'
							break;
						
						case 'u':

							var hexValue:String = "";
							
							for ( var i:int = 0; i < 4; i++ ) {

								if ( !isHexDigit( nextChar() ) ) {
									parseError( " Excepted a hex digit, but found: " + ch );
								}
								hexValue += ch;
							}
							
							string += String.fromCharCode( parseInt( hexValue, 16 ) );
							
							break;
					
						default:

							string += '\\' + ch;
						
					}
					
				} else {
					string += ch;
					
				}
				nextChar();
				
			}
			if ( ch == '' ) {
				parseError( "Unterminated string literal" );
			}
			
			nextChar();
			
			token.value = string;
			
			return token;
		}

		private function readNumber():GbToken {
			var token:GbToken = new GbToken();
			token.type = GbTokenType.NUMBER;
			
			var input:String = "";
			
			if ( ch == '-' ) {
				input += '-';
				nextChar();
			}
			
			if ( !isDigit( ch ) )
			{
				parseError( "Expecting a digit" );
			}
			
			if ( ch == '0' )
			{
				input += ch;
				nextChar();
				

				if ( isDigit( ch ) )
				{
					parseError( "A digit cannot immediately follow 0" );
				}
			}
			else
			{
				while ( isDigit( ch ) ) {
					input += ch;
					nextChar();
				}
			}
			
			if ( ch == '.' ) {
				input += '.';
				nextChar();
				
				if ( !isDigit( ch ) )
				{
					parseError( "Expecting a digit" );
				}
				
				while ( isDigit( ch ) ) {
					input += ch;
					nextChar();
				}
			}

			if ( ch == 'e' || ch == 'E' )
			{
				input += "e"
				nextChar();

				if ( ch == '+' || ch == '-' )
				{
					input += ch;
					nextChar();
				}
				
				if ( !isDigit( ch ) )
				{
					parseError( "Scientific notation number needs exponent value" );
				}
							
				while ( isDigit( ch ) )
				{
					input += ch;
					nextChar();
				}
			}
			
			var num:Number = Number( input );
			
			if ( isFinite( num ) && !isNaN( num ) ) {
				token.value = num;
				return token;
			} else {
				parseError( "Number " + num + " is not valid!" );
			}
            return null;
		}

		private function nextChar():String {
			return ch = gbString.charAt( loc++ );
		}
		
		private function skipIgnored():void
		{
			var originalLoc:int;

			do
			{
				originalLoc = loc;
				skipWhite();
				skipComments();
			}
			while ( originalLoc != loc );
		}

		private function skipComments():void {
			if ( ch == '/' ) {
				nextChar();
				switch ( ch ) {
					case '/': 
						
						do {
							nextChar();
						} while ( ch != '\n' && ch != '' )
						
						nextChar();
						
						break;
					
					case '*':


						nextChar();
						
				
						while ( true ) {
							if ( ch == '*' ) {
								
								nextChar();
								if ( ch == '/') {
									
									nextChar();
									break;
								}
							} else {
								
								nextChar();
							}
							
							if ( ch == '' ) {
								parseError( "Multi-line comment not closed" );
							}
						}

						break;
					
					default:
						parseError( "Unexpected " + ch + " encountered (expecting '/' or '*' )" );
				}
			}
			
		}
		
		
		private function skipWhite():void {
			
			while ( isWhiteSpace( ch ) ) {
				nextChar();
			}
			
		}
		
		private function isWhiteSpace( ch:String ):Boolean {
			return ( ch == ' ' || ch == '\t' || ch == '\n' || ch == '\r' );
		}

		private function isDigit( ch:String ):Boolean {
			return ( ch >= '0' && ch <= '9' );
		}
		

		private function isHexDigit( ch:String ):Boolean {

			var uc:String = ch.toUpperCase();

			return ( isDigit( ch ) || ( uc >= 'A' && uc <= 'F' ) );
		}

		public function parseError( message:String ):void {
			throw new GbParseError( message, loc, gbString );
		}
	}
	
}
