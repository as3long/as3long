package com.as3long.view 
{
	import com.as3long.event.TimeEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import org.weemvc.as3.PaperLogger;
	import org.weemvc.as3.view.IView;
	import org.weemvc.as3.view.View;
	
	/**
	 * 时间视图
	 * @author huanglong
	 */
	public class TimeView extends View implements IView 
	{
		private var _timeTextField:TextField = new TextField();
		private var _main:MovieClip;
		public function TimeView(main:MovieClip) 
		{
			_main = main;
			_main.addChild(_timeTextField);
			_timeTextField.text = 'loading';
			PaperLogger.getInstance().log('时间视图显示',TimeView);
			setWeeList([TimeEvent.TIME_CHANGE]);
		}
		
		override public function onDataChanged(wee:String, data:Object = null):void 
		{
			super.onDataChanged(wee, data);
			_timeTextField.text = String(data);
		}
	}

}