package com.mySite 
{
	import com.webBase.Menu;
	import com.webBase.ParentBase;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author WZH(shch8.com)
	 */
	public class About extends ParentBase
	{
		
		override protected function init():void 
		{
			gotoAndPlay(2)
		}
		public function install():void {
			btn.addEventListener(MouseEvent.CLICK, click)
			callAddPage = function() {
				addChild(currentSwf)
				currentSwf.x = 30
				currentSwf.y=230
			}
		}
		private function click(e:MouseEvent):void {
			openPage(Menu.about_1)
		}
	}
	
}