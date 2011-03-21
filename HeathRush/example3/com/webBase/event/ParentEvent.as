package com.webBase.event 
{
	import com.webBase.swfList.SwfFile;
	import flash.display.Loader;
	import flash.events.Event;
	
	/**
	 * 父级文件使用的事件
	 * 用于触发是否有子文件需要添加或删除
	 * 比如，可以用在完成SWF后添加到舞台显示列表中
	 * @author WZH(shch8.com)
	 * 
	 */
	public class ParentEvent extends Event 
	{
		/**
		 * 有子文件需要被添加
		 */
		public static var ADD_CHILD:String = "addChild";
		/**
		 * 子文件被移除
		 */
		public static var REMOVE_CHILD:String = "removeChild";
		private var _file:SwfFile;
		/**
		 * 
		 * @param	type	事件类型；该值指示引发事件的动作。
		 * @param	file	文件对象
		 */
		public function ParentEvent(type:String,file:SwfFile) 
		{ 
			_file=file
			super(type);
		} 
		/**
		 * 需要添加的文件对象
		 */
		public function set swfFile(value:SwfFile):void {
			_file=value;
			}
		public function get swfFile():SwfFile {
			return _file;
			}
		/**
		 * 加载SWF的loader对象
		 */
		public function get loader():Loader {
			return _file.file;
			}
		
	}
	
}