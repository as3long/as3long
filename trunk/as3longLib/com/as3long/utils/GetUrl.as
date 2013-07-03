package com.as3long.utils
{
	import flash.system.Capabilities;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author 黄龙
	 */
	public class GetUrl
	{
		
		[Embed(source="ForceWindow.js",mimeType="application/octet-stream")]
		private static var jsCode:Class;
		ExternalInterface.available && ExternalInterface.call("eval", new jsCode().toString());
		
		public function GetUrl()
		{
			//if( instance ) throw new Error( "Singleton and can only be accessed through Singleton.getInstance()" ); 
		}
		
		public static function init():void { };
		
		public static function openUrl_JS(url:String):void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.call("window.force.open", String(url));
			}
			else
			{
				navigateToURL(new URLRequest(url), '_blank');
			}
		}
		
		public static function open(url:String):void
		{
			if (Capabilities.playerType == "ActiveX" || Capabilities.playerType == "PlugIn")
			{
				if (ExternalInterface.available)
				{
					ExternalInterface.call("window.open", String(url));
				}
				else
				{
					navigateToURL(new URLRequest(url), '_blank');
				}
			}
			else
			{
				navigateToURL(new URLRequest(url), '_blank');
			}
		}
		
		public static function openToUrl(url:String):void
		{
			navigateToURL(new URLRequest(url), '_blank');
		}
	
	}

}