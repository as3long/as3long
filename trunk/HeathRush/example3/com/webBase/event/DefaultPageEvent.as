package com.webBase.event 
{
	import flash.events.Event;
	
	/**
	 * 打开默认页，也许你有这样的需求，当用户使用的你域名(www.xxx.com)进入网站，这时由于没有子页(比如这样的新闻子页www.xx.com/#/news)
	 * <br>你可以通过这个事件，去执行你特定的命令，比如，你可以在这里打开一个关于我们的默认页
	 * <br>例：
	 * <br>this.addEventListener(DefaultPageEvent.DEFAULT_PAGE, defaultPage);
	 * <br>private function defaultPage(event:DefaultPageEvent):void
		<br>{
		<br>	openPage("about");//默认会自动打开关于我们的页面
		<br>}
		
	 * @author WZH(shch8.com)
	 * 
	 */
	public class DefaultPageEvent extends Event
	{
		/**
		 * 触发默认页面的打开
		 */
		public static var DEFAULT_PAGE:String = "defaultPage";
		/**
		 * 使用指定参数创建新的 DefaultPageEvent 对象。 
		 * @param	type 事件类型；该值指示引发事件的动作。 
		 */
		public function DefaultPageEvent(type:String) 
		{ 
			super(type);
			
		} 
		
	}
	
}