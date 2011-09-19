package com.rush360.c 
{
	import com.rush360.v.VLogin;
	import org.weemvc.as3.control.SimpleCommand;
	
	/**
	 * ...
	 * @author 360rush
	 */
	public class ShowFirstCommand extends SimpleCommand 
	{
		
		public function ShowFirstCommand() 
		{
			
		}
		
		override public function execute(data:Object = null):void {
			var loginView:VLogin = viewLocator.getView(VLogin);
			//将 firstView 里的输入框中输入的文字 发送过来，并显示在secondView的 文本框里
			loginView.inputTxt("你输入了" + data);
		}
		
	}

}