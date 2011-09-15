package
{
	import com.rush360.event.RushEvent;
	import com.rush360.net.RushRemoting;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.rush360.proxy.ObjectProxy;
	import flash.text.TextField;
	import org.aswing.ASColor;
	import org.aswing.AsWingManager;
	import org.aswing.border.LineBorder;
	import org.aswing.EmptyLayout;
	import org.aswing.FlowLayout;
	import org.aswing.JButton;
	import org.aswing.JFrame;
	import org.aswing.JLabel;
	import org.aswing.JWindow;
	
	/**
	 * ...
	 * @author 360rush
	 */
	public class Main extends Sprite
	{
		private var window:JWindow;
		private var frame:JFrame;
		private var label:JLabel;
		private var button1:JButton;
		private var button2:JButton;
		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			AsWingManager.initAsStandard(this);
			window = new JWindow(this);
			window.setSizeWH(800, 600);
			//window.setLocationXY(0,0);
			window.setBorder(new LineBorder());
			window.setBackground(new ASColor(0xFF0000));
			//window.getContentPane().setLayout(new FlowLayout());
			window.show();
			
			frame = new JFrame(window, "时间");
			frame.setSizeWH(400, 300);
			//frame.getContentPane().setLayout(new FlowLayout());
			frame.getContentPane().setLayout(new EmptyLayout());
			frame.show();
			
			button1 = new JButton("时间");
			button1.setSizeWH(100, 50);
			button1.setLocationXY(0, 0);
			button1.addActionListener(click);
			frame.getContentPane().append(button1);
			
			button2 = new JButton("日期");
			button2.setSizeWH(100, 50);
			button2.setLocationXY(0, 90);
			button2.addActionListener(click);
			frame.getContentPane().append(button2);
			
			label = new JLabel("");
			label.setSizeWH(200, 20);
			label.setLocationXY(100,200)
			label.setToolTipText("现在时间");
			label.setText("现在时间是多少呢?");
			frame.getContentPane().append(label);
			RushRemoting.i.baseUrl = "http://360rushgame.sinaapp.com/Amfphp/";
			RushRemoting.i.gateway(RushEvent.TIME_GETTIME, result);
			
			var o:Object = {};
			o.hi = function(name:*, age:*):void
			{
				trace('hi ', name, '!', age);
			}
			//
			var op:ObjectProxy = new ObjectProxy(o);
			var obj:Object = {y: 3};
			//
			op.bind(obj, 'x');
			op.bind(obj, 'y');
			op.bindFun(fun, 'hi');
			op.y = 4;
			op.hi('rod', 23);
			op.x = 2;
			trace(obj.y);
			trace(op.x);
			trace(obj.x);
		}
		
		private function click(e:Event):void 
		{
			switch(e.target)
			{
				case button1:
					label.setText("时间");
					break;
				case button2:
					label.setText("日期");
					break;
				default:
					label.setText(e.target.getName());
			}
		}
		
		private function result(_result:*):void
		{
			label.setText(_result.toString());
		}
		
		public function fun(v:*, v1:*):void
		{
			trace('call==', v, v1);
		}
	
	}

}