package 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author 360rush
	 */
	public class Preloader extends MovieClip 
	{
		public var _txtLoad:TextField;
		public function Preloader() 
		{
			_txtLoad = new TextField();
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				stage.addChild(_txtLoad);
			}
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO show loader
		}
		
		private function ioError(e:IOErrorEvent):void 
		{
			//trace(e.text);
			_txtLoad.text = e.text;
		}
		
		private function progress(e:ProgressEvent):void 
		{
			// TODO update loader
			_txtLoad.text = int(e.bytesLoaded / e.bytesTotal * 100) + "%";
		}
		
		private function checkFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) 
			{
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void 
		{
			_txtLoad.text = "";
			stage.removeChild(_txtLoad);
			_txtLoad = null;
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO hide loader
			
			startup();
		}
		
		
		private function startup():void 
		{
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
	}
	
}