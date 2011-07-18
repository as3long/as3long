/*
 * Tetris Engine * Author: Richard Lord
 * Copyright (c) Big Room Ventures Ltd. 2007
 * Version: 1.0.0
 * 
 * Licence Agreement
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package uk.co.bigroom.tetris
{
	/**
	 * Manages a single tetrad. A tetrad is a four block shape
	 * used within the game.
	 */
	internal class Tetrad
	{
		private var _tetris:Tetris;
		private var _shape:Shape;
		private var _points:Array;
		private var _location:CellPos;
		private var _rotation:int;
		
		/**
		 * Constructor.
		 * 
		 * @param g The tetris game the tetrad will be used in
		 * @param s The shape for this tetrad. If null, a
		 * random shape is used
		 */
		public function Tetrad( g:Tetris, s:Shape = null )
		{
			_tetris = g;
			_points = new Array();
			reset( s );
		}
		
		private function getRandomShape():Shape
		{
			return [ Shape.I, Shape.O, Shape.T, Shape.Z, Shape.S, Shape.L, Shape.F ][ Math.floor( 7 * Math.random() ) ];
		}
		
		/**
		 * Set the tetrad shape
		 * 
		 * @param s the new shape for the tetrad. if null, a 
		 * random shape is used
		 */
		internal function reset( s:Shape = null ):void
		{
			if ( s == null )
			{
				s = getRandomShape();
			}
			_shape = s;
			// set coordinates to 0,0
			_location = new CellPos( 0, 0 );
			_rotation = 0;
			// clear the points array
			_points.length = 0;
			// set the points for this shape
			switch( _shape )
			{
				case Shape.I:
					_points.push( new CellPos( -1, 0 ),  new CellPos( 0, 0 ),  new CellPos( 1, 0 ),  new CellPos( 2, 0 ) );
					break;
				case Shape.O:
					_points.push( new CellPos( 0, 0 ),  new CellPos( 1, 0 ),  new CellPos( 0, 1 ),  new CellPos( 1, 1 ) );
					break;
				case Shape.T:
					_points.push( new CellPos( -1, 0 ),  new CellPos( 0, 0 ),  new CellPos( 1, 0 ),  new CellPos( 0, 1 ) );
					break;
				case Shape.S:
					_points.push( new CellPos( 0, 0 ),  new CellPos( 1, 0 ),  new CellPos( -1, 1 ),  new CellPos( 0, 1 ) );
					break;
				case Shape.Z:
					_points.push( new CellPos( -1, 0 ),  new CellPos( 0, 0 ),  new CellPos( 0, 1 ),  new CellPos( 1, 1 ) );
					break;
				case Shape.L:
					_points.push( new CellPos( -1, 0 ),  new CellPos( 0, 0 ),  new CellPos( 1, 0 ),  new CellPos( -1, 1 ) );
					break;
				case Shape.F:
					_points.push( new CellPos( -1, 0 ),  new CellPos( 0, 0 ),  new CellPos( 1, 0 ),  new CellPos( 1, 1 ) );
					break;
			}
		}
		
		/**
		 * Place the tetrad in a precise location in the game grid.
		 * This method doesn't remove the tetrad from any previous position.
		 * 
		 * @param newLocation the location to place the tetrad
		 */
		internal function setLocation( newLocation:CellPos ):Boolean
		{
			// if we can't place it at x, y
			if ( !canMoveTo( newLocation, _points ) )
			{
				return false;
			}
			// place it at x,y
			_location.assign( newLocation );
			// tell the game that the tetrad has moved
			_tetris.tetradMoved( getCells() );
			return true;
		}
		
		private function moveTo( newLocation:CellPos, newPoints:Array, newrotation:int ):Boolean
		{
			// if we can't move it to newLocation, newPoints
			if ( !canMoveTo( newLocation, newPoints ) )
			{
				return false;
			}
			
			// array for cells to update - start with current cells
			var update:Array = getCells();
			
			for ( var i:uint = 0; i < 4; ++i )
			{
				update[i].state.shape = Shape.CLEAR;
				update[i].state.number = 0;
			}
			// move to newLocation, newPoints
			_location = newLocation;
			_points = newPoints;
			_rotation = newrotation;
			// add new cells to update
			update = update.concat( getCells() );
			// tell the game that the tetrad has moved, with cells to update
			_tetris.tetradMoved( update );
			return true;
		}
		
		private function canMoveTo( newLocation:CellPos, newPoints:Array ):Boolean
		{
			for ( var i:uint = 0; i < 4; ++i )
			{
				if ( !_tetris.isCellClear( CellPos.sum( newPoints[i], newLocation ) ) )
				{
					return false;
				}
			}
			return true;
		}
		
		/**
		 * Move the tetrad one space to the left.
		 */
		internal function shiftLeft():void
		{
			moveTo( CellPos.sum( _location, new CellPos( -1, 0 ) ), _points, _rotation );
		}
		
		/**
		 * Move the tetrad one space to the right.
		 */
		internal function shiftRight():void
		{
			moveTo( CellPos.sum( _location, new CellPos( 1, 0 ) ), _points, _rotation );
		}
		
		/**
		 * Rotate the tetrad 90 degrees to the left.
		 */
		internal function rotateLeft():void
		{
			var temp:Array = new Array();
			var i:uint;
			if ( _shape == Shape.O )
			{
				for ( i = 0; i < 4; ++i )
				{
					temp.push( _points[i].rotateLeftOffset() ); 
				}
			}
			else
			{
				for ( i = 0; i < 4; ++i )
				{
					temp.push( _points[i].rotateLeft() ); 
				}
			}
			moveTo( _location, temp, _rotation - 90);
		}
		
		/**
		 * Rotate the tetrad 90 degrees to the right.
		 */
		internal function rotateRight():void
		{
			var temp:Array = new Array();
			for ( var i:Number = 0; i < 4; ++i )
			{
				temp.push( _points[i].rotateRight() ); 
			}
			moveTo( _location, temp, _rotation + 90);
		}
		
		/**
		 * Move the tetrad one space down.
		 */
		internal function drop():void
		{
			if ( !moveTo( CellPos.sum( _location, new CellPos( 0, 1 ) ), _points, _rotation ) )
			{
				// call atBottom if can't move down
				atBottom();
			}
		}
		
		private function atBottom():void
		{
			// tell the game that we've landed
			_tetris.tetradLanded();
		}
		
		/**
		 * Get the shape of the tetrad.
		 */
		internal function get shape():Shape
		{
			return _shape;
		}
		
		/**
		 * Get the cells occupied by the tetrad.
		 */
		internal function getCells():Array
		{
			var temp:Array = new Array();
			for ( var i:uint = 0; i < 4; ++i )
			{
				temp.push( new Cell( CellPos.sum( _location,  _points[i] ), new CellState( Shape.CURRENT, i, _rotation ) ) );
			}
			return temp;
		}
	}
}