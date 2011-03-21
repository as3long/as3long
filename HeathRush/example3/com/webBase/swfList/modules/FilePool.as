package com.webBase.swfList.modules 
{
	import com.webBase.swfList.SwfCollect;
	
	/**
	 * 文件池
	 * @author wzh (shch8.com)
	 */
	public class FilePool extends SwfCollect
	{
		private static var Instance:FilePool = new FilePool;
		public static function getInstance():FilePool {
			return Instance;
		}
		public function FilePool() 
		{
			
		}
		
		
	}
	
}