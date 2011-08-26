package com.rush360 
{
	/**
	 * ...Ipeople的实现
	 * @author 360rush
	 */
	public class People implements Ipeople 
	{
		private var _car:Icar;
		public function People() 
		{
			
		}
		
		public function set car(icar:Icar):void
		{
			_car = icar;
		}
		
		/* INTERFACE Ipeople */
		
		public function usecar():void 
		{
			_car.run();
		}
		
	}

}