package ghostcat.util
{
	import ghostcat.util.text.NumberUtil;

	/**
	 * 帮组嵌入字体的类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class FontEmbedHelper
	{
		/**
		 * 字母范围
		 */
		public static const LETTER:String = "U+0020-U+007e";
		
		/**
		 * 全角字母范围
		 */
		public static const SBC_LETTER:String = "U+ff01-U+ff65";
		
		/**
		 * 中文标点范围
		 */
		public static const CHINESE_INTERPUNCTION:String = "U+00b7,U+2014,U+2018,U+2019,U+201c,U+201d,U+2026,U+3001,U+3002,U+3008-U+3011,U+3014-U+3017";
		
		/**
		 * 将需要陷入的文字作为参数输入，将会获得一串代码。
		 * 添加这段代码即可成功嵌入文字。
		 * 
		 * @param fontName	FLASH内部的字体名称，内部将以这个名字为准
		 * @param systemName	系统字体名称
		 * @param source	外部字体路径
		 * @param italic	是否是粗体
		 * @param weight	是否是斜体
		 * @param text	需要嵌入的文字
		 * @param exUnicodeRange 附加的嵌入文本范围（类似U+ff01-U+ff65）
		 * @param createRegisterCode 是否创建注册代码
		 * @param disabledEmbedAsCFF 是否取消掉CFF字体
		 */
		public static function getEmbedFontCode(fontName:String, systemFont:String, source:String, italic:Boolean = false, weight:Boolean = false,text:String=null,exUnicodeRange:Array = null,createRegisterCode:Boolean = true,disabledEmbedAsCFF:Boolean = false):String
		{
			var result:String = "[Embed(";
			if (systemFont)
				result += 'systemFont="'+ systemFont +'"';
			else
				result += 'source="'+ source.replace(/\"|\\/g,"\\$&") +'"';
			
			if (fontName)
				result += ', fontName="'+ fontName +'"' 
			if (italic) 
				result+= ', fontStyle="italic"';
			if (weight) 
				result+= ', fontWeight="bold"';
			if (disabledEmbedAsCFF)
				result+= ', embedAsCFF="false"';
			
			result += ', mimeType="application/x-font"';
				
			if (!exUnicodeRange)
				exUnicodeRange = [];
			
			if (text)
				exUnicodeRange.push(getUnicodeRange(text));
			
			var unicodeRangeText:String = exUnicodeRange.join(",");
			if (unicodeRangeText)
				result += ', unicodeRange="'+ unicodeRangeText +'"';
			result += ')]';
			
			if (createRegisterCode)
			{
				result += '\r\nvar '+ fontName +':Class;'
				result += '\r\nFont.registerFont('+ fontName +');'
			}
			return result;
		}
		
		/**
		 * 获得一段文本的Unicode范围 
		 * @param text
		 * @return 
		 * 
		 */
		public static function getUnicodeRange(text:String):String
		{
			var textArr:Array = [];
			for (var i:int = 0;i < text.length;i++)
				textArr.push(text.charCodeAt(i));
			textArr.sort(Array.NUMERIC);
			
			var unicodeRange:String = "";
			var prev:uint;
			for (i = 0;i < textArr.length;i++)
			{
				var now:uint = textArr[i];
				if (now != prev)
				{
					if (unicodeRange != "")
						unicodeRange += ",";
					unicodeRange += "U+" + NumberUtil.fillZeros(now.toString(16).toUpperCase(),4);
				}
				prev = now;
			}
			return unicodeRange;
		}
	}
}