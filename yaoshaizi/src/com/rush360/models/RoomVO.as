package com.rush360.models 
{
	/**
	 * 房间信息
	 * @author huanglong
	 */
	public class RoomVO 
	{
		/**
		 * 房间id
		 */
		public var roomId:int = 0;
		/**
		 * 房间玩家数
		 */
		public var roomUserNum:int = 0;
		/**
		 * 房间最大玩家数
		 */
		public var roomMaxUserNum:int = 5;
		/**
		 * 房间说明
		 */
		public var roomInfo:String = '摇色子';
		/**
		 * 房间玩家信息数组
		 */
		public var roomUserArr:Array = [];
		public function RoomVO() 
		{
			
		}
		
	}

}