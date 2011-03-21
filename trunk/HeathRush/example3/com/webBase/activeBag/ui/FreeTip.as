package com.webBase.activeBag.ui 
{
	import com.webBase.activeBag.control.ChildCtrl;
	import com.webBase.activeBag.style.useFilter;
	import flash.accessibility.AccessibilityProperties;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	/**
	 * 提示组件 2010-3-9 15:36
	 * @author WZH(shch8.com)
	 * 
	 * @example
FreeTip.init(stage);//安装显示区
FreeTip.adjust=true;//是否自动调整
FreeTip.delay=2;//延时时间
FreeTip.speed=3;//速度
FreeTip.glow=false;//是否使用外发光
FreeTip.specular=true;//是否使用高光
FreeTip.setStyle(0x009900,0.8,5,0x003300);//样式设置
FreeTip.setTextFormat(new TextFormat("宋体",12,0xffffff))//文本样式设置
//与显示元素关联。  
FreeTip.register(btn1, "我是按钮我是按按按钮我是按按按钮我是按按钮1",200);
	 */
	public class FreeTip extends Sprite
	{
		public static var tip:FreeTip;
		private var _textFormat:TextFormat;
		private var _styleObj:Object;
		private const DIS:uint = 6;
		private var _wid:Number = 100;
		private var _limitWid:Number = 0;//限制宽度
		private static var _delay:Number = 0;//延时;
		private var _hei:Number = 25;
		private var txt:TextField;
		private var bgShape:Shape = new Shape;
		private var triangle:Shape;
		private var shapeMask:Shape;
		private var area:Object;
		private var mouseDown:Boolean;//鼠标是否处在按下状态，用于_downHide为True时
		private static var _downHide:Boolean;//鼠标按下时是否消失
		private static var _adjust:Boolean = true;//是否自动调整
		private static var _glow:Boolean=true;//是否使用外发光
		private static var _specular:Boolean;//是否使用高光
		private static var _follow:Boolean=true;//是否跟随
		private var _speed:Number;
		private static var speed_b:Number=2;
		private var runTimer:Timer;
		private var delayTimer:Timer;
		private static const STR:String=":*p"
		private static var _base:DisplayObjectContainer;
		private static var _showArea:DisplayObjectContainer;
		public function FreeTip() 
		{
			visible = false;
			mouseEnabled = mouseChildren = false;  
			addChild(bgShape);
		}
		/**
		 * 使用安装
		 * @param	base	 显示区安装
		 * @param	showArea 显示区域，影响自适应时的位置，为空的话使用base为显示区域
		 */
		 public static function init(base:DisplayObjectContainer,showArea:DisplayObjectContainer=null) {  
            if (tip == null) {
				_base = base;
				_showArea=showArea
                tip = new FreeTip();
				tip.alpha = 0;
                _base.addChild(tip);
            }  
        }  
		/**
		 * 注册感应区
		 * @param	area		感应对象
		 * @param	message		提示文字(支持HTML标签)
		 * @param	limitWid	固定宽度
		 */
		 public static function register(area:Object, message:String,limitWid:Number=0):void {  
            if (tip != null) {
                area.addEventListener(MouseEvent.MOUSE_OVER, add(tip.handler,area));			
				var prop:AccessibilityProperties = new AccessibilityProperties();  
                prop.description = limitWid+STR+message;
                area.accessibilityProperties = prop;  
            }else {
				throw new Error("请先执行init(),安装Tip感应区");
				}
        } 
		public static function add(fun:Function,... more):Function {
			var orif:Boolean=false;
			var setfun:Function=function(e:*,..._more){
			_more=more
			if(!orif){
			orif=true
			_more.unshift(e)}
			fun.apply(null,_more)
			};
			return setfun;
		}
		public function removeInit(e:Event):void {
			if (area == null) return
			this.area.removeEventListener(MouseEvent.MOUSE_OVER, this.handler);
			hide()
			}
		public override function set width(value:Number):void
		{
			if (value < 30) value = 30;
			_wid = value;
		}
		public override function set height(value:Number):void
		{
			_hei = value;
		}
		public override function get width():Number
		{
			return _wid;
		}
		public override function get height():Number
		{
			return _hei;
		}
		/*鼠标按下时是否消失*/
		public static function set downHide(value:Boolean):void
		{
			_downHide = value;
		}
		/*是否自动调整*/
		public static function set adjust(value:Boolean):void
		{
			_adjust = value;
		}
		public static function get speed():Number{return speed_b}
		/*速度(1-10)*/
		public static function set speed(value:Number):void
		{
			if (value < 1) value = 1;
			if (value > 10) value = 10;
			speed_b = value;
		}
		public static function get delay():Number { return _delay };
		/*延时(1-100) */
		public static function set delay(value:Number):void
		{
			if (value < 1) value = 1;
			if (value > 100) value = 100;
			value *= 100;
			_delay = value;
		}
		public static function get follow():Boolean{return _follow}
		/*是否跟随*/
		public static function set follow(value:Boolean):void
		{
			_follow = value;
		}
		public static function get glow():Boolean{return _glow}
		/*是否使用外发光*/
		public static function set glow(value:Boolean):void
		{
			_glow = value;
		}
		public static function get specular():Boolean{return _specular}
		/*是否使用高光*/
		public static function set specular(value:Boolean):void
		{
			_specular = value;
		}
		/**
		 * 样式设置
		 * @param	color 	背景色
		 * @param	alpha = 1	透明度
		 * @param	ellipse	圆角大小
		 * @param	glowColor	外发光颜色
		 */
		public static function setStyle(color:uint = 0xffffff, alpha = 1, ellipse:uint = 5,glowColor:uint=0x999999):void
		{
			tip._styleObj = new Object;
			tip._styleObj._bgColor = color;
			tip._styleObj._alpha = alpha;
			tip._styleObj._ellipse = ellipse;
			tip._styleObj._glowColor = glowColor;
		}
		public static function setTextFormat(value:TextFormat):void
		{
			tip._textFormat=value;
		}
		public function show():void {  
			if (_base == null || area == null) return
			ChildCtrl.getInstance().layerTop(_base,this)
			if (_styleObj==null) FreeTip.setStyle();
			if (area.accessibilityProperties) text = area.accessibilityProperties.description;
        }
        public function hide():void {
			if (this.area == null) return;
			this.area.removeEventListener(MouseEvent.MOUSE_DOWN, this.handler);
			this.area.removeEventListener(MouseEvent.MOUSE_OUT, this.handler);
			area.removeEventListener(Event.REMOVED_FROM_STAGE,removeInit);	
            this.area = null;
            visible = false;  
			alpha = 0;
			if(runTimer!=null){
			runTimer.stop();
			runTimer.removeEventListener(TimerEvent.TIMER, enter_Frame);
			ChildCtrl.getInstance().runClear();
			}
        }  
        private function enter_Frame(event:TimerEvent):void {
			if (_base == null || area == null) return;
			if(area.parent==null)return
			var rect:Rectangle = area.parent.getBounds(area);
			var maxWid:uint = uint(area.x + rect.width*area.scaleX);
			var maxHei:uint = uint(area.y + rect.height*area.scaleY);
			if (!(maxWid > area.parent.mouseX && (area.x+rect.x) < area.parent.mouseX && maxHei > area.parent.mouseY && (area.y+rect.y) < area.parent.mouseY)) {
				handler(MouseEvent.MOUSE_OUT);
				return;
				}
			var lp:Point
			lp = this.parent.globalToLocal(new Point(tip.stage.mouseX, tip.stage.mouseY));
			var ba:DisplayObjectContainer = _showArea
			if(ba==null)ba=_base
			if(!visible){  
                visible = true;
				if (ba.mouseY < ba.height / 2) {
					this.y = lp.y  +25 + 30
					}
				if (ba.mouseY >= ba.height / 2) {
					this.y = lp.y - bgShape.height - 10 - 30;
					}
				if (ba.mouseX<ba.width/2) {
				//this.x = lp.x - bgShape.width + 10;
				//triangle.x = bgShape.width - triangle.width - 5 + align;
				this.x = lp.x -10
				triangle.x = align + 5
				}
				if (ba.mouseX>=ba.width/2) {
					//this.x = lp.x -10 ;
					//triangle.x = align + 5;
					this.x = lp.x - bgShape.width + 20
					triangle.x = (bgShape.width - 25+align)
				}
				
            }
			if (!_adjust) {
				if(this.alpha!=1){
					this.alpha = 1;
					}
				this.y = lp.y - bgShape.height - 10;
				this.x = lp.x - 12;
				triangle.x = align + 5;
				triangle.y = bgShape.height-3;
				return;
				}
			if (_speed < 2) {
				alpha=1
				}else{
			if (this.alpha < 1) {
				this.alpha += 1/(_speed*2);
				}else if(this.alpha>1){
					this.alpha=1
				}}
				var align:uint=0;
				if (ba.mouseY<ba.height/2) {
					this.y += (lp.y  +30 - this.y) / _speed;
					triangle.y += (0-triangle.y)/_speed;
					triangle.rotation = 180;
					align = 20;
				}else {
					triangle.rotation = 0;
					}
				if (ba.mouseY>=ba.height/2) {
					this.y += (lp.y - bgShape.height - 10 - y) / _speed;
					triangle.y = bgShape.height;
				}
				
				if (ba.mouseX<ba.width/2) {
					this.x += (lp.x -10 - this.x) / _speed;
					triangle.x = align + 5 
				}
				if (ba.mouseX>=ba.width/2) {
					this.x += (lp.x - bgShape.width + 20 - x) / _speed;
					triangle.x += (bgShape.width - 25 - triangle.x + align) / _speed;
				}
				rect = null
				ba = null
				lp = null
				maxHei=maxWid = NaN
				
		}
		
		private function handler(event:Object,_area:DisplayObject=null):void {  
			if (event == null) return;
			var eventSort:String;
			if (event is MouseEvent) {
				eventSort = event.type;
				}else if (event is String) {
					eventSort = event as String;
					}
			if (mouseDown && _downHide) {
				if (event.type == MouseEvent.MOUSE_UP) {
				stage.removeEventListener(MouseEvent.MOUSE_UP, handler);
				mouseDown = false;
				}
				return;
			}
            switch(eventSort) {  
                case MouseEvent.MOUSE_OUT:
					if (delayTimer != null) {
						delayTimer.reset();
						delayTimer.removeEventListener(TimerEvent.TIMER, delayShow);
						delayTimer = null;
						}
						hide();
                break;
				case MouseEvent.MOUSE_DOWN:
					if (_downHide&&stage) {
						mouseDown = true;
					if (delayTimer != null) {
						delayTimer.reset();
						delayTimer.removeEventListener(TimerEvent.TIMER, delayShow);
						delayTimer = null;
						}
						hide();
						stage.addEventListener(MouseEvent.MOUSE_UP, handler);
					}
				break
                case MouseEvent.MOUSE_OVER:
				area=_area?_area:event.target as Object;
				area.addEventListener(MouseEvent.MOUSE_DOWN, handler);
				area.addEventListener(MouseEvent.MOUSE_OUT, handler);
				area.addEventListener(Event.REMOVED_FROM_STAGE,removeInit);	
                   if (_delay == 0) {
					   show();  
				   }else {
					   if (delayTimer == null) delayTimer = new Timer(_delay);
					   delayTimer.addEventListener(TimerEvent.TIMER, delayShow);
					   delayTimer.start();
						area.addEventListener(MouseEvent.MOUSE_DOWN, handler);
					   }
                    break;   
			}
			function delayShow(e:TimerEvent):void
			{
				if(delayTimer!=null){
				delayTimer.removeEventListener(TimerEvent.TIMER, delayShow);
				delayTimer.stop();
				delayTimer = null;
				show();
				}
			}
        } 
		private function set text(value:String):void
		{
			if(txt)removeChild(txt)
				txt = new TextField;
				txt.x = txt.y = DIS/2;
				if (_glow) {
						new useFilter(this, "glow", { color:tip._styleObj._glowColor, alpha:1, blurX:2, blurY:2 } ) //添加发光
					}else{
						new useFilter(txt, "glow", { color:0x000000, alpha:0} ) //添加发光
					}
				addChild(txt);
			var inIndex:int = value.indexOf(STR);
			if ( inIndex!= -1) {
				_limitWid = uint(value.slice(0, inIndex))
				value=value.slice(inIndex+STR.length)
				}
			txt.autoSize=TextFieldAutoSize.LEFT;
			txt.wordWrap = false;
			txt.multiline = true;
			if (!_textFormat) {
				_textFormat = new TextFormat
				_textFormat.color=0x666666
				}
			txt.defaultTextFormat=_textFormat;
			txt.htmlText = value;
			
			if (_limitWid != 0) {
					var myTimer:Timer=new Timer(10);//延时设计时间,为调整文本块
					myTimer.addEventListener(TimerEvent.TIMER, timerHandler);
					myTimer.start();
				}else {
					width = txt.width+DIS;
					height = txt.height + DIS;
					showing();
					}
				function timerHandler(e:TimerEvent) {
					myTimer.stop();
					myTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
					if (txt.width > _limitWid) {//只有一行
						txt.width = _limitWid;
						txt.wordWrap = true;
						txt.autoSize = TextFieldAutoSize.LEFT;
					}
					width = txt.width+DIS;
					height = txt.height+DIS;
					showing();
				}
			function showing():void
			{
				drawBg();
				if (_adjust){
				_speed = speed_b;
				}else {
					speed_b = _speed;
					_speed = 1;
					}
				if(follow){
					if (runTimer == null) {
						runTimer = new Timer(20);
						}
						runTimer.addEventListener(TimerEvent.TIMER, enter_Frame);
						runTimer.start();
				}else {
					_speed=1
					enter_Frame(null)
					}
			}
		}
		private function drawBg():void
		{
			bgShape.graphics.clear();
			bgShape.graphics.beginFill(tip._styleObj._bgColor,tip._styleObj._alpha);
			bgShape.graphics.drawRoundRect(0, 0, _wid, _hei, tip._styleObj._ellipse, tip._styleObj._ellipse);//画矩形背景
						if(_specular){
			if (shapeMask != null) removeChild(shapeMask);
			shapeMask = new Shape;
			addChild(shapeMask);
  var colors:Array = [0xffffff, 0xffffff];
  var alphas:Array = [0.1, 0.5];
  var ratios:Array = [0x00, 0xFF];
  var matr:Matrix = new Matrix();
  matr.createGradientBox(_hei, _hei);
 shapeMask.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matr, SpreadMethod.PAD);  
			shapeMask.graphics.drawRoundRect(1, 1, _hei-2,_wid-2,  tip._styleObj._ellipse,tip._styleObj._ellipse);
			shapeMask.graphics.endFill();
			shapeMask.rotation = -90;
			shapeMask.y = _hei;
			}
			if (triangle == null) {
				triangle=new Shape
			triangle.graphics.beginFill(tip._styleObj._bgColor,tip._styleObj._alpha);
			triangle.graphics.moveTo(0,0);//绘制点,初始时都为0
			triangle.graphics.lineTo(10,0);
			triangle.graphics.lineTo(5,5);
			triangle.graphics.lineTo(0,0);
			triangle.graphics.endFill();
			addChild(triangle)
			setChildIndex(triangle,0)
			}
		}
	}
	
}