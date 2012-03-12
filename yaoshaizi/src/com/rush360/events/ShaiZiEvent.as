package com.rush360.events 
{
	import flash.events.Event;
	
	/**
	 * 骰子事件
	 * @author huanglong
	 */
	public class ShaiZiEvent
	{
		/**
		 * 聊天数据发生改变
		 */
		public static const CHAR_DATA_ADD_STRING:String = 'CharDataAddString';
		
		/**
		 * 发送聊天信息
		 */
		public static const SPRAKCHARVIEW_SENDSTRING:String = 'SprakCharView_SendString';
		
		/**
		 * 骰子数据发生改变
		 */
		public static const DICE_MODEL_CHANGE:String = 'Dice_model_change';
		
		/**
		 * 用户列表发生改变
		 */
		public static const USER_LIST_CHANGE:String = 'user_list_change';
		
		/**
		 * 房间列表发生改变
		 */
		public static const ROOM_LIST_CHANGE:String = 'room_list_change';
		public function ShaiZiEvent() 
		{ 
			
		}
		
	}
	
}