package com.rush360.view 
{
	import com.rush360.controll.SoundCommand;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	import org.weemvc.as3.view.View;
	
	/**
	 * ...
	 * @author 360rush
	 */
	public class McBtnView extends View 
	{
		private var mcBtn:MovieClip;
		private var _btnStop:SimpleButton;
		private var _btnPlay:SimpleButton;
		public function McBtnView(_mcBtn:MovieClip) 
		{
			mcBtn = _mcBtn;
			_btnStop = mcBtn._btnStop;
			_btnStop.visible = false;
			_btnPlay = mcBtn._btnPlay;
			mcBtn.addEventListener(MouseEvent.CLICK, onclick);
		}
		
		private function onclick(e:MouseEvent):void 
		{
			var fleg:Boolean = false;
			if (e.target == _btnPlay)
			{
				fleg = true;
			}
			else if(e.target==_btnStop)
			{
				fleg = false;
			}
			sendWee(SoundCommand, fleg);
		}
		
		public function stop():void
		{
			_btnStop.visible = false;
		}
		
		public function play():void
		{
			_btnStop.visible = true;
		}
	}

}