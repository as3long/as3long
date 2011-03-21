package com.webBase.activeBag.net
{
	/**
	 * ...
	 * @author wmy
	 * 
	 * 弹出窗口类
	 */
	//例子:
	/*
	new GetUrl("http://www.xxxx.com/");
	*/
	
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.external.ExternalInterface;

	public class GetUrl {
		public function GetUrl(url:String, window:String="_blank", features:String="") {
			var WINDOW_OPEN_FUNCTION:String = "window.open";
			var myURL:URLRequest = new URLRequest(url);
			var browserName:String = getBrowserName();

			if (getBrowserName() == "Firefox") {//Firefox
				ExternalInterface.call(WINDOW_OPEN_FUNCTION, url, window, features);
			} else if (browserName == "IE") {//If IE, 
				ExternalInterface.call(WINDOW_OPEN_FUNCTION, url, window, features);
			} else if (browserName == "Safari") {//If Safari     
				navigateToURL(myURL, window);
			} else if (browserName == "Opera") {//If Opera 
				navigateToURL(myURL, window);
			} else {
				navigateToURL(myURL, window);
			}
		}
		private function getBrowserName():String {
			var browser:String;
			
			var browserAgent:String = ExternalInterface.call("function getBrowser(){return navigator.userAgent;}");

			if (browserAgent != null && browserAgent.indexOf("Firefox") >= 0) {
				browser = "Firefox";
			} else if (browserAgent != null && browserAgent.indexOf("Safari") >= 0) {
				browser = "Safari";
			} else if (browserAgent != null && browserAgent.indexOf("MSIE") >= 0) {
				browser = "IE";
			} else if (browserAgent != null && browserAgent.indexOf("Opera") >= 0) {
				browser = "Opera";
			} else {
				browser = "Undefined";
			}
			return browser;
		}
	}
}