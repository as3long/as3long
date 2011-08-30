package com.qq.openapi
{
	import com.qq.protocol.DataHead;
	import com.qq.protocol.DataHelp;
	import com.qq.protocol.ProtocolHelper;
	import com.qq.utils.HttpRequest;
	import com.qq.utils.MEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.utils.ByteArray;

	/**
	 * 	API全局数据定义、错误码定义、数据发送等包裹类。
	 * 
	 * 	@author Tencent
	 * 
	 */
	public class MttService
	{
		/**
		 *	后台服务发现当前用户没有登录或者回话已经过期。	 
		 */		
		public static const ELOGOUT		:int = -60000;

		/**
		 *	解码登录SERVER返回数据包时出错，不能判定因何出现。
		 */		
		public static const EPDECODE		:int = -61000;

		/**
		 *	解码业务SERVER返回数据包时出错，不能判定因何出现。
		 */
		public static const ESDECODE		:int = -61100;

		/**
		 *	网络通信出现故障。
		 */
		public static const EIOERROR		:int = -62000;

		/**
		 *	网络通信调用超时。	 
		 */		
		public static const EIOTIMEOUT	:int = -62100; 

		/**
		 *	表明某件事物不存在。比如在获取游戏数据，后台服务发现指定的key不存在时就返回该错误码。
		 */		
		public static const ENOENT		:int = -63000;

		/**
		 *	当前用户没有登录或者登录会话已过有效期。 
		 */		
		public static const ETLOGOUT		:String = "LOOUT";

		/**
		 *	用于判断当前运行环境是否是QQ手机浏览器。 
		 */
		public static function get qqbrowser():Boolean						
		{
			if(flash.system.Capabilities.version.indexOf("QB") != -1)
			{
				return true;
			}

			return false;
		}

		/**
		 *	接口调用的网络请求超时时间，时间单位为秒。 
		 */
		public static function set timeout(value:uint):void
		{
			mTimeout = value;
		}

		/**
		 *	接口调用的网络请求超时时间，时间单位为秒。 
		 */		
		public static function get timeout():uint
		{
			return mTimeout;
		}

		/**
		 *	获取当前API的版本号。 
		 * 
		 * 	@return 返回版本号的字符串表示。 
		 * 
		 */
		public static function get version():String
		{
			return STR_VERSION;
		}

		/**
		 *	获取当前API的数字版本号。 
		 * 	@return 
		 * 
		 */		
		public static function get nversion():uint
		{
			return NUM_VERSION;
		}

		/**
		 * 	身份认证票据失效后的登录地址，当用户登录后会跳转回当前游戏。 
		 * 	@return 登录地址  
		 * 
		 */
		public static function get urlLogin():String	
		{ 
			return mUrlLogin + "&go_url=" + encodeURIComponent((isLocal()?URL_LOGINDEV:URL_LOGINREAL) + mAppId);
		}

		/**
		 *	后台接入服务器地址，在网络游戏中使用，单机游戏忽略该参数。 
		 * 	@return 返回请求所用的URL地址
		 * 
		 */		
		public static function get urlRequest():String
		{
			return qqbrowser?"imtts://":mUrlRequest;
		}

		/**
		 *	全局数据初始化函数。
		 * 
		 *  <p>程序启动时使用该函数从FlashVars获取传入的系统设定参数。</p>
		 * 	@param root Stage的root
		 * 	@param token 在闪游地带地带登陆后的身份认证票据，只用在开发测试环境。
		 * 	@param appId 用于网络游戏请求转发的应用ID，只用在开发测试环境，单机游戏忽略该参数。
		 * 	@return 
		 * 
		 */
		public static function initialize(root:DisplayObject, token:String = "", appId:String = ""):void
		{
			if (isLocal())
			{			
				mNoVerify 	= true;
				mToken 		= token;
				mAppId 		= appId;
			}

			if(!mNoVerify)
			{
				mGameId = root.loaderInfo.parameters["gameid"];
				if (mGameId == null)
				{
					trace("Error:not found gameid, please review the api cookbook");
					return ;
				}
				
				mAppId = root.loaderInfo.parameters["appid"];
				mToken = root.loaderInfo.parameters["token"];
			}

			if (root.loaderInfo.parameters["isImtt"] != null && root.loaderInfo.parameters["isImtt"] == "1")
			{
				mMttProtocol = true;
			}

			if (root.loaderInfo.parameters["imtts"] != null)
			{
				mUrlRequest = root.loaderInfo.parameters["imtts"];
			}

			if (root.loaderInfo.parameters["imtt"] != null)
			{
				mUrlResouec = root.loaderInfo.parameters["imtt"];
			}
			
			if (mUrlResouec.charAt(mUrlResouec.length - 1) != "/")
			{
				mUrlResouec += "/";
			}

			if (root.loaderInfo.parameters["version"] != null)
			{
				mVersion = root.loaderInfo.parameters["version"];
			}
		}

		/**
		 *	跳转到登录页面。登陆后跳转回当前游戏的进入页面。	 
		 * 	@param root  
		 * 
		 */
		public static function login(root:MovieClip = null):void
		{
			if (root != null) root.stop();

			navigateToURL(new URLRequest(urlLogin), "_self");
		}

		/**
		 *	退出游戏并且跳转到当前游戏的积分排行榜。 
		 */		
		public static function exit():void
		{
			jump(1, false);
		}

		/**
		 *	跳转到指定的页面。	 
		 * 
		 * 	@param url 欲跳转到的URL索引值，其值对应的实际地址，请参考最新的文档说明。
		 * 	@param window 是否打开新的窗口。
		 */		
		public static function jump(url:uint, window:Boolean):void
		{
			send(URL_URLJUMP, AID_FORURLJUMP, ProtocolHelper.UrlJumpEncode(url, window), null);
		}

		/**
		 *	设置资源路径。
		 * 
		 *	@param name		资源关键字，在当前游戏中唯一标识该资源
		 *	@param local	本地测试路径，可以使用相对于当前程序的相对路径
		 * 	@param imtt		在网络服务器上相对于当前程序根目录的相对路径
		 *
		 * 	@example
		 * 	<p>开发者只需一次设置资源的路径，API会自动判断运行环境的类型，以决定从网络还是本地磁盘获取资源。</p>
		 * 	<p>使用该接口的好处显而易见，只要保证相对路径的不变，程序可以直接上线，而不必重新设置URL地址了。</p>
		 * 	<p> </p>
		 * 	<p>例如，如果程序需要动态加载素材包“HelloWorld.swf”。开发者可以这样使用接口设置该资源的URL：</p>
		 * 	<p>ApiTool.putSubResource("Hello", "../assets/HelloWorld.swf", "/HelloWorld/assets/HelloWorld.swf");</p>
		 * 	<p> </p>
		 * 	<p>当开发者需要下载资源时，可以直接使用下面的资源URL获取函数：</p>
		 * 	<p>mLoader:Loader = new Loader();</p>
		 *	<p>mLoader.load(new URLRequest(ApiTool.getSubResource("Hello")));</p>
		 */
		public static function putSubResource(name:String, local:String, imtt:String):void
		{
			if(imtt.indexOf("/") != 0)
			{
				imtt = "/" + imtt;
			}

			var httpRes : String = mUrlResouec;
			if (mVersion.length != 0)
			{
				httpRes += mVersion + "/";
			}

			httpRes += mGameId + imtt;

			mResources[name] = {local:local, net: mUrlResouec + mGameId + imtt, imtt:"imtt://" + mGameId + imtt};
		}

		/**
		 * 	获取资源地址。
		 *
		 * 	@param name 资源关键字，同函数ApiTool.putSubResource的第一参数。
		 * 	@return 欲下载资源的URL地址
		 * 
		 */
		public static function getSubResource(name:String):String
		{
			if (isLocal())
			{
				return mResources[name].local;
			}
			else if (qqbrowser)
			{
				return mResources[name].imtt;
			}
			else
			{
				return mResources[name].net;
			}
		}

		/**
		 * 	发送数据请求数据	
		 * 
		 * 	@param req
		 * 	@param onFinish
		 * 
		 */
		public static function post(req:ByteArray, onFinish:Function):void
		{
			send(urlRequest, mAppId, req, onFinish);
		}

		/**
		 *	发送API数据 
		 * 	
		 * 	@private
		 * 	@param req
		 * 	@param onFinish
		 * 
		 */		
		public static function sapi(req:ByteArray, onFinish:Function):void
		{
			send(urlApiProxy, AID_FORAPI, req, onFinish);
		}

		/**
		 *	带有APPID的发送方式 
		 * 	@param url
		 * 	@param appid
		 * 	@param req
		 * 	@param onFinish
		 * 
		 */
		public static function send(url:String, appid:String, req:ByteArray, onFinish:Function):void
		{
			var _http:HttpRequestItem = getIdleNetSender();
			_http.http.url = url;
			_http.http.timeout = mTimeout * 1000;
			_http.http.addEventListener(HttpRequest.COMPLETE, 	onFinishLoad);
			_http.http.addEventListener(HttpRequest.ERROR, 		onFinishLoadError);
			_http.http.addEventListener(HttpRequest.TIMEOUT, 	onFinishLoadTimeout);
			_http.http.doRequest((qqbrowser && mttprotocol)?req:PluginEncode(appid, req));

			function onFinishLoad(e:MEvent):void
			{
				removeListeners(e);

				var code:int 		= 0;
				var data:ByteArray	= e.data as ByteArray;
				try
				{
					if (qqbrowser == false || mttprotocol == false)
					{
						var res:Object = PluginDecode(data);

						code = res.code;
						data = res.data;
					}
				}
				catch(e:Error) { code = EPDECODE; }
				onFinish && onFinish.call(null, code, data);
			}

			function onFinishLoadError(e:MEvent):void
			{
				removeListeners(e);

				onFinish && onFinish.call(null, EIOERROR, null);
			}

			function onFinishLoadTimeout(e:MEvent):void
			{
				removeListeners(e);

				onFinish && onFinish.call(null, EIOTIMEOUT, null);
			}

			function removeListeners(e:MEvent):void
			{
				_http.http.removeEventListener(HttpRequest.COMPLETE, 	onFinishLoad);
				_http.http.removeEventListener(HttpRequest.ERROR, 		onFinishLoadError);
				_http.http.removeEventListener(HttpRequest.TIMEOUT, 	onFinishLoadTimeout);
				_http.idle = true;
			}
		}

		///////////////////////////////////////////////////////////////////////////////////////////
		//	全局事件注册函数
		private static var mDispatch:EventDispatcher = new EventDispatcher();
		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			mDispatch.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			mDispatch.removeEventListener(type, listener, useCapture);
		}
		
		public static function dispatchEvent(event:Event):Boolean
		{
			return mDispatch.dispatchEvent(event);
		}

		//获取一个空闲的链接
		private static function getIdleNetSender():HttpRequestItem
		{
			for (var i:uint = 0; i < mHttp.length; i++)
			{
				if (mHttp[i].idle == true)
				{
					mHttp[i].idle = false;
					return mHttp[i];
				}
			}

			var http:HttpRequestItem = new HttpRequestItem(false);
			mHttp.push(http);
			return http;
		}

		//模拟插件封包逻辑
		private static function PluginEncode(appID:String, postData:ByteArray):ByteArray
		{
			var ost:ByteArray 	= new ByteArray();

			DataHelp.writeString(ost, "imtt://from_pc_browser", 0);
			DataHelp.writeString(ost, "", 1);
			DataHelp.writeString(ost, "token=" + mToken + "; appid=" + appID + "; gameid=" + mGameId, 2);
			DataHelp.writeVectorByte(ost, postData, 3);

			return ost;
		}

		//模拟插件解包逻辑
		private static function PluginDecode(ist:ByteArray):Object
		{
			var rtnCode:int			= DataHelp.readInt32(ist, 0, false);
			var rspContType:int		= DataHelp.readInt32(ist, 1, false);
			var openNew:int			= DataHelp.readInt32(ist, 2, false);
			var respData:ByteArray	= DataHelp.readVectorByte(ist, 3, false);

			if (rtnCode == -2)
			{
				mUrlLogin 			= respData.readMultiByte(respData.length, "cn-gb");
				rtnCode				= ELOGOUT;
			}
			return {code:rtnCode, data:respData};
		}

		//判断当前是否本机调试 
		private static function isLocal():Boolean
		{
			return flash.system.Security.sandboxType == flash.system.Security.LOCAL_WITH_FILE || flash.system.Security.sandboxType == flash.system.Security.LOCAL_TRUSTED;
		}

		//判断当前游戏是否使用IMTTS协议 
		private static function get mttprotocol():Boolean
		{
			return true;
			return mMttProtocol;
		}

		//后台API服务器地址，被API内部代码使用，开发者忽略该参数。 
		private static function get urlApiProxy():String
		{
			return qqbrowser?URL_APIIMTTS:URL_APIHTTP;
		}

		///////////////////////////////////////////////////////////////////////////////////////////
		//	私有常量数据
		private static const NUM_VERSION		: uint   = 310003;
		private static const STR_VERSION		: String = "AS3V1.0.3";
		private static const URL_APIIMTTS		: String = "imtts://appid=3";
		private static const URL_URLJUMP		: String = "imtts://appid=5";
		private static const URL_LOGINDEV		: String = "http://fgdev.imtt.qq.com/flash?action=singleGame&version=v1.0&gameId=";
		private static const URL_LOGINREAL	: String = "http://fg.imtt.qq.com/flash?action=singleGame&version=v1.0&gameId=";
		private static const GID_FORTEST		: String = "180";
		private static const AID_FORAPI		: String = "3";
		private static const AID_FORURLJUMP	: String = "5";

		private static const URL_APIHTTP		: String = "http://120.196.211.166:18200/http";
		private static const URL_REQUEST		: String = "http://120.196.211.166:18200/http";
		private static const URL_RESOURCE		: String = "http://120.196.211.166/flash/";

		///////////////////////////////////////////////////////////////////////////////////////////
		//	内部变量数据
		private static var mResources 		: Object = new Object();
		private static var mGameId			: String = GID_FORTEST;
		private static var mAppId 			: String;
		private static var mToken 			: String;
		private static var mUrlRequest 		: String = URL_REQUEST;
		private static var mUrlResouec 		: String = URL_RESOURCE;
		private static var mUrlLogin			: String = "";
		private static var mVersion 			: String = "";
		private static var mNoVerify 			: Boolean	= false;
		private static var mMttProtocol		: Boolean	= false;
		private static var mTimeout 			: uint	= 30;
		private static var mHttp				: Array	= new Array();
	}
}

import com.qq.utils.HttpRequest;
import com.qq.openapi.MttService;
class HttpRequestItem
{
	public var idle:Boolean 		= true;
	public var http:HttpRequest	= null;

	public function HttpRequestItem(v:Boolean = true)
	{
		idle = v;
		http = new HttpRequest();
	}
};
