package com.rush360 
{
	import com.rush360.interfac.*;
	/**
	 * ...Ipeople的实现
	 * @author 360rush
	 */
	public class People implements Ipeople 
	{
		private var _car:Icar;
		private var _apple:Iapple;
		public function People() 
		{
		}
		
		public function set car(icar:Icar):void
		{
			_car = icar;
		}
		
		public function set apple(iapple:Iapple):void
		{
			_apple = iapple;
		}
		
		/* INTERFACE Ipeople */
		
		public function usecar():void 
		{
			_car.run();
		}
		
		public function eatApple():void
		{
			trace(_apple.color());
		}
	}

}