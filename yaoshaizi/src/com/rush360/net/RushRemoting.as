package com.rush360.net
{
	import com.rush360.events.RushEvent;
	import flash.display.GraphicsSolidFill;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.utils.describeType;
	import ghostcat.operation.server.RemotingProxy;
	
	/**
	 * ...
	 * @author 360rush
	 */
	public class RushRemoting extends NetConnection
	{
		/**
		 * 单例
		 */
		private static var _i:RushRemoting;
		
		/**
		 * AMFPHP的基础路径
		 */
		private var _baseUrl:String = "";
		
		public function RushRemoting()
		{
		
		}
		
		/**
		 * 获取AMFPHP的基础路径
		 */
		public function get baseUrl():String
		{
			return _baseUrl;
		}
		
		/**
		 * 设置AMDPHP的基础路径,设置完成已经开始连接
		 */
		public function set baseUrl(value:String):void
		{
			_baseUrl = value;
			this.connect(_baseUrl);
			this.addEventListener(NetStatusEvent.NET_STATUS, NetStatus);
		}
		
		private function NetStatus(e:NetStatusEvent):void 
		{
			trace(e.toString());
		}
		
		public function gateway(eventString:String, result:Function = null, faild:Function = null, ... arg):void
		{
			if (faild == null)
			{
				faild = rush_faild;
			}
			if (result == null)
			{
				result = rush_result;
			}
			this.call(eventString, new Responder(result, faild), arg);
		}
		
		public function rush_faild(result:*):void
		{
			trace("连接失败");
			trace(result);
		}
		
		public function rush_result(result:*):void
		{
			trace("连接成功");
			trace(result);
			//var data:Date = new Date();
			//trace(data.fullYear, data.month, data.date, data.day, data.hours, data.minutes, data.seconds);
			//data.setTime(result);
			//trace(data.fullYear, data.month, data.date, data.day, data.hours, data.minutes, data.seconds);
		}
		
		public static function getInstance():RushRemoting
		{
			if (_i == null)
			{
				_i = new RushRemoting();
			}
			return _i;
		}
	}

}