package com.webBase.activeBag.net.pack 
{
	
	/**
	 * ...
	 * @author WZH(shch8.com)
	 */
	public class BgSound 
	{
		private var _path:String="";//路径
		private var _context:Number = 1;//缓冲秒数
		private var _cycle:Number = -1;//播放次数-1为循环播放
		private var _soundEffect:Boolean;//是否使用渐渐效果,音乐播放与关闭时渐渐打开或停止
		private var loadSound:LoadSound = LoadSound.getInstance();
		public function set path(value:String):void
		{
			_path = value;
		}
		/**
		 * 缓冲秒数
		 */
		public function set context(value:Number):void
		{
			_context = value;
		}
		/**
		 * 播放次数-1为循环播放
		 */
		public function set cycle(value:Number):void
		{
			_cycle = value;
		}
		/**
		 * 是否使用渐渐效果,音乐播放与关闭时渐渐打开或停止
		 */
		public function set soundEffect(value:Boolean):void
		{
			_soundEffect = value;
		}
		public function stop():void {
			loadSound.stop();
			}
			/*播放*/
		public function play():void {
			if (loadSound.filePath != ""&&loadSound.filePath==_path) loadSound.play();
			if (_path != "") loadSound.loadSound(_path, _context, _cycle, _soundEffect);
			
			}
			/*暂停*/
		public function pause():void {
			loadSound.pause();
			}
			/*音量*/
		public function set volume(Num:Number):void {
			loadSound.volume = Num;
		}
	}
	
}