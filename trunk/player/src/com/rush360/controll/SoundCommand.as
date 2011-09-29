package com.rush360.controll 
{
	import com.rush360.view.McBtnView;
	import com.rush360.view.McSongNameView;
	import org.weemvc.as3.control.SimpleCommand;
	
	/**
	 * 声音控制
	 * @author 360rush
	 */
	public class SoundCommand extends SimpleCommand 
	{
		public function SoundCommand() 
		{
			
		}
		
		override public function execute(data:Object = null):void 
		{
			//var firstView:McBtnView = viewLocator.getView(McBtnView);
			var secondView:McSongNameView = viewLocator.getView(McSongNameView);
			if (data == false)
			{
				secondView.songStop();
			}
			else
			{
				secondView.songPlay();
			}
		}
	}

}