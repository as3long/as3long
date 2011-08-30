package com.rush360.Manager 
{
	import com.rush360.Apple;
	import com.rush360.interfac.Ipeople;
	import com.rush360.People;
	import com.rush360.RedCar;
	import flash.display.Stage;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author 360rush
	 */
	public class AppBean
	{
		private var _stage:Stage;
		public function AppBean(stage:Stage)
		{
			_stage = stage;
		}
		
		
		public function getBean():*
		{
			//getDefinitionByName();
			var _class:Class = getDefinitionByName("com.rush360.People") as Class;
			var people:*;
			if (_class != null)
			{
				people= new _class;
				people.apple = new Apple();
				people.car = new RedCar();
			}
			return people;
		}
	}

}