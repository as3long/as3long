package com.as3long.view.components
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.*;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.display.CapsStyle;
	import flash.display.LineScaleMode;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author huanglong
	 */
	public class CoolButton extends Sprite
	{
		private var mybutton:MovieClip;
		private var colormatrix:Matrix;
		private var colorarray:Array;
		private var ispressed:Boolean;
		private var _txtField:TextField;
		private var _height:Number;
		private var _width:Number;
		
		public function CoolButton(txt:String = '按钮', _height1:Number = 32, _width1:Number = 64)
		{
			_height = _height1;
			_width = _width1;
			mybutton = new MovieClip();
			ispressed = false;
			colorarray = [0, 148, 148, 255];
			colormatrix = new Matrix();
			colormatrix.createGradientBox(_width, _height, Math.PI / 2, 0, 0);
			//mybutton._height = _height;
			//mybutton._width = _width;
			
			mybutton.graphics.lineStyle(1, 0x707070, 1, true, LineScaleMode.NONE, CapsStyle.NONE, null, 3);
			mybutton.graphics.drawRoundRect(3, 3, _width - 1, _height - 1, 3, 3);
			mybutton.graphics.lineStyle(1, 0xF3F3FF, 1, true, LineScaleMode.NONE, CapsStyle.NONE, null, 3);
			mybutton.graphics.beginGradientFill(GradientType.LINEAR, [0xF5F5F5, 0xE0E0E0, 0xCFCFCF, 0xC0C0C0], [1, 1, 1, 1], colorarray, colormatrix);
			mybutton.graphics.drawRoundRect(4, 4, _width - 3, _height - 3, 3, 3);
			mybutton.graphics.endFill();
			addChild(mybutton);
			_txtField = new TextField();
			/*var tf:TextFormat = new TextFormat();
			tf.align = TextFormatAlign.CENTER;
			_txtField.setTextFormat(tf);*/
			_txtField.selectable = false;
			_txtField.text = txt;
			_txtField.mouseEnabled = false;
			_txtField.y = (_height-_txtField.textHeight)/2;
			_txtField.x = (_width - _txtField.textWidth) / 2;
			_txtField.width = _txtField.textWidth+3;
			_txtField.height = _txtField.textHeight+3;
			addChild(_txtField);
			this.addEventListener(MouseEvent.MOUSE_OVER, onhover);
			this.addEventListener(MouseEvent.MOUSE_OUT, onout);
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function onhover(event:Event):void
		{
			//var _height:Number = event.target._height;
			//var _width:Number = event.target._width;
			if (ispressed)
			{
				mybutton.graphics.lineStyle(1, 0x2C628B, 1, true, LineScaleMode.NONE, CapsStyle.NONE, null, 3);
				mybutton.graphics.drawRoundRect(3, 3, _width - 1, _height - 1, 3, 3);
				mybutton.graphics.lineStyle(1, 0x63ACD3, 1, true, LineScaleMode.NONE, CapsStyle.NONE, null, 3);
				mybutton.graphics.beginGradientFill(GradientType.LINEAR, [0xE5F4FC, 0xC4E5F6, 0x98D1EF, 0x6DB6DD], [1, 1, 1, 1], colorarray, colormatrix);
				mybutton.graphics.drawRoundRect(4, 4, _width - 3, _height - 3, 3, 3);
				mybutton.graphics.endFill();
			}
			else
			{
				mybutton.graphics.lineStyle(1, 0x3C7FBE, 1, true, LineScaleMode.NONE, CapsStyle.NONE, null, 3);
				mybutton.graphics.drawRoundRect(3, 3, _width - 1, _height - 1, 3, 3);
				mybutton.graphics.lineStyle(1, 0xEFF9FE, 1, true, LineScaleMode.NONE, CapsStyle.NONE, null, 3);
				mybutton.graphics.beginGradientFill(GradientType.LINEAR, [0xF5F5F5, 0xD9F0FC, 0xBEE6FD, 0xA7D9F5], [1, 1, 1, 1], colorarray, colormatrix);
				mybutton.graphics.drawRoundRect(4, 4, _width - 3, _height - 3, 3, 3);
				mybutton.graphics.endFill();
			}
		}
		
		public function onout(event:Event):void
		{
			//var _height:Number = event.target._height;
			//var _width:Number = event.target._width;
			mybutton.graphics.lineStyle(1, 0x707070, 1, true, LineScaleMode.NONE, CapsStyle.NONE, null, 3);
			mybutton.graphics.drawRoundRect(3, 3, _width - 1, _height - 1, 3, 3);
			mybutton.graphics.lineStyle(1, 0xF3F3FF, 1, true, LineScaleMode.NONE, CapsStyle.NONE, null, 3);
			mybutton.graphics.beginGradientFill(GradientType.LINEAR, [0xF5F5F5, 0xE0E0E0, 0xCFCFCF, 0xC0C0C0], [1, 1, 1, 1], colorarray, colormatrix);
			mybutton.graphics.drawRoundRect(4, 4, _width - 3, _height - 3, 3, 3);
			mybutton.graphics.endFill();
		}
		
		public function onpress(event:Event):void
		{
			//var _height:Number = event.target._height;
			//var _width:Number = event.target._width;
			ispressed = true;
			mybutton.graphics.lineStyle(1, 0x2C628B, 1, true, LineScaleMode.NONE, CapsStyle.NONE, null, 3);
			mybutton.graphics.drawRoundRect(3, 3, _width - 1, _height - 1, 3, 3);
			mybutton.graphics.lineStyle(1, 0x63ACD3, 1, true, LineScaleMode.NONE, CapsStyle.NONE, null, 3);
			mybutton.graphics.beginGradientFill(GradientType.LINEAR, [0xE5F4FC, 0xC4E5F6, 0x98D1EF, 0x6DB6DD], [1, 1, 1, 1], colorarray, colormatrix);
			mybutton.graphics.drawRoundRect(4, 4, _width - 3, _height - 3, 3, 3);
			mybutton.graphics.endFill();
		}
		
		public function onrelease(event:Event):void
		{
			//var _height:Number = event.target._height;
			//var _width:Number = event.target._width;
			ispressed = false;
			mybutton.graphics.lineStyle(1, 0x707070, 1, true, LineScaleMode.NONE, CapsStyle.NONE, null, 3);
			mybutton.graphics.drawRoundRect(3, 3, _width - 1, _height - 1, 3, 3);
			mybutton.graphics.lineStyle(1, 0xF3F3F3, 1, true, LineScaleMode.NONE, CapsStyle.NONE, null, 3);
			mybutton.graphics.beginGradientFill(GradientType.LINEAR, [0xF5F5F5, 0xE0E0E0, 0xCFCFCF, 0xC0C0C0], [1, 1, 1, 1], colorarray, colormatrix);
			mybutton.graphics.drawRoundRect(4, 4, _width - 3, _height - 3, 3, 3);
			mybutton.graphics.endFill();
		}
		
		public function onClick(event:Event):void
		{
			//trace(event.target, 'is just being clicked');
			dispatchEvent(new Event('onClick'));
		}
	
	}
}