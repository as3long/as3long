package ghostcat.util.core
{
	import flash.utils.setTimeout;
	
	import ghostcat.events.TickEvent;
	import ghostcat.util.Tick;

	/**
	 * 延迟执行并只执行一次
	 * @author flashyiyi
	 * 
	 */
	public class UniqueCall
	{
		/**
		 * 是否刚修改过
		 */
		public var dirty:Boolean = false;
		
		/**
		 * 是否是在下一帧执行
		 */
		public var frame:Boolean = false;
		
		/**
		 * 执行的函数
		 */
		public var handler:Function;
		
		/**
		 * 参数列表
		 */
		protected var para:Array;
		
		private var tick:Tick = Tick.instance;//缓存Tick实例
		
		/**
		 * 
		 * @param handler	执行的函数
		 * @param frame	是否是在下一帧执行
		 */
		public function UniqueCall(handler:Function,frame:Boolean = false)
		{
			this.handler = handler;
			this.frame = frame;
		}
		
		public function invalidate(...para):void
		{
			if (dirty)
				return;
			dirty = true;
			
			this.para = para;
			
			if (frame)
				CallLaterQueue.instance.callLaterByTick(vaildNow);	
			else
				CallLaterQueue.instance.callLaterByTime(vaildNow);	
		}
		
		public function vaildNow():void
		{
			if (para)
				handler.apply(null,para);
			else
				handler();
			
			dirty = false;
			para = null;
		}
		
		public function halt():void
		{
			dirty = false;
			
			if (frame)
				CallLaterQueue.instance.removeCallLaterByTick(vaildNow);	
			else
				CallLaterQueue.instance.removeCallLaterByTime(vaildNow);	
		}
	}
}