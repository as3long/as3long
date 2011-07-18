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
	import flash.events.EventDispatcher;
	/**
	 * Contains and manages the current state of a tetris game.
	 */
	internal class Tetris extends EventDispatcher
	{
		private var _width:uint;
		private var _height:uint;
		private var _startx:uint;
		private var _board:Array;
		private var _tetrad:Tetrad;
		private var _nextTetrad:Tetrad;
		
		/**
		 * Constructor
		 * 
		 * @param height the number of cells high for the game grid
		 * @param width the number if cells wide for the game grid
		 */
		public function Tetris( width:uint, height:uint )
		{
			_width = width;
			_height = height;
			
			// central position to start new tetrads from.
			_startx = Math.floor( ( _width - 1 ) * 0.5 );
			
			// set up the game board.
			_board = new Array();
			for ( var i:uint = 0; i < _width; ++i )
			{
				_board[i] = new Array();
				for ( var j:uint = 0; j < _height; ++j )
				{
					_board[i][j] = new CellState( Shape.CLEAR, 0, 0 );
				}
			}
			
			// create the two tetrad objects
			_tetrad = new Tetrad( this );
			_nextTetrad = new Tetrad( this );
		}
	
		private function reset():void
		{
			// Clear the game board
			for ( var i:Number = 0; i < _width; ++i )
			{
				for ( var j:Number = 0; j < _height; ++j )
				{
					_board[i][j] = new CellState( Shape.CLEAR, 0, 0 );
				}
			}
			// reset the tetrads
			_tetrad.reset();
			_nextTetrad.reset();
			var ev:TetrisEvent = new TetrisEvent( TetrisEvent.UPDATE_NEXT );
			ev.shape = _nextTetrad.shape;
			dispatchEvent( ev );
		}
		
		/**
		 * To restart the game.
		 */
		internal function restart():void
		{
			// Reset the game
			reset();
			// start the tetrad dropping
			newTetrad();
		}
		
		/**
		 * Move the game forward one step.
		 */
		internal function stepGame():void
		{
			// move the tetrad down
			_tetrad.drop();
		}
		
		/**
		 * Move the tetrad left.
		 */
		internal function shiftLeft():void
		{
			_tetrad.shiftLeft();
		}
		
		/**
		 * Move the tetrad right
		 */
		internal function shiftRight():void
		{
			_tetrad.shiftRight();
		}
		
		/**
		 * Rotate the tetrad left.
		 */
		internal function rotateLeft():void
		{
			_tetrad.rotateLeft();
		}
		
		/**
		 * Rotate the tetrad right.
		 */
		internal function rotateRight():void
		{
			_tetrad.rotateRight();
		}
		
		/**
		 * Move the tetrad down.
		 */
		internal function drop():void
		{
			_tetrad.drop();
		}
		
		// get the state of the cell at point x,y
		private function getCellShape( pos:CellPos ):Shape
		{
			if ( pos.x < 0 || pos.x >= _width || pos.y < 0 || pos.y >= _height )
			{
				// if the cell is outside of the game board
				return Shape.OUT;
			}
			else
			{
				// the value in the cell
				return _board[pos.x][pos.y].shape;
			}
		}
		
		/**
		 * Start a new tetrad from teh top.
		 */
		internal function newTetrad():void
		{
			// reset tetrad to the shape of next tetrad
			_tetrad.reset( _nextTetrad.shape );
			// reset next tetrad to a new random shape
			_nextTetrad.reset();
			var ev:TetrisEvent = new TetrisEvent( TetrisEvent.UPDATE_NEXT );
			ev.shape = _nextTetrad.shape;
			dispatchEvent( ev );
			// move the tetrad to the start position
			moveTetradToStart();
		}
		
		/**
		 * To test whether a cell is clear.
		 * 
		 * @param pos the cell to test
		 * 
		 * @return true if the cell is clear, false otherwise
		 */
		internal function isCellClear( pos:CellPos ):Boolean
		{
			var shape:Shape = getCellShape( pos );
			return( shape == Shape.CLEAR || shape == Shape.CURRENT );
		}
		
		// move the tetrad to the start position
		private function moveTetradToStart():void
		{
			if ( !_tetrad.setLocation( new CellPos( _startx, 0 ) ) )
			{
				// if can't then must be game over
				dispatchEvent( new TetrisEvent( TetrisEvent.GAME_OVER ) );
			}
		}
		
		// remove all completed lines
		private function removeLines():void
		{
			// this bit finds which lines to remove
			// array will hold reference to each completed line
			var linesToRemove:Array = new Array();
			var i:int, j:int, k:int;
			for ( j = _height; j--; )
			{
				// initially pressume to remove line
				var remove:Boolean = true;
				for ( i = _width; i--; )
				{
					if ( isCellClear( new CellPos( i, j ) ) )
					{
						// if we find a clear cell in the line, don't remove it
						remove = false;
						break;
					}
				}
				// if removable, add to array of lines to remove
				if ( remove )
				{
					linesToRemove.push( j );
				}
			}
			
			// this bit removes the lines
			var numlines:uint = linesToRemove.length;
			if ( numlines )
			{
				// array to hold cells which have changed
				var update:Array = new Array();
				// move lines down and add cells to update if necessary
				for ( i = 1; i <= numlines; ++i )
				{
					var max:Number = linesToRemove[ i-1 ] - 1;
					var min:Number = ( i == numlines ? 0 : linesToRemove[i] + 1 );
					for ( j = max; j >= min; --j )
					{
						for ( k = 0; k < _width; ++k )
						{
							// add cells to the update array
							update.push( new Cell( new CellPos( k, j+i ), _board[k][j] ) );
						}
					}
				}
				// add blank lines at top
				for ( j = numlines; j--; )
				{
					for ( k = 0; k < _width; ++k )
					{
						if ( _board[k][j] != Shape.CLEAR )
						{
							update.push( new Cell( new CellPos( k, j ), new CellState( Shape.CLEAR, 0, 0 ) ) );
						}
					}
				}
				// update the cells
				updateCells( update );
				
				// broadcast how many lines have been removed
				var ev:TetrisEvent = new TetrisEvent( TetrisEvent.LINES_REMOVED );
				ev.lines = numlines;
				dispatchEvent( ev );
			}
		}
		
		// update the values in changed cells
		// parameter is an array of cell objects
		private function updateCells( cells:Array ):void
		{
			for ( var i:uint = 0; i < cells.length; ++i )
			{
				_board[cells[i].location.x][cells[i].location.y] = cells[i].state;
				// modify update for display purposes
				if (cells[i].state.shape == Shape.CURRENT)
				{
					cells[i].state = new CellState( _tetrad.shape, cells[i].state.number, cells[i].state.rotation );
				}
			}
			// broadcast message to update the cells
			var ev:TetrisEvent = new TetrisEvent( TetrisEvent.UPDATE_CELLS );
			ev.cells = cells;
			dispatchEvent( ev );
		}
		
		// triggered by event if the tetrad has landed
		internal function tetradLanded():void
		{
			// update display, setting all current to tetrad's shape
			var temp:Array = _tetrad.getCells();
			var shape:Shape = _tetrad.shape;
			for ( var i:uint = temp.length; i--; )
			{
				temp[i].state.shape = shape;
				_board[temp[i].location.x][temp[i].location.y] = temp[i].state;
			}
			// broadcast that the tetrad has landed
			dispatchEvent( new TetrisEvent( TetrisEvent.TETRAD_LANDED ) );
			// remove completed lines
			removeLines();
			newTetrad();
		}
		
		// triggered by event if the tetrad has moved
		internal function tetradMoved( cells:Array ):void
		{
			// update the cells
			updateCells( cells );
			// broadcast the message that the tetrad has moved
			dispatchEvent( new TetrisEvent( TetrisEvent.TETRAD_MOVED ) );
		}
	}
}