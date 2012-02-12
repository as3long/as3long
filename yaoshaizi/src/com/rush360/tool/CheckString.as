package com.rush360.tool
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * 字符串检查类
	 * @author huanglong
	 */
	public class CheckString
	{
		private var _keyArr:Vector.<String> = new Vector.<String>();
		
		public function CheckString()
		{
		
		}
		
		public function init():void
		{
			var custom_loader:URLLoader = new URLLoader();
			custom_loader.addEventListener(Event.COMPLETE, custom_load);
			custom_loader.load(new URLRequest("keywords.txt"));
		}
		
		private function custom_load(e:Event):void
		{
			var txt:String = e.currentTarget.data;
			var t_rep:RegExp = new RegExp("\\r\\n", "gi");
			txt = txt.replace(t_rep, "|")
			var arr:Array = txt.split("|");
			var len:int = arr.length;
			for (var i:int = 0; i < len; i++)
			{
				_keyArr.push(arr[i]);
			}
			trace('加载完成')
		}
		
		public function check(st1:String):String
		{
			if (_keyArr.length == 0)
			{
				return st1;
			}
			if (st1 != "" && st1 != null)
			{
				for (var i:int = 0; i < _keyArr.length; i++)
				{
					var t_rep:RegExp = new RegExp(_keyArr[i], "gi");
					st1 = st1.replace(t_rep, "神马");
				}
			}
			
			return st1;
		}
		
		private static var _instance:CheckString;
		public static function getInstance():CheckString
		{
			if (_instance == null)
			{
				_instance = new CheckString();
			}
			return _instance;
		}
	
	}

}