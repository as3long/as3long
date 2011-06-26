package com.as3long
{
	import com.as3long.tool.BitmapHitTest;
	import flash.display.Sprite;
	import com.as3long.tool.LTrace;
	import com.as3long.tool.SWFLoader;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.media.Sound;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import com.as3long.tool.BitmapHitTestPlus;
	
	/**
	 * 主程序
	 */
	public class HitTestMain extends Sprite
	{
		/**
		 * 加载器
		 */
		public var swfLoad:SWFLoader;
		/**
		 * 刀
		 */
		public var _dao:MovieClip;
		/**
		 * 当前气球数量
		 */
		public var qiqiuNum:int = 0;
		/**
		 * 最大气球数量(默认:5)
		 */
		public var _maxNum:int = 5;
		/**
		 * 存放气球对象的数组
		 */
		public var qiqiuArr:Array = new Array();
		/**
		 * 气球爆炸的声音
		 */
		public var _music:Sound;
		/**
		 * 计分文本
		 */
		public var _txtShow:TextField;
		/**
		 * 割破的气球数量
		 */
		public var _poNum:int = 0;
		/**
		 * 逃跑的气球数量
		 */
		public var _taoNum:int = 0;
		/**
		 * 模式:	0为键盘模式,	1为鼠标模式.
		 */
		public var _mode:int = 0;
		
		public var __mc:MovieClip;
		
		/**
		 * 实例化程序入口 
		 */
		public function HitTestMain()
		{
			Security.loadPolicyFile("http://www.360rush.com/crossdomain.xml");
			LTrace.t("hello hitTest");
			swfLoad=new SWFLoader();
			swfLoad.addEventListener(Event.COMPLETE,loadComplete);
			swfLoad.Load("http://www.360rush.com/smallgame/hittest/lib.swf");
		}
		
		/**
		 * 素材加载完成后执行
		 * @param	e 
		 */
		public function loadComplete(e:Event):void
		{
			__mc = new 飲料櫃_2();
			__mc.stop();
			__mc._list.stop();
			__mc._list._goods.stop();
			this.addChild(__mc);
			__mc.x = 200;
			__mc.y = 200;
			gameStart();
		}
		
		/**
		 * 游戏开始
		 */
		public function gameStart():void
		{
			var test:Class=swfLoad.GetClass("ui.mc.dao");
			_dao=new test();
			_dao.x=100;
			_dao.y=100;
			_dao.speedX=0;
			_dao.speedY=0;
			this.addChild(_dao);
			test=swfLoad.GetClass("music.pop2");
			_music=new test();
			
			test=swfLoad.GetClass("ui.mc.jifen");
			_txtShow=(new test())._txtShow;
			this.addChild(_txtShow);
			_txtShow.text="切破气球数:0 气球逃跑数:0";
			this.addEventListener(Event.ENTER_FRAME,enter_Frame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,key_down);
			stage.addEventListener(KeyboardEvent.KEY_UP,key_up);
		}
		
		/**
		 * 按键按下
		 * @param	e
		 */
		public function key_down(e:KeyboardEvent):void
		{
			//trace(e.keyCode);
			if(e.keyCode==87||e.keyCode==38)
			{
				_dao.speedY=-15;
			}else if(e.keyCode==83||e.keyCode==40)
			{
				_dao.speedY=15;
			}else if(e.keyCode==65||e.keyCode==37)
			{
				_dao.speedX=-15;
			}else if(e.keyCode==68||e.keyCode==39)
			{
				_dao.speedX=15;
			}
		}
		
		/**
		 * 按键松开
		 * @param	e
		 */
		public function key_up(e:KeyboardEvent):void
		{
			//trace(e.keyCode);
			if(e.keyCode==87||e.keyCode==38)
			{
				_dao.speedY=0;
			}else if(e.keyCode==83||e.keyCode==40)
			{
				_dao.speedY=0;
			}else if(e.keyCode==65||e.keyCode==37)
			{
				_dao.speedX=0;
			}else if(e.keyCode==68||e.keyCode==39)
			{
				_dao.speedX=0;
			}
		}
		
		/**
		 * 进入下一帧事件
		 * @param	e
		 */
		public function enter_Frame(e:Event):void
		{
			qiqiuNum++;
			//_dao.rotationZ+=42;
			_dao.x+=_dao.speedX;
			_dao.y+=_dao.speedY;
			var _length:int=qiqiuArr.length;
			var __speed:int=0;
			if(qiqiuNum>10&&_length<_maxNum)
			{
				var qiqiu:Class=swfLoad.GetClass("ui.mc.qiqiu");
				var _qiqiu:MovieClip=new qiqiu();
				__speed=Math.floor(Math.random()*5)+1;
				_qiqiu.gotoAndStop(__speed);
				_qiqiu.speedNum=__speed+2;
				_qiqiu.x=Math.random()*stage.stageWidth;
				_qiqiu.y=stage.stageHeight;
				this.addChild(_qiqiu);
				qiqiuArr.push(_qiqiu);
				qiqiuNum=0;
			}
			for(var i:int=0;i<_length;i++)
			{
				if(qiqiuArr[i].y<0)
				{
					_taoNum+=1;
					qiqiuArr[i].y=stage.stageHeight;
					qiqiuArr[i].x = Math.random() * stage.stageWidth;
					__speed=Math.floor(Math.random()*5)+1;
					qiqiuArr[i].gotoAndStop(__speed);
					qiqiuArr[i].speedNum=__speed+2;
				}
				else
				{
					qiqiuArr[i].y-=qiqiuArr[i].speedNum;
				}
				
				if(BitmapHitTestPlus.complexHitTestObject(qiqiuArr[i],_dao))
				{
					//trace(_music);
					_poNum+=1;
					_music.play(0,1);
					qiqiuArr[i].y=stage.stageHeight;
					qiqiuArr[i].x=Math.random()*stage.stageWidth;
					__speed=Math.floor(Math.random()*5)+1;
					qiqiuArr[i].gotoAndStop(__speed);
					qiqiuArr[i].speedNum = __speed + 2;
					if (__mc.currentFrame != 4)
					{
						__mc.nextFrame();
					}
					else
					{
						__mc.gotoAndStop(1);
					}
				}
				_txtShow.text = "切破气球数:" + _poNum + "气球逃跑数:" + _taoNum;
			}
		}
		
	}
}