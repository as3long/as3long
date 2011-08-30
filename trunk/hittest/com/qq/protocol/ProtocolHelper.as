package com.qq.protocol
{
	import com.qq.openapi.MttService;
	import com.qq.protocol.DataHead;
	import com.qq.protocol.DataHelp;
	
	import flash.utils.ByteArray;

	public class ProtocolHelper
	{
		///////////////////////////////////////////////////////////////////////////////////////////
		//	积分接口编解码
		public static function ScoreEncode(op:int, sc:uint, tp:uint):ByteArray
		{
			var szEncode:ByteArray = new ByteArray();

			DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTBEGIN);
			DataHelp.writeUInt32(szEncode, op, 0);
			DataHelp.writeUInt32(szEncode, sc, 1);
			DataHelp.writeUInt32(szEncode, tp, 2);
			DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTEND);

			return EncodeRequest("s", szEncode);
		}

		public static function ScoreDecode(s:ByteArray):Object
		{
			try
			{
				var ret:Object = DecodeRequest(s);
				if (ret.scode == 0 && ret.fcode == 0)
				{
					var rsp:ScoreRsp = ScoreRsp.readStruct(ret.res, 0, true) as ScoreRsp; 

					return {scode:0, fcode:0, score:rsp.selfScore, board:rsp.vRankScore}; 
				}

				return {scode:ret.scode, fcode:ret.fcode};
			}
			catch (e:Error) { }

			return {scode: MttService.EPDECODE, fcode:MttService.EPDECODE};
		}

		//////////////////////////////////////////////////////////////////////////////////////
		//	KEY-VALUE的设置函数
		public static function SetGameDataEncode(key:String, value:ByteArray):ByteArray
		{
			var szEncode:ByteArray = new ByteArray();

			DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTBEGIN);
			DataHelp.writeString(szEncode, key, 0);
			DataHelp.writeVectorByte(szEncode, value, 1);
			DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTEND);

			return EncodeRequest("sgd", szEncode);
		}

		public static function SetGameDataDecode(s:ByteArray):Object
		{
			try
			{
				var ret:Object = DecodeRequest(s);
				if (ret.scode == 0 && ret.fcode == 0)
				{
					var rsp:Object = PutGameDataRsp.readStruct(ret.res, 0, true) as PutGameDataRsp;

					return {scode:0, fcode:0, rsp:rsp.ret}; 
				}

				return {scode:ret.scode, fcode:ret.fcode};
			}
			catch (e:Error) { }

			return {scode: MttService.EPDECODE, fcode: MttService.EPDECODE};		
		}

		//////////////////////////////////////////////////////////////////////////////////////
		//	KEY-VALUE的读取函数
		public static function GetGameDataEncode(key:String):ByteArray
		{
			var szEncode:ByteArray = new ByteArray();

			DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTBEGIN);
			DataHelp.writeString(szEncode, key, 0);
			DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTEND);

			return EncodeRequest("ggd", szEncode);
		}

		public static function GetGameDataDecode(s:ByteArray):Object
		{
			try
			{
				var ret:Object = DecodeRequest(s);
				if (ret.scode == 0 && ret.fcode == 0)
				{
					var rsp:Object = GetGameDataRsp.readStruct(ret.res, 0, true) as GetGameDataRsp; 

					return {scode:0, fcode:0, rsp:rsp.data}; 
				}

				return {scode:0, fcode:ret.fcode==-6?MttService.ENOENT:ret.fcode};
			}
			catch (e:Error)
			{

			}

			return {scode: 0, fcode: MttService.EPDECODE};				
		}

		///////////////////////////////////////////////////////////////////////////////////////////
		//	URL跳转请求封包
		public static function UrlJumpEncode(url:uint, window:Boolean):ByteArray
		{
			var szEncode:ByteArray = new ByteArray();

			DataHelp.writeUInt32(szEncode, url, 0);
			DataHelp.writeBoolean(szEncode, window, 1);

			return szEncode;
		}

		//////////////////////////////////////////////////////////////////////////////////////
		//	最终协议的打包
		private static function EncodeRequest(sFuncName:String, sBuffer:ByteArray):ByteArray
		{
			var szEncode:ByteArray = new ByteArray(); 
			DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTBEGIN);
			DataHelp.writeUInt32(szEncode, MttService.nversion, 0);
			DataHelp.writeUInt32(szEncode, ++mRequestID, 1);
			DataHelp.writeString(szEncode, sFuncName, 2);
			DataHelp.writeVectorByte(szEncode, sBuffer, 3);
			DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTEND);
			return szEncode;
		}

		private static function DecodeRequest(ist:ByteArray):Object	//返回框架的错误
		{
			try
			{
				var pack:ApiResponse = ApiResponse.readStruct(ist, 0, false);

				return {scode:0, fcode:pack.code, res:pack.data};
			}
			catch (e:Error)	{ }

			return {scode: MttService.EPDECODE, fcode: MttService.EPDECODE};
		}

		private static var mRequestID:uint = 100;
	}
}

