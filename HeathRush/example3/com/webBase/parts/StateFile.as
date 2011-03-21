package com.webBase.parts 
{
	
	/**
	 * ...
	 * @author WZH(shch8.com)
	 * 状态文件
	 */
	public class StateFile
	{
		public var array:Array = new Array;
		public function adds(value:Array):void {
			if (value == null) return;
			for (var i:uint; i < value.length; i++ ) {
				add(value[i]);
				}
			}
		public function clear():void {
			array = new Array;
			}
		public  function add(value:String):void {
			if(!isExist(value))array.push(value);
			}
		public function del(value:String):void {
			var getID:int = searchValue(value);
			if (getID ==-1) return;
			array.splice(getID,1)
			}
		public function get stateStr():String {
			
			if (array.length == 0) return "";
			/*var str:String = array.toLocaleString();
			var myPattern:RegExp = /,/g;
			str = str.replace(myPattern, "-")*/
			var str:String="";
			for (var i:uint; i < array.length; i++) {
				str += array[i]
				if (i != array.length-1) {
					str+="-"
					}
				}
			return str;
			}
		public function isExist(value:String):Boolean {
			if(searchValue(value)==-1)return false;
			return true;
			}
		public function isSame(value:Array):Boolean {
			if (value.length != array.length) return false;
			var j:uint;
			var isTrue:Boolean;
			for (var i:uint; i < array.length; i++ ) {
				isTrue = false;
				for (j = 0; j < value.length; j++ ) {
					if (array[i] == value[j]) {
						isTrue = true;
						break;
						}
					}
				if (!isTrue) return false;
				}
			return true;
			}
		private function searchValue(value:String):int {
			for (var i:uint; i < array.length; i++ ) {
				if (array[i] == value) return i;
				}
				return -1;
			}
		
	}
	
}