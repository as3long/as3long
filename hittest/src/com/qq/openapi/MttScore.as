package com.qq.openapi
{
	import com.qq.openapi.MttService;
	import com.qq.protocol.ProtocolHelper;
	import flash.events.Event;
	import flash.utils.ByteArray;


	/**
	 * 	闪游地带开发平台提供积分管理API函数的包裹类。
	 * 	<p>支持Flash游戏结束后的用户积分上传，以支持游戏积分排行榜、好友积分排行榜的运营。</p>
	 * 	@author Tencent
	 * 
	 */	
	public class MttScore
	{
		/**
		 *	提交“当前游戏”、“当前玩家”的游戏积分。
		 *  <p>本次请求成功或者失败，以参数形式传入的回调函数callback都将被调用。开发者可在该函数中判断调用结果，并取得当前玩家的积分数据。</p>
		 * 	@param score 玩家本次游戏的总积分
		 * 	@param callback 提交积分的回调函数
		 * 
		 * 	@example
		 * 	<p>提交积分的回调函数包含一个描述积分结果的参数result，该参数的数据成员见下面的描述。</p>
		 * 	<p>function callback_function(result:Object):void</p>
		 * 	<p>result.code 	类型为int，表示调用结果返回码，0表示成功，非0表示错误。</p>
		 * 	<p>result.score	类型为com.qq.openapi.ScoreInfo，包含当前玩家在本游戏中的积分情况。</p>
		 *	<p>class ScoreInfo</p>
		 * 	<p>{</p>
		 * 	<p>    public var nickName:String = "";    //当前用户的QQ昵称</p>
		 * 	<p>    public var score:Number = 0;        //当前用户的当前游戏的最高积分</p>
		 * 	<p>    public var playTime:Number = 0;     //提交本次积分的时间戳，单位秒</p>
		 * 	<p>    public var rank:uint = 0;           //当前玩家的积分排名.</p>
		 * 	<p>};</p>
		 * 
		 * 	@see com.qq.openapi.ScoreInfo
		 */
		public static function submit(score:uint, callback:Function):void
		{
			MttService.sapi(ProtocolHelper.ScoreEncode(1, score, 0), onLoadFinish);

			function onLoadFinish(scode:int, data:ByteArray):void
			{
				LoadFinish(scode, data, callback);	
			}
		}

		/**
		 *	查询“当前游戏”、“当前玩家TOP10好友”的游戏积分列表。
		 *  <p>本次请求成功或者失败，以参数形式传入的回调函数callback都将被调用。开发者可在该函数中判断调用结果，并取得当前玩家的积分数据。</p> 
		 * @param callback 查询积分的回调函数
		 * 
		 */
		public static function query(callback:Function):void
		{
			MttService.sapi(ProtocolHelper.ScoreEncode(2, 0, 10), onLoadFinish);

			function onLoadFinish(scode:int, data:ByteArray):void
			{
				LoadFinish(scode, data, callback);	
			}
		}

		///////////////////////////////////////////////////////////////////////////////////////////
		//	上传积分的响应函数
		private static function LoadFinish(scode:int, data:ByteArray, callback:Function):void
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

			var res:Object = ProtocolHelper.ScoreDecode(data);
			callback && callback.call(null, {code:res.fcode, desc:"", score:res.score, board:res.board});
		}
	}
}
