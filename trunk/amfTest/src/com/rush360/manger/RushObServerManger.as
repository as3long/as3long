package com.rush360.manger 
{
	import com.rush360.i.IObservable;
	import com.rush360.i.IobServer;
	
	/**
	 * ...
	 * @author 360rush
	 */
	public class RushObServerManger implements IObservable 
	{
		private var _obServersArr:Vector.<IobServer>;
		public function RushObServerManger() 
		{
			_obServersArr = new Vector.<IobServer>();
		}
		
		/* INTERFACE com.rush360.i.IObservable */
		
		/**
		 * @copy	com.rush360.i.IObservable#addObServer()
		 */
		public function addObServer(obServer:IobServer):void 
		{
			_obServersArr.push(obServer);
		}
		
		/**
		 * @copy	com.rush360.i.IObservable#removeObServer()
		 */
		public function removeObServer(obServer:IobServer):void 
		{
			var obLength:int = _obServersArr.length;
			var i:int = 0;
			for (i = 0; i < obLength; i++)
			{
				if (_obServersArr[i] == obServer)
				{
					_obServersArr.splice(i, 1);
					break;
				}
			}
		}
		
		/**
		 * @copy	com.rush360.i.IObservable#notifyObServers()
		 */
		public function notifyObServers(msg:String):void 
		{
			var obLength:int = _obServersArr.length;
			var i:int = 0;
			for (i = 0; i < obLength; i++)
			{
				_obServersArr[i].notify(msg);
			}
		}
		
		private static var _i:RushObServerManger;
		/**
		 * 观察者管理类单例
		 */
		public static function get i():RushObServerManger
		{
			if (_i == null)
			{
				_i = new RushObServerManger();
			}
			return _i;
		}
	}

}