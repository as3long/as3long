package ghostcat.display.graphics
{
	import flash.geom.Point;
	
	import ghostcat.events.MoveEvent;
	import ghostcat.parse.graphics.GraphicsPath;
	

	/**
	 * 可通过拖动节点修改显示的图形
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class EditableGraphicsSprite extends GraphicsSprite
	{
		/**
		 * 控制点数组
		 */
		public var controls:Array = [];
		/**
		 * 控制点皮肤 
		 */
		public var pointSkin:* = null;
		public function EditableGraphicsSprite(data:Array = null)
		{
			super(data);
		}
		/** @inheritDoc*/
		override public function set graphicsData(v:Array) : void
		{
			clear();
			for (var i:int = 0;i < v.length;i++)
			{
				if (v[i] is GraphicsPath)
					doWithPath(v[i] as GraphicsPath);
			}
			super.graphicsData = v;
		}
		
		private function doWithPath(v:GraphicsPath):void
		{
			for (var i:int = 0; i < v.points.length;i++)
			{
				var p:Object = v.points[i];
				if (p is Point)
					addControl(p as Point);
				else if (p is Array)
				{
					addControl(p[0] as Point);
					addControl(p[1] as Point);
				}
			}
		}
		
		private function addControl(v:Point):void
		{
			var pt:DragPoint = new DragPoint(pointSkin,v);
			pt.addEventListener(MoveEvent.MOVE,moveHandler,false,0,true);
			addChild(pt);
			
			controls.push(pt);
		}
		
		private function moveHandler(event:MoveEvent):void
		{
			invalidateDisplayList();
		}
		
		private function clear():void
		{
			graphics.clear();
			for (var i:int = 0;i < controls.length;i++)
			{
				var pt:DragPoint = controls[i] as DragPoint;
				pt.removeEventListener(MoveEvent.MOVE,moveHandler);
				removeChild(pt);
			}
			controls = [];
		}
		/** @inheritDoc*/
		override public function destory() : void
		{
			clear();
			super.destory();
		}
	}
}