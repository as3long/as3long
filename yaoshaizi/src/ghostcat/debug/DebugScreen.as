package ghostcat.debug
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.getQualifiedClassName;
	
	import ghostcat.parse.DisplayParse;
	import ghostcat.parse.graphics.GraphicsEllipse;
	import ghostcat.parse.graphics.GraphicsFill;
	import ghostcat.parse.graphics.GraphicsLineStyle;
	import ghostcat.parse.graphics.GraphicsRect;
	import ghostcat.util.RandomUtil;
	import ghostcat.util.Util;
	import ghostcat.util.display.DisplayUtil;
	import ghostcat.util.display.Geom;
	import ghostcat.util.text.TextFieldUtil;

	/**
	 * 调试用，查看显示对象的属性。
	 * 按下Cirl键看查看local属性。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class DebugScreen extends Sprite
	{
		private var pointTextField:TextField;
		private var currentObj:DisplayObject;
		private var global:Boolean;
		
		public var target:DisplayObject;
		
		/**
		 * 显示到舞台上
		 * @param root
		 * 
		 */
		public static function show(root:DisplayObject):void
		{
			root.stage.addChild(new DebugScreen(root.stage));
		}
		/**
		 * 获得显示对象的具体属性
		 * 
		 * @param obj	对象
		 * @param global	是否取舞台属性
		 * @return 
		 * 
		 */
		public static function getdisplayObjectDetail(obj:DisplayObject,global:Boolean = false):String
		{
			var result:String = "";
			result += obj.name + ":" + getQualifiedClassName(obj) + "\n";
			
			if (global)
			{
				result += "注册点：" + obj.localToGlobal(new Point()) +"\n";
				result += "旋转："+ DisplayUtil.getStageRotation(obj).toFixed(2) + " 缩放："+ DisplayUtil.getStageScale(obj) + "\n";
				result += "矩形："+ obj.getRect(obj.stage); 
			}
			else
			{
				result += "注册点：" + new Point(obj.x , obj.y) +"\n";
				result += "旋转："+ obj.rotation.toFixed(2) + " 缩放："+ new Point(obj.scaleX ,obj.scaleY) + "\n";
				result += "矩形："+ obj.getRect(obj); 
			}
			
			return result;
		}
		public function DebugScreen(target:DisplayObject = null)
		{
			this.target = target;
			
			DisplayUtil.setMouseEnabled(this,false);
			
			pointTextField = Util.createObject(TextField,{selectable:false,defaultTextFormat:new TextFormat("宋体",12),mouseEnabled:false,filters:[new GlowFilter(0xFFFFFF,1,2,2,100)]}) as TextField;
			addChild(pointTextField);
			
			addEventListener(Event.ADDED_TO_STAGE,initHandler);
		}
		
		private function initHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,initHandler);
			
			var dispatcher:EventDispatcher = target ? target : stage;
			if (dispatcher)
			{
				dispatcher.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
				dispatcher.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
				dispatcher.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
				dispatcher.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
			}
		}
		
		private function enterFrameHandler(event:Event):void
		{
			if (!currentObj || currentObj.parent == null)
				return;
			
			var rect:Rectangle = currentObj.getRect(this);
			var pos:Point = Geom.localToContent(new Point(currentObj.x,currentObj.y),currentObj.parent,this);
			
			pointTextField.x = pos.x + 5;
			pointTextField.y = pos.y + 5;
			pointTextField.text = getdisplayObjectDetail(currentObj,global);
			pointTextField.autoSize = TextFieldAutoSize.LEFT;
			
			if (stage)
				Geom.forceRectInside(pointTextField,stage);
			
			graphics.clear();
			DisplayParse.create([new GraphicsLineStyle(2,RandomUtil.integer(0,0xFFFFFF),0.5),new GraphicsFill(0x0,0),new GraphicsRect(rect.x,rect.y,rect.width,rect.height)]).parse(this);
			DisplayParse.create([new GraphicsLineStyle(2,0x000000),new GraphicsFill(0xFFFFFF),new GraphicsEllipse(pos.x,pos.y,5,5)]).parse(this);
		}
		
		private function mouseOverHandler(event:MouseEvent):void
		{
			currentObj = event.target as DisplayObject;
		}
		
		private function keyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.CONTROL)
				global = true;
		}
		
		private function keyUpHandler(event:KeyboardEvent):void
		{
			global = false;
		}
		
		/**
		 * 销毁方法
		 * 
		 */
		public function destory():void
		{
			var dispatcher:EventDispatcher = target ? target : stage;
			if (dispatcher)
			{
				dispatcher.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
				dispatcher.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
				dispatcher.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
				dispatcher.removeEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
			}
			parent.removeChild(this);
		}
	}
}