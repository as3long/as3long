package com.webBase.parts 
{
	
	/**
	 * ...
	 * @author WZH(shch8.com)
	 */
	public class ChildFile 
	{
		private var _childFile:String;		
		private var _fileStrs:String;	
		private var _stateArray:Array;
		private var _menuXml:XML;
		public function set menuXml(value:XML):void { this._menuXml =  value; }
		/*将XML菜单存起来用于子SWF加载子页用*/
		public function get menuXml():XML { return this._menuXml; }
		public function set childFile(childFile:String):void { this._childFile =  childFile; }
		/*要加载的ID*/
		public function get childFile():String { return this._childFile; }
		
		public function set fileStrs(fileStrs:String):void { this._fileStrs =  fileStrs; }
		/*存储子文件的子文件调用址*/
		public function get fileStrs():String { return this._fileStrs; }
		
		public function set stateArray(stateArray:Array):void { this._stateArray =  stateArray; }
		/*存储子文件状态值*/
		public function get stateArray():Array { return this._stateArray; }
		
	}
	
}