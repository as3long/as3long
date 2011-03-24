package com.rush360.model 
{
	/**
	 * ...
	 * @author ...
	 */
	public class UserModel 
	{
		public var userDetail:Object;
		
		public var allocation:Object;
		
		public var friendDetail:Object;
		
		public function UserModel() 
		{
			
		}
		
		/**
		 * 单例引用
		 */
		public static function get instance():UserModel
		{
			if(_instance == null)
			{
				_instance = new UserModel();
			}
			return _instance;
		}
		
		private static var _instance:UserModel = null;
	}

}