package
{
	import com.rush360.c.StartupCommand;
	import com.rush360.event.RushEvent;
	import com.rush360.manger.*;
	import com.rush360.net.RushRemoting;
	import com.rush360.v.LoginView;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.rush360.proxy.ObjectProxy;
	import flash.events.MouseEvent;
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
	public class Main extends MovieClip
	{
		private var rushObServer1:RushObServer1;
		private var rushObServer2:RushObServer2;
		public var loginView:LoginView;
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
			loginView = new LoginView();
			addChild(loginView);
			rushObServer1 = new RushObServer1();
			rushObServer2 = new RushObServer2();
			RushObServerManger.i.addObServer(rushObServer1);
			RushObServerManger.i.addObServer(rushObServer2);
			Controller.getInstance().addCommand(StartupCommand);
			Controller.getInstance().executeCommand(StartupCommand, this);
		}
	}

}