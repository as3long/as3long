package com.as3long.utils
{
	
	/**
	 * 字符串工具类
	 * @author 黄龙
	 */
	public class StringUtils
	{
		
		public function StringUtils()
		{
		
		}
		
		/**
		 * 仿C#的string.Format()函数
		 * <p>trace(StringUtils.Format("t{0}s is {2} test","hi",null,"a"));</p>
		 * @param	format
		 * @param	... params
		 * @return
		 */
		public static function Format(format:String, ... params):String
		{
			if (params.length == 0)
			{
				return format;
			}
			var re:RegExp = /\{(\d+)\}/g;
			var getParam:Function = function(result:String, match:String, position:int, source:String):String
			{
				if (params[match] == null)
				{
					return params[0];
				}
				return params[match];
			}
			return format.replace(re, getParam);
		}
	}

}