package com.as3long.tool
{

	/**
	 * 调试时统一输出
	 */
	public class LTrace
	{
		public function LTrace()
		{
			// constructor code
		}
		
		/**
		 * 输出调试信息
		 * @param	...arg
		 */
		public static function t(...arg):void
		{
			trace(arg);
		}
	}

}