package  
{
	/**
	 * ...
	 * @author huanglong
	 */
	public class as3Socketjs
	{
		import flash.external.ExternalInterface;
		import flash.display.*;
		import flash.net.*;
		
		public var objectCount:Number = 1;
		public var objectCache:Array = new Array();
		public function as3Socketjs() 
		{
			
		}
		public	function aflaxInit():Void
		{
			Stage.align = "TL";
			Stage.scaleMode = "noScale";
			
			objectCache["_root"] = _root;
			objectCache["_stage"] = Stage;
			/*			
			ExternalInterface.addCallback("aflaxUpdateAfterEvent", _root, updateAfterEvent);
			
			ExternalInterface.addCallback("aflaxCreateObject", _root, aflaxCreateObject);
			ExternalInterface.addCallback("aflaxGetProperty", _root, aflaxGetProperty);
			ExternalInterface.addCallback("aflaxSetProperty", _root, aflaxSetProperty);
			ExternalInterface.addCallback("aflaxCallFunction", _root, aflaxCallFunction);
			ExternalInterface.addCallback("aflaxBulkCallFunction", _root, aflaxBulkCallFunction);
			
			ExternalInterface.addCallback("aflaxCallStaticFunction", _root, aflaxCallStaticFunction);
			ExternalInterface.addCallback("aflaxGetStaticProperty", _root, aflaxGetStaticProperty);
			
			ExternalInterface.addCallback("aflaxAttachSocketEvents", _root, aflaxAttachSocketEvents);
			
			ExternalInterface.addCallback("aflaxAttachVideo", _root, aflaxAttachVideo);
			ExternalInterface.addCallback("aflaxAttachCuePointEvent", _root, aflaxAttachCuePointEvent);
			ExternalInterface.addCallback("aflaxAttachVideoStatusEvent", _root, aflaxAttachVideoStatusEvent);
			
			ExternalInterface.addCallback("aflaxCreateVideoClip", _root, aflaxCreateVideoClip);
			ExternalInterface.addCallback("aflaxLoadMovie", _root, aflaxLoadMovie);
			ExternalInterface.addCallback("aflaxAttachBitmap", _root, aflaxAttachBitmap);
			ExternalInterface.addCallback("aflaxApplyFilter", _root, aflaxApplyFilter);
			ExternalInterface.addCallback("aflaxAddEventHandler", _root, aflaxAddEventHandler);
			ExternalInterface.addCallback("aflaxCreateTextField", _root, aflaxCreateTextField);
			ExternalInterface.addCallback("aflaxCreateEmptyMovieClip", _root, aflaxCreateEmptyMovieClip);
			ExternalInterface.addCallback("aflaxDuplicateMovieClip", _root, aflaxDuplicateMovieClip);
			
			ExternalInterface.addCallback("aflaxStoreValue", _root, aflaxStoreValue);
			ExternalInterface.addCallback("aflaxGetValue", _root, aflaxGetValue);
			
			ExternalInterface.addCallback("aflaxGetCamera", _root, aflaxGetCamera);
			
			ExternalInterface.addCallback("aflaxAddEventListener", _root, aflaxAddEventListener);
			ExternalInterface.addCallback("aflaxAttachEventListener", _root, aflaxAttachEventListener);
			if(_root["callback"] != null)
			{
			ExternalInterface.call(_root["callback"]);
			}
			else
			{
			ExternalInterface.call("main");
			}
			*/		
			}
		
	}

}