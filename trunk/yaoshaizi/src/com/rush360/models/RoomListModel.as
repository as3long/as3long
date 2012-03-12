package com.rush360.models 
{
	import org.weemvc.as3.model.IModel;
	import org.weemvc.as3.model.Model;
	import com.rush360.events.ShaiZiEvent;
	/**
	 * 房间列表模型
	 * @author huanglong
	 */
	public class RoomListModel extends Model 
	{
		private var _roomDataArr:Vector.<RoomVO> = new Vector.<RoomVO>();
		public function RoomListModel() 
		{
			
		}
		
		/**
		 * 添加房间
		 * @param	_room 房间信息
		 */
		public function addRoom(_room:RoomVO):void
		{
			if (!checkRoom(_room))
			{
				_roomDataArr.push(_room);
				sendWee(ShaiZiEvent.USER_LIST_CHANGE, _roomDataArr);
			}
		}
		
		public function removeRoom(_room:RoomVO):void
		{
			for (var i:int = _roomDataArr.length - 1; i >= 0; i--)
			{
				if (_roomDataArr[i] == _room)
				{
					_roomDataArr.slice(i, 1);
					break;
				}
			}
		}
		
		private function checkRoom(_room:RoomVO):Boolean
		{
			var returnFleg:Boolean = false;
			for (var i:int = _roomDataArr.length - 1; i >= 0; i--)
			{
				if (_roomDataArr[i] == _room)
				{
					returnFleg = true;
					break;
				}
			}
			return returnFleg;
		}
		
	}

}