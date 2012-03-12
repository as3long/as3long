package ghostcat.manager
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import ghostcat.events.DragEvent;
	import ghostcat.events.TickEvent;
	import ghostcat.parse.display.AlphaShapeParse;
	import ghostcat.parse.display.DrawParse;
	import ghostcat.util.Tick;
	import ghostcat.util.core.Handler;
	import ghostcat.util.display.Geom;
	
	/**
	 * FLASH自带的拖动功能缺乏扩展性，因此必要时只能重新实现。
	 * 
	 * 这个类可以实现对Bitmap,TextField的拖动，支持多物品拖动,
	 * 并且会自动向外发布DragOver,DragOut,DragDrop等事件。
	 * 
	 * 这个类的DragStart和DragStop事件都是可中断的，若指定中断就可以中止原来的操作。
	 * 
	 * 设定type可以选择拖动临时图标代替拖动本体
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class DragManager
	{
		/**
		 * 直接拖动
		 */
		public static const DIRECT:String = "direct";
		/**
		 * 复制一个图标并拖动
		 */
		public static const CLONE:String = "clone";
		/**
		 * 复制一个带有透明度的图标并拖动
		 */
		public static const ALPHA_CLONE:String = "alpha_clone";
		
		private static var list:Dictionary = new Dictionary();//物品对应拖动管理器的临时字典
		private static var regObject:Dictionary = new Dictionary();//注册的拖动物品字典
		
		/**
		 * 开始拖动
		 * 
		 * @param obj	要拖动的物品
		 * @param bounds	拖动的范围，坐标系为父对象
		 * @param startHandler	开始拖动时执行的事件
		 * @param stopHandler	停止拖动后执行的事件
		 * @param onHandler	拖动时每帧执行的事件
		 * @param type	拖动类型
		 * @param lockCenter	是否以物体中心点为拖动的点
		 * @param upWhenLeave	当移出拖动范围时，是否停止拖动
		 * @param collideByRect	判断范围是否以物品的边缘而不是注册点为标准
		 * 
		 */
		public static function startDrag(obj:DisplayObject,bounds:Rectangle=null,startHandler:Function = null,stopHandler:Function=null,onHandler:Function=null,
									type:String = DIRECT,lockCenter:Boolean = false,upWhenLeave:Boolean = false,collideByRect:Boolean = false):void
		{
			if (list[o]!=null)
				return;
				
			var o:DragManager = new DragManager();
			
			o.obj = obj;
			o.bounds = bounds;
			o.type = type;
			o.lockCenter = lockCenter;
			o.upWhenLeave = upWhenLeave;
			o.collideByRect = collideByRect;
			o.startHandler = startHandler;
			o.stopHandler = stopHandler;
			o.onHandler = onHandler;
			o.startDrag();
		}
		
		/**
		 * 停止拖动
		 * @param obj
		 * 
		 */
		public static function stopDrag(obj:DisplayObject):void
		{
			if (list[obj])
				(list[obj] as DragManager).stopDrag();
		}
		
		/**
		 * 注册一个可拖动的物品
		 * 
		 * @param obj	触发拖动的对象
		 * @param target	被拖动的对象
		 * 
		 */
		public static function register(obj:DisplayObject,target:DisplayObject=null,bounds:Rectangle=null,startHandler:Function=null,stopHandler:Function=null,onHandler:Function=null,
									type:String = DIRECT,lockCenter:Boolean = false,upWhenLeave:Boolean = false,collideByRect:Boolean = false):void
		{
			if (!target)
				target = obj;
			
			regObject[obj] = new Handler(DragManager.startDrag,[target,bounds,startHandler,stopHandler,onHandler,
									type,lockCenter,upWhenLeave,collideByRect]);
			obj.addEventListener(MouseEvent.MOUSE_DOWN,dragStartHandler);
		}
		
		/**
		 * 取消注册拖动，这样被拖动的物品才可以被回收
		 * @param obj
		 * 
		 */
		public static function unregister(obj:DisplayObject):void
		{
			obj.removeEventListener(MouseEvent.MOUSE_DOWN,dragStartHandler);
			delete regObject[obj];
		}
		
		private static function dragStartHandler(event:MouseEvent):void
		{
			var h:Handler = regObject[event.currentTarget];
			if (h)
				h.call();
		}
		
		protected var obj:DisplayObject;
		protected var type:String;
		protected var lockCenter:Boolean;
		protected var upWhenLeave:Boolean;
		protected var collideByRect:Boolean;
		protected var bounds:Rectangle;
		protected var onHandler:Function;
		protected var startHandler:Function;
		protected var stopHandler:Function;
		
		protected var dragMousePos:Point;
		protected var dragPos:Point;
		protected var dragContainer:DisplayObject;
		
		protected var image:Bitmap;
	
		protected function startDrag():void
		{
			if (startHandler!=null)
				obj.addEventListener(DragEvent.DRAG_START,startHandler);
			
			var e:DragEvent = new DragEvent(DragEvent.DRAG_START,false,true);
			e.dragObj = obj;
			obj.dispatchEvent(e);
			
			if (e.isDefaultPrevented())
				return;
			
			list[obj] = this;
			if (lockCenter)
				dragMousePos = Geom.center(obj);
			else
				dragMousePos = Geom.localToContent(new Point(obj.mouseX,obj.mouseY),obj,obj.parent);;
				
			dragPos = new Point(obj.x,obj.y);
			
			Tick.instance.addEventListener(TickEvent.TICK,enterFrameHandler);
			obj.stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			obj.stage.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			obj.stage.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
			if (stopHandler!=null)
				obj.addEventListener(DragEvent.DRAG_STOP,stopHandler);
			if (onHandler!=null)
				obj.addEventListener(DragEvent.DRAG_ON,onHandler);
				
			if (type == CLONE || type == ALPHA_CLONE)
			{
				image = DrawParse.createBitmap(obj);
				dragMousePos.x -= image.x;
				dragMousePos.y -= image.y;
				obj.stage.addChild(image);
				
				if (type == ALPHA_CLONE)
					new AlphaShapeParse(image).parse(image.bitmapData);
			}
		}
		
		protected function stopDrag():void
		{
			var e:DragEvent = new DragEvent(DragEvent.DRAG_STOP,false,true);
			e.dragObj = obj;
			obj.dispatchEvent(e)
			
			if (e.isDefaultPrevented())
				return;
			
			Tick.instance.removeEventListener(TickEvent.TICK,enterFrameHandler);
			if (obj.stage)
			{
				obj.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
				obj.stage.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
				obj.stage.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
			}
			if (startHandler!=null)
				obj.removeEventListener(DragEvent.DRAG_START,startHandler);
			if (stopHandler!=null)
				obj.removeEventListener(DragEvent.DRAG_STOP,stopHandler);
			if (onHandler!=null)
				obj.removeEventListener(DragEvent.DRAG_ON,onHandler);
			
			dragPos = null;
			dragMousePos = null;
			
			delete list[obj];
			
			if (image)
			{
				image.bitmapData.dispose();
				image.parent.removeChild(image);
			}
		}
		
		private function enterFrameHandler(event:TickEvent):void
		{
			var	parentOffest:Point = Geom.localToContent(new Point(obj.mouseX,obj.mouseY),obj,obj.parent).subtract(dragMousePos);
			
			if (image)
			{
				image.x = dragPos.x + parentOffest.x;
				image.y = dragPos.y + parentOffest.y;
			}
			else
			{
				obj.x = dragPos.x + parentOffest.x;
				obj.y = dragPos.y + parentOffest.y;
			}
			
			if (bounds)
			{
				var out:Boolean;
				if (collideByRect)
					out = Geom.forceRectInside(obj,bounds);
				else
					out = Geom.forcePointInside(obj,bounds);
			}
			
			var e:DragEvent = new DragEvent(DragEvent.DRAG_ON,false,false);
			e.dragObj = obj;
			obj.dispatchEvent(e);
			
			if (out && upWhenLeave)
				stopDrag();
		}
		
		private function mouseUpHandler(event:MouseEvent):void
		{
			stopDrag();
			
			if (dragContainer)
			{
				var e:DragEvent = new DragEvent(DragEvent.DRAG_DROP,true,false);
				e.dragObj = obj;
				dragContainer.dispatchEvent(e);
				dragContainer = null;
			}
			
			e = new DragEvent(DragEvent.DRAG_COMPLETE,false,false);
			e.dragObj = obj;
			obj.dispatchEvent(e);
		}
		
		private function mouseOverHandler(event:MouseEvent):void
		{
			dragContainer = event.target as DisplayObject;
			
			var e:DragEvent = new DragEvent(DragEvent.DRAG_OVER,true,false);
			e.dragObj = obj;
			event.target.dispatchEvent(e);
		}
		
		private function mouseOutHandler(event:MouseEvent):void
		{
			var e:DragEvent = new DragEvent(DragEvent.DRAG_OUT,true,false);
			e.dragObj = obj;
			event.target.dispatchEvent(e);
		}
	}
}
