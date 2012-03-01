package  
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	/**
	 * ...
	 * @author huanglong
	 */
	public class KeyComtroller 
	{
		private var leftArrow:Boolean = false;
		private var rightArrow:Boolean = false;
		private var upArrow:Boolean = false;
		private var downArrow:Boolean = false;
		
		public var speed:Number = 8;
		
		public var mc:DisplayObject = new Sprite();
		
		private var _mstage:Stage;
		
		public function KeyComtroller() 
		{
			
		}
		
		
		
		//按键时的检测，左上右下分别是37，38，39，40
		public function addKeyEvent(mStage:Stage):void
		{
			_mstage = mStage;
			_mstage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressedDown);
			_mstage.addEventListener(KeyboardEvent.KEY_UP, keyPressedUp);
			_mstage.addEventListener(Event.ENTER_FRAME, mcMove);
			_mstage.addEventListener(Event.DEACTIVATE, missingStage); //Flash处于非活动状态时调用
		}
		
		public function keyPressedDown(_evt:KeyboardEvent):void
		{
			if (_evt.keyCode == 37)
			{
				leftArrow = true;
			}
			else if (_evt.keyCode == 39)
			{
				rightArrow = true;
			}
			else if (_evt.keyCode == 38)
			{
				upArrow = true;
			}
			else if (_evt.keyCode == 40)
			{
				downArrow = true;
			}
		}
		//松开按键时
		public function keyPressedUp(_evt:KeyboardEvent):void
		{
			if (_evt.keyCode == 37)
			{
				leftArrow = false;
			}
			else if (_evt.keyCode == 39)
			{
				rightArrow = false;
			}
			else if (_evt.keyCode == 38)
			{
				upArrow = false;
			}
			else if (_evt.keyCode == 40)
			{
				downArrow = false;
			}
		}
		
		//MC的移动部分
		public function mcMove(_evt:Event):void
		{
			//移动的速度
			if (leftArrow)
			{
			//MC的位置检测，下边相同
				/*if (0 <= mc.x)*/
				//{
					mc.x -= speed;
				/*}*/
			}
			if (rightArrow)
			{
				//if (mc.x <= _mstage.stageWidth - mc.width - 20)
				//{
					mc.x += speed;
				//}
			}
			if (upArrow)
			{
				/*if (0 <= mc.y)
				{*/
					mc.y -= speed;
				/*}*/
			}
			if (downArrow)
			{
				/*if (mc.y <= _mstage.stageHeight - mc.height - 20)
				{*/
					mc.y += speed;
				/*}*/
			}
		}
		
		//Flash处于非激活状态时
		public function missingStage(_evt:Event):void
		{
			/*leftArrow = false;
			rightArrow = false;
			upArrow = false;
			downArrow = false;*/
		}
	}

}