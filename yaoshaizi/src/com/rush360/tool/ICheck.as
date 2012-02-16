package com.rush360.tool 
{
	
	/**
	 * 字符串检查接口
	 * @author huanglong
	 */
	public interface ICheck 
	{
		/**
		 * 设置数据加密
		 * @param	str
		 * @return
		 */
		function setData(str:String):String
		
		/**
		 * 获取数据
		 * @param	String
		 * @return
		 */
		function getData(String):*
	}
	
}