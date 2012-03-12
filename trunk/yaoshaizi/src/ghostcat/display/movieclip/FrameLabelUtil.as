package ghostcat.display.movieclip
{
	import flash.display.FrameLabel;

	/**
	 * 处理帧标签的方法
	 * @author flashyiyi
	 * 
	 */
	public final class FrameLabelUtil
	{
		/**
		 * 从一个对象中创建
		 * 
		 * @param obj	键为帧标签，值为开始帧数（以1开始）
		 * @return 
		 * 
		 */
		public static function createFromObject(obj:Object):Array
		{
			var result:Array = [];
			for (var key:String in obj)
			{
				var f:FrameLabel = new FrameLabel(key,obj[key]);
				result.push(f);
			}
			result.sortOn("frame",Array.NUMERIC);
			return result;
		}
		
		/**
		 * 获得FrameLabel数组的标签 
		 * @param list
		 * @return 
		 * 
		 */
		public static function getLabels(list:Array):Array
		{
			var result:Array = [];
			for (var i:int = 0;i < list.length;i++)
			{
				var f:FrameLabel = list[i] as FrameLabel;
				result.push(f.name);
			}
			return result;
		}
	}
}