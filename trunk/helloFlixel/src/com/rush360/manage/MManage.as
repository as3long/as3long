package com.rush360.manage 
{
	/**
	 * ...主管理类
	 * @author 360rush
	 */
	public class MManage 
	{
		/**
		 * 单例
		 */
		private static var _g:MManage;
		
		public var gameState:GameState = new GameState();
		public var winState:WinState = new WinState();
		public var gameStartTime:Date;
		public var gameOverTime:Date;
		public function MManage() 
		{
			
		}
		
		public static function get instance():MManage
		{
			if (_g == null)
			{
				_g = new MManage();
			}
			return _g;
		}
	}

}