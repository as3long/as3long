package 
{
	import com.rush360.view.PicView;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author 360rush
	 */
	[Frame(factoryClass = "Preloader")]
	public class Main extends Sprite 
	{
		private var picArr:Array;
		private var nowI:int = 0;
		private var _nowI:int = 0;
		private var _pointX:Number = 0;
		private var maxNum:int = 23;
		private var render:Boolean = false;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			picArr = new Array();
			var i:int = 0;
			for (i = 1; i <=maxNum; i++)
			{
				var picView:PicView = new PicView();
				picView.url = "image/"+i+".jpg";
				addChild(picView);
				picView.visible = false;
				picView.mouseEnabled = false;
				picArr.push(picView);
			}
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseEvent_mouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseEvent_mouse_Up);
			stage.addEventListener(Event.ENTER_FRAME, enter_frame);
			picArr[nowI].visible = true;
		}
		
		private function enter_frame(e:Event):void 
		{
			if (render)
			{
				picArr[_nowI].visible = false;
				var delta:int = int((_pointX-stage.mouseX) / 10);
				delta = delta % maxNum;
				trace(delta);
				if(nowI+delta>maxNum-1)
				{
					_nowI = nowI + delta - maxNum;
				}
				else if (nowI + delta < 0)
				{
					_nowI =maxNum+nowI+delta;
				}
				else
				{
					_nowI = nowI + delta;
				}
				picArr[_nowI].visible = true;
			}
		}
		
		private function mouseEvent_mouse_Up(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseEvent_mouse_Move);
			nowI = _nowI;
			render = false;
		}
		
		private function mouseEvent_mouseDown(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseEvent_mouse_Move);
			_pointX = e.target.mouseX;
			trace(_pointX);
			//_point.y = e.target.mouseY;
		}
		
		private function mouseEvent_mouse_Move(e:MouseEvent):void 
		{
			render = true;
		}
		
	}
	
}