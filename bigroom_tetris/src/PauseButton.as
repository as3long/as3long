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
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * Custom class for the pause button in Blox
	 */

	public class PauseButton extends Sprite 
	{
		public static var PAUSE:String = "pause";
		public static var RESUME:String = "resume";
		
		public var pause_btn:SimpleButton;
		public var resume_btn:SimpleButton;
		
		public function PauseButton()
		{
			pause_btn.addEventListener( MouseEvent.CLICK, pauseClick, false, 0, true );
			resume_btn.addEventListener( MouseEvent.CLICK, resumeClick, false, 0, true );
			showPause( true );
		}
		
		public function showPause( state:Boolean ):void
		{
			pause_btn.visible = state;
			resume_btn.visible = !state;
		}
		
		public function pauseClick( ev:MouseEvent ):void
		{
			dispatchEvent( new Event( PAUSE ) );
			showPause( false );
		}
		
		public function resumeClick( ev:MouseEvent ):void
		{
			dispatchEvent( new Event( RESUME ) );
			showPause( true );
		}
	}
}
