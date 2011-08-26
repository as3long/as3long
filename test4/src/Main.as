package 
{
	import com.rush360.interfac.Icar;
	import com.rush360.Manager.AppBean;
	import com.rush360.Manager.InjectManager;
	import com.rush360.Manager.XmlManager;
	import com.rush360.People;
	import com.rush360.RedCar;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;

	/**
	 * ...
	 * @author 360rush
	 */
	[Frame(factoryClass = "Preloader")]
	public class Main extends Sprite 
	{
		private var loader:URLLoader;
		private var traceTxt:TextField;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			XmlManager.instance.addEventListener(Event.COMPLETE, load_ok);
			XmlManager.instance.loadXml("di/B_people_car.xml");
		}
		
		private function load_ok(e:Event):void 
		{
			var appBean:AppBean = new AppBean(XmlManager.instance.urlLoader.data);
			var people:People = People(appBean.getBean("people"));
			people.usecar();
			people.eatApple();
		}
	}

}