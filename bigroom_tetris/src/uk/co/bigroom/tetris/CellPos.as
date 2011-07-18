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
	 * Coordinates within the cell grid
	 */
	internal class CellPos
	{
		/**
		 * The x coordinate of the cell in the game grid.
		 */
		internal var x:Number;
		/**
		 * The y coordinate of the cell in the game grid.
		 */
		internal var y:Number;
		
		/**
		 * The constructor.
		 * 
		 * @param sx the x coordinate of the cell in the game grid
		 * @param sy the y coordinate of the cell in the game grid
		 */
		public function CellPos( sx:Number, sy:Number )
		{
			x = sx;
			y = sy;
		}
	
		/**
		 * Set the position of the cell.
		 * 
		 * @param v another CellPos to assign to this one
		 */
		internal function assign( v:CellPos ):CellPos
		{
			if ( this != v )
			{
				x = v.x;
				y = v.y;
			}
			return this;
		}
		
		/**
		 * Add two CellPos objects together.
		 * 
		 * @param u a CellPos to add
		 * @param v a CellPos to add
		 * 
		 * @return the sum of the two inputs
		 */
		internal static function sum( u:CellPos, v:CellPos ):CellPos
		{
			return new CellPos( u.x + v.x, u.y + v.y );
		}
		
		/**
		 * Rotate this CellPos to the left.
		 * 
		 * @return the CellPos rotated left
		 */
		internal function rotateLeft():CellPos
		{
			return new CellPos( y, -x );
		}
		/**
		 * Rotate this CellPos to the left and offset by one vertically.
		 * 
		 * @return the CellPos rotated left and offset
		 */
		internal function rotateLeftOffset():CellPos
		{
			return new CellPos( y, 1 - x );
		}
		/**
		 * Rotate this CellPos to the right.
		 * 
		 * @return the CellPos rotated right
		 */
		internal function rotateRight():CellPos
		{
			return new CellPos( -y, x );
		}
	}
}