package com.rush360 
{
	import com.rush360.interfac.Iapple;
	/**
	 * ...
	 * @author 360rush
	 */
	public class Apple implements Iapple
	{
		public var _color:String = "红色的苹果";
		public function Apple() 
		{
			
		}
		
		public function color():String
		{
			return _color;
		}
		
	}

}