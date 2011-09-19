package com.rush360.v
{
	import flash.display.Sprite;
	import org.aswing.*;
	import org.aswing.ext.*;
	
	/**
	 * 注册视图
	 * @author 360rush
	 */
	public class RegistView extends RushViewBase
	{
		private var registFrame:JFrame;
		private var nameLabel:JLabel;
		private var pwdLabel:JLabel;
		public var nameTextField:JTextField;
		public var pwdTextField:JTextField;
		
		public var registForm:Form;
		
		public function RegistView()
		{
			init();
		}
		
		override public function init():void
		{
			registFrame = new JFrame(this, "注册");
			registForm = new Form();
			//registFrame.
		}
	
	}

}