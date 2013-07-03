package com.as3long.utils
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import org.flashdevelop.utils.FlashConnect;
	import flash.utils.setTimeout;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	
	/**
	 * 可视对象工具类
	 * @author 黄龙
	 */
	public class DisplayUtil
	{
		
		public function DisplayUtil()
		{
		
		}
		
		public static function removeAll(container:MovieClip):void
		{
			while (container.numChildren > 0)
			{
				container.removeChildAt(0);
			}
		}
		
		/**
		 * 变灰
		 * @param	child
		 */
		public static function applyGray(child:DisplayObject):void
		{
			var matrix:Array = new Array();
			matrix = matrix.concat([0.3086, 0.6094, 0.0820, 0, 0]); // red
			matrix = matrix.concat([0.3086, 0.6094, 0.0820, 0, 0]); // green
			matrix = matrix.concat([0.3086, 0.6094, 0.0820, 0, 0]); // blue
			matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
			applyFilter(child, matrix);
		}
		
		/**
		 * 添加滤镜
		 * @param	child
		 * @param	matrix
		 */
		private static function applyFilter(child:DisplayObject, matrix:Array):void
		{
			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			var filters:Array = new Array();
			filters.push(filter);
			child.filters = filters;
		}
		
		/**
		 * 移除滤镜
		 * @param	child
		 */
		public static function removeFilter(child:DisplayObject)
		{
			child.filters = [];
		}
		
		/**
		 * 抖一下
		 * @param	dis 可视对象
		 * @param	times 次数
		 * @param	offset 偏移量
		 * @param	speed 速度
		 */
		public static function shake(dis:DisplayObject, times:uint = 4, offset:uint = 4, speed:uint = 32):void
		{
			var point:Point = new Point(dis.x, dis.y);
			var offsetXYArray:Array = [0, 0];
			var num:int = 0;
			var u:int = setInterval(function():void
				{
					offsetXYArray[num % 2] = (num++) % 4 < 2 ? 0 : offset;
					if (num > (times * 4 + 1))
					{
						clearInterval(u);
						num = 0;
					}
					dis.x = offsetXYArray[0] + point.x;
				//dis.y = offsetXYArray[1] + point.y;
				}, speed);
		}
	
	}

}