import com.qq.openapi.ScoreInfo;
import com.qq.protocol.DataHead;
import com.qq.protocol.DataHelp;
import flash.utils.ByteArray;

///////////////////////////////////////////////////////////////////////////////////////////////////
//	OPENAPISERVER的包裹类
class ApiResponse
{
	public var code:int		= 0;
	public var reqid:uint		= 0;
	public var data:ByteArray	= new ByteArray();

	public static function readFrom(ist:ByteArray):ApiResponse
	{
		var value:ApiResponse 	= new ApiResponse();
		value.code				= DataHelp.readInt32(ist, 0, false);
		value.reqid				= DataHelp.readUInt32(ist, 1, false);
		value.data				= DataHelp.readVectorByte(ist, 2, false);

		return value;
	}

	public static function readStruct(ist:ByteArray, tag:int, require:Boolean):ApiResponse
	{
		return DataHelp.readStruct(ist, tag, require, readFrom) as ApiResponse;
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//	读取积分查询的返回结构体
class ScoreRsp
{
	public var vRankScore	: Array 	= new Array();
	public var selfScore	: ScoreInfo = new ScoreInfo();
	
	public static function readFrom(ist:ByteArray):ScoreRsp
	{
		var value:ScoreRsp 	= new ScoreRsp();
		value.vRankScore	= DataHelp.readVectorObject(ist, 0, false, ScoreInfoReadStruct);
		value.selfScore		= ScoreInfoReadStruct(ist, 1, false);
		return value;
	}

	public static function readStruct(ist:ByteArray, tag:int, require:Boolean):ScoreRsp
	{
		return DataHelp.readStruct(ist, tag, require, readFrom) as ScoreRsp;
	}

	private static function ScoreInfoReadFrom(ist:ByteArray):ScoreInfo
	{
		var value:ScoreInfo = new ScoreInfo();
		value.nickName=DataHelp.readString(ist, 0, false);
		value.score=DataHelp.readInt64(ist, 1, false);
		value.playTime=DataHelp.readInt64(ist, 2, false);
		value.rank = DataHelp.readUInt32(ist, 3, false);
		return value;
	}

	private static function ScoreInfoReadStruct(ist:ByteArray, tag:int, require:Boolean):ScoreInfo
	{
		return DataHelp.readStruct(ist, tag, require, ScoreInfoReadFrom) as ScoreInfo;
	} 
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//	设置KEY-VALUE的返回结构体
class PutGameDataRsp
{
	public var ret:int = 0;

	public static function readFrom(ist:ByteArray):PutGameDataRsp
	{
		var value:PutGameDataRsp 	= new PutGameDataRsp();
		value.ret					= DataHelp.readInt32(ist, 0, false);

		return value;
	}

	public static function readStruct(ist:ByteArray, tag:int, require:Boolean):PutGameDataRsp
	{
		return DataHelp.readStruct(ist, tag, require, readFrom) as PutGameDataRsp;
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//	读取KEY-VALUE的返回结构体
class GetGameDataRsp
{
	public var data:ByteArray = new ByteArray();

	public static function readFrom(ist:ByteArray):GetGameDataRsp
	{
		var value:GetGameDataRsp 	= new GetGameDataRsp();
		value.data					= DataHelp.readVectorByte(ist, 0, true);

		return value;
	}

	public static function readStruct(ist:ByteArray, tag:int, require:Boolean):GetGameDataRsp
	{
		return DataHelp.readStruct(ist, tag, require, readFrom) as GetGameDataRsp;
	}
}
