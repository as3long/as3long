package com.webBase.activeBag.control
{
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author WZH(shch8.com)
	 */
	public class Cache 
	{
		
		private static var Instace:Cache=new Cache;
		private var mySo:SharedObject;
		private const shareName:String="webBase";
		public function Cache(){
		}
		public static function getInstance():Cache {
			return Instace;
		}
		/**
		 * 保存对象
		 * @param	item
		 * @param	id
		 */
		public function saveData(item:Object,id:String):void
		{
			mySo = SharedObject.getLocal(shareName);
			mySo.data[id]=item;
			mySo.flush();
		}
		/**
		 * 清除所有已存储对象
		 */
		public function clearData():void {
			mySo = SharedObject.getLocal(shareName);
			mySo.clear();
		}
		/**
		 * 获取对象
		 * @param	id
		 * @return
		 */
		public function getData(id:String):Object{
			mySo = SharedObject.getLocal(shareName);
			return mySo.data[id]; 
		}

		
	}
	
}