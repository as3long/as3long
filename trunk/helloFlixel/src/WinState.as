package  
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONDecoder;
	import com.rush360.manage.MManage;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldType;

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
		public function WinState() 
		{
			
		}
		
		override public function create():void 
		{
			super.create();
			add(new FlxSprite(0, 0, winImg));
			MManage.instance.gameOverTime = new Date();
			timer = MManage.instance.gameOverTime.valueOf() - MManage.instance.gameStartTime.valueOf();
			useTimeText = new FlxText(50, 100, 200, "use time " + int(timer / 1000) + "s");
			useTimeText = useTimeText.setFormat("system", 12);
			nameFlxText = new FlxText(50, 130, 200, 'your name:');
			nameFlxText = nameFlxText.setFormat("system", 12);
			sayFlxText = new FlxText(50, 160, 200, 'you went say:');
			sayFlxText = sayFlxText.setFormat("system", 12);
			nameTextField = new TextField();
			nameTextField.x = 150;
			nameTextField.y = 130;
			sayTextField = new TextField();
			sayTextField.x = 150;
			sayTextField.y = 160;
			nameTextField.border = true;
			nameTextField.width = 200;
			nameTextField.height = 25;
			nameTextField.text = 'rusher';
			nameTextField.type = TextFieldType.INPUT;
			sayTextField.border = true;
			sayTextField.type=TextFieldType.INPUT;
			sayTextField.text = '不错哇!';
			//nameTextField.
			add(useTimeText);
			add(nameFlxText);
			add(sayFlxText);
			addChild(sayTextField);
			addChild(nameTextField);
			//add(new FlxText(50,130,200,"Press R to RESTART"))
		}
		
		private function sendMessage():void 
		{
			var urlLoader:URLLoader = new URLLoader();
			var urlString:String = "http://360rushgame.sinaapp.com/?c=game&a=add&guser=" + nameTextField.text + "&gusetime=" + int(timer / 1000) + "&gsay=" + sayTextField.text;
			var request:URLRequest = new URLRequest(urlString);
			urlLoader.load(request);
		}
		
		private function show():void
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
			var objArr:Object = JSON.decode(showLoader.data);
			var objLength:int = objArr.length;
			for (var i:int = 0; i < objLength; i++)
			{
				var listSprite:ListSprite = new ListSprite(objArr[i]);
				listSprite.y = i * 30;
				addChild(listSprite);
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
			else if (FlxG.keys.justPressed('S'))
			{
				sendMessage();
			}else if (FlxG.keys.justPressed('L'))
			{
				show();
			}
			super.update();
		}
	}

}