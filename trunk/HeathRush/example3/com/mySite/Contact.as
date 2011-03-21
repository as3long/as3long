package com.mySite 
{
	import com.webBase.ParentBase;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author WZH(shch8.com)
	 */
	public class Contact extends ParentBase
	{
		
		public function Contact() 
		{
			
		}
		override protected function init():void 
		{
			gotoAndPlay(1)
			content.bt.addEventListener(MouseEvent.CLICK,clickEvent)
		}
		private function clickEvent(e:MouseEvent):void {
			getURL("http://www.shch8.com/webBase")
		}
	}
	
}