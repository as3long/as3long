package com.webBase.swfList 
{
	import com.webBase.activeBag.PageBase;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.system.System;
	import flash.utils.setTimeout;
	import com.webBase.activeBag.baseName;
	/**
	 * ...
	 * @author WZH(shch8.com)
	 */
	public class SwfCollect 
	{
		public static var playerVersion:Number=9.0
		private var _list:Array = new Array;
		/**对象装入
			 * @param path:String 要移除的SWF路径
			 * @param isRemove:Boolean 是否代理移除
			 * */
		public function push(swfFile:SwfFile):void {
			if(!isExist(swfFile.path))
			_list.push(swfFile);
		}
			/**对象获取
			 * @param path:String SWF路径，或者是loader加载对象
			 * @return SwfFile
			 * */
		public function getSwf(path:Object):SwfFile {
			var i:uint
			if(path is String){
			for (i=0; i < _list.length; i++ ) {
				if (_list[i].path == path) {
					return _list[i];
				}
			}}else {
				for (i=0; i < _list.length; i++ ) {
				if (_list[i].file.content == path) {
					return _list[i];
				}
				}
				}
			return null;
			}
			/**单个清除
			 * @param path:String 要移除的SWF路径
			 * @param isRemove:Boolean 是否代理移除
			 * */
		public function remove(path:String,isRemove:Boolean=true):void {
			for (var i:uint; i < _list.length; i++ ) {
				if (_list[i].path == path) {
					removeSwf(_list[i], isRemove);
					_list[i] = null;
					_list.splice(i, 1);
					return;
					}
				}
		}
		/*清空残余项目*/
		public function clearOther():void {
			if (_list == null) return;
			while(length>0){
					removeSwf(_list[0], true);
					_list.shift()
				}
		}
		/*清空*/
		public function clearAll():void {
			if (_list == null)return;
			for (var i:uint; i < _list.length; i++ ) {
					removeSwf(_list[i],true);
				}
			_list = null;
		}
		public function toString():String {
			var str:String = "";
			for (var i:uint; i < _list.length; i++ ) {
					str += i + ":" + _list[i].path;
				}
			return str;
			}
		public function get length():uint {
			return _list.length;
			}
		private function removeSwf(swfFile:SwfFile, isRemove:Boolean = true):void {
			var loadObj:DisplayObject = swfFile.file.content;
			use namespace baseName;
			var iConnect:PageBase = swfFile.file.content as PageBase;
			if (iConnect != null) {
				iConnect.clearRefuse();//通知子级，清除自己的垃圾;
				}
			if (isRemove) unload(swfFile.file);
			swfFile.file = null;
			}
		public function isExist(path:String):Boolean {
			for (var i:uint; i < _list.length; i++ ) {
				if (_list[i].path == path) {
					return true;
					}
				}
				return false;
		}
		public function unload(targetLoader:Loader):void {
			if (playerVersion <= 9) {
					targetLoader["unload"]()
					}else{
					targetLoader["unloadAndStop"]()
					}
		}
	}
	
}