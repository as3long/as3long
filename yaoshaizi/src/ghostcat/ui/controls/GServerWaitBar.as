package ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	
	import ghostcat.util.load.LoadHelper;
	
	[Event(name="complete",type="flash.events.Event")]
	[Event(name="io_error",type="flash.events.IOErrorEvent")]
	
	/**
	 * 等待服务器返回时显示的提示，将不显示进度
	 * 
	 * 标签规则：和进度条相同
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GServerWaitBar extends GPercentBar
	{
		/**
		 * 加载完成文字
		 */
		public var loadCompleteText:String = "加载完成";
		
		/**
		 * 加载失败文字 
		 */
		public var loadFailText:String = "加载失败";
		
		protected var loadHelper:LoadHelper;
		
		public function GServerWaitBar(skin:*=null, replace:Boolean=true, fields:Object=null)
		{
			super(skin, replace, null, fields);
		}
		
		protected var _target:EventDispatcher;
		
		/**
		 * 设置进度条目标。请在加载器的load方法执行前设置。
		 * 
		 * @return 
		 * 
		 */
		public function get target():EventDispatcher
		{
			return _target;
		}
		
		public function set target(v:EventDispatcher):void
		{
			if (_target == v)
				return;
			
			if (loadHelper)
			{
				loadHelper.removeEventListener(Event.COMPLETE,completeHandler);
				loadHelper.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
				loadHelper.destory();
			}
			_target = v;
			
			loadHelper = new LoadHelper(_target);
			loadHelper.addEventListener(Event.COMPLETE,completeHandler);
			loadHelper.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
		}
		
		protected function completeHandler(event:Event):void
		{
			label = loadCompleteText;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			label = loadFailText;
			
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR))
		}
	}
}