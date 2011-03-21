package com.rush360.manger 
{
	import as3isolib.core.IsoDisplayObject;
	import as3isolib.display.IsoSprite;
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.geom.Pt;
	import com.rush360.pathing.AStar;
	import com.rush360.pathing.Grid;
	import eDpLib.events.ProxyEvent;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import as3isolib.geom.IsoMath;
	import flash.events.Event;
	/**
	 * ...
	 * @author 黄龙
	 */
	public class GameManger extends Sprite
	{
		private static var _this:GameManger = null;
		public var _stage:Stage = null;
		
		public var spr:IsoSprite;
		public var grid:IsoGrid;
		public var scene:IsoScene;
		public var view:IsoView;
		public var box:IsoBox;
		
		private var pt:Pt;
		private var me:MouseEvent;
		private static var cell_size:Number = 50;
		private var go:Boolean = false;
		private var myGrid:Grid = null;
		private var path:Array = null;
		private var iPath:int = 0;
		
		private var testArr:Array = 
		[
			[0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0],
			[0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0],
			[1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0],
			[0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0],
			[0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0],
			[1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1],
			[0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0],
			[1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0],
			[0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0],
			[0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0],
			[1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0],
		]
		
		public function GameManger() 
		{
			scene = new IsoScene();
			scene.hostContainer = this;
			
			grid = new IsoGrid();
			grid.cellSize = cell_size;
			grid.setGridSize(10, 10, 1);
			grid.showOrigin = false;
			
			view = new IsoView();
			view.centerOnPt(new Pt(200, 200));
			view.setSize(800, 600);
            view.addScene(scene); 
			scene.addChild(grid);
            addChild(view);
			
			this.addEventListener(Event.ENTER_FRAME, enter_frame);
		}
		
		private function enter_frame(e:Event):void 
		{
			if (go==true&&iPath < path.length)
			{
				box.moveTo(path[iPath].x * cell_size, path[iPath].y * cell_size,0);
				scene.render ();
				iPath++;
			}
			else
			{
				go = false;
			}
		}
		
		public function init():void
		{
			trace("程序开始执行");
			//*** scence要先把grid加上
			myGrid = new Grid(10, 10);
			box = new IsoBox();
			box.setSize(cell_size, cell_size, cell_size);
			scene.addChild(box);
			for (var i:int = 0; i < 10; i++)
			{
				for (var j:int = 0; j < 10; j++)
				{
					if (testArr[i][j] > 0)
					{
						var diban:IsoSprite = new IsoSprite();
						diban.sprites = [new diban_2()];
						diban.moveTo(i * cell_size, j * cell_size, 0);
						scene.addChild(diban);
						myGrid.setWalkable (i, j);
					}
					else
					{
						/*diban = new IsoSprite();
						diban.sprites = [new diban_1()];
						diban.moveTo(i * cell_size, j * cell_size, 0);
						scene.addChild(diban);*/
					}
				}
			}	
			grid.addEventListener(MouseEvent.CLICK, grid_click);
			scene.render();
		}
		
		private function grid_click(e:ProxyEvent):void 
		{
			me= MouseEvent(e.targetEvent);
			pt = new Pt(me.localX, me.localY);
			IsoMath.screenToIso(pt);
			//box.moveTo(Math.floor(pt.x/cell_size)*cell_size,Math.floor(pt.y/cell_size)*cell_size, 0);
			//scene.render();
			var pt1:Pt = new Pt(box.x, box.y);
			IsoMath.screenToIso(pt1);
			myGrid.setStartNode(Math.floor(box.x/cell_size),Math.floor(box.y/cell_size));
			myGrid.setEndNode(Math.floor(pt.x / cell_size), Math.floor(pt.y / cell_size))
			if (AStar.instance.findPath(myGrid))
			{
				path = AStar.instance.path;
				iPath = 0;
				go = true;
			}
		}
		
		public static function getThis():GameManger
		{
			if (_this == null)
			{
				_this = new GameManger();
			}
			return _this;
		}
		
	}

}