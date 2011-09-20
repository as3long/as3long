package 
{
	import com.rush360.view.PicView;
	import com.rush360.view.PicView2;
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
		private var render2:Boolean = false;
		private var _spr:Sprite;
		private var _timer:Number;
		private var _picView2:PicView2;
		public var _mask:Sprite;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			start();
		}
		
		private function start():void
		{
			_mask = new Sprite();
			_mask.graphics.beginFill(0xFF0000);
			_mask.graphics.drawRect(0, 0, 200, 200);
			_mask.graphics.endFill();
			addChild(_mask);
			
			_spr = new Sprite();
			_spr.graphics.beginFill(0x808080, 0.5);
			_spr.graphics.drawRect(0, 0, 100, 100);
			_spr.graphics.endFill();
			_spr.visible = false;
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
			//stage.doubleClickEnabled = true;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseEvent_mouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseEvent_mouse_Up);
			stage.addEventListener(Event.ENTER_FRAME, enter_frame);
			//stage.addEventListener(MouseEvent.DOUBLE_CLICK, double_click);
			picArr[nowI].visible = true;
			this.addChild(_spr);
			_picView2 = new PicView2();
			_picView2.url = "image/" + (_nowI+1) + ".jpg";
			_picView2.visible = false;
			addChild(_picView2);
			_picView2.mask = _mask;
		}
		
		
		private function double_click(e:MouseEvent):void 
		{
			//trace("双击");
			if (_spr.visible == true)
			{
				_spr.visible = false;
				_picView2.visible = false;
				render2 = false;
			}
			else if(_spr.visible==false)
			{
				_picView2.url = "image/" +(_nowI + 1) + ".jpg";
				_picView2.scaleX = _picView2.scaleY = 2 * picArr[0].imageObj.scaleX;
				trace(_picView2.scaleX);
				_spr.visible = true;
				_picView2.visible = true;
				render2 = true;
			}
		}
		
		private function enter_frame(e:Event):void 
		{
			if (render)
			{
				picArr[_nowI].visible = false;
				var delta:int = int((_pointX-stage.mouseX) / 10);
				delta = delta % maxNum;
				//trace(delta);
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
			
			if (render2)
			{
				_spr.x = mouseX - 50;
				_spr.y = mouseY - 50;
				
				if (_mask.x == 0)
				{
					_picView2.x = 0 - 2 * _spr.x;
				}
				else
				{
					_picView2.x = 450 - 2 * _spr.x;
				}
				_picView2.y = 0 - 2 * _spr.y+2 * picArr[0].imageObj.y;
				
				if (mouseX - 50 < 325)
				{
					//_picView2.x = 450;
					if (_mask.x == 0)
					{
						_mask.x = 450;
					}
				}
				else if (mouseX + 50 > 325)
				{
					//_picView2.x = 0;
					if (_mask.x == 450)
					{
						_mask.x = 0;
					}
				}
				
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
			var nowTimer:Number = (new Date()).getTime();
			trace(nowTimer);
			if (nowTimer - _timer < 300)
			{
				double_click(e);
				return;
			}
			_timer = nowTimer;
			
			_spr.visible = false;
			_picView2.visible = false;
			render2 = false;
			
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