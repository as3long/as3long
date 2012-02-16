package com.rush360.tool 
{
	/**
	 * 和谐检查器(和谐检查器无法获取原有数据)
	 * @author huanglong
	 */
	public class HeXieCheck implements ICheck 
	{
		
		public function HeXieCheck() 
		{
			
		}
		
		public function setData(str:String):String 
		{
			return CheckString.getInstance().check(str);
		}
		
		
		public function getData(String):* 
		{
			
		}
		
	}

}