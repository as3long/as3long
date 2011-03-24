package com.rush360.pathing
{
	/**
	 *代表一个特定的节点(评价作为一项寻路算法)
	 */
	public class Node
	{
		public var x:int;
		public var y:int;
		public var f:Number;
		public var g:Number;
		public var h:Number;
		/**
		 * 节点是否可以通行
		 */
		public var walkable:Boolean = true;
		public var parent:Node;
		public var costMultiplier:Number = 1.0;
		
		public function Node(x:int, y:int)
		{
			this.x = x;
			this.y = y;
		}
	}
}