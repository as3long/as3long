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
	public class About1 extends ParentBase
	{
		override protected function init():void 
		{
			gotoAndPlay(2)
		}
		public function install():void {
			var mcBtn:SimpleButton=getChildByName("btn") as SimpleButton
			if(mcBtn)mcBtn.addEventListener(MouseEvent.CLICK, click)
			callAddPage = function() {
				addChild(currentSwf)
				currentSwf.x = 30
				currentSwf.y=0
			}
		}
		private function click(e:MouseEvent):void {
			openPage(Menu.about_2,BLANK,true)
		}
		
	}
	
}