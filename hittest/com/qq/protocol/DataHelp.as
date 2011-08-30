package com.qq.protocol
{
	import flash.utils.ByteArray;

	public class DataHelp
	{
		//基本数据类型的读取和写入函数
		public static function writeBoolean(ost:ByteArray, value:Boolean, tag:int):void
		{
			writeInt8(ost, value?1:0, tag);
		}

		public static function writeInt8	(ost:ByteArray, value:int, tag:int):void
		{
			if (value == 0)
			{
				DataHead.writeTo(ost, tag, DataHead.EM_ZERO);	
			}
			else
			{
				DataHead.writeTo(ost, tag, DataHead.EM_INT8);
				ost.writeByte(value);
			}
		}

		public static function writeUInt8(ost:ByteArray, value:int, tag:int):void
		{
			writeInt16(ost, value, tag);
		}
		
		public static function writeInt16(ost:ByteArray, value:int, tag:int):void
		{
			if (value >= -128 && value <= 127)
			{
				writeInt8(ost, value, tag);
			}
			else
			{
				DataHead.writeTo(ost, tag, DataHead.EM_INT16);
				ost.writeShort(value);
			}
		}
		
		public static function writeUInt16(ost:ByteArray, value:int, tag:int):void
		{
			writeInt32(ost, value, tag);
		}
		
		public static function writeInt32(ost:ByteArray, value:int, tag:int):void 
		{
			if (value >= -32768 && value <= 32767)
			{
				writeInt16(ost, value, tag);
			}
			else
			{
				DataHead.writeTo(ost, tag, DataHead.EM_INT32);
				ost.writeInt(value);
			}
		}
		
		public static function writeUInt32(ost:ByteArray, value:uint, tag:int):void
		{
			if (value <= int.MAX_VALUE)
			{
				writeInt32(ost, value, tag);
			}
			else
			{
				DataHead.writeTo(ost, tag, DataHead.EM_INT64);
				ost.writeInt(0);
				ost.writeInt(value);
			}
		}
		
		public static function writeInt64(ost:ByteArray, value:Number, tag:int):void
		{
			if (value >= int.MIN_VALUE && value <= int.MAX_VALUE)
			{
				writeInt32(ost, value, tag);
			}
			else
			{
				var h:int = value / (uint.MAX_VALUE + 1);
				var l:int = value % (uint.MAX_VALUE + 1);
				
				DataHead.writeTo(ost, DataHead.EM_INT64, tag);
				ost.writeInt(h);
				ost.writeInt(l);
			}
		}

		public static function writeString(ost:ByteArray, value:String, tag:int):void
		{
			if (value.length < 255)
			{
				DataHead.writeTo(ost, tag, DataHead.EM_STRING1);
				ost.writeByte(value.length);
			}
			else
			{
				DataHead.writeTo(ost, tag, DataHead.EM_STRING4);
				ost.writeInt(value.length);
			}

			ost.writeMultiByte(value, "cn-gb");
		}	
		
		public static function writeStruct(ost:ByteArray, value:Object, tag:int):void
		{
			DataHead.writeTo(ost, tag, DataHead.EM_STRUCTBEGIN);	
			value.writeTo(ost);
			DataHead.writeTo(ost,   0, DataHead.EM_STRUCTEND);
		}

		//对应vector<char>
		public static function writeVectorByte(ost:ByteArray, value:ByteArray, tag:int):void
		{
			DataHead.writeTo(ost, tag, DataHead.EM_SIMPLELIST);
			DataHead.writeTo(ost,   0, DataHead.EM_INT8);
			writeInt32(ost, value.length, 0);
			ost.writeBytes(value, 0, value.length);
		}

		public static function writeVectorObject(ost:ByteArray, value:Array, tag:int, wFunc:Function):void
		{
			DataHead.writeTo(ost, tag, DataHead.EM_LIST);
			writeInt32(ost, value.length, 0);
			for (var i:int = 0; i < value.length; i++)
			{
				wFunc(ost, value[i], 0);
			}
		}

		public static function writeMap(ost:ByteArray, key:Array, value:Array, tag:int, wFuncF:Function, wFuncS:Function):void
		{
			DataHead.writeTo(ost, tag, DataHead.EM_MAP);
			writeInt32(ost, key.length, 0);

			for (var i:int = 0; i < key.length; i++)
			{
				wFuncF(ost, key[i], 0);
				wFuncS(ost, value[i], 1);
			}
		}

		///////////////////////////////////////////////////////////////////////////////////////////
		//	二进制协议读取函数
		public static function readBoolean	(ist:ByteArray, tag:int, require:Boolean = true):Boolean
		{
			return 	readInt8(ist, tag, require) == 1?true:false;
		}

		public static function readInt8		(ist:ByteArray, tag:int, require:Boolean = true):int
		{
			if (skipToTag(ist, tag))
			{
				h.readFrom(ist);

				switch (h.type)
				{
					case DataHead.EM_ZERO:	return 0;
					case DataHead.EM_INT8:	return ist.readByte();
					default: throw new Error("read int8 type mismatch, tag:" + tag + ", get type:" + h.type);
				}
			}
			else if (require)
			{
				throw new Error("require field not exist, tag:" + tag);
			}

			return 0;
		}

		public static function readInt16		(ist:ByteArray, tag:int, require:Boolean = true):int
		{
			if (skipToTag(ist, tag))
			{
				h.readFrom(ist);

				switch (h.type)
				{
					case DataHead.EM_ZERO	:	return 0;
					case DataHead.EM_INT8	:	return ist.readByte();
					case DataHead.EM_INT16	:	return ist.readShort();
					default				:	throw new Error("read int16 type mismatch, tag:" + tag + ", get type:" + h.type);
				}
			}
			else if (require)
			{
				throw new Error("require field not exist, tag:" + tag);
			}
			
			return 0;
		}
		
		public static function readInt32(ist:ByteArray, tag:int, require:Boolean = true):int
		{
			if (skipToTag(ist, tag))
			{
				h.readFrom(ist);
				
				switch (h.type)
				{
					case DataHead.EM_ZERO	:	return 0;
					case DataHead.EM_INT8	:	return ist.readByte();
					case DataHead.EM_INT16	:	return ist.readShort();
					case DataHead.EM_INT32	:	return ist.readInt();
					default				:	throw new Error("read int32 type mismatch, tag:" + tag + ", get type:" + h.type);
				}
			}
			else if (require)
			{
				throw new Error("require field not exist, tag:" + tag);
			}

			return 0;
		}

		public static function readUInt32(ist:ByteArray, tag:int, require:Boolean):uint
		{
			var num:Number = readInt64(ist, tag, require);
			return uint(num);
		}

		public static function readInt64(ist:ByteArray, tag:int, require:Boolean):Number
		{
			if (skipToTag(ist, tag))
			{
				h.readFrom(ist);

				switch (h.type)
				{
					case DataHead.EM_ZERO	:	return 0;
					case DataHead.EM_INT8	:	return ist.readByte();
					case DataHead.EM_INT16	:	return ist.readShort();
					case DataHead.EM_INT32	:	return ist.readInt();
					case DataHead.EM_INT64	:	
												var hi:uint = ist.readInt();
												var lo:uint = ist.readInt();
												return hi * (uint.MAX_VALUE + 1) + lo;
					default:					throw new Error("read int64 type mismatch, tag:" + tag + ", get type:" + h.type)
				}
			}
			else if (require)
			{
				throw new Error("require field not exist, tag:" + tag);
			}

			return 0;
		}

		public static function readString(ist:ByteArray, tag:int, require:Boolean):String
		{
			if (skipToTag(ist, tag))
			{
				h.readFrom(ist);
				
				switch (h.type)
				{
					case DataHead.EM_STRING1:
					{
						var len:int = ist.readByte();
						if (len<0 && len > -255) len = 256 + len;

						return ist.readMultiByte(len, "utf-8");
					}
					break;
					case DataHead.EM_STRING4:
					{
						len = ist.readInt();

						return ist.readMultiByte(len, "utf-8");
					}
					break;
					default:
					{
						throw new Error("read int64 type mismatch, tag:" + tag + ", get type:" + h.type)
					}
				}
			}
			else if (require)
			{
				throw new Error("require field not exist, tag:" + tag);
			}
			
			return null;
		}

		public static function readStruct(ist:ByteArray, tag:int, require:Boolean, readFrom:Function):Object
		{
			var value:Object = null;
			
			if (skipToTag(ist, tag))
			{
				h.readFrom(ist);
				if (h.type != DataHead.EM_STRUCTBEGIN)
				{
					throw new Error("read struct type mismatch, tag: " + tag + ", get type:" + h.type);
				}

				value = readFrom(ist);

				skipToStructEnd(ist);
			}
			else if (require)
			{
				throw new Error("require field not exist, tag:" + tag);
			}

			return value;
		}

		//对应vector<char>
		public static function readVectorByte(ist:ByteArray, tag:int, require:Boolean = true):ByteArray
		{
			var value:ByteArray = new ByteArray();

			if (skipToTag(ist, tag))
			{
				h.readFrom(ist);
			
				switch (h.type)
				{
					case DataHead.EM_SIMPLELIST:
					{
						var hh:DataHead = new DataHead();
						hh.readFrom(ist);
						
						if (hh.type != DataHead.EM_INT8)
						{
							throw new Error("type mismatch, tag:" + tag + ",type:" + h.type + "," + hh.type);
						}
						
						var len:int = readInt32(ist, 0, true);
						if (len < 0)
						{
							throw new Error("invalid size, tag:" + tag + ",type:" + h.type + "," + hh.type);
						}
					
						ist.readBytes(value, 0, len);
						break;
					}
					case DataHead.EM_LIST:
					{
						len = readInt32(ist, 0, true);
						if (len < 0)
						{
							throw new Error("invalid size, tag:" + tag + ",type:" + h.type + "," + hh.type);
						}
						for (var i:int = 0; i < len; ++i)
							value.writeByte(readInt8(ist, 0, true));
					}
					default:
					{
						throw new Error("type mismatch, tag:" + tag + ",type:" + h.type );
					}
				}
			}
			else if (require)
			{
				throw new Error("require field not exist, tag:" + tag);
			}

			value.position = 0;
			return value;
		}

		public static function readVectorObject(ist:ByteArray, tag:int, require:Boolean, rFunc:Function):Array
		{
			var value:Array;
			
			if (skipToTag(ist, tag))
			{
				h.readFrom(ist);
				
				switch (h.type)
				{
					case DataHead.EM_LIST:
					{
						value = new Array();
						
						var len:int = readInt32(ist, 0, true);
						if (len < 0)
						{
							throw new Error("invalid size, tag:" + tag + ",type:" + h.type);
						}
						for (var i:int = 0; i < len; ++i)
						{
							value.push(rFunc(ist, 0, true));
						}
					}
						break;
					default:
					{
						throw new Error("type mismatch, tag:" + tag + ",type:" + h.type );
					}
				}
			}
			else if (require)
			{
				throw new Error("require field not exist, tag:" + tag);
			}

			return value;
		}

		//IDataInput和IDataOutput的操作函数
		//跳到指定的tag的数据之前
		public static function skipToTag(ist:ByteArray, tag:int):Boolean 
		{
			while (ist.position < ist.length)
			{
				var len:int = h.peekFrom(ist);

				if (tag <= h.tag || h.type == DataHead.EM_STRUCTEND)
				{
					return h.type == DataHead.EM_STRUCTEND?false:(tag == h.tag);
				}

				ist.position = ist.position + len;
				skipField(ist, h.type);
			}
			return false;
		}
		
		public static function skipField(ist:ByteArray, type:int):void
		{
			switch (type)
			{
				case DataHead.EM_INT8			: ist.position += 1; 				break;
				case DataHead.EM_INT16			: ist.position += 2;				break;
				case DataHead.EM_INT32			: ist.position += 4;				break;
				case DataHead.EM_STRING1		: ist.position += ist.readByte(); 	break;
				case DataHead.EM_STRING4		: ist.position += ist.readInt();	break;
				case DataHead.EM_STRUCTBEGIN	: skipToStructEnd(ist);				break; 
				case DataHead.EM_STRUCTEND		:
				case DataHead.EM_ZERO			: break;
				
				case DataHead.EM_SIMPLELIST		:
				{
					var h:DataHead = new DataHead();
					h.readFrom(ist);
					if (h.type != DataHead.EM_INT8)
					{
						throw new Error("skipField with invalid type, type value: " + type + "," + h.type);
					}
				
					ist.position += readInt32(ist, 0, true);
				}
				break;

				case DataHead.EM_LIST			:
				{
					h = new DataHead();
					var size:int = readInt32(ist, 0, true);
					for (var i:int = 0; i < size; ++i)
					{
						h.readFrom(ist);
						skipField(ist, h.type);
					}
				}
				break;

				default						: throw new Error("skipField with invalid type, type value: " + type);
			}
		}
		
		public static function skipToStructEnd(ist:ByteArray):void
		{
			do
			{
				h.readFrom(ist);
				
				skipField(ist, h.type);
			}
			while (h.type != DataHead.EM_STRUCTEND);
		}
		
		public static var h:DataHead 	= new DataHead();
		
	}
}
