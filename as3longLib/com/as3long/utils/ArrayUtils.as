package com.as3long.utils
{
	public class ArrayUtils
	{
		/**
		 * 将Array自身的数据扩展N倍
		 * @param source
		 * @param num
		 * @return 
		 * 
		 */		
		public static function extendArrayByClone(source:Array,num:int):Array {
			var extendArray:Array = [];
			for(var i:uint=0;i<num;i++) {
				for(var j:uint=0;j<source.length;j++) {
					extendArray.push(source[j]);
				}
			}
			return extendArray;
		}
		
		public static function clone(arr:Array):Array
		{
			var newArr:Array = [];
			for each(var item:Object in arr)
			{
				newArr.push(item);
			}
			return newArr;
		}
		
		public static function delObj(arr:Array, obj:Object):void
		{
			var index:int = arr.indexOf(obj);
			if (index == -1)
			{
				return;
			}
			arr.splice(index, 1);
		}
	}
}