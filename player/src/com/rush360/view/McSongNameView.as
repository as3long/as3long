package com.rush360.view
{
	import com.rush360.controll.SoundUrlCommand;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	import org.weemvc.as3.view.View;
	
	/**
	 * ...
	 * @author 360rush
	 */
	public class McSongNameView extends View
	{
		private var mcSongName:MovieClip;
		private var _txtSongName:TextField;
		private var _bg:MovieClip;
		private var _bgWidth:Number;
		private var _sound:Sound = new Sound();
		private var _soundChannel:SoundChannel = new SoundChannel();
		private var _pointNum:Number = 0;
		;
		private var _isPlaying:Boolean = false;
		
		public function McSongNameView(_mcSongName:MovieClip)
		{
			mcSongName = _mcSongName;
			_txtSongName = mcSongName._txtName;
			_bg = mcSongName._jindu;
			_bgWidth = _bg.width;
			setSongUrl(mcSongName._abcurl);
			setSongName(mcSongName._abcSname);
		}
		
		private function enterframe(e:Event):void
		{
			_pointNum = _soundChannel.position;
			setjindu(_pointNum / getLength());
		}
		
		/**
		 * 设置进度
		 * @param	num 进度
		 */
		public function setjindu(num:Number):void
		{
			_bg.width = num * _bgWidth;
		}
		
		public function songStop():void
		{
			_pointNum = _soundChannel.position;
			_soundChannel.stop();
		}
		
		public function setSongUrl(url:String):void
		{
			_sound.load(new URLRequest(url));
			mcSongName.addEventListener(Event.ENTER_FRAME, enterframe);
		}
		
		public function songPlay():void
		{
			_soundChannel = _sound.play(_pointNum);
		}
		
		public function getLength():Number
		{
			if (_sound.bytesLoaded == _sound.bytesTotal)
			{
				return _sound.length;
			}
			else
			{
				return _sound.length * _sound.bytesTotal / _sound.bytesLoaded;
			}
		}
		
		/**
		 * 设置歌曲名
		 * @param	songName 歌曲名
		 */
		public function setSongName(songName:String):void
		{
			_txtSongName.text = songName;
		}
	
	}

}