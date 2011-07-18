/*
 * Tetris Engine
 * Author: Richard Lord
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
	 * Configuration settings for a tetris game. You should pass
	 * an instance of this class or of a derived class to the 
	 * constructor for the tetris controller class.
	 */
	public class Config
	{
		/**
		 * How many points are awarded for each line cleared.
		 */
		public var scorePerLine:uint = 10;
		/**
		 * How quickly the game speeds up. The value should be lower 
		 * than but close to 1. A value of 1 means it doesn't speed 
		 * up at all. Smaller numbers causes it to speed up more quickly.
		 */
		public var acceleration:Number = 1;
		/**
		 * The initial speed of the game. Represents the number of 
		 * milliseconds between each drop of the tetrad. So smaller
		 * numbers are fatser.
		 */
		public var startSpeed:Number = 400;
		/**
		 * The keyCode of the key used to move the tetrad left. 
		 * Use 0 for no key.
		 */
		public var keyLeft:uint = 0;
		/**
		 * The keyCode of the key used to move the tetrad right.
		 * Use 0 for no key.
		 */
		public var keyRight:uint = 0;
		/**
		 * The keyCode of the key used to rotate the tetrad left.
		 * Use 0 for no key.
		 */
		public var keyRotLeft:uint = 0;
		/**
		 * The keyCode of the key used to rotate the tetrad right.
		 * Use 0 for no key.
		 */
		public var keyRotRight:uint = 0;
		/**
		 * The keyCode of the key used to make the tetrad drop rapidly.
		 * Use 0 for no key.
		 */
		public var keyDrop:uint = 0;
		/**
		 * The sound to play when a line is removed. This is the name
		 * of the class the sound is exported as. Use null for no sound.
		 */
		public var sndRemoveLine:String = null;
		/**
		 * The sound to play when a tetrad lands. This is the name
		 * of the class the sound is exported as. Use null for no sound.
		 */
		public var sndTetradLand:String = null;
		/**
		 * The sound to play when a tetrad moves. This is the name
		 * of the class the sound is exported as. Use null for no sound.
		 */
		public var sndTetradMove:String = null;
		/**
		 * The sprite to use for an L-shaped tetrad. This is the name
		 * of the class the library asset is exported as.
		 */
		public var tetradL:String = null;
		/**
		 * The sprite to use for an O-shaped tetrad. This is the name
		 * of the class the library asset is exported as.
		 */
		public var tetradO:String = null;
		/**
		 * The sprite to use for an F-shaped tetrad. This is the name
		 * of the class the library asset is exported as.
		 */
		public var tetradF:String = null;
		/**
		 * The sprite to use for a T-shaped tetrad. This is the name
		 * of the class the library asset is exported as.
		 */
		public var tetradT:String = null;
		/**
		 * The sprite to use for an S-shaped tetrad. This is the name
		 * of the class the library asset is exported as.
		 */
		public var tetradS:String = null;
		/**
		 * The sprite to use for a Z-shaped tetrad. This is the name
		 * of the class the library asset is exported as.
		 */
		public var tetradZ:String = null;
		/**
		 * The sprite to use for an I-shaped tetrad. This is the name
		 * of the class the library asset is exported as.
		 */
		public var tetradI:String = null;
		/**
		 * How many cells wide is the play area.
		 */
		public var playWidth:uint = 0;
		/**
		 * How many cells tall is the play area.
		 */
		public var playHeight:uint = 0;
		/**
		 * The width and height of a cell.
		 */
		public var blockSize:uint = 0;
		/**
		 * The horizontal position of the top left corner of the game.
		 */
		public var gameX:uint = 0;
		/**
		 * The vertical position of the top left corner of the game.
		 */
		public var gameY:uint = 0;
		/**
		 * The horizontal position of the top left corner of the next tetrad display.
		 */
		public var nextX:uint = 0;
		/**
		 * The vertical position of the top left corner of the next tetrad display.
		 */
		public var nextY:uint = 0;
		
		public function Config()
		{
		}
	}
}
