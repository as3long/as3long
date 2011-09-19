package com.rush360.v 
{
	import com.rush360.c.ShowFirstCommand;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.weemvc.as3.view.View;
	
	/**
	 * ...
	 * @author 360rush
	 */
	public class VLogin extends View 
	{
		private var m_panel:LoginView;
		public function VLogin(panel:LoginView) 
		{
			m_panel = panel;
			m_panel.mouseEnabled = false;
			trace("m_panel.name", m_panel.name);
			m_panel.loginButton.addActionListener(onMouseClickHandler);
		}
		
		private function onMouseClickHandler(e:Event):void 
		{
			sendWee(ShowFirstCommand, m_panel.nameTextField.getText());
		}
		
		public function inputTxt(data:String):void
		{
			m_panel.setText(data);
		}
	}

}