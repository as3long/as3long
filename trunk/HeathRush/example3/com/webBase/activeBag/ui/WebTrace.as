package com.webBase.activeBag.ui
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.net.SharedObject;
	
	/**
	 * ...
	 * @author wmy
	 * 调试工具类
	 */
	public class WebTrace extends Sprite
	{
		//自己
		static private var _thisTrace:WebTrace;
		//舞台
		static private var _stage:Stage;
		//是否调试Bug
		static private var _isBug:Boolean;
		//窗口
		static private var _win:Win;
		
		//构造函数
		public function WebTrace(c:_thisInit) {}
		/**
		 * 获取自己
		 */
		static private function get thisTrace():WebTrace {
			if(!_thisTrace)_thisTrace=new WebTrace(new _thisInit());
			return _thisTrace; 
		}
		/**
		 * 设置
		 * @param	stage 舞台
		 * @param	isBug 是否调试Bug
		 */
		static public function get isInstall():Boolean { if (_stage) return true; return false; };
		static public function init(stage:Stage,isBug:Boolean=true):void
		{
			if (!stage || _thisTrace) return;
			_stage = stage;
			_isBug = isBug;
			_stage.addChild(thisTrace);
			var mySo:SharedObject = SharedObject.getLocal("webTracePoint");
			if (mySo.data.width == null) mySo.data.width = (_stage.stageWidth - 400) / 2;
			if (mySo.data.height == null) mySo.data.height = (_stage.stageHeight - 300) / 2;
			if (mySo.data.x == null) mySo.data.x = _stage.stageWidth / 2;
			if (mySo.data.y == null) mySo.data.y = _stage.stageHeight / 2;
			
			_win = new Win(mySo.data.x,mySo.data.y,mySo.data.width,mySo.data.height);
			_thisTrace.addChild(_win);
		}
		
		/**
		 * 输出
		 * @param	obj 对象
		 * @param	aes 排序正反
		 */
		static public function trace(obj:Object = null,aes:Boolean=true):void
		{
			if((obj is String)&&obj=="")obj="空字符串"
			if (obj == null) obj = "null";
			if (!_isBug) return;
			_stage.addChild(thisTrace);
			_win.visible = true;
			_win.contentTxt(obj.toString(),aes);
		}
	}
}
class _thisInit { };

import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.SpreadMethod;
import flash.display.Sprite;
import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.SharedObject;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

class Win extends Sprite {
	private var _mouseDifference:Point;
	private var _minSize:Point;
	
	//坐标，宽，高，标题
	private var _dx:Number;
	private var _dy:Number;
	private var _width:Number;
	private var _height:Number;
	private var _title:String;
	
