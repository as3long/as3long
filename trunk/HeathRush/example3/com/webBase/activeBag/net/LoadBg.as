// Copyright @ shch8.com All Rights Reserved At 2009-3-5
//开发：商创技术（www.shch8.com）望月狼
/*
·图片背景加载
加载外部图片，jpg,png,gif图片
* 例：
import com._public._net.LoadBg;
var url:String="http://www.shch8.com/v3/images/logo.gif"
var bgSpr:Sprite=LoadBg.getInstance().load(url,400,300,LoadBg.MATRIX);
bgSpr.addEventListener(Event.COMPLETE,complete)
function complete(event:Event):void{
	addChild(event.target as Sprite)
	}

 }

 */
package com.webBase.activeBag.net {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	public class LoadBg {
		public static const STRETCH:String = "stretch";//拉伸
		public static const CENTER:String = "center";//居中
		public static const MATRIX:String = "matrix";//平埔
		public static function getInstance():LoadBg {
			return new LoadBg;
		}
		/**
		 * 加载背景
		 * @param	filePath	文件路径
		 * @param	width		宽
		 * @param	height		高
		 * @param	mode		显示模式 STRETCH：拉伸 CENTER:居中 MATRIX:平埔 默认为：MATRIX
		 * @return
		 */
		public function load(filePath:String,width:uint=300,height:uint=200,mode:String=MATRIX):Sprite {
				var imgBox:Sprite = new Sprite;
				var loadimg:Loader = new Loader;
				loadimg.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoadComplete);
				loadimg.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
				loadimg.load(new URLRequest(filePath));
				function imgLoadComplete(event:Event):void {
					if (!(event.target.content is Bitmap)) return;
					var img:BitmapData = Bitmap(event.target.content).bitmapData;
					switch(mode) {
						case MATRIX:
							imgBox.graphics.beginBitmapFill(img);
							imgBox.graphics.drawRect(0, 0, width, height);
							imgBox.graphics.endFill();
						break;
						case CENTER:
							imgBox.addChild(loadimg);
							loadimg.x = (width - loadimg.width) / 2;
							loadimg.y = (height - loadimg.height) / 2;
						break
						case STRETCH:
							imgBox.addChild(loadimg);
							loadimg.width = width;
							loadimg.height = height;
						break
						default:
							imgBox.graphics.beginBitmapFill(img);
							imgBox.graphics.drawRect(0, 0, width, height);
							imgBox.graphics.endFill();
						break
					}
					imgBox.dispatchEvent(new Event(Event.COMPLETE));
						}
				return imgBox;
			}
		private function loadError(event:IOErrorEvent):void {
					throw new Error("背景加载失败，请检查您的文件路径！");
				}
	}
}