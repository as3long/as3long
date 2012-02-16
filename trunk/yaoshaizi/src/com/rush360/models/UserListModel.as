package com.rush360.models 
{
	import com.rush360.events.ShaiZiEvent;
	import org.weemvc.as3.model.IModel;
	import org.weemvc.as3.model.Model;
	
	/**
	 * 用户列表模型
	 * @author huanglong
	 */
	public class UserListModel extends Model implements IModel 
	{
		private var userListArr:Array = [];
		public function UserListModel() 
		{
			
		}
		/**
		 * 添加用户
		 * @param	userInfo 用户信息
		 */
		public function addUser(userInfo:String):void
		{
			if (!checkUser(userInfo))
			{
				userListArr.push(userInfo);
				sendWee(ShaiZiEvent.USER_LIST_CHANGE, userListArr);
			}
		}
		
		private function checkUser(userInfo:String):Boolean
		{
			var returnFleg:Boolean = false;
			for (var i:int = userListArr.length - 1; i >= 0; i--)
			{
				if (userListArr[i] == userInfo)
				{
					returnFleg = true;
					break;
				}
			}
			return returnFleg;
		}
		
		/**
		 * 删除用户
		 * @param	userInfo 用户信息
		 */
		public function removeUser(userInfo:String):void
		{
			for (var i:int = userListArr.length - 1; i >= 0; i--)
			{
				if (userInfo == userListArr[i])
				{
					userListArr.splice(i, 1);
				}
			}
			sendWee(ShaiZiEvent.USER_LIST_CHANGE,userListArr);
		}
	}

}