	//
	//改变大小按钮
	private var _scaleBtn:Sprite;
	//关闭按钮
	private var _closeBtn:Sprite;
	//最小化按钮
	private var _minBtn:Sprite;
	//最小化窗口
	private var _minSp:Sprite;
	//最大化按钮
	private var _maxBtn:Sprite;
	//最大化窗口
	private var _maxSp:Sprite;
	//拖动条
	private var _titleBar:Sprite;
	//标题Txt
	//private var _titleTxt:TextField;
	//内容Txt
	private var _contentTxt:TextField;
	//文本拖动条
	private var _thumbBtn:Sprite;
	//背景
	private var _bgSp:Sprite;
	private var _ruler:Sprite
	private var mySo:SharedObject;
	/**
	 * 构造函数
	 * @param	_x x坐标
	 * @param	_y y坐标
	 * @param	_w 宽
	 * @param	_h 高
	 * @param	_tit 标题
	 */
	public function Win(_x:Number=0,_y:Number=0,_w:Number=400,_h:Number=300,_tit:String="")
	{
		visible = false;
		_minSize = new Point(100, 150);
		
		_width = _w<_minSize.x?_minSize.x:_w;
		_height = _h<_minSize.y?_minSize.y:_h;
		_title = _tit;
		
		x = _dx = _x;
		y = _dy = _y;
		
		createWin();
		addListener();
		var myContextMenu:ContextMenu = new ContextMenu();
		var item:ContextMenuItem = new ContextMenuItem("清除内容");
        myContextMenu.customItems.push(item);
        item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuSelectHandler);
		this.contextMenu = myContextMenu
		 mySo = SharedObject.getLocal("webTracePoint");
	}
	private function menuSelectHandler(event:ContextMenuEvent):void {
           _contentTxt.text = "";
        }
	/**
	 * 输出
	 * @param	t 文本
	 * @param	aes 排序正反
	 */
	public function contentTxt(t:String,aes:Boolean=true):void 
	{
		if(aes){
			_contentTxt.appendText(t + "\n");
			_thumbBtn.y = _contentTxt.y + _contentTxt.height - _thumbBtn.height;
			if (_thumbBtn.y <= _contentTxt.y)_thumbBtn.y = _contentTxt.y;
			if (_thumbBtn.y >= _contentTxt.y + _contentTxt.height - _thumbBtn.height) {
				_thumbBtn.y = _contentTxt.y + _contentTxt.height - _thumbBtn.height;
			}
			var nowPosition : Number = Math.floor(_thumbBtn.y);
			var totalPixels:Number = _contentTxt.height - _thumbBtn.height;
			_contentTxt.scrollV = (_contentTxt.maxScrollV - 1) * (nowPosition - _contentTxt.y ) / totalPixels + 2;
			//误差校正
			var unitPixels : Number = totalPixels / (_contentTxt.maxScrollV - 1);
			if((nowPosition - _contentTxt.y) < unitPixels) {
				_contentTxt.scrollV = (_contentTxt.maxScrollV - 1) * (nowPosition - _contentTxt.y) / totalPixels;
			}
		}else {
			_contentTxt.replaceText(0, 0, t + "\n");
		}
		if(_contentTxt.maxScrollV != 1) {
			_thumbBtn.visible = true;
		}else {
			_thumbBtn.visible = false;
		}
	}
	
	//创建win
	private function createWin():void
	{
		//最大化窗体
		_maxSp = new Sprite();
		addChild(_maxSp)
		//背景
		_bgSp = new Sprite();
		_maxSp.addChild(_bgSp);
		drawBg();
		//标题Text
		/*_titleTxt = new TextField();
		_titleTxt.mouseEnabled = false;
		//_titleTxt.border = true;
		_titleTxt.textColor = 0x676767;
		_titleTxt.x = 60;
		_titleTxt.y = 0;
		_titleTxt.width = _width - 60;
		_titleTxt.height = 20;
		_titleTxt.text = _title;
		_maxSp.addChild(_titleTxt);*/
		//内容Text
		_contentTxt	= new TextField();
		_contentTxt.wordWrap = true;
		_contentTxt.mouseWheelEnabled = false;
		//_contentTxt.border = true;
		_contentTxt.defaultTextFormat=new TextFormat("宋体",13)
		_contentTxt.textColor = 0x676767;
		_contentTxt.x =15;
		_contentTxt.y = 30;
		_contentTxt.width = _width-30;
		_contentTxt.height = _height-40;
		_maxSp.addChild(_contentTxt);
		//拖动条
		_thumbBtn = new Sprite;
		_thumbBtn.visible = false;
		_thumbBtn.buttonMode = true;
		with (_thumbBtn) {
			graphics.beginFill(0xd9d9d9);
			graphics.drawRect(0, 0, 10, _contentTxt.height);
			graphics.endFill();
		}
		_thumbBtn.x = _contentTxt.x + _contentTxt.width;
		_thumbBtn.y = _contentTxt.y;
		_maxSp.addChild(_thumbBtn);
		_titleBar = new Sprite();
		with (_titleBar) {
			graphics.beginFill(0,0);
			graphics.drawRect(0, 0, _width, 20);
			graphics.endFill();
		}
		_titleBar.width = _width;
		_maxSp.addChild(_titleBar);
		//最小化按钮
		_minBtn = new Sprite();
		_minBtn.buttonMode = true;
		with (_minBtn) {
			graphics.beginFill(0xffffff,0.6);
			graphics.drawRoundRect(-8, -8, 16,16,5,5);
			graphics.endFill();
			
			graphics.lineStyle(1, 0x000000,1,true);
			graphics.moveTo(-4, 0);
			graphics.lineTo(4, 0);
		}
		_minBtn.x = 13;
		_minBtn.y = 11;
		_maxSp.addChild(_minBtn);
		//关闭按钮
		_closeBtn = new Sprite();
		_closeBtn.buttonMode = true;
		with (_closeBtn) {
			graphics.beginFill(0xffffff,0.6);
			graphics.drawRoundRect(-8, -8, 16,16,5,5);
			graphics.endFill();
			
			graphics.lineStyle(1, 0x000000,1,true);
			graphics.moveTo(Math.cos(Math.PI / 4) * 6, Math.sin(Math.PI / 4) * 6);
			graphics.lineTo(Math.cos( -3 / 4 * Math.PI) * 6, Math.sin( -3 / 4 * Math.PI) * 6);
			
			graphics.moveTo(Math.cos( -Math.PI / 4) * 6, Math.sin(-Math.PI / 4) * 6);
			graphics.lineTo(Math.cos( 3 / 4 * Math.PI) * 6, Math.sin( 3 / 4 * Math.PI) * 6);
		}
		_closeBtn.x = 33;
		_closeBtn.y = 11;
		_maxSp.addChild(_closeBtn);
		//调整大小按钮
		_scaleBtn = new Sprite();
		_scaleBtn.buttonMode = true;
		with (_scaleBtn) {
			graphics.beginFill(0,0);
			graphics.drawRect(0, 0, 20, 20);
			graphics.endFill();
			graphics.beginFill(0x999999);
			graphics.lineStyle(1, 0x999999,0,true);
			graphics.moveTo(10, 18);
			graphics.lineTo(18, 18);
			graphics.lineTo(18, 10);
			graphics.lineTo(10, 18);
			graphics.lineTo(16, 12);
		}
		_scaleBtn.x = _width - 20;
		_scaleBtn.y = _height - 20;
		_maxSp.addChild(_scaleBtn);
		
		//最小化窗体
		_minSp = new Sprite();
		with (_minSp) {
			graphics.beginFill(0xe9e9e9);
			graphics.drawRoundRect( 0, 0,40, 20, 10, 10);
			graphics.endFill();
			_minSp.filters=new Array(new GlowFilter(0x333333,0.8,4,4,2,1,true));
		}
		_minSp.visible = false;
		addChild(_minSp);
		//最大化按钮
		_maxBtn = new Sprite();
		_maxBtn.buttonMode = true;
		with (_maxBtn) {
			graphics.beginFill(0xb5b5b5);
			graphics.drawRoundRect(0, 0, 16,16,5,5);
			graphics.endFill();
			graphics.beginFill(0x666666);
			graphics.drawRoundRect(2, 4, 12,8,5,5);
			graphics.endFill();
		}
		_maxBtn.x = 2;
		_maxBtn.y = 2;
		_minSp.addChild(_maxBtn);
	}
	private function drawBg():void
	{
		var titleHeight:uint = 25;
		var shapeMask:Shape = _bgSp.getChildByName("shapeMask") as Shape;
		if (shapeMask == null) shapeMask = new Shape;
		shapeMask.graphics.clear();
		shapeMask.name="shapeMask"
		_bgSp.addChild(shapeMask);
		var colors:Array = [0xffffff, 0xffffff];
		var alphas:Array = [0.03, 0.4];
		var ratios:Array = [0x00, 0xFF];
		var matr:Matrix = new Matrix();
		matr.createGradientBox(titleHeight-10, titleHeight-10);  
		shapeMask.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matr, SpreadMethod.PAD);  
		shapeMask.graphics.drawRoundRect(1, 1, titleHeight-2-10,_width,  5,5);
		shapeMask.graphics.endFill();
		shapeMask.rotation = -90;
		shapeMask.y = titleHeight-10;
		
		
		var g:Graphics = _bgSp.graphics;
		g.clear();
		
		g.lineStyle(1, 0xbbbbbb, 1, true);
		g.beginFill(0xf9f9f9);
		g.moveTo(0, 5);
		g.curveTo(0, 0, 5, 0);
		g.lineTo(_width - 5, 0);
		g.curveTo(_width, 0, _width, 5);
		g.lineTo(_width, _height - 5);
		g.curveTo(_width, _height, _width-5, _height);
		g.lineTo(5, _height);
		g.curveTo(0, _height, 0, _height - 5);
		g.lineTo(0, 5);
		g.endFill();
		
		g.beginFill(0x222222);
		g.moveTo(0, titleHeight);
		g.lineTo(0, 5);
		g.curveTo(0, 0, 5, 0);
		g.lineTo(_width - 5, 0);
		g.curveTo(_width, 0, _width, 5);
		g.lineTo(_width, titleHeight);
		g.lineTo(0, titleHeight);
		g.endFill();
		
		if (_ruler == null) {
			_ruler = new Sprite
			_bgSp.addChild(_ruler)
		}
		_ruler.graphics.clear()
		_ruler.graphics.beginFill(0xeeeeee)
		_ruler.graphics.drawRect(1,titleHeight, 10, _height-titleHeight-1)
		_ruler.graphics.endFill()

	}
	
	//事件
	private function addListener():void
	{
		_scaleBtn.addEventListener(MouseEvent.MOUSE_OVER, mouseoverListener);
		_scaleBtn.addEventListener(MouseEvent.ROLL_OUT, mouseoutListener);
		_scaleBtn.addEventListener(MouseEvent.MOUSE_DOWN, mousedownScaleListener);
		
		_titleBar.addEventListener(MouseEvent.MOUSE_DOWN, mousedownMoveListener);
		_titleBar.doubleClickEnabled = true;
		_titleBar.addEventListener(MouseEvent.DOUBLE_CLICK, clickMinBtnListener);
		
		_minSp.addEventListener(MouseEvent.MOUSE_DOWN, mousedownMoveListener);
		_minSp.doubleClickEnabled = true;
		_minSp.addEventListener(MouseEvent.DOUBLE_CLICK, clickMaxBtnListener);
		
		
		_closeBtn.addEventListener(MouseEvent.MOUSE_OVER, mouseoverListener);
		_closeBtn.addEventListener(MouseEvent.ROLL_OUT, mouseoutListener);
		_closeBtn.addEventListener(MouseEvent.CLICK, clickCloseListener);
		
		_minBtn.addEventListener(MouseEvent.MOUSE_OVER, mouseoverListener);
		_minBtn.addEventListener(MouseEvent.ROLL_OUT, mouseoutListener);
		_minBtn.addEventListener(MouseEvent.CLICK, clickMinBtnListener);
		
		_maxBtn.addEventListener(MouseEvent.MOUSE_OVER, mouseoverListener);
		_maxBtn.addEventListener(MouseEvent.ROLL_OUT, mouseoutListener);
		_maxBtn.addEventListener(MouseEvent.CLICK, clickMaxBtnListener);
		
		
		_thumbBtn.addEventListener(MouseEvent.MOUSE_DOWN, mousedownThumbListener);
		_contentTxt.addEventListener(Event.SCROLL, scrollContentTxtListener);
		_contentTxt.addEventListener(MouseEvent.MOUSE_WHEEL, mousewheelContentTxtListener);
	}
	private function clickMinBtnListener(e:MouseEvent):void 
	{
		_maxSp.visible = false;
		_minSp.visible = true;
	}
	private function clickMaxBtnListener(e:MouseEvent):void 
	{
		_maxSp.visible = true;
		_minSp.visible = false;
	}
	private function scrollContentTxtListener(e:Event):void 
	{
		if(_contentTxt.maxScrollV != 1) {
			_thumbBtn.visible = true;
			var heightVar : Number = 1 - (_contentTxt.maxScrollV - 1) / _contentTxt.maxScrollV;
			_thumbBtn.height = Math.floor(_contentTxt.height * Math.pow(heightVar, 1 / 3));
			var totalPixels:Number = _contentTxt.height - _thumbBtn.height;
			_thumbBtn.y = Math.floor(_contentTxt.y + totalPixels * (_contentTxt.scrollV - 1) / (_contentTxt.maxScrollV - 1));
		}else {
			_thumbBtn.visible = false;
		}
	}
	private function mousewheelContentTxtListener(e:MouseEvent):void 
	{
		if(_contentTxt.selectable) {
			_contentTxt.scrollV -= Math.floor(e.delta / 2);
		}else{
			e.delta = 1;
		}
		var totalPixels:Number = _contentTxt.height - _thumbBtn.height;
		_thumbBtn.y = Math.floor(_contentTxt.y + totalPixels * (_contentTxt.scrollV - 1) / (_contentTxt.maxScrollV - 1));
	}
	private function mousedownThumbListener(e:MouseEvent):void 
	{
		_mouseDifference = new Point(_thumbBtn.mouseX, _thumbBtn.mouseY);
		addEventListener(Event.ENTER_FRAME, enterframeThumbListener);
		this.stage.addEventListener(MouseEvent.MOUSE_UP, mouseupThumbListener);
	}
	private function mouseupThumbListener(e:MouseEvent):void 
	{
		removeEventListener(Event.ENTER_FRAME, enterframeThumbListener);
		this.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseupThumbListener);
	}
	private function enterframeThumbListener(e:Event):void 
	{
		_thumbBtn.y = mouseY - _mouseDifference.y * _thumbBtn.scaleY;
		if (_thumbBtn.y <= _contentTxt.y)_thumbBtn.y = _contentTxt.y;
		if (_thumbBtn.y >= _contentTxt.y + _contentTxt.height - _thumbBtn.height) {
			_thumbBtn.y = _contentTxt.y + _contentTxt.height - _thumbBtn.height;
		}
		//在滚动过程中及时获得滑块所处位置
		var nowPosition : Number = Math.floor(_thumbBtn.y);
		var totalPixels:Number = _contentTxt.height - _thumbBtn.height;
		//使文本随滚动条滚动,这里为什么要加1，可见scroll属性值应该是取正的，也就是说它会删除小数部分，而非采用四舍五入制？
		_contentTxt.scrollV = (_contentTxt.maxScrollV - 1) * (nowPosition - _contentTxt.y ) / totalPixels + 2;
		//误差校正
		var unitPixels : Number = totalPixels / (_contentTxt.maxScrollV - 1);
		if((nowPosition - _contentTxt.y) < unitPixels) {
			_contentTxt.scrollV = (_contentTxt.maxScrollV - 1) * (nowPosition - _contentTxt.y) / totalPixels;
		}
	}
	private function clickCloseListener(e:MouseEvent):void 
	{
		visible = false;
		_contentTxt.text = "";
	}
	private function mousedownMoveListener(e:MouseEvent):void 
	{
		_mouseDifference = new Point(mouseX, mouseY);
		addEventListener(Event.ENTER_FRAME, enterframeMoveListener);
		addEventListener(MouseEvent.MOUSE_UP, mouseupMoveListener);
	}
	private function enterframeMoveListener(e:Event):void 
	{
		x = parent.mouseX - _mouseDifference.x * scaleX;
		y = parent.mouseY - _mouseDifference.y * scaleY;
            mySo.data.x = x;
			mySo.data.y = y;
            mySo.flush();
	}
	private function mouseupMoveListener(e:MouseEvent):void 
	{
		removeEventListener(Event.ENTER_FRAME, enterframeMoveListener);
		removeEventListener(MouseEvent.MOUSE_UP, mouseupMoveListener);
	}
	private function mousedownScaleListener(e:MouseEvent):void 
	{
		_mouseDifference = new Point(_width-mouseX, _height-mouseY);
		addEventListener(Event.ENTER_FRAME, enterframeScaleListener);
		stage.addEventListener(MouseEvent.MOUSE_UP, mouseupScaleListener);
	}
	private function enterframeScaleListener(e:Event):void 
	{
		_width = mouseX + _mouseDifference.x;
		_height = mouseY + _mouseDifference.y;
		if (_width < _minSize.x) _width = _minSize.x;
		if (_height < _minSize.y) _height = _minSize.y;
		
		drawBg();
		
		_scaleBtn.x = _width - 20;
		_scaleBtn.y = _height - 20;
		
		_titleBar.width = _width;
		
		//_titleTxt.width = _width - 60;
		
		_contentTxt.width = _width-30;
		_contentTxt.height = _height - 40;
		
		_thumbBtn.x = _contentTxt.x + _contentTxt.width;
		if(_contentTxt.maxScrollV != 1) {
			_thumbBtn.visible = true;
			if (_thumbBtn.y <= _contentTxt.y)_thumbBtn.y = _contentTxt.y;
			if (_thumbBtn.y >= _contentTxt.y + _contentTxt.height - _thumbBtn.height) {
				_thumbBtn.y = _contentTxt.y + _contentTxt.height - _thumbBtn.height;
			}
			var nowPosition : Number = Math.floor(_thumbBtn.y);
			var totalPixels:Number = _contentTxt.height - _thumbBtn.height;
			_contentTxt.scrollV = (_contentTxt.maxScrollV - 1) * (nowPosition - _contentTxt.y ) / totalPixels + 2;
			//误差校正
			var unitPixels : Number = totalPixels / (_contentTxt.maxScrollV - 1);
			if((nowPosition - _contentTxt.y) < unitPixels) {
				_contentTxt.scrollV = (_contentTxt.maxScrollV - 1) * (nowPosition - _contentTxt.y) / totalPixels;
			}
		}else {
			_thumbBtn.visible = false;
		}
	}
	private function mouseupScaleListener(e:MouseEvent):void 
	{
		removeEventListener(Event.ENTER_FRAME, enterframeScaleListener);
		stage.removeEventListener(MouseEvent.MOUSE_UP, mouseupScaleListener);
            mySo.data.width = _width;
			mySo.data.height = _height;
			trace(_width)
            mySo.flush();
	}
	private function mouseoverListener(e:Event):void 
	{
		e.target.alpha = 0.5;
	}
	
	private function mouseoutListener(e:Event):void 
	{
		e.target.alpha = 1;
	}
	
}
