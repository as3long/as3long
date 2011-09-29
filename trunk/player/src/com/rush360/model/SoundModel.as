package com.rush360.model 
{
	import org.weemvc.as3.model.Model;
	
	/**
	 * ...
	 * @author 360rush
	 */
	public class SoundModel extends Model 
	{
		
		public function SoundModel() 
		{
			
		}
		
		/**
		 * 调用此方法将发送名为“第一数据” 的 WeeMVC 事件
		 */
		public function sendData(url:String):void {
			sendWee("soundUrl", url);
		}
	}

}