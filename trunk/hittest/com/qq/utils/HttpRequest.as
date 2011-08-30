package com.qq.utils
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.errors.IOError;

	public class HttpRequest extends EventDispatcher
	{
		public static const COMPLETE	: String 	= "HRCOMPLETE";
		public static const ERROR		: String 	= "HRERROR";
 		public static const TIMEOUT	: String	= "TIMEOUT";

		private var mTimeout			: uint		= 30*1000;	//请求超时时间，单位为毫秒
		private var mTimer				: Timer		= null;
		private var mURLLoader			: URLLoader;
		private var mURLRequest		: URLRequest;

		public function HttpRequest(url:String = "")
		{
			mURLRequest				= new URLRequest();
			mURLRequest.url			= url;
			mURLRequest.method		= URLRequestMethod.POST;
			mTimer					= new Timer(mTimeout);
		}

		public function set url(url:String):void 			{ mURLRequest.url = url;	}
		public function get url():String 						{ return mURLRequest.url; 	}
		public function set timeout(value:uint):void			{ mTimeout = value;			}
		public function get timeout():uint					{ return mTimeout;			}

		//请求比较短用get, 请求比较长用post
		public function doRequest(data:ByteArray):void
		{
			if (mURLLoader == null)
			{
				mURLLoader 				= new URLLoader();
				mURLLoader.dataFormat 	= URLLoaderDataFormat.BINARY;
			}

			addEventListeners();

			mURLRequest.contentType = "application/octet-stream";
			mURLRequest.data = data;
			mURLLoader.load(mURLRequest);

			mTimer.delay = mTimeout;
			mTimer.start();
		}	

		private function addEventListeners():void
		{
			mURLLoader.addEventListener(Event.COMPLETE, 						onLoad);
			mURLLoader.addEventListener(IOErrorEvent.IO_ERROR,					onLoadError);
			mURLLoader.addEventListener(ErrorEvent.ERROR, 						onLoadError);
			mURLLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 		onLoadError);

			mTimer.addEventListener(TimerEvent.TIMER, 	onTimeout);
		}

		private function removeEventListeners():void
		{
			mURLLoader.removeEventListener(Event.COMPLETE, 						onLoad);
			mURLLoader.removeEventListener(IOErrorEvent.IO_ERROR, 				onLoadError);
			mURLLoader.removeEventListener(ErrorEvent.ERROR, 					onLoadError);
			mURLLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, 	onLoadError);

			mURLLoader.close();
			mTimer.reset();  
			mTimer.removeEventListener(TimerEvent.TIMER, onTimeout);
		}

		private function onLoad(e : Event):void
		{
			removeEventListeners();
			
			dispatchEvent(new MEvent(COMPLETE, e.target.data));
		}

		private function onLoadError(e : Event):void
		{
			removeEventListeners();
			mURLLoader = null;

			dispatchEvent(new MEvent(ERROR, 	{type:e.type}));
		}

		private function onTimeout(e:TimerEvent):void
		{
			removeEventListeners();
			mURLLoader = null;

			dispatchEvent(new MEvent(TIMEOUT, 	{type:TIMEOUT}));
		}
 	}
}
