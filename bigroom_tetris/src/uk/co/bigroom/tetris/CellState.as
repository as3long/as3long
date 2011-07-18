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
	 * An instance of this class represents the state of a cell
	 * in the game area.
	 */
	internal class CellState
	{
		/**
		 * The tetrad shape in the cell.
		 */
		internal var shape:Shape;
		/**
		 * Which part of the tetrad is in the cell.
		 * A number from 1 to 4.
		 */
		internal var number:uint;
		/**
		 * The rotation (in degrees) of the tetrad.
		 */
		internal var rotation:int;
		
		/**
		 * The constructor.
		 * 
		 * @param s Initial valkue for the shape
		 * @param n Initial value for the number
		 * @param r initial value for the rotation
		 */
		public function CellState( s:Shape, n:uint, r:int )
		{
			shape = s;
			number = n;
			rotation = r;
		}
	}
}