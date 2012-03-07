package  
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import mx.events.ModuleEvent;
	import mx.modules.IModuleInfo;
	import mx.modules.ModuleManager;
	
	/**
	 * ...
	 * @author huanglong
	 */
	public class Test extends Sprite 
	{
		private var modelInfo:IModuleInfo
		public function Test() 
		{
			modelInfo = ModuleManager.getModule('Module1.swf');
			modelInfo.addEventListener(ModuleEvent.READY, setup);
			//modelInfo.addEventListener(ModuleEvent.SETUP, setup);
			modelInfo.addEventListener(ModuleEvent.ERROR, onLoadError);  
			modelInfo.load(ApplicationDomain.currentDomain);
		}
		
		private function onLoadError(e:ModuleEvent):void 
		{
			trace(e.errorText);
		}
		
		private function setup(e:ModuleEvent):void 
		{
			var module:*= modelInfo.factory.create();
			//var jWindow:Object = module.getClass('org.aswing.JFrame');
			//var jWin:DisplayObject = new jWindow();
			//addChild(jWin);
			//this.addChild();
		}
		
	}

}