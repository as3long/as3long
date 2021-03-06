package com.rush360.models 
{
	import com.rush360.events.ShaiZiEvent;
	import org.weemvc.as3.model.IModel;
	import org.weemvc.as3.model.Model;
	
	/**
	 * 骰子模型
	 * @author huanglong
	 */
	public class DiceModel extends Model implements IModel 
	{
		private var _numArr:Array;
		public function DiceModel() 
		{
			
		}
		
		public function get numArr():Array 
		{
			return _numArr;
		}
		
		public function set numArr(value:Array):void 
		{
			_numArr = value;
			trace(value);
			sendWee(ShaiZiEvent.DICE_MODEL_CHANGE, _numArr);
		}
		
		public function getArrString():String
		{
			var arr:Array = _numArr;
			var str:String = '';
			for (var i:int = arr.length - 1; i >= 0; i--)
			{
				if (i != 0)
				{
					str += arr[i] + "|";
				}
				else
				{
					str += arr[i];
				}
			}
			return str;
		}
		
	}

}