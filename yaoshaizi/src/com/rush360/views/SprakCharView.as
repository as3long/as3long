package com.rush360.views 
{
	import com.rush360.events.ShaiZiEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import org.aswing.JButton;
	import org.aswing.JTextArea;
	import org.weemvc.as3.view.IView;
	import org.weemvc.as3.view.View;
	import org.aswing.ASColor;
	import org.aswing.AsWingManager;
	import org.aswing.border.LineBorder;
	import org.aswing.FlowLayout;
	import org.aswing.JWindow;
	import org.weemvc.as3.view.ViewLocator;
	import com.rush360.models.*;
	import com.rush360.views.*;
	import com.rush360.actions.*;
	
	/**
	 * 输入文本框
	 * @author huanglong
	 */
	public class SprakCharView extends View implements IView 
	{
		private var _main:MovieClip;
		public var txtField:JTextArea;
		
		public var btnSend:JButton;
		public function SprakCharView(main:MovieClip) 
		{
			_main = main;
			txtField = new JTextArea();
			txtField.y = 210;
			//txtField.type = TextFieldType.INPUT;
			txtField.setSizeWH(400, 50);
			txtField.setToolTipText('请输入文本');
			btnSend = new JButton('发送');
			btnSend.setSizeWH(60, 25);
			btnSend.x = 340;
			btnSend.y = 260;
			btnSend.addActionListener(btn_send_click);
			//_main.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
			(ViewLocator.getInstance().getView(MainView) as MainView).window.getContentPane().append(txtField);
			(ViewLocator.getInstance().getView(MainView) as MainView).window.getContentPane().append(btnSend);
		}
		
		private function key_down(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.ENTER)
			{
				btn_send_click(null);
			}
		}
		
		public function btn_send_click(e:Event):void
		{
			//trace('发送', txtField.getText());
			if (txtField.getText() != '')
			{
				sendWee(SpeakCharCommand, txtField.getText());
				txtField.setText('');
			}
		}
		
		override public function onDataChanged(wee:String, data:Object = null):void 
		{
			
		}
		
	}

}