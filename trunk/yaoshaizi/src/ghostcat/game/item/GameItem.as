package ghostcat.game.item
{
	import flash.display.Sprite;
	
	import ghostcat.display.GBase;
	import ghostcat.display.GSprite;
	import ghostcat.game.item.collision.ICollision;
	import ghostcat.game.layer.collision.client.ICollisionClient;
	import ghostcat.game.item.sort.ISortCalculater;
	import ghostcat.game.layer.camera.ICamera;
	
	public class GameItem extends Sprite implements ICollisionClient
	{
		/**
		 * 设置了摄像机后，会自动调用其refreshItem方法
		 */
		public var camera:ICamera;
		/**
		 * 设置了排序器后，会自动计算排序深度，并赋值给priority
		 */
		public var sortCalculater:ISortCalculater;
		/**
		 * 排序深度 
		 */
		public var priority:Number;
		
		private var _oldX:Number;
		private var _oldY:Number;
		
		private var _collision:ICollision;
		public function get collision():ICollision
		{
			return _collision;
		}
		
		public override function set x(v:Number):void
		{	
			if (x == v)
				return;
			
			_oldX = super.x;
			super.x = v;
			
			updatePosition();
		}
		
		public override function set y(v:Number):void
		{
			if (y == v)
				return;
			
			_oldY = super.y;
			super.y = v;
			
			updatePosition();
		}
		
		public function setPosition(x:Number,y:Number,updatePos:Boolean = true):void
		{
			if (this.x == x && this.y == y)
				return;
			
			_oldX = super.x;
			_oldY = super.y;
			super.x = x;
			super.y = y;
					
			if (updatePos)
				updatePosition();
		}
		
		protected function updatePosition():void
		{
			if (sortCalculater)
				priority = sortCalculater.calculate();
			
			if (camera)
				camera.refreshItem(this);
		}
		
		public function get oldX():Number
		{
			return _oldX;
		}
		
		public function get oldY():Number
		{
			return _oldY;
		}
		
		public function GameItem()
		{
			super();
			updatePosition();
		}
	}
}