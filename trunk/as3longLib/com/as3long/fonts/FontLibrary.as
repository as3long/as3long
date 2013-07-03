package com.as3long.fonts
{
	import flash.text.Font;
	import flash.display.Sprite;
	public class FontLibrary extends Sprite
	{
		[Embed(systemFont = "Helvetica Narrow", fontName = "HeleveticaNarrow", mimeType = "application/x-font", embedAsCFF="false",
		unicodeRange = "U+0020-U+007e,U+ff01-U+ff65,U+00b7,U+2014,U+2018,U+2019,U+201c,U+201d,U+2026,U+3001,U+3002,U+3008-U+3011,U+3014-U+3017,U+002C,U+0030,U+0031,U+0032,U+0033,U+0034,U+0035,U+0036,U+0037,U+0038,U+0039,U+4E07,U+4EBA,U+5143"
		)]
		public var font0:Class;
		
		[Embed(systemFont = "simsun",fontWeight="bold",fontName = "SongTi", mimeType = "application/x-font", embedAsCFF = "false", 
		unicodeRange = "U+0020-U+007e,U+ff01-U+ff65,U+00b7,U+2014,U+2018,U+2019,U+201c,U+201d,U+2026,U+3001,U+3002,U+3008-U+3011,U+3014-U+3017,U+4E07,U+4E2A,U+4EBA,U+5143,U+5343,U+6237,U+6B21,U+767E,U+FF08,U+FF09"
		)]
		public var font1:Class;
		
		public function FontLibrary():void
		{
			Font.registerFont(font0);
			Font.registerFont(font1);
		}
		
	}
}
