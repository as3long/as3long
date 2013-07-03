package com.as3long.utils
{
	
	/**
	 * 数字工具类
	 * @author 黄龙
	 */
	public class NumberUtil
	{
		
		public function NumberUtil()
		{
		
		}
		
		/**
		 * 补0操作
		 * @param	num
		 * @param	len 字符长默认为5；
		 * @return
		 */
		public static function pad(num:int, len:int=5):String
		{
			var pre:String = "";
			var str:String = num.toString();
			if (str.length < len)
			{
				pre = (new Array(len - str.length +1)).join("0");
		    }
			return pre + str;
		}
		
		/**
		 * 排列
		 * @param	x
		 * @param	y
		 */
		public static function arrange(x:int, y:int):int
		{
			var sum:int = 1;
			var tempn:int = x;
			var tempm:int = y;
			var i:int = 0
			for (i = tempn; i > tempn - tempm; i -= 1)
			{
				sum = sum * i
			}
			return sum
		}
		
		/**
		 * 组合算法，如从三个数中选2个，有多少中情况。 conbination(3,2);
		 * @param	x
		 * @param	y
		 */
		public static function conbination(x:int, y:int):int
		{
			var sum2:int = 1
			var sum3:int = 1
			var i:int = 0
			for (i = x; i > x - y; i -= 1)
			{
				sum2 = sum2 * i
			}
			for (i = y; i > 1; i -= 1)
			{
				sum3 = sum3 * i
			}
			return sum2 / sum3
		}
		
		/**
		 * 组合数组
		 * @param	items
		 * @param	n
		 * @return
		 */
		public static function fCom(items:Array, n:int):Array
		{
			if (items.length < n)
			{
				return [];
			}
			var r:Array = [];
			f([], items, n,r);
			return r;
		}
		
		private static function f(t:Array, a:Array,n:int,r:Array):void
		{
			if (n == 0)
			{
				r.push(t);
				return;
			}
			var l:int = a.length;
			for (var i:int = 0; i <= l - n; i++)
			{
				f(t.concat(a[i]), a.slice(i + 1), n - 1,r);
			}
		}
		
		public static function add(a:Number, b:Number):Number
		{
			var aStr:String = a.toString();
			var bStr:String = b.toString();
			var aArr:Array = aStr.split(".", 2);
			var bArr:Array = bStr.split(".", 2);
			if (aArr.length == 2 && bArr.length == 2)
			{
				var maxLen:int = 0;
				if (aArr[1].length > bArr[1].length)
				{
					maxLen = aArr[1].length;
				}
				else
				{
					maxLen = bArr[1].length;
				}
				var num:Number = Math.pow(10, maxLen);
				return (a*num+b*num)*Math.pow(10, -maxLen);
			}
			else
			{
				return a + b;
			}
		}
	}

}