package com.rush360.models 
{
	import com.rush360.actions.ProxySendData;
	import com.rush360.events.ShaiZiEvent;
	import com.rush360.tool.CheckString;
	import org.weemvc.as3.model.IModel;
	import org.weemvc.as3.model.Model;
	
	/**
	 * 聊天模型
	 * @author huanglong
	 */
	public class CharModel extends Model implements IModel 
	{
		private var _allString:String;
		public function CharModel() 
		{
			
		}
		
		public function get allString():String 
		{
			return _allString;
		}
		
		public function addString(str:String):void
		{
			str += '\n';
			_allString += str;
			
			sendWee(ShaiZiEvent.CHAR_DATA_ADD_STRING,str);
		}
		
		public function set allString(value:String):void 
		{
			_allString = value;
		}
		
	}

}