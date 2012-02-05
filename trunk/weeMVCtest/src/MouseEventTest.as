package  
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author huanglong
	 */
	public class MouseEventTest extends Sprite 
	{
		
		public function MouseEventTest() 
		{
			stage.addEventListener(MouseEvent.CLICK, on_click);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, on_mouse_down);
			//stage.addEventListener(MouseEvent.MOUSE_MOVE, on_mouse_move);
			stage.addEventListener(MouseEvent.MOUSE_UP, on_mouse_up);
			trace(123);
		}
		
		private function on_mouse_up(e:MouseEvent):void 
		{
			print('on_mouse_up');
		}
		
		private function on_mouse_move(e:MouseEvent):void 
		{
			print('on_mouse_move');
		}
		
		private function on_mouse_down(e:MouseEvent):void 
		{
			print('on_mouse_down');
		}
		
		private function on_click(e:MouseEvent):void 
		{
			print('on_click');
		}
		
		private function print(str:String):void
		{
			trace(str, getTimer());
		}
	}

}