package com.as3long.model.vo 
{
	/**
	 * 亮点信息
	 * @author huanglong
	 */
	public class LightPointVo 
	{
		/**
		 * 起始点x坐标
		 */
		public var x:Number=0;
		
		/**
		 * 起始点y坐标
		 */
		public var y:Number=0;
		
		/**
		 * 宽度
		 */
		public var width:Number=0;
		
		/**
		 * 高度
		 */
		public var height:Number = 0;
		
		public function toString():String
		{
			var returnString:String = '(';
			returnString += ('x=' + x);
			returnString += (', y=' + y);
			returnString += (', width=' + width);
			returnString += (', height=' + height + ')');
			return returnString;
		}
	}

}