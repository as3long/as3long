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
	import flash.media.Sound;
	import flash.utils.getDefinitionByName;
	/**
	 * Manages the sound in the game. This class is used by the controller.
	 */
	internal class Audio
	{
		private var _soundOn:Boolean = true;
		private var _removeLine:Sound = null;
		private var _tetradLanded:Sound = null;
		private var _tetradMoved:Sound = null;
		/**
		 * The constructor.
		 * 
		 * @param removeLine the name of the class for the sound to play when a line 
		 * of blocks is removed
		 * @param tetradLanded the name of the class for the sound to play when a tetrad
		 * lands at the bottom
		 * @param tetradMoved the name of the class for the sound to play when a tetrad
		 * moves
		 */
		public function Audio( removeLine:String = null, tetradLanded:String = null, tetradMoved:String = null )
		{
			var c:Class;
			if ( removeLine != null )
			{
				c = getDefinitionByName( removeLine ) as Class;
				_removeLine = new c();
			}
			if ( tetradLanded != null )
			{
				c = getDefinitionByName( tetradLanded ) as Class;
				_tetradLanded = new c();
			}
			if ( tetradMoved != null )
			{
				c = getDefinitionByName( tetradMoved ) as Class;
				_tetradMoved = new c();
			}
		}
		
		internal function onTetradLanded( ev:TetrisEvent ):void
		{
			if ( _tetradLanded != null && _soundOn )
			{
				_tetradLanded.play();
			}
		}
		
		internal function onLinesRemoved( ev:TetrisEvent ):void
		{
			if ( _removeLine != null && _soundOn )
			{
				_removeLine.play( 0, ev.lines );
			}
		}
		
		internal function onTetradMoved( ev:TetrisEvent ):void
		{
			if ( _tetradMoved != null && _soundOn )
			{
				_tetradMoved.play();
			}
		}
		
		/**
		 * To enable and disable the sound.
		 */
		internal function get soundOn():Boolean
		{
			return _soundOn;
		}
		internal function set soundOn( state:Boolean ):void
		{
			_soundOn = state;
		}
	}
}