package com.webBase.swfList 
{
	import com.webBase.parts.ChildFile;
	import flash.display.Loader;
	
	/**
	 * ...
	 * @author WZH(shch8.com)
	 */
	public class SwfFile 
	{
		public static const CLOSE:String = "close";
		public static const LOADING:String = "loading";
		public static const COMPLETE:String = "complete";
		/*SWF路径*/
		public var path:String;
		/*加载SWF的Loader对象*/
		public var file:Loader;
		/*状态*/
		public var runState:String = LOADING;
		/*传值参数*/
		public var param:ChildFile;
		/*状态数组，存放SWF操作状态*/
		public var stateArray:Array;
	}
	
}