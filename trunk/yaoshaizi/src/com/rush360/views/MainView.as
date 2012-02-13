package com.rush360.views 
{
	import flash.display.MovieClip;
	import org.aswing.border.CaveBorder;
	import org.aswing.border.SimpleTitledBorder;
	import org.aswing.border.TitledBorder;
	import org.aswing.EmptyLayout;
	import org.aswing.JFrame;
	import org.weemvc.as3.view.IView;
	import org.weemvc.as3.view.View;
	import org.aswing.ASColor;
	import org.aswing.AsWingManager;
	import org.aswing.border.LineBorder;
	import org.aswing.FlowLayout;
	import org.aswing.JWindow;
	
	/**
	 * 
	 * @author huanglong
	 */
	public class MainView extends View implements IView 
	{
		public var window:JWindow;
		public var liaotian:JFrame;
		public function MainView(_main:MovieClip) 
		{
			window = new JWindow();
			window.setSizeWH(_main.stage.stageWidth,_main.stage.stageHeight);
			//window.setSizeWH(500, 400);
            //window.setBorder(new SimpleTitledBorder(new CaveBorder(),'摇骰子'));
			//window.setBackground(new ASColor(0x0080C0));
            window.getContentPane().setLayout(new EmptyLayout());
			_main.addChild(window);
            window.show();
			liaotian = new JFrame();
			liaotian.setTitle('聊天框');
			liaotian.setSizeWH(420, 320);
			liaotian.setResizable(false);
			liaotian.getContentPane().setLayout(new EmptyLayout());
			window.getContentPane().append(liaotian);
			liaotian.show();
		}
		
		public override function onDataChanged(wee:String, data:Object = null):void 
		{
			
		}
		
	}

}