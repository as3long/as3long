package com.as3long.actions 
{
	import com.as3long.model.TimeModel;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.weemvc.as3.control.ICommand;
	import org.weemvc.as3.control.SimpleCommand;
	
	/**
	 * 时间控制器
	 * 控制TimeModel
	 * @author huanglong
	 */
	public class TimeCommand extends SimpleCommand implements ICommand 
	{
		private var _timer:Timer = new Timer(1000);
		public function TimeCommand() 
		{
			
		}
		
		override public function execute(data:Object = null):void 
		{
			super.execute(data);
			_timer.addEventListener(TimerEvent.TIMER, timer_func);
			_timer.start();
		}
		
		private function timer_func(e:TimerEvent):void 
		{
			var timeModel:TimeModel = modelLocator.getModel(TimeModel);
			var date:Date = new Date();
			var hours:String = (date.getHours() > 9)?date.getHours().toString():'0' + date.getHours().toString();
			var minutes:String = (date.getMinutes() > 9)?date.getMinutes().toString():'0' + date.getMinutes().toString();
			var seconds:String=date.getSeconds() > 9?date.getSeconds().toString():'0' + date.getSeconds().toString();
			timeModel.time = hours+':' + minutes+':' + seconds;
		}
		
	}

}