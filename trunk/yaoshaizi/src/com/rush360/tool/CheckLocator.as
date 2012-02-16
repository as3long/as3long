package com.rush360.tool 
{
	import org.weemvc.as3.core.WeemvcLocator;
	/**
	 * 字符串检查集合类
	 * @author huanglong
	 */
	public class CheckLocator extends WeemvcLocator
	{
		
		private var arr:Array = [];
		public function CheckLocator() 
		{
			
		}
		
		/**
		 * 添加字符检测类
		 * @param	checkClass
		 */
		public function addCheck(checkClass:Class):void
		{
			if (!hasCheck(checkClass))
			{
				var check:ICheck = new checkClass();
				add(checkClass, check);
				arr.push(checkClass);
			}
		}
		
		/**
		 * 执行所有检测
		 * @param	str 需要检测的字符
		 * @return 检测或者需要加密的字符
		 */
		public function checkAll(str:String):String
		{
			for (var i:int = arr.length - 1; i >= 0; i-- )
			{
				str=getCheck(arr[i]).setData(str);
			}
			return str;
		}
		
		/**
		 * 是否存在字符检测类
		 * @param	checkClass
		 * @return
		 */
		public function hasCheck(checkClass:Class):Boolean
		{
			return hasExists(checkClass);
		}
		
		public function removeCheck(checkClass:Class):void
		{
			if (hasCheck(checkClass))
			{
				remove(checkClass);
				for (var i:int = arr.length - 1; i >= 0; i-- )
				{
					if (checkClass == arr[i])
					{
						arr.splice(i, 1);
					}
				}
			}
		}
		
		public function getCheck(checkClass:Class):ICheck
		{
			return retrieve(checkClass);
		}
		
		private static var _instance:CheckLocator;
		public static function getInstance():CheckLocator
		{
			if (_instance == null)
			{
				_instance = new CheckLocator();
			}
			return _instance;
		}
	}

}