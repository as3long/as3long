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
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Manages the game grid display.
	 */
	internal class View
	{
		private var _clip:Sprite;
		private var _cells:Array;
		private var _width:uint;
		private var _height:uint;
		private var _size:uint;	
		private var _sprites:Object;
		
		/**
		 * Constructor.
		 * 
		 * @param clip the DisplayObject to show the game grid in
		 * @param width the number of cells wide for the game grid
		 * @param height the number of cells tall fro the game grid
		 * @param sixe the pixel width/height of the cells in the game grid
		 * @param sprites an object containing the names of the sprites to use for the tetrads
		 */
		public function View( clip:Sprite, width:uint, height:uint, size:uint, sprites:Object )
		{
			_clip = clip;
			_width = width;
			_height = height;
			_size = size;
			_sprites = sprites;
			
			// create and initialise the cells in the game area
			var id:uint = 0;
			var pos:Number = _size * 0.5;
			_cells = new Array();
			for ( var i:uint = 0; i < _width; ++i )
			{
				_cells[i] = new Array();
				for ( var j:uint = 0; j < _height; ++j )
				{
					var cell:Sprite = new Sprite();
					cell.x = _size * i + pos;
					cell.y = _size * j + pos;
					var mask:Sprite = new Sprite();
					mask.graphics.beginFill( 0 );
					mask.graphics.drawRect( 0, 0, _size, _size );
					mask.x = _size * i;
					mask.y = _size * j;
					++id;
					_clip.addChild( cell );
					_clip.addChild( mask );
					cell.mask = mask;
					_cells[i][j] = cell;
				}
			}
		}
		
		private function clearCell( cell:Sprite ):void
		{
			while ( cell.numChildren )
			{
				cell.removeChildAt( 0 );
			}
		}
		
		/**
		 * Clears all the cells in the game board.
		 */
		internal function clearCells():void
		{
			for ( var i:uint = 0; i < _width; ++i )
			{
				for ( var j:uint = 0; j < _height; ++j )
				{
					clearCell( _cells[i][j] );
				}
			}
		}
		
		// triggered by the updateCells event from the game
		// sets the updated cell movieclips to the new state
		internal function onUpdateCells( ev:TetrisEvent ):void
		{
			var offset:Number = _size * 0.5;
			for ( var i:uint = 0; i < ev.cells.length; ++i )
			{
				var a:Cell = ev.cells[i];
				if ( a.state.shape == Shape.CLEAR )
				{
					clearCell( _cells[a.location.x][a.location.y] );
				}
				else
				{
					clearCell( _cells[a.location.x][a.location.y] );
					var id:Class = getDefinitionByName( _sprites[ a.state.shape.label ] ) as Class;
					var clip:Sprite = new id();
					_cells[a.location.x][a.location.y].addChild( clip );
					switch( a.state.shape )
					{
						case Shape.I:
							switch( a.state.number )
							{
								case 0:
									clip.x = - offset;
									clip.y = - offset;
									break;
								case 1:
									clip.x = - _size - offset;
									clip.y = - offset;
									break;
								case 2:
									clip.x = - 2 * _size - offset;
									clip.y = - offset;
									break;
								case 3:
									clip.x = - 3 * _size - offset;
									clip.y = - offset;
									break;
							}
							break;
						case Shape.O:
							switch( a.state.number )
							{
								case 0:
									clip.x = - offset;
									clip.y = - offset;
									break;
								case 1:
									clip.x = - _size - offset;
									clip.y = - offset;
									break;
								case 2:
									clip.x = - offset;
									clip.y = - _size - offset;
									break;
								case 3:
									clip.x = - _size - offset;
									clip.y = - _size - offset;
									break;
							}
							break;
						case Shape.T:
							switch( a.state.number )
							{
								case 0:
									clip.x = - offset;
									clip.y = - offset;
									break;
								case 1:
									clip.x = - _size - offset;
									clip.y = - offset;
									break;
								case 2:
									clip.x = - 2 * _size - offset;
									clip.y = - offset;
									break;
								case 3:
									clip.x = - _size - offset;
									clip.y = - _size - offset;
									break;
							}
							break;
						case Shape.S:
							switch( a.state.number )
							{
								case 0:
									clip.x = - _size - offset;
									clip.y = - offset;
									break;
								case 1:
									clip.x = - 2 * _size - offset;
									clip.y = - offset;
									break;
								case 2:
									clip.x = - offset;
									clip.y = - _size - offset;
									break;
								case 3:
									clip.x = - _size - offset;
									clip.y = - _size - offset;
									break;
							}
							break;
						case Shape.Z:
							switch( a.state.number )
							{
								case 0:
									clip.x = - offset;
									clip.y = - offset;
									break;
								case 1:
									clip.x = - _size - offset;
									clip.y = - offset;
									break;
								case 2:
									clip.x = - _size - offset;
									clip.y = - _size - offset;
									break;
								case 3:
									clip.x = - 2 * _size - offset;
									clip.y = - _size - offset;
									break;
							}
							break;
						case Shape.L:
							switch( a.state.number )
							{
								case 0:
									clip.x = - offset;
									clip.y = - offset;
									break;
								case 1:
									clip.x = - _size - offset;
									clip.y = - offset;
									break;
								case 2:
									clip.x = - 2 * _size - offset;
									clip.y = - offset;
									break;
								case 3:
									clip.x = - offset;
									clip.y = - _size - offset;
									break;
							}
							break;
						case Shape.F:
							switch( a.state.number )
							{
								case 0:
									clip.x = - offset;
									clip.y = - offset;
									break;
								case 1:
									clip.x = - _size - offset;
									clip.y = - offset;
									break;
								case 2:
									clip.x = - 2 * _size - offset;
									clip.y = - offset;
									break;
								case 3:
									clip.x = - 2 * _size - offset;
									clip.y = - _size - offset;
									break;
							}
							break;
					}
					_cells[a.location.x][a.location.y].rotation = a.state.rotation;
				}
			}
		}
	}
}