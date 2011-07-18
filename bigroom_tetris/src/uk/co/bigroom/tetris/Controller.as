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
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.events.EventDispatcher;
	
	import uk.co.bigroom.input.KeyPoll;
	/**
	 * This is the main interface to the tetris game engine.
	 * All normal interaction with the game is through
	 * this class.
	 */
	public class Controller extends EventDispatcher
	{
		private var _view:View;
		private var _tetris:Tetris;
		private var _score:uint;
		private var _speed:Number;
		private var _keyTimer:Timer;
		private var _playTimer:Timer;
		private var _audio:Audio;
		private var _clip:Sprite;
		private var _key:KeyPoll;
		private var _next:NextTetrad;
		private var _config:Config;
		
		/**
		 * Constructor.
		 * 
		 * @param root the root sorite or mivie clip in which the
		 * game should be displayed
		 * @param config configuration settings for the game
		 */
		public function Controller( root:Sprite, config:Config )
		{
			_config = config;
			var sprites:Object = {
				L:config.tetradL,
				O:config.tetradO,
				F:config.tetradF,
				T:config.tetradT,
				S:config.tetradS,
				Z:config.tetradZ,
				I:config.tetradI
			};
			_clip = new Sprite();
			root.addChild( _clip );
			_clip.x = _config.gameX;
			_clip.y = _config.gameY;
			_view = new View( _clip, _config.playWidth, _config.playHeight, _config.blockSize, sprites );
			_tetris = new Tetris( _config.playWidth, _config.playHeight );
			_audio = new Audio( _config.sndRemoveLine, _config.sndTetradLand, _config.sndTetradMove );
			var next:Sprite = new Sprite();
			root.addChild( next );
			next.x = _config.nextX;
			next.y = _config.nextY;
			_next = new NextTetrad( next, _config.blockSize, sprites );
			
			_tetris.addEventListener( TetrisEvent.LINES_REMOVED, onLinesRemoved, false, 0, true );
			_tetris.addEventListener( TetrisEvent.GAME_OVER, onGameOver, false, 0, true );
			_tetris.addEventListener( TetrisEvent.UPDATE_NEXT, onUpdateNext, false, 0, true );
			_tetris.addEventListener( TetrisEvent.UPDATE_CELLS, _view.onUpdateCells, false, 0, true );
			_tetris.addEventListener( TetrisEvent.TETRAD_LANDED, _audio.onTetradLanded, false, 0, true );
			_tetris.addEventListener( TetrisEvent.LINES_REMOVED, _audio.onLinesRemoved, false, 0, true );
			_tetris.addEventListener( TetrisEvent.TETRAD_MOVED, _audio.onTetradMoved, false, 0, true );
			_tetris.addEventListener( TetrisEvent.UPDATE_NEXT, _next.onUpdateNext, false, 0, true );
			
			_key = new KeyPoll( root.stage );
			root.stage.focus = root.stage;
			_playTimer = new Timer( _config.startSpeed );
			_playTimer.addEventListener( TimerEvent.TIMER, stepGame, false, 0, true );
			_keyTimer = new Timer ( _config.startSpeed * 0.2 );
			_keyTimer.addEventListener( TimerEvent.TIMER, testKeys, false, 0, true );
		}
		
		/**
		 * To start the game playing
		 */
		public function startGame():void
		{
			// reset the score and the level
			_score = 0;
			scoreChange();
			// reset game board cells
			_view.clearCells();
			// reset speed to initial value
			_speed = _config.startSpeed; // initial speed - milliseconds per move
			// restart the game
			_tetris.restart();
			// start the game playing
			playGame();
		}
		
		/**
		 * To resume the game after a pause
		 */
		public function playGame():void
		{
			// start the game loop
			_playTimer.delay = _speed;
			if ( !_playTimer.running )
			{
				_playTimer.start();
			}
			// start the keyboard testing loop
			_keyTimer.delay = _speed * 0.2;
			if ( !_keyTimer.running )
			{
				_keyTimer.start();
			}
			// turn on the keyboard sensing
			_clip.stage.removeEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
			_clip.stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true );
		}
		
		private function changeSpeed():void
		{
			_playTimer.delay = _speed;
			_keyTimer.delay = _speed * 0.2;
		}
		
		/**
		 * to pause the game.
		 */
		public function pauseGame():void
		{
			// turn off the game loop
			_playTimer.stop();
			// turn off the keyboard testing loop
			_keyTimer.stop();
			// trun off the keyboard sensing
			_clip.stage.removeEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
		}
		
		// onKeyDown handler for left/right and rotation keys
		private function onKeyDown( ev:KeyboardEvent ):void
		{
			switch( ev.keyCode )
			{
				case _config.keyRotLeft:
					_tetris.rotateLeft();
					break;
				case _config.keyRotRight:
					_tetris.rotateRight();
					break;
				case _config.keyLeft:
					_tetris.shiftLeft();
					break;
				case _config.keyRight:
					_tetris.shiftRight();
					break;
			}
		}
		
		// drop key must be detected continuously, so use this handler in an interval
		private function testKeys( ev:TimerEvent ):void
		{
			if ( _key.isDown( _config.keyDrop ) )
			{
				_tetris.drop();
			}
		}
		
		// the core function which moves the game on one step
		private function stepGame( ev:TimerEvent ):void
		{
			// move the game on one step
			_tetris.stepGame();
		}
		
		// triggered by lines linesRemoved event from the game
		private function onLinesRemoved( ev:TetrisEvent ):void
		{
			_score += ev.lines * _config.scorePerLine;
			scoreChange();
			_speed *= Math.pow( _config.acceleration, ev.lines );
			changeSpeed();
			dispatchEvent( ev );
		}
		
		// game over and you lose
		private function onGameOver( ev:TetrisEvent ):void
		{
			pauseGame();
			dispatchEvent( ev );
		}
		
		private function onUpdateNext( ev:TetrisEvent ):void
		{
			dispatchEvent( ev );
		}

		/**
		 * The score in the current game.
		 */
		public function get score():uint
		{
			return _score;
		}
		
		/**
		 * To turn the sound on and off.
		 */
		public function get soundOn():Boolean
		{
			return _audio.soundOn;
		}
		
		public function set soundOn( state:Boolean ):void
		{
			_audio.soundOn = state;
		}
		
		private function scoreChange():void
		{
			var ev:TetrisEvent = new TetrisEvent( TetrisEvent.SCORE_CHANGE );
			ev.score = _score;
			dispatchEvent( ev );
		}
	}
}