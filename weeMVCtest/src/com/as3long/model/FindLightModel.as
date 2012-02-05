package com.as3long.model 
{
	import com.as3long.event.FindLightEvent;
	import flash.geom.Rectangle;
	import org.weemvc.as3.model.Model;
	
	/**
	 * 找亮点模型
	 * @author 黄龙
	 */
	public class FindLightModel extends Model 
	{
		private var _picUrl:String = '';
		private var _lightArr:Array = [];
		public function FindLightModel() 
		{
			
		}
		
		public function get picUrl():String 
		{
			return _picUrl;
		}
		
		public function set picUrl(value:String):void 
		{
			_picUrl = value;
			sendWee(FindLightEvent.SET_PICURL, _picUrl);
		}
		
		/**
		 * 添加亮点数据
		 * @param	x 亮点的左上角x
		 * @param	y 亮点的左上角y
		 * @param	width 亮点的宽
		 * @param	height 亮点的高
		 */
		public function addLight(x:Number, y:Number, width:Number, height:Number):void
		{
			var r:Rectangle = new Rectangle(x, y, width, height);
			_lightArr.push(r);
			sendWee(FindLightEvent.ADD_LIGHT, _lightArr);
		}
		
		/**
		 * 移除所有亮点
		 */
		public function removeAllLight():void
		{
			_lightArr = [];
			sendWee(FindLightEvent.REMOVE_ALLLIGHT, _lightArr);
		}
	}

}