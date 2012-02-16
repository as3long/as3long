package com.rush360.views 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import org.aswing.EmptyLayout;
	import org.aswing.JButton;
	import org.aswing.JFrame;
	import org.aswing.JLabel;
	import org.aswing.JSlider;
	import org.weemvc.as3.view.IView;
	import org.weemvc.as3.view.View;
	import org.weemvc.as3.view.ViewLocator;
	
	/**
	 * 游戏控制视图
	 * @author huanglong
	 */
	public class GameView extends View implements IView 
	{
		private var jFrame:JFrame;
		private var jv:JSlider;
		private var jvLabel:JLabel;
		private var diceSlider:JSlider;
		private var diceLabel:JLabel;
		private var btnSend:JButton;
		private var btnOpen:JButton;
		public function GameView(mv:MovieClip) 
		{
			jFrame = new JFrame();
			jFrame.setTitle('游戏控制');
			jFrame.setSizeWH(420, 200);
			jFrame.y = 320;
			jFrame.setResizable(false);
			jFrame.getContentPane().setLayout(new EmptyLayout());
			(ViewLocator.getInstance().getView(MainView) as MainView).window.getContentPane().append(jFrame);
			jFrame.show();
			jv = new JSlider(4, 0, 24, 5);
			jv.setSizeWH(400, 20);
			jv.y = 20;
			//jFrame.getContentPane().append(jv);
			
			diceSlider = new JSlider(2, 1, 6, 2);
			diceSlider.setSizeWH(400, 20);
			diceSlider.y = 50;
			//jFrame.getContentPane().append(diceSlider);
			
			jvLabel = new JLabel();
			jvLabel.setSizeWH(60, 20);
			jvLabel.setLocationXY(20, 70);
			jvLabel.setText(jv.getValue() + '个');
			diceLabel = new JLabel();
			diceLabel.setText(diceSlider.getValue() + '点');
			diceLabel.setSizeWH(60, 20);
			diceLabel.setLocationXY(80, 70);
			diceSlider.addStateListener(diceChange);
			jv.addStateListener(jvChange);
			
			btnSend = new JButton('赌一把');
			btnSend.setSizeWH(160, 40);
			btnSend.x = 40;
			btnSend.y = 100;
			
			btnOpen = new JButton('开你')
			btnOpen.setSizeWH(160, 40);
			btnOpen.x = 210;
			btnOpen.y = 100;
			
			jFrame.getContentPane().appendAll(jv, diceSlider, jvLabel, diceLabel, btnSend, btnOpen);
		}
		
		private function jvChange(e:Event):void 
		{
			jvLabel.setText(jv.getValue() + '个');
		}
		
		private function diceChange(e:Event):void 
		{
			diceLabel.setText(diceSlider.getValue() + '点');
		}
		
		public override function onDataChanged(wee:String, data:Object = null):void 
		{
			
		}
		
	}

}