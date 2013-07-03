package com.as3long.test 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author 黄龙
	 */
	public class DisplayobjectTest extends Sprite 
	{
		private var boll1:Boll = new Boll(20);
		private var boll2:Boll = new Boll(20);
		//private var boll1_1:Boll = new Boll(10);
		//private var boll2_1:Boll = new Boll(10);
		public function DisplayobjectTest() 
		{
			//boll1.addChild(boll1_1);
			//boll2.addChild(boll2_1);
			boll1.x = 10;
			boll1.y = 10;
			addChild(boll1);
			boll2.x = 19;
			boll2.y = 46;
			addChild(boll2);
			trace(boll1.label.hitTestObject(boll2.label));
		}
		
	}
	
	

}