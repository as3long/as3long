package  
{
	import com.greensock.TimelineLite;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import ui.quzi;
	
	/**
	 * ...
	 * @author 黄龙
	 */
	public class GangQin extends MovieClip
	{
		private var gangqin:quzi;
		private var musicString:String;
		private var nowI:int;
		private var lastMv:*;
		private var length:int;
		private var timer:Timer;
		public function GangQin() 
		{
			init();
		}
		
		private function init():void
		{
			gangqin = new quzi();
			gangqin.x = stage.stageWidth / 2;
			gangqin.y = stage.stageHeight / 2;
			this.addChild(gangqin);
			with (gangqin)
			{
				qing.a.stop();
				qing.b.stop();
				qing.c.stop();
				qing.d.stop();
				qing.e.stop();
				qing.f.stop();
				qing.g.stop();
				qing.h.stop();
				qing.i.stop();
				qing.j.stop();
				qing.k.stop();
				qing.l.stop();
				qing.m.stop();
				qing.n.stop();
				qing.o.stop();
				qing.p.stop();
				qing.q.stop();
				qing.r.stop();
				qing.s.stop();
				qing.t.stop();
				qing.u.stop();
				qing.v.stop();
				qing.w.stop();
				qing._x.stop();
				qing._y.stop();
				qing._z.stop();
			}
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			gangqin._btnPlay.addEventListener(MouseEvent.CLICK, musicPlay);
		}
		
		private function musicPlay(e:MouseEvent):void 
		{
			gangqin._btnPlay.visible = false;
			gangqin._txtInput.visible = false;
			musicString = gangqin._txtInput.text;
			trace(musicString);
			length = musicString.length;
			trace(length);
			timer = new Timer(300, length);
			timer.addEventListener(TimerEvent.TIMER, timerDo);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timer_complete);
			timer.start();
			//(firstName.charAt(1)
		}
		
		private function timerDo(e:TimerEvent):void 
		{
			if (nowI <length)
			{
				var nowString:String = musicString.charAt(nowI);
				playOne(nowString);
				trace(nowString);
				nowI++;
			}
		}
		
		private function timer_complete(e:TimerEvent):void 
		{
			nowI = 0;
			gangqin._btnPlay.visible = true;
			gangqin._txtInput.visible = true;
			timer.removeEventListener(TimerEvent.TIMER, timerDo);
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timer_complete);
			if (lastMv != null)
			{
				lastMv=null;
			}
			with (gangqin)
			{
				qing.a.gotoAndStop(1);
				qing.b.gotoAndStop(1);
				qing.c.gotoAndStop(1);
				qing.d.gotoAndStop(1);
				qing.e.gotoAndStop(1);
				qing.f.gotoAndStop(1);
				qing.g.gotoAndStop(1);
				qing.h.gotoAndStop(1);
				qing.i.gotoAndStop(1);
				qing.j.gotoAndStop(1);
				qing.k.gotoAndStop(1);
				qing.l.gotoAndStop(1);
				qing.m.gotoAndStop(1);
				qing.n.gotoAndStop(1);
				qing.o.gotoAndStop(1);
				qing.p.gotoAndStop(1);
				qing.q.gotoAndStop(1);
				qing.r.gotoAndStop(1);
				qing.s.gotoAndStop(1);
				qing.t.gotoAndStop(1);
				qing.u.gotoAndStop(1);
				qing.v.gotoAndStop(1);
				qing.w.gotoAndStop(1);
				qing._x.gotoAndStop(1);
				qing._y.gotoAndStop(1);
				qing._z.gotoAndStop(1);
			}
		}
		
		private function playOne($arg:String):void
		{
			$arg = $arg.toLocaleLowerCase();
			trace($arg);
			if (lastMv != null)
			{
				lastMv.gotoAndStop(1);
			}
			switch($arg)
			{
				case 'a':
					gangqin.qing.a.gotoAndStop(3);
					lastMv = gangqin.qing.a;
					break;
				case 'b':
					gangqin.qing.b.gotoAndStop(3);
					lastMv = gangqin.qing.b;
					break;
				case 'c':
					gangqin.qing.c.gotoAndStop(3);
					lastMv = gangqin.qing.c;
					break;
				case 'd':
					gangqin.qing.d.gotoAndStop(3);
					lastMv = gangqin.qing.d;
					break;
				case 'e':
					gangqin.qing.e.gotoAndStop(3);
					lastMv = gangqin.qing.e;
					break;
				case 'f':
					gangqin.qing.f.gotoAndStop(3);
					lastMv = gangqin.qing.f;
					break;
				case 'g':
					gangqin.qing.g.gotoAndStop(3);
					lastMv = gangqin.qing.g;
					break;
				case 'h':
					gangqin.qing.h.gotoAndStop(3);
					lastMv = gangqin.qing.h;
					break;
				case 'i':
					gangqin.qing.i.gotoAndStop(3);
					lastMv = gangqin.qing.i;
					break;
				case 'j':
					gangqin.qing.a.gotoAndStop(3);
					lastMv = gangqin.qing.j;
					break;
				case 'k':
					gangqin.qing.k.gotoAndStop(3);
					lastMv = gangqin.qing.k;
					break;
				case 'l':
					gangqin.qing.l.gotoAndStop(3);
					lastMv = gangqin.qing.l;
					break;
				case 'm':
					gangqin.qing.m.gotoAndStop(3);
					lastMv = gangqin.qing.m;
					break;
				case 'n':
					gangqin.qing.n.gotoAndStop(3);
					lastMv = gangqin.qing.n;
					break;
				case 'o':
					gangqin.qing.o.gotoAndStop(3);
					lastMv = gangqin.qing.o;
					break;
				case 'p':
					gangqin.qing.p.gotoAndStop(3);
					lastMv = gangqin.qing.p;
					break;
				case 'q':
					gangqin.qing.q.gotoAndStop(3);
					lastMv = gangqin.qing.q;
					break;
				case 'r':
					gangqin.qing.r.gotoAndStop(3);
					lastMv = gangqin.qing.r;
					break;
				case 's':
					gangqin.qing.s.gotoAndStop(3);
					lastMv = gangqin.qing.s;
					break;
				case 't':
					gangqin.qing.t.gotoAndStop(3);
					lastMv = gangqin.qing.t;
					break;
				case 'u':
					gangqin.qing.u.gotoAndStop(3);
					lastMv = gangqin.qing.u;
					break;
				case "v":
					gangqin.qing.v.gotoAndStop(3);
					lastMv = gangqin.qing.v;
					break;
				case "w":
					gangqin.qing.w.gotoAndStop(3);
					lastMv = gangqin.qing.v;
					break;
				case "x":
					gangqin.qing._x.gotoAndStop(3);
					lastMv = gangqin.qing._x;
					break;
				case "y":
					gangqin.qing._y.gotoAndStop(3);
					lastMv = gangqin.qing._y;
					break;
				case "z":
					gangqin.qing._z.gotoAndStop(3);
					lastMv = gangqin.qing._z;
					break;
				default:
					break;
			}
		}
		
		private function keyUp(e:KeyboardEvent):void 
		{
			switch(e.keyCode)
			{
				case 65:
					gangqin.qing.a.gotoAndStop(1);
					break;
				case 66:
					gangqin.qing.b.gotoAndStop(1);
					break;
				case 67:
					gangqin.qing.c.gotoAndStop(1);
					break;
				case 68:
					gangqin.qing.d.gotoAndStop(1);
					break;
				case 69:
					gangqin.qing.e.gotoAndStop(1);
					break;
				case 70:
					gangqin.qing.f.gotoAndStop(1);
					break;
				case 71:
					gangqin.qing.g.gotoAndStop(1);
					break;
				case 72:
					gangqin.qing.h.gotoAndStop(1);
					break;
				case 73:
					gangqin.qing.i.gotoAndStop(1);
					break;
				case 74:
					gangqin.qing.j.gotoAndStop(1);
					break;
				case 75:
					gangqin.qing.k.gotoAndStop(1);
					break;
				case 76:
					gangqin.qing.l.gotoAndStop(1);
					break;
				case 77:
					gangqin.qing.m.gotoAndStop(1);
					break;
				case 78:
					gangqin.qing.n.gotoAndStop(1);
					break;
				case 79:
					gangqin.qing.o.gotoAndStop(1);
					break;
				case 80:
					gangqin.qing.p.gotoAndStop(1);
					break;
				case 81:
					gangqin.qing.q.gotoAndStop(1);
					break;
				case 82:
					gangqin.qing.r.gotoAndStop(1);
					break;
				case 83:
					gangqin.qing.s.gotoAndStop(1);
					break;
				case 84:
					gangqin.qing.t.gotoAndStop(1);
					break;
				case 85:
					gangqin.qing.u.gotoAndStop(1);
					break;
				case 86:
					gangqin.qing.v.gotoAndStop(1);
					break;
				case 87:
					gangqin.qing.w.gotoAndStop(1);
					break;
				case 88:
					gangqin.qing._x.gotoAndStop(1);
					break;
				case 89:
					gangqin.qing._y.gotoAndStop(1);
					break;
				case 90:
					gangqin.qing._z.gotoAndStop(1);
					break;
				default:
					break;
			}
		}
		
		private function keyDown(e:KeyboardEvent):void 
		{
			//trace(e.keyCode);
			switch(e.keyCode)
			{
				case 65:
					gangqin.qing.a.gotoAndStop(3);
					break;
				case 66:
					gangqin.qing.b.gotoAndStop(3);
					break;
				case 67:
					gangqin.qing.c.gotoAndStop(3);
					break;
				case 68:
					gangqin.qing.d.gotoAndStop(3);
					break;
				case 69:
					gangqin.qing.e.gotoAndStop(3);
					break;
				case 70:
					gangqin.qing.f.gotoAndStop(3);
					break;
				case 71:
					gangqin.qing.g.gotoAndStop(3);
					break;
				case 72:
					gangqin.qing.h.gotoAndStop(3);
					break;
				case 73:
					gangqin.qing.i.gotoAndStop(3);
					break;
				case 74:
					gangqin.qing.j.gotoAndStop(3);
					break;
				case 75:
					gangqin.qing.k.gotoAndStop(3);
					break;
				case 76:
					gangqin.qing.l.gotoAndStop(3);
					break;
				case 77:
					gangqin.qing.m.gotoAndStop(3);
					break;
				case 78:
					gangqin.qing.n.gotoAndStop(3);
					break;
				case 79:
					gangqin.qing.o.gotoAndStop(3);
					break;
				case 80:
					gangqin.qing.p.gotoAndStop(3);
					break;
				case 81:
					gangqin.qing.q.gotoAndStop(3);
					break;
				case 82:
					gangqin.qing.r.gotoAndStop(3);
					break;
				case 83:
					gangqin.qing.s.gotoAndStop(3);
					break;
				case 84:
					gangqin.qing.t.gotoAndStop(3);
					break;
				case 85:
					gangqin.qing.u.gotoAndStop(3);
					break;
				case 86:
					gangqin.qing.v.gotoAndStop(3);
					break;
				case 87:
					gangqin.qing.w.gotoAndStop(3);
					break;
				case 88:
					gangqin.qing._x.gotoAndStop(3);
					break;
				case 89:
					gangqin.qing._y.gotoAndStop(3);
					break;
				case 90:
					gangqin.qing._z.gotoAndStop(3);
					break;
				default:
					break;
			}
		}
		
		
	}

}