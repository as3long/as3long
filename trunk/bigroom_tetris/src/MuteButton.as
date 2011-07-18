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
	 * Custom class for the mute button in Blox
	 */

	public class MuteButton extends Sprite 
	{
		public static var SOUND_OFF:String = "pause";
		public static var SOUND_ON:String = "resume";
		
		public var sound_off_btn:SimpleButton;
		public var sound_on_btn:SimpleButton;
		
		public function MuteButton()
		{
			sound_off_btn.addEventListener( MouseEvent.CLICK, soundOffClick, false, 0, true );
			sound_on_btn.addEventListener( MouseEvent.CLICK, soundOnClick, false, 0, true );
			showMute( true );
		}
		
		public function showMute( state:Boolean ):void
		{
			sound_off_btn.visible = state;
			sound_on_btn.visible = !state;
		}
		
		public function soundOffClick( ev:MouseEvent ):void
		{
			dispatchEvent( new Event( SOUND_OFF ) );
			showMute( false );
		}
		
		public function soundOnClick( ev:MouseEvent ):void
		{
			dispatchEvent( new Event( SOUND_ON ) );
			showMute( true );
		}
	}
}
