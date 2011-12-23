package com.rush360.huanzhuang
{

	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;


	public class Main extends MovieClip
	{

		public var _bg:MovieClip;
		public var _set:MovieClip;
		public var _nvHai:MovieClip;
		public function Main()
		{
			// constructor code
			trace(123);
			//_bg=MovieClip(stage.getChildByName('_bg'));
			//_bg.stop();
			init();
		}

		public function init():void
		{
			var len:int = this.numChildren;
			for (var i:int=0; i<len; i++)
			{
				var mv:DisplayObject = this.getChildAt(i);
				var str:String = mv.name;
				if (str.substr(0,8) != 'instance')
				{
					this[str] = mv;
				}
			}

			_bg.p7.stop();
			_bg.p8.stop();
			_bg.p9.stop();
			_bg.p10.stop();
			_nvHai.p1.stop();
			_nvHai.p1n.stop();
			_nvHai.p2.stop();
			_nvHai.p3.stop();
			_nvHai.p4.stop();
			_nvHai.p5.stop();
			_nvHai.p6.stop();
			_set.addEventListener(MouseEvent.CLICK,on_set_Click);
		}

		public function on_set_Click(e:MouseEvent):void
		{
			var str:String = e.target.name;
			if (str.substr(0,1) == 'b')
			{
				var mv:MovieClip;
				var num:int=0;
				if (str.length != 3)
				{
					num=int(str.substr(1,1));
					mv = MovieClip(_bg['p' + str.substr(1,1)]);
				}
				else
				{
					num=int(str.substr(1,2));
					mv = MovieClip(_bg['p' + str.substr(1,2)]);
				}
				
				if(num>=7)
				{
					mv = MovieClip(_bg['p' + num]);
				}
				else if(num!=0)
				{
					mv = MovieClip(_nvHai['p' + num]);
				}
				
				if (mv!=null)
				{
					if (mv.currentFrame == mv.totalFrames)
					{
						mv.gotoAndStop(1);
					}
					else
					{
						mv.nextFrame();
					}
				}
				
				if(num==1)
				{
					if (_nvHai.p1n.currentFrame == _nvHai.p1n.totalFrames)
					{
						_nvHai.p1n.gotoAndStop(1);
					}
					else
					{
						_nvHai.p1n.nextFrame();
					}
				}
			}
		}
	}

}