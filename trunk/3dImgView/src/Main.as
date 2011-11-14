package 
{
	import com.rush360.ui.Tool;
	import com.rush360.view.PicView;
	import com.rush360.view.PicView2;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
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
		private var _tool:Tool;
		public var mainSprite:Sprite = new Sprite();
		
		/**
		 * 是否全屏的标志
		 * false 表示不是全屏.true表示喜爱你在是全屏
		 */
		private var fullFleg:Boolean = false;
		private var leftFleg:Boolean = false;
		private var rightFleg:Boolean = false;
		
		private var imageSmallUrl:String = "image/";
		private var imageBigUrl:String = "image/";
		
		private var suffixString:String = ".jpg";
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			if (loaderInfo.parameters["surl"])
			{
				imageSmallUrl = loaderInfo.parameters["surl"];
			}
			
			if (loaderInfo.parameters["burl"])
			{
				imageBigUrl=loaderInfo.parameters["burl"];
			}
			
			if (loaderInfo.parameters["suffix"])
			{
				suffixString=loaderInfo.parameters["suffix"];
			}
			
			start();
		}
		
		private function start():void
		{
			addChild(mainSprite);
			_mask = new Sprite();
			_mask.graphics.beginFill(0xFF0000);
			_mask.graphics.drawRect(0, 0, 200, 200);
			_mask.graphics.endFill();
			mainSprite.addChild(_mask);
			
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
				picView.url = imageSmallUrl+i+suffixString;
				mainSprite.addChild(picView);
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
			mainSprite.addChild(_spr);
			_picView2 = new PicView2();
			_picView2.url = imageBigUrl + (_nowI+1) + suffixString;
			_picView2.visible = false;
			mainSprite.addChild(_picView2);
			_picView2.mask = _mask;
			_tool = new Tool();
			_tool.x = (stage.stageWidth / 2);
			_tool.y = stage.stageHeight - _tool.height;
			addChild(_tool);
			stage.addEventListener(Event.RESIZE, resize);
			_tool._btnFull.addEventListener(MouseEvent.CLICK, setFull);
			_tool._btnBig.addEventListener(MouseEvent.CLICK, double_click);
			_tool._btnLeft.addEventListener(MouseEvent.CLICK,setLeft);
			_tool._btnRight.addEventListener(MouseEvent.CLICK,setRight);
		}
		
		private function setLeft(e:MouseEvent):void
		{
			leftFleg = true;
		}
		
		private function setRight(e:MouseEvent):void
		{
			rightFleg = true;
		}
		
		private function setFull(e:MouseEvent):void 
		{
			if (fullFleg == false)
			{
				fullFleg = true;
				_tool._btnFull.gotoAndStop(2);
				stage.displayState=StageDisplayState.FULL_SCREEN;  //这个是关键，其他的改成你自己的按钮
			}
			else
			{
				fullFleg = false;
				_tool._btnFull.gotoAndStop(1);
				stage.displayState=StageDisplayState.NORMAL;
			}
			
			resize(null);
		}
		
		/**
		 * 大小改变触发的方法
		 * @param	e
		 */
		private function resize(e:Event):void
		{
			_tool.x = stage.stageWidth / 2;
			_tool.y = stage.stageHeight - _tool.height;
			mainSprite.x = _tool.x-mainSprite.width/2;
			mainSprite.y = (_tool.y+_tool.height)/2 - (mainSprite.height / 2);
			if (mainSprite.x < 0 || mainSprite.y < 0)
			{
				mainSprite.x = 0;
				mainSprite.y = 0;
			}
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
				_tool._btnBig.gotoAndStop(2);
				_picView2.url = imageBigUrl +(_nowI + 1) + suffixString;
				_picView2.scaleX = _picView2.scaleY = 2 * picArr[0].imageObj.scaleX;
				trace(_picView2.scaleX);
				_spr.visible = true;
				_picView2.visible = true;
				render2 = true;
			}
		}
		
		private function enter_frame(e:Event):void 
		{
			if (render||leftFleg||rightFleg)
			{
				picArr[_nowI].visible = false;
				var delta:int = int((_pointX-stage.mouseX) / 10);
				delta = delta % maxNum;
				//trace(delta);
				if (leftFleg)
				{
					leftFleg = false;
					delta = 1;
				}
				
				if (rightFleg)
				{
					rightFleg = false;
					delta = -1;
				}
				
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
				_spr.x = mouseX - 50-mainSprite.x;
				_spr.y = mouseY - 50-mainSprite.y;
				
				if (_mask.x == 0)
				{
					_picView2.x = 0 - 2 * _spr.x;
				}
				else
				{
					_picView2.x = 450 - 2 * _spr.x;
				}
				_picView2.y = 0 - 2 * _spr.y+2 * picArr[0].imageObj.y;
				
				if (mouseX-mainSprite.x - 50 < 325)
				{
					//_picView2.x = 450;
					if (_mask.x == 0)
					{
						_mask.x = 450;
					}
				}
				else if (mouseX-mainSprite.y + 50 > 325)
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
			_tool._btnBig.gotoAndStop(1);
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