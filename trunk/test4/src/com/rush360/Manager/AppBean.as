package com.rush360.Manager 
{
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author 360rush
	 */
	public class AppBean extends DisplayObject
	{
		private var _xml:XML;
		public function AppBean(xml:XML) 
		{
			_xml = xml;
		}
		
		public function getBean(id:String):*
		{
			//getDefinitionByName();
		}
	}

}