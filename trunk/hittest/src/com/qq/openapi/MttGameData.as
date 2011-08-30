package com.qq.openapi
{
	import com.qq.openapi.MttService;
	import com.qq.protocol.ProtocolHelper;
	import com.qq.utils.HttpRequest;
	import com.qq.utils.MEvent;
	import flash.events.Event;
	import flash.utils.ByteArray;

	/**
	 * 	闪游地带开发平台提供KEY-VALUE游戏数据管理API函数的包裹类。
	 * 	<p>为Flash游戏提供数据存储，支持游戏进度以及相关数据的存储，减少Flash游戏开发者对数据存储的成本安全等方面的压力。</p>
	 * 	@author Tencent
	 * 
	 */	
	public class MttGameData
	{
		/**
		 * 	游戏数据获取函数。
		 * 
		 * 	<p>向服务器提交“当前游戏”、“当前玩家”以key值为主键的游戏数据，该key为所有玩家共用的键值。后台存储时重新生成主键，类似于gameid + qq + key。开发者获取游戏数据时，只需传入对应key即可获得已保存的游戏数据。</p>
		 * 	@param key 所有玩家共用的关键字，可为游戏进度，比如“GameProcess”
		 * 	@param value 该key上对应的数据
		 *	@param callback  提交游戏数据后的回调函数
		 * 
		 * 	@example
		 * 	提交游戏数据的回调函数包含一个描述结果的参数result，该参数的数据成员见下面的描述。
		 * 	<p>function callback_function(result:Object):void</p>
		 * 	<p>result.code 	类型为int，表示调用结果返回码，0表示成功，非0表示错误。</p>
		 * 
		 */
		public static function put(key:String, value:ByteArray, callback:Function):void
		{
			MttService.sapi(ProtocolHelper.SetGameDataEncode(key, value), onLoadFinish);
			
			function onLoadFinish(scode:int, data:ByteArray):void
			{
				PutLoadFinish(scode, data, callback);
			}
		}

		/**
		 * 	游戏数据获取函数。
		 * 
		 * 	<p>获取“当前游戏”、“当前玩家”以key值为主键的游戏数据。</p>
		 * 	@param key 所有玩家共用的关键字，可为游戏进度，比如“GameProcess”
		 *	@param callback 获取游戏数据后的回调函数
		 * 
		 * 	@example
		 * 	<p>获取游戏数据的回调函数包含一个描述结果的参数result，该参数的数据成员见下面的描述。</p>
		 * 	<p>function callback_function(result:Object):void</p>
		 * 	<p>result.code 	类型为int，调用返回码，0成功，MttService.ENOENT不存在该key，其他错误；</p>
		 * 	<p>result.value	类型为ByteArray，key上对应的数据；</p>
		 */		
		public static function get(key:String, callback:Function):void
		{
			MttService.sapi(ProtocolHelper.GetGameDataEncode(key), onLoadFinish);

			function onLoadFinish(scode:int, data:ByteArray):void
			{
				GetLoadFinish(scode, data, callback);
			}
		}

		///////////////////////////////////////////////////////////////////////////////////////////
		//	获取数据内部函数
		private static function PutLoadFinish(scode:int, data:ByteArray, callback:Function):void
		{
			if (scode == MttService.ELOGOUT)
			{
				MttService.dispatchEvent(new Event(MttService.ETLOGOUT));
				return ;
			}

			if (scode != 0)
			{
				callback && callback.call(null, {code:scode, desc:""});
				return ;
			}

			var res:Object = ProtocolHelper.SetGameDataDecode(data);
			callback && callback.call(null, {code:res.fcode, desc:"", retcode:res.rsp});
		}

		private static function GetLoadFinish(scode:int, data:ByteArray, callback:Function):void
		{
			if (scode == MttService.ELOGOUT)
			{
				MttService.dispatchEvent(new Event(MttService.ETLOGOUT));
				return ;
			}

			if (scode != 0)
			{
				callback && callback.call(null, {code:scode, desc:""});
				return ;
			}

			var res:Object = ProtocolHelper.GetGameDataDecode(data);
			callback && callback.call(null, {code:res.fcode, desc:"", value:res.rsp});
		}
	}
}
