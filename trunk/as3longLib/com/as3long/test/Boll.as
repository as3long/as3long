package com.as3long.test 
{
	import com.riameeting.ui.control.Label;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author 黄龙
	 */
	public class Boll extends Sprite
	{
		public var label:Label = new Label();
		public function Boll(r:int=5)
		{
			//this.graphics.beginFill(Math.random() * 0xffffff, 1);
			//this.graphics.drawRect(0, 0, r, r);
			//this.graphics.endFill();
			
			//label.color = 0x000000;
			label.x = 5;
			label.y = 5;
			label.text = "label";
			addChild(label);
		}
	}

}