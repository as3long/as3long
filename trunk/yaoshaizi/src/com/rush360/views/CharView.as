package com.rush360.views 
{
	import com.rush360.events.*;
	import com.rush360.actions.*;
	import com.rush360.models.*;
	import com.rush360.views.*;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import org.aswing.BorderLayout;
	import org.aswing.JPanel;
	import org.aswing.JScrollPane;
	import org.aswing.JTabbedPane;
	import org.aswing.JTextArea;
	import org.aswing.JTextField;
	import org.weemvc.as3.view.IView;
	import org.weemvc.as3.view.View;
	import org.weemvc.as3.view.ViewLocator;
	
	/**
	 * 聊天框视图
	 * @author huanglong
	 */
	public class CharView extends View implements IView
	{
		private var _main:MovieClip;
		public var txtField:JTextArea;
		public var jpan:JScrollPane;
		public var destPane:JPanel;
		public function CharView(main:MovieClip) 
		{
			_main = main;
			
			txtField = new JTextArea();
			txtField.setWordWrap(true);
			txtField.setEditable(false);
			txtField.setSizeWH(400, 200);
			jpan = new JScrollPane(txtField);
			jpan.setSizeWH(400, 200);
			jpan.setVerticalScrollBarPolicy(JScrollPane.SCROLLBAR_AS_NEEDED);
			//destPane = new JPanel(new BorderLayout()); 
			//destPane.append(jpan);
			//txtField.set
			(ViewLocator.getInstance().getView(MainView) as MainView).window.getContentPane().append(jpan);
			//(ViewLocator.getInstance().getView(MainView) as MainView).window.getContentPane().append(jpan);
			setWeeList([ShaiZiEvent.CHAR_DATA_ADD_STRING]);
		}
		
		override public function onDataChanged(wee:String, data:Object = null):void 
		{
			super.onDataChanged(wee, data);
			txtField.appendText(String(data));
			
		}
	}

}