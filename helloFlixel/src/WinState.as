package  
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONDecoder;
	import com.rush360.manage.MManage;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Mouse;
	import ui.Shengli;

	import org.flixel.*;
	/**
	 * ...
	 * @author 360rush
	 */
	public class WinState extends FlxState
	{
		[Embed(source='media/win.png')]
		protected var winImg:Class;
		private var useTimeText:FlxText;
		private var nameFlxText:FlxText;
		private var sayFlxText:FlxText;
		private var nameTextField:TextField;
		private var sayTextField:TextField;
		private var timer:Number;
		private var showLoader:URLLoader;
		private var _bg:Sprite;
		private var sendFleg:Boolean = false;
		private var focus_in_fleg:Boolean = false;
		private var nameString:String;
		private var sayString:String;
		private var shengli:Shengli;
		public function WinState() 
		{
			
		}
		
		override public function create():void 
		{
			super.create();
			add(new FlxSprite(0, 0, winImg));
			MManage.instance.gameOverTime = new Date();
			timer = MManage.instance.gameOverTime.valueOf() - MManage.instance.gameStartTime.valueOf();
			/*useTimeText = new FlxText(50, 100, 200, "use time " + int(timer / 1000) + "s");
			useTimeText = useTimeText.setFormat("system", 12);
			nameFlxText = new FlxText(50, 130, 200, 'your name:');
			nameFlxText = nameFlxText.setFormat("system", 12);
			sayFlxText = new FlxText(50, 160, 200, 'you went say:');
			sayFlxText = sayFlxText.setFormat("system", 12);
			nameTextField = new TextField();
			nameTextField.x = 160;
			nameTextField.y = 130;
			sayTextField = new TextField();
			sayTextField.x = 160;
			sayTextField.y = 160;
			nameTextField.border = true;
			nameTextField.width = 400;
			nameTextField.height = 25;
			sayTextField.width = 400;
			sayTextField.height = 100;
			nameTextField.text = 'rusher';
			nameTextField.type = TextFieldType.INPUT;
			sayTextField.border = true;
			sayTextField.type=TextFieldType.INPUT;
			sayTextField.text = '不错哇!';
			sayTextField.multiline = true;
			//nameTextField.
			add(useTimeText);
			add(nameFlxText);
			add(sayFlxText);
			addChild(sayTextField);
			addChild(nameTextField);
			nameTextField.addEventListener(FocusEvent.FOCUS_IN, focus_in);
			nameTextField.addEventListener(FocusEvent.FOCUS_OUT, focus_out);
			sayTextField.addEventListener(FocusEvent.FOCUS_IN, focus_in);
			sayTextField.addEventListener(FocusEvent.FOCUS_OUT, focus_out);*/
			//add(new FlxText(50,130,200,"Press R to RESTART"))
			shengli = new Shengli();
			addChild(shengli);
			shengli._txtuseTime.text = int(timer / 1000).toString();
			shengli._btnOk.addEventListener(MouseEvent.CLICK, sendMessage);
			shengli._btnShow.addEventListener(MouseEvent.CLICK, show);
			_bg = new Sprite();
			_bg.graphics.beginFill(0xFFD0FF, 0.9);
			_bg.graphics.drawRect(0, 0, 640, 480);
			_bg.graphics.endFill();
			addChild(_bg);
			_bg.visible = false;
			Mouse.show();
		}
		
		/*private function focus_out(e:FocusEvent):void 
		{
			focus_in_fleg = false;
			nameString = nameTextField.text;
			sayString = sayTextField.text;
		}
		
		private function focus_in(e:FocusEvent):void 
		{
			focus_in_fleg = true;
			nameString = nameTextField.text;
			sayString = sayTextField.text;
		}*/
		
		private function sendMessage(e:Event):void 
		{
			nameString = shengli._txtname.text;
			sayString = shengli._txtsay.text;
			if (sendFleg == false)
			{
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE,sendload_ok)
				var urlString:String = "http://360rushgame.sinaapp.com/?c=game&a=add";
				var request:URLRequest = new URLRequest(urlString);
				var _data:URLVariables = new URLVariables();
				_data.guser = nameString;
				_data.gusetime = int(timer / 1000).toString();
				_data.gsay = sayString;
				request.method = URLRequestMethod.POST;
				request.data = _data;
				urlLoader.load(request);
				sendFleg = true;
			}
		}
		
		private function sendload_ok(e:Event):void 
		{
			e.target.removeEventListener(Event.COMPLETE, sendload_ok);
			show(null);
		}
		
		private function show(e:Event):void
		{
			showLoader = new URLLoader();
			var urlString:String = "http://360rushgame.sinaapp.com/?c=game&a=getList";
			showLoader.addEventListener(Event.COMPLETE, load_ok);
			var request:URLRequest = new URLRequest(urlString);
			showLoader.load(request);
		}
		
		private function load_ok(e:Event):void 
		{
			//trace(showLoader.data);
			//sayTextField.visible = false;
			//nameTextField.visible = false;
			_bg.visible = true;
			var objArr:Object = JSON.decode(showLoader.data);
			var objLength:int = objArr.length;
			shengli._btnOk.removeEventListener(MouseEvent.CLICK, sendMessage);
			shengli._btnShow.removeEventListener(MouseEvent.CLICK, show);
			for (var i:int = 0; i < objLength; i++)
			{
				var listSprite:ListSprite = new ListSprite(objArr[i]);
				listSprite.y = i * 20;
				_bg.addChild(listSprite);
			}
		}
		
		override public function update():void 
		{
			if (FlxG.keys.justPressed('R')) 
			{
				MManage.instance.gameState = new GameState();
				FlxG.state = MManage.instance.gameState;
				MManage.instance.gameStartTime = new Date();
			}
			super.update();
		}
	}

}