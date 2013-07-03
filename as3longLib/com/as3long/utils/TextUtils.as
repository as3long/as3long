package com.as3long.utils
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * 文本工具类
	 * @author 黄龙
	 */
	public class TextUtils
	{
		private static var tf:TextFormat = new TextFormat("Tahoma");
		private static var testTextFiled:TextField = new TextField();
		
		public function TextUtils()
		{
			testTextFiled.defaultTextFormat = tf;
		}
		
		/**
		 * 给添加的这段文本指定颜色
		 * @param	txtField	文本框
		 * @param	text	内容
		 * @param	color	文本颜色
		 */
		public static function appendText(txtField:TextField, text:String, color:uint = 0x000000):void
		{
			if (txtField == null)
			{
				return;
			}
			var len:int = txtField.length;
			txtField.appendText(text);
			tf.color = color;
			//var str:String = txtField.htmlText;
			//str += "<font color='#" + color.toString(16) + "'>" + text + "</font>";
			//txtField.htmlText = str;
			txtField.setTextFormat(tf, len, len + text.length);
		}
		
		/**
		 * 字符串补齐空格
		 * @param	str 字符串
		 * @param	len 需要的长度
		 * @return
		 */
		public static function completeStr(str:String, len:int):String
		{
			var rStr:String = str;
			testTextFiled.text = rStr;
			if (testTextFiled.textWidth >= len)
			{
				return rStr;
			}
			
			while (testTextFiled.textWidth < len)
			{
				testTextFiled.appendText("1");
			}
			trace("补齐", testTextFiled.textWidth, len);
			rStr = testTextFiled.text;
			return rStr;
		}
		
		public static function distinguish_cn_en(s):int
		{
			var count:int = 0;
			var cn = 0;
			var en = 0;
			var reg:RegExp = /[\u4e00-\u9fa5]/;
			for (var i = 0; i < s.length; i++)
			{
				if (reg.test(s.charAt(i))) //cn
				{
					cn++;
					count += 23; //一个中文字占23个像素
				}
				else
				{
					en++;
					count += 10; //一个英文字占10个像素
				}
			}
			return count;
		}
	}

}