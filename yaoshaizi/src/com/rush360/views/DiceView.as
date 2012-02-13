package com.rush360.views 
{
	import com.rush360.actions.DiceCommand;
	import com.rush360.events.ShaiZiEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import org.aswing.border.EmptyBorder;
	import org.aswing.EmptyLayout;
	import org.aswing.JButton;
	import org.aswing.JFrame;
	import org.aswing.JLabel;
	import org.weemvc.as3.control.Controller;
	import org.weemvc.as3.view.IView;
	import org.weemvc.as3.view.View;
	import org.weemvc.as3.view.ViewLocator;
	
	/**
	 * 骰子视图
	 * @author huanglong
	 */
	public class DiceView extends View implements IView 
	{
		private var jFrame:JFrame;
		private var jLablel:JLabel;
		private var jbutton:JButton;
		public function DiceView(mv:MovieClip)
		{
			setWeeList([ShaiZiEvent.DICE_MODEL_CHANGE]);
			jFrame = new JFrame();
			jFrame.setTitle('骰子');
			jFrame.setSizeWH(200, 250);
			jFrame.x = 430;
			jFrame.getContentPane().setLayout(new EmptyLayout());
			(ViewLocator.getInstance().getView(MainView) as MainView).window.getContentPane().append(jFrame);
			jFrame.show();
			jLablel = new JLabel();
			jLablel.setSizeWH(200, 170);
			jFrame.getContentPane().append(jLablel);
			//jLablel.setText('123');
			jbutton = new JButton("摇骰子");
			jbutton.setSizeWH(60, 25);
			jbutton.y = 170;
			jbutton.x = 120;
			jbutton.addActionListener(randomDice);
			jFrame.getContentPane().append(jbutton);
			jFrame.setResizable(false);
		}
		
		private function randomDice(e:Event):void 
		{
			sendWee(DiceCommand);
		}
		
		public override function onDataChanged(wee:String, data:Object = null):void
		{
			//trace('view', data);
			var arr:Array = data as Array;
			var str:String = '';
			for (var i:int = arr.length - 1; i >= 0; i--)
			{
				if (i != 0)
				{
					str += arr[i] + "|";
				}
				else
				{
					str += arr[i];
				}
			}
			jLablel.setText(str);
		}
		
	}

}