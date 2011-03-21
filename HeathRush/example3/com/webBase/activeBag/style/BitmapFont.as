// Copyright @ shch8.com All Rights Reserved At 2010-1-25
//开发：商创技术（www.shch8.com）望月狼
package com.webBase.activeBag.style
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * 生成位图文字
	 * @author WZH(shch8.com)
	 * @param	sourceTxt<TextField>	文字模板
	 * @param	showText<String>		文字内容
	 * @param	txtFormat<TextFormat>	样式
	 * @param	wid<Number>						强制宽度
	 * @param	sharp<Boolean>					是否使用未消除锯齿
	 * 
	 * @example 
	 * var txtFormat:TextFormat = new TextFormat("隶书",15,0x990000);
			var bf:Sprite = new BitmapFont(textBox.txt,"测试文本abcdefg",txtFormat);
			addChild(bf)
	 */
	public class BitmapFont extends Sprite
	{
		private var _bitmap:Bitmap;
		private var _text:String;
		private var _txtFormat:TextFormat;
		private var _sourceTxt:TextField;
		private var _width:Number
		private var _sharp:Boolean = false;
		public function BitmapFont(sourceTxt:TextField=null,showText:String="",txtFormat:TextFormat=null,wid:Number=0,sharp:Boolean=false) 
		{
			_text = showText;
			_txtFormat = txtFormat;
			_sourceTxt = sourceTxt;
			_width = wid;
			_sharp = sharp;
			refreshData();
		}
		private function refreshData():void {
			if (_sourceTxt == null) return;
			var bitmapData:BitmapData;
			if (_bitmap != null) {
				removeChild(_bitmap);
				_bitmap = null;
				}
			if(_text!=""){
				_sourceTxt.text = _text;
			}
			
			if (_sharp) {
				if (_txtFormat != null)_sourceTxt.setTextFormat(_txtFormat);
				_sourceTxt.autoSize = "left";
				bitmapData = new BitmapData(_sourceTxt.textWidth, _sourceTxt.textHeight,true,0);
				bitmapData.draw(_sourceTxt);
				_bitmap=new Bitmap(bitmapData,"always",true)
				addChild(_bitmap);
				return;
				}
			var size:uint = 12;
			
			
			if(_txtFormat==null){
			_txtFormat = new TextFormat;
			_txtFormat.font = "黑体";
			_txtFormat.size = 30;
			}else {
				size = _txtFormat.size as uint;
				if(size<25){
				_txtFormat.size = 25;
				}
				}
			var txtSize:uint=_txtFormat.size as uint;
			var sizeScale:Number = size / txtSize;
			
			if(_width==0){
			_sourceTxt.autoSize = TextFormatAlign.LEFT;
			_sourceTxt.multiline = false;
			_sourceTxt.wordWrap=false
			}else {
				_sourceTxt.wordWrap = true;
				_sourceTxt.multiline = true;
				_sourceTxt.width = _width/sizeScale;
				}
			
			_sourceTxt.setTextFormat(_txtFormat);
			_sourceTxt.autoSize = "left"
			bitmapData = new BitmapData(_sourceTxt.textWidth, _sourceTxt.textHeight, true, 0);
			
			bitmapData.draw(_sourceTxt);//转化为BitmapData数据
			
			_bitmap=new Bitmap(bitmapData,"always",true)
			var addSpr:Sprite = new Sprite;
			addSpr.addChild(_bitmap);
			
			_bitmap.width *= sizeScale;
			_bitmap.height *= sizeScale;
			//完成第一阶段生成
		
			bitmapData = new BitmapData(addSpr.width,addSpr.height,true,0);
			bitmapData.draw(addSpr);//转化为BitmapData数据
			_bitmap=new Bitmap(bitmapData,"always",true)
			addChild(_bitmap)
			
			_txtFormat.size = size;
			
			}
		//取得文字源
		public function set sourceTxt(value:TextField):void {
			_sourceTxt = value;
			refreshData();
			}
		//取得位图对象
		public function get bitmap():Bitmap {
			return _bitmap;
			}
		//字体样式设置
		public function get textFormat():TextFormat {
			return _txtFormat;
			}
		public function set textFormat(value:TextFormat):void {
			_txtFormat = value;
			refreshData();
			}
		public function setTextFormat(value:TextFormat):void {
			textFormat = value;
			}
		//文字设置
		public function set text(value:String):void {
			_text = value;
			refreshData();
			}
		public function get text():String {
			return _text;
			}
		
	}
	
}