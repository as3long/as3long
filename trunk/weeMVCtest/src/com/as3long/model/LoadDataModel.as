package com.as3long.model 
{
	import com.as3long.event.FindLightEvent;
	import org.weemvc.as3.model.Model;
	
	/**
	 * 数据代理
	 * @author huanglong
	 */
	public class LoadDataModel extends Model 
	{
		private var _url:String;
		public function LoadDataModel() 
		{
			
		}
		
		public function get url():String 
		{
			return _url;
		}
		
		public function set url(value:String):void 
		{
			_url = value;
			sendWee(FindLightEvent.SET_PICURL, _url);
		}
		
	}

}