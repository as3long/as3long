package com.as3long.operation.server 
{
	import com.as3long.utils.NumberUtil;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	import ghostcat.debug.Debug;
	import ghostcat.operation.Oper;
	import ghostcat.operation.Queue;
	import ghostcat.util.data.E4XUtil;
	
	[Event(name="socket_oper_data", type="ghostcat.operation.server.SocketDataEvent")]
	/**
	 * Socket服务类。
	 * 
	 * 收到的消息会先读取一个32位的长度值，根据长度值读取一节数据。数据中第一部分是16位的ID，剩下的为实际数据。
	 * 之后会根据opers对象的值，执行相应的命令，将数据发布出去。
	 * 
	 * 1．`g`：包标识符（第1-3位）
	 * 2．00000：包总长度，为5位10进制数字的字符串（第4-8位）
	 * 3．00000000：用户ID，为8位字符串（第9-16位）
	 * 4．tttttttt：TransactionID为8位整型（第17-24位）
	 * 5．xxxxxxxx：效验码主要是为了防止用户模拟包攻击，为4位字符串。（第25-32位）
	 * 7．222222222：发送包的时间（小时，分，秒，毫秒）。为9位10进制数字（第33-41位）
	 * 8.  sta：Beg/con/end    为3为字符（第42-44位）
	 * 9．*dl: ：指令类型，包括人物行动指令，攻击指令等等，为3位字符串（第45-47位）
	 * 10．bbbbbbbbbbbb……：具体操作指令
	 * 
	 * 数据为ByteArray，可以用readObject/writeObject使用AMF序列化数据，也可以用JSON配合writeUTF,reandUTF，也可以传输完全自定义的二进制数据
	 * SocketDataCreater是我写的一个将任意对象序列化成二进制的类
	 * @author flashyiyi
	 * 
	 */
	public class SocketProxy extends EventDispatcher 
	{
		public var socket:Socket;
		
		/**
		 * 指令与id对照表
		 * 格式为：{id:类/函数/字符串}
		 * 函数会被执行，参数为ByteArray数据。
		 * 字符串会被反射为类。
		 * 类会被实例化，构造函数参数为ByteArray数据。
		 */
		public var opers:Object;
		
		/**
		 * 出错时执行的方法
		 */
		public var faultHander:Function;
		
		protected var cache:ByteArray;
		
		public function SocketProxy(host:String,port:int)
		{
			this.socket = new Socket(host, port);
			this.socket.addEventListener(ProgressEvent.SOCKET_DATA,socketDataHandler);
			this.socket.addEventListener(IOErrorEvent.IO_ERROR,onConnectionError);
			this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onConnectionError);
		
			this.cache = new ByteArray();
		}
		
		
		/**
		 * 发送消息 
		 * @param id
		 * @param bytes
		 * 
		 */
		public function operate(uid:int,bytes:ByteArray):void
		{	
			this.socket.writeUTFBytes("`g`");
			this.socket.writeUTFBytes(NumberUtil.pad(48 + bytes.length));
			this.socket.writeUTFBytes(NumberUtil.pad(uid, 8));
			//this.socket.writeUTFBytes('00000893');
			this.socket.writeUTFBytes('04024328');
			this.socket.writeUTFBytes('9fc6d58a');
			var data:Date = new Date();
			//var dateNum:int = data.time*;
			this.socket.writeUTFBytes(NumberUtil.pad(data.hours, 2));
			this.socket.writeUTFBytes(NumberUtil.pad(data.minutes, 2));
			this.socket.writeUTFBytes(NumberUtil.pad(data.seconds, 2));
			this.socket.writeUTFBytes(NumberUtil.pad(data.milliseconds, 3));
			this.socket.writeUTFBytes('endlgn:');
			bytes.position = 0;
			this.socket.writeBytes(bytes,0,bytes.length);
			this.socket.flush();
			trace("发送数据");
		}
		
		protected function socketDataHandler(event:ProgressEvent):void
		{
			socket.readBytes(cache,cache.length);
			cache.position = 0;
			trace(this.cache.readMultiByte(cache.length,'utf8'));
			return;
			var p:int = cache.position;
			while (true)
			{
				//读取长度值
				if (cache.bytesAvailable < 48)
					break;
				var len:uint = this.cache.readUnsignedInt();
				if (len < 2)
					throw new Error("数据长度至少要大于2bytes");
				
				if (cache.bytesAvailable < len)
					break;
				
				//读取id
				var id:uint = cache.readShort();
				//读取数据
				var body:ByteArray = new ByteArray();
				cache.readBytes(body,0,len - 2);
				body.position = 0;
				
				var e:SocketDataEvent = new SocketDataEvent(SocketDataEvent.SOCKET_OPER_DATA);
				e.id = id;
				e.data = body;
				this.dispatchEvent(e);
				
				this.createOper(id,body);
				
				p = cache.position;
			}
			
			//退回到上次读取的位置将剩余的数据留下
			this.cache.position = p;
			var leftBytes:ByteArray = new ByteArray();
			cache.readBytes(leftBytes);
			
			cache = leftBytes;
		}
		
		/**
		 * 执行指令
		 * @param id
		 * @param body
		 * 
		 */
		protected function createOper(id:uint,body:ByteArray):void
		{
			if (!this.opers)
				return;
			
			var oper:* = this.opers[id];
			if (oper is String)
				oper = getDefinitionByName(oper);
			
			if (oper is Class)
			{
				new oper(body);
			}
			else if (oper is Function)
			{
				oper(body);
			}
		}
		
		/**
		 * 获得Oper对应的id
		 * @param oper
		 * @return 
		 * 
		 */
		public function getOperId(oper:*):int
		{
			if (!(oper is Class || oper is Function || oper is String))
				oper = oper["constructor"] as Class;
		
			for (var p:String in opers)
			{
				if (opers[p] == oper)
					return int(p);
			}
			return -1;
		}
		
		protected function onConnectionError(event:Event):void
		{
			if (faultHander != null)
			{
				this.faultHander(event);
			}
			else
			{
				trace(event);
			}
		}
		
		protected function defaultFaultHandler(event:Event):void
		{
			Debug.trace("HTTP","ERROR:" + event);
		}		
		
	}

}