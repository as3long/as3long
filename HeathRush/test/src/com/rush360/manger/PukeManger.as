package com.rush360.manger 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	import uk.co.bigroom.utils.ObjectPool;
	import flash.filters.GlowFilter;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author 黄龙
	 */
	public class PukeManger extends EventDispatcher
	{
		public static var WIDTH:int = 800;
		public static var HEIGHT:int = 600;
		public var pok_arr:Array = ["DY", "FK", "HT", "MH"];
		public var mainSprite:PukeMain;
		public var stageObj:Stage;
		
		public function PukeManger()
		{
			
		}
		
		public function puke_init():void
		{
			for (var i:int = 0; i <= 54; i++)
			{
				var obj:DisplayObject= get_puke(54);
				obj.x = 360+2*i;
				obj.y =	257.5;
				mainSprite.pukeSprite.addChild(obj);
			}
		}
		
		public function puke_Test():void
		{
			for (var i:int = 0; i <=54; i++)
			{
				var obj:DisplayObject= get_puke(i);
				obj.x = (i % 10)*70 + 35;
				obj.y =	int(i / 10) * 100+50;
				mainSprite.pukeSprite.addChild(obj);
			}
			mainSprite.pukeSprite.addEventListener(MouseEvent.MOUSE_OVER, mouse_over);
		}
		
		private function mouse_over(e:MouseEvent):void 
		{
			var my_Filter:GlowFilter =ObjectPool.getObject(GlowFilter,0x0080FF, 100, 10, 10, 2, 1, false, false);
			e.target.filters = [my_Filter];
			ObjectPool.disposeObject(my_Filter);
			e.target.addEventListener(MouseEvent.MOUSE_OUT, mouse_Out);
		}
		
		private function mouse_Out(e:MouseEvent):void 
		{
			e.target.filters = [];
		}
		
		/**
		 * 获取扑克
		 * @param	id
		 * @return
		 */
		public function get_puke(id:int):*
		{
			var obj:*;
			var str:String = "";
			switch(id)
			{
				case 54: 
						obj = getClass("CARDBG");
						break;
				case 53:
						obj = getClass("KingB");
						break;
				case 52:
						obj =getClass("KingA");
						break;
				default:
						if ((id%13)< 9)
						{
							obj = getClass(pok_arr[int(id/13)]+"0" +(id%13+1))
						}
						else
						{
							obj=getClass(pok_arr[int(id/13)]+(id%13+1))
						}
						break;
			}
			return obj;
		}
		
		private function getClass(name:String):*
		{
		 	 var cls:Class=getDefinitionByName(name) as Class;
			 return ObjectPool.getObject(cls);
		}
		
		/**
		 * 随机发牌的方法
		 * @param	with_joker 是否含有大小王(0表示有);
		 * @param	column 分成几份
		 * @return
		 */
		public function random_puke(with_joker:int = 0,column:int=4):Array
		{
			return [];
		}
		
		
		
		/**
		 * 单例引用
		 */
		public static function get instance():PukeManger
		{
			if(_instance == null)
			{
				_instance = new PukeManger();
			}
			return _instance;
		}
		
		private static var _instance:PukeManger = null;
	}

}