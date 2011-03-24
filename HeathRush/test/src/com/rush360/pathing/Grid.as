package com.rush360.pathing
{
	/**
	 * Holds a two-dimensional array of Nodes methods to manipulate them, start node and end node for finding a path.
	 */
	public class Grid
	{
		private var _startNode:Node;
		private var _endNode:Node;
		private var _nodes:Array;
		private var _numCols:int;
		private var _numRows:int;
		
		/**
		 * 网格的构造器
		 * @param	numCols 列数
		 * @param	numRows 行数
		 */
		public function Grid(numCols:int, numRows:int)
		{
			_numCols = numCols;
			_numRows = numRows;
			_nodes = new Array();
			
			for(var i:int = 0; i < _numCols; i++)
			{
				_nodes[i] = new Array();
				for(var j:int = 0; j < _numRows; j++)
				{
					_nodes[i][j] = new Node(i, j);
				}
			}
		}
		
		
		////////////////////////////////////////
		// public methods
		////////////////////////////////////////
		
		/**
		 * 作用是:返回给定的坐标的节点
		 * @param x The x coord.
		 * @param y The y coord.
		 */
		public function getNode(x:int, y:int):Node
		{
			return _nodes[x][y] as Node;
		}
		
		/**
		 * 设置坐标为最终节点
		 * @param x The x 坐标.
		 * @param y The y 坐标.
		 */
		public function setEndNode(x:int, y:int):void
		{
			_endNode = _nodes[x][y] as Node;
		}
		
		/**
		 * 设置坐标为初始节点
		 * @param x The x 坐标.
		 * @param y The y 坐标.
		 */
		public function setStartNode(x:int, y:int):void
		{
			_startNode = _nodes[x][y] as Node;
		}
		
		/**
		 * 设置坐标点 是否能通过
		 * @param	x The x 坐标.
		 * @param	y The y 坐标.
		 * @param	value 是否能通过,默认为false
		 */
		public function setWalkable(x:int, y:int, value:Boolean=false):void
		{
			_nodes[x][y].walkable = value;
		}
		
		
		
		////////////////////////////////////////
		// getters / setters
		////////////////////////////////////////
		
		/**
		 * 获取结束节点
		 */
		public function get endNode():Node
		{
			return _endNode;
		}
		
		/**
		 * 返回网格的列数
		 */
		public function get numCols():int
		{
			return _numCols;
		}
		
		/**
		 *返回网格的行数
		 */
		public function get numRows():int
		{
			return _numRows;
		}
		
		/**
		 * 返回起始节点
		 */
		public function get startNode():Node
		{
			return _startNode;
		}
		
	}
}