package ghostcat.community.physics
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import ghostcat.community.GroupManager;
	import ghostcat.events.TickEvent;
	
	/**
	 * 物理管理类
	 * （command参数为PhysicsItem对象和更新间隔毫秒数）
	 * 
	 * @author flashyiyi
	 */
	public class PhysicsManager extends GroupManager
	{
		/**
		 * 全局加速度（像素/秒*秒）
		 */
		public var gravity:Point;
		
		private var dict:Dictionary;
		
		public function PhysicsManager(command:Function = null)
		{
			this.priority = 1000;
			this.dict = new Dictionary();
			
			super(command);
			
			this.paused = false;
		}
		
		/**
		 * 添加对象
		 * @param obj
		 * 
		 */
		public override function add(obj:*,checkDup:Boolean = true) : void
		{
			var item:PhysicsItem;
			if (obj is PhysicsItem)
				item = obj as PhysicsItem
			else
				item = new PhysicsItem(obj);
			
			dict[obj] = item;
			
			super.add(item,checkDup);
		}
		
		/**
		 * 删除对象
		 * @param obj
		 * 
		 */
		public override function remove(obj:*) : void
		{
			var item:* = dict[obj];
			if (item)
				obj = item;
			
			super.remove(obj);
			
			if (obj is PhysicsItem)
				delete dict[(obj as PhysicsItem).target]
			delete dict[obj];
		}
		
		/**
		 * 设置加速度（像素/秒*秒）
		 * @param obj
		 * @param v
		 * 
		 */
		public function setAcceleration(obj:*,v:Point):void
		{
			(dict[obj] as PhysicsItem).acceleration = v;
		}
		
		/**
		 * 设置速度（像素/秒）
		 * @param obj
		 * @param v
		 * 
		 */
		public function setVelocity(obj:*,v:Point):void
		{
			(dict[obj] as PhysicsItem).velocity = v;
		}
		
		/**
		 * 获得物理物品 
		 * @param v
		 * @return 
		 * 
		 */
		public function getPhysicsItem(v:*):PhysicsItem
		{
			return dict[v];
		}
		
		/** @inheritDoc*/
		protected override function tickHandler(event:TickEvent):void
		{
			tick(event.interval);
		}
		
		public override function calculateAll(onlyFilter:Boolean=true) : void
		{
			throw new Error("calculateAll不能在这里使用，应用tick方法代替")
		}
		
		/**
		 * 基于时基的计算 
		 * @param interval
		 * 
		 */
		public function tick(interval:int):void
		{
			var d:Number = interval / 1000;
			for each (var item:PhysicsItem in dict)
			{
				if (item.acceleration)
				{
					item.velocity.x += item.acceleration.x * d;
					item.velocity.y += item.acceleration.y * d;
				}
				if (gravity)
				{
					item.velocity.x += gravity.x * d;
					item.velocity.y += gravity.y * d;
				}
				if (item.friction != 1)
				{
					item.velocity.x *= item.friction;
					item.velocity.y *= item.friction;
				}
				
				if (item.spin)
					item.rotation += item.spin;
				
				if (item.spinFriction != 1)
					item.spin *= item.spinFriction;
				
				if (item.scaleSpeed)
					item.scale += item.scaleSpeed;
				
				if (item.scaleFriction != 1)
					item.scaleSpeed *= item.scaleFriction;
				
				item.x += item.velocity.x * d * item.scale;
				item.y += item.velocity.y * d * item.scale;
				
				if (command!=null)
					command(item,interval);
			}
		}
	}
}