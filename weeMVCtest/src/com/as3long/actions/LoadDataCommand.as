package com.as3long.actions 
{
	import com.as3long.model.LoadDataModel;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import org.weemvc.as3.control.IController;
	import org.weemvc.as3.view.IViewLocator;
	import org.weemvc.as3.control.ICommand;
	import org.weemvc.as3.control.SimpleCommand;
	import org.weemvc.as3.model.IModelLocator;
	
	/**
	 * 数据加载控制器
	 * @author huanglong
	 */
	public class LoadDataCommand extends SimpleCommand implements ICommand 
	{
		public static const PLAY_LIST:String = "playList";
		
		public override function execute(data:Object = null):void 
		{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, on_complete);
			urlLoader.load(new URLRequest('url.txt'));
		}
		
		private function on_complete(e:Event):void 
		{
			var model:LoadDataModel = modelLocator.getModel(LoadDataModel);
			model.url = e.target.data;
		}
		
	}

}