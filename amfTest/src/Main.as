package
{
	import com.rush360.event.RushEvent;
	import com.rush360.net.RushRemoting;
	import com.rush360.v.LoginView;
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
	import org.flashdevelop.utils.FlashViewer;
	import org.weemvc.as3.control.Controller;
	
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
			
			//Controller.getInstance().addCommand(StartupCommand);
			//Controller.getInstance().executeCommand(StartupCommand, this);
			AsWingManager.initAsStandard(this);
			addChild(new LoginView());
		}
	}

}