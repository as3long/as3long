// Copyright @ shch8.com All Rights Reserved At 2009-3-23
//开发：商创技术（www.shch8.com）望月狼
/*
·数据加载

 例：
 LoadSound.getInstance().loadSound("music.mp3",2)
 */
package com.webBase.activeBag.net.pack 
{	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	public class LoadSound {
		private var _sound:Sound=new Sound;
		private var music:SoundChannel = new SoundChannel;
		private static var Instance:LoadSound = new LoadSound;
		private var pos:Number = 0;
		private var timer:Timer;
		private var cycle:Number;//循环次数
		/*声音控制增量,停止与开始用的渐隐值*/
		public var conNum:Number = 10;
		public var filePath:String;
		private var volueNum:Number=100;//当前音量
		private var volueNum_c:Number;//音量备份
		private var soundEffect:Boolean;
		private const DIS_TIME:Number = 100;
		public static function getInstance():LoadSound {
			return Instance;
		}
		/*加载mp3文件(路径,缓冲秒数默认1秒-单位“秒”,播放次数-1为循环播放,使用渐渐效果)*/
		public function loadSound(_filePath:String, context:Number = 1, _cycle:Number = -1, _soundEffect:Boolean = true):void {
			cycle = _cycle;
			filePath = _filePath;
			soundEffect=_soundEffect;
			_sound=new Sound;
			var con:SoundLoaderContext = new SoundLoaderContext(context*1000,false);
			_sound.load(new URLRequest(_filePath),con);
			_sound.addEventListener(IOErrorEvent.IO_ERROR, loadError);
			play();
		}
		/*停止*/
		public function stop():void {
			pos=0
			useEffect(false);
			}
			/*播放*/
		public function play():void {
			var soundv:SoundTransform = new SoundTransform();
			soundv.volume = volueNum / 100;
			if (soundEffect) soundv.volume = 0;
			if (music != null) music.stop();
			music = new SoundChannel;
			music = _sound.play(pos);
			music.soundTransform = soundv;
			music.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			if (soundEffect) {
				useEffect(true)
			}
			}
			/*暂停*/
		public function pause():void {
				pos = music.position;
				useEffect(false)
			}
			/*音量*/
		public function set volume(Num:Number):void {
			if (Num < 0) {
				Num = 0;
				}
			if (Num > 100) {
				Num = 100;
				}
			volueNum = Num;
			var soundv:SoundTransform = new SoundTransform();
			soundv.volume = Num/100;
			music.soundTransform = soundv;
			}
		private function useEffect(actPlay:Boolean):void {
			if (!soundEffect&&!actPlay) {
				music.stop();//关闭时，不使用渐隐效果
				return;
				}
			if (actPlay) {//打开声音的增量
				conNum = Math.abs(conNum);
				volueNum_c = 0;
				}else {
					conNum = Math.abs(conNum)*-1;
					}
			if (volueNum_c> volueNum) {
				volueNum_c = volueNum;
				}
			if (timer) timer.stop();
			timer = new Timer(DIS_TIME);
			timer.addEventListener(TimerEvent.TIMER, enterFrame);
			timer.start();
			}
		private function enterFrame(event:TimerEvent):void {
			
			var soundv:SoundTransform = new SoundTransform();
			soundv.volume = volueNum_c/100;
			music.soundTransform = soundv;
			volueNum_c += conNum;
			if (volueNum_c > volueNum||volueNum_c>100) {//开启声音
				timer.stop();
				}else if (volueNum_c < 0) {//关闭声音
					if (pos != 0) {//暂停 否则为停止
						pos = music.position;
						}
					music.stop();
					timer.stop();
					}
			}
		private function soundCompleteHandler(event:Event):void {
			if (cycle == -1) {//声音循环
				pos = 0;
				play()
				return;
				}
				if (cycle > 1) {
					cycle--
					pos = 0;
					play()
					}
			}
		private function loadError(event:IOErrorEvent):void {
					throw new Error("加载失败");
				}
	}
}