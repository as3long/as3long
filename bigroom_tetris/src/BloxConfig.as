/*
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
 
package
{
	import uk.co.bigroom.tetris.Config;
	
	import flash.ui.Keyboard;	

	/**
	 * Tetris configuration used in the Blox game
	 */
	public class BloxConfig extends Config
	{
		public function BloxConfig()
		{
			scorePerLine = 25;
			acceleration = 0.97;
			startSpeed = 400;
			keyLeft = Keyboard.LEFT;
			keyRight = Keyboard.RIGHT;
			keyRotLeft = Keyboard.UP;
			keyRotRight = 0;
			keyDrop = Keyboard.DOWN;
			sndRemoveLine = "HitSound";
			sndTetradLand = "PopSound";
			sndTetradMove = null;
			tetradL = "Tetrad_L";
			tetradO = "Tetrad_O";
			tetradF = "Tetrad_F";
			tetradT = "Tetrad_T";
			tetradS = "Tetrad_S";
			tetradZ = "Tetrad_Z";
			tetradI = "Tetrad_I";
			playWidth = 10;
			playHeight = 17;
			blockSize = 20;
			gameX = 21;
			gameY = 21;
			nextX = 244;
			nextY = 21;
		}
	}
}
