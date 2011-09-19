package com.rush360.v 
{
	import flash.display.Sprite;
	import com.rush360.i.IView;
		import com.rush360.manger.RushObServerManger;
	/**
	 * ...
	 * @author 360rush
	 */
	public class RushViewBase extends Sprite implements IView 
	{
		
		public function RushViewBase() 
		{
			super();
			
		}
		
		public function init():void
		{
			
		}
		
		/**
		 * 通知给观察者(控制类)
		 * @param	msg
		 */
		public function notify(msg:String):void
		{
			RushObServerManger.i.notifyObServers(msg);
		}
	}

}