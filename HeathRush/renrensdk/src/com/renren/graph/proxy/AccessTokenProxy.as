package com.renren.graph.proxy {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	import flash.net.URLVariables;
	
	public class AccessTokenProxy extends Sprite {
		
		public function AccessTokenProxy() {
			if(stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(event:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var url:String;
			if(ExternalInterface.available) {
				ExternalInterface.call(loadJS);					
				url = ExternalInterface.call("JS.loadURL");
			}
			
			url = url.replace(/#/, "&");
			var paramsString:String = url.substring(url.indexOf("?")+1, url.length);
			var params:URLVariables = new URLVariables(paramsString);
			var result:Object = new Object();
			for(var n:String in params) {
				if(n != "local_connection" && n != "callback_method") {
					result[n] = params[n];
				}
			}
			var localConnectionId:String = params["local_connection"];
			var callbackMethod:String = params["callback_method"];
			
			var localConnection:LocalConnection = new LocalConnection();
			localConnection.addEventListener(StatusEvent.STATUS, onConnectionReportStatus);
			localConnection.send(localConnectionId, callbackMethod, result); 
		}
		
		private function onConnectionReportStatus(event:StatusEvent):void {
			if( ExternalInterface.available ) {
				ExternalInterface.call("JS.closeWindow");
			}
		}
		
		private const loadJS:XML =
			<script>
				<![CDATA[
					function() {
						JS = {
							loadURL:function(){
								return document.location.href;
							},
							
							closeWindow:function() {
								window.close();
							}
						};
					}
				]]>
			</script>;
	}
}