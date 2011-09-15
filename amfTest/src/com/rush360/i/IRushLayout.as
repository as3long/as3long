package com.rush360.i 
{
	
	/**
	 * 排序接口
	 * @author 360rush
	 */
	public interface IRushLayout 
	{
		/**
		 * 是否需要排序
		 */
		function get isSort():Boolean;
		
		/**
		 * 排序的序列值
		 */
		function get indexSort():int;
	}
	
}