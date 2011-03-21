package com.rush360.manger 
{
	import com.rush360.net.Ku_Loader;
	import cwin5.net.C5Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.system.ApplicationDomain;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author 黄龙
	 */
	public class BlogManger extends Sprite
	{
		
		public var xingqi_obj:* = null;
		public var xingqi_Loader:Ku_Loader = null;
		
		public function BlogManger() 
		{
			xingqi_Loader = new Ku_Loader();
			xingqi_Loader.addEventListener(Event.COMPLETE, load_complete);
			trace("开始加载");
			xingqi_Loader.load("xingqi.swf");
		}
		
		private function load_complete(e:Event):void 
		{
			init();
		}
		
		public function init():void
		{
			xingqi_obj =xingqi_Loader.getObject("ui.xingqi");
			xingqi_obj.x = 400;
			xingqi_obj.y = 300;
			this.addChild(xingqi_obj);
			for (var i:int = 0; i < 7; i++)
			{
				if (i == 0)
				{
					xingqi_obj["_x" + (i + 1)]._xingqi.text = "一";
					
				}
				else if (i == 1)
				{
					xingqi_obj["_x"+(i+1)]._xingqi.text = "二";
				}
				else if (i == 2)
				{
					xingqi_obj["_x"+(i+1)]._xingqi.text = "三";
				}
				else if (i == 3)
				{
					xingqi_obj["_x"+(i+1)]._xingqi.text = "四";
				}
				else if (i == 4)
				{
					xingqi_obj["_x"+(i+1)]._xingqi.text = "五";
				}
				else if (i == 5)
				{
					xingqi_obj["_x"+(i+1)]._xingqi.text = "六";
				}
				else if (i == 6)
				{
					xingqi_obj["_x"+(i+1)]._xingqi.text = "日";
				}
				xingqi_obj["_x" + (i + 1)]._title.text = "寂寞" + i;
				xingqi_obj["_x" + (i + 1)]._info.text = "一些说明" + i;
				xingqi_obj["_x" + (i + 1)]._image.source =i + ".jpg" ;
				xingqi_obj["_x" + (i + 1)].addEventListener(MouseEvent.MOUSE_OVER, isOver);
				xingqi_obj["_x" + (i + 1)].alpha = 0.95;
			}
		}
		
		private function isOver(e:MouseEvent):void 
		{
			e.currentTarget.addEventListener(MouseEvent.MOUSE_OUT, isOut);
			e.currentTarget.parent.setChildIndex(e.currentTarget, e.currentTarget.parent.numChildren - 1);
			e.currentTarget.alpha = 1;
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1.2;
		}
		
		private function isOut(e:MouseEvent):void 
		{
			e.currentTarget.addEventListener(MouseEvent.MOUSE_OUT, isOut);
			e.currentTarget.alpha = 0.95;
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
		}
		
		/**
		 * 单例引用
		 */
		public static function get instance():BlogManger
		{
			if(_instance == null)
			{
				_instance = new BlogManger();
			}
			return _instance;
		}
		
		private static var _instance:BlogManger = null;
		
	}

}