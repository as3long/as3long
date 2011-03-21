package com.mySite 
{
	import com.webBase.activeBag.MethodBag;
	import com.webBase.event.LoadModuleEvent;
	import com.webBase.event.LoadSwfEvent;
	import com.webBase.ParentBase;
	import com.webBase.swfList.modules.IloadInfo;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author WZH(shch8.com)
	 */
	public class Blog extends ParentBase
	{
		private var module1:IloadInfo
		private var canvas:Sprite
		private var setX:Number=150;
		private var setY:Number=150;
		public function Blog() 
		{
			cache=true
		}
		override protected function init():void 
		{
			gotoAndPlay(1)
			canvas=getChildByName("content") as Sprite
			canvas.addEventListener(MouseEvent.CLICK, clickEvent)
		}
		private function clickEvent(e:MouseEvent):void {
			switch(e.target.name) {
				case "b1":
				if (module1 == null) {
				module1 = loadModule("module1.swf")
				module1.addEventListener(LoadModuleEvent.COMPLETE, moduleComplete)
				module1.addEventListener(LoadSwfEvent.PROGRESS, loadProgress)
				}else if(!module1.loaded){
					module1.load("module1.swf")
					}
				break
				case "b2":
				loadModule("module2.swf").addEventListener(LoadModuleEvent.COMPLETE, moduleComp)
				break
				}
		}
		private function moduleComp(e:LoadModuleEvent):void {
			
			if(stage.stageWidth<setX+150)
			{
				setX=150;
				setY+=150;
			}
			e.content.x=setX;
			e.content.y=setY;
			canvas.addChild(e.content);
			setX += 150;
		}
		private function loadProgress(e:LoadSwfEvent):void {
			//trace(e.bytesPct)
		}
		private function moduleComplete(e:LoadModuleEvent):void {
			module1.loader.y = 150;
			canvas.addChild(module1.loader)
			module1.content.getChildByName("closeBtn").addEventListener(MouseEvent.CLICK,unloadModule)
		}
		private function unloadModule(e:MouseEvent):void {
			module1.unload();
		}
	}
	
}