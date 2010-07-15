package  
{
	/**
	 * ...
	 * @author huanglong
	 */
	public class loadData
	{
		/**
		 * 接收的值字符串
		 */
		private var dataValue:String;
		/**
		 * 接收的时间字符串
		 */
		private var dataTime:String;
		/**
		 * 用于存放值数组
		 */
		private var dataValueArray:Array;
		/**
		 * 用于存放时间数组
		 */
		private var dataTimeArray:Array;
		/**
		 * 用于存放高度数组
		 */
		private var heightArray:Array;
		/**
		 * 最后得到的存放tbData的数组
		 */
		private var data:Array;
		/**
		 * 接收的第一个数值参数
		 */
		private var max0:Number;
		/**
		 * 接收的第二个数值参数
		 */
		private var max1:Number;
		/**
		 * 接收的第三个数值参数
		 */
		private var max2:Number;
		/**
		 * 接收的第四个数值参数
		 */
		private var max3:Number;
		/**
		 * 接收的第五个参数数组
		 */
		private var max4:Number;
		/**
		 * 是否为向上增长
		 */
		private var add:Boolean;
		public function loadData(_dataValue:String,_dataTime:String,_max0:Number,_max1:Number,_max2:Number,_max3:Number,_max4:Number,_add:Boolean=true)
		{
			dataValue = _dataValue;
			dataTime = _dataTime;
			max0 = _max0;
			max1 = _max1;
			max2 = _max2;
			max3 = _max3;
			max4 = _max4;
			add = _add;
		}
		
		public function load():Array
		{
			dataValueArray = dataValue.split(",");
			dataTimeArray = dataTime.split(",");
			heightArray = valueConvertHeight(dataValueArray, max0, max1, max2, max3, max4);
			data = new Array();
			for (var i:int=0; i <= dataValue.length; i++)
			{
					if (dataTimeArray[i] ==null||dataValueArray[i]==null)
					{
					}
					else
					{
					data[i] = new tbData(dataTimeArray[i], heightArray[i], dataValueArray[i]);
					}
			}
			return data;
		}
			/**
			 * 值到高度的方法
			 * @param	valueArray 值数组
			 * @param	max0 第一区间的最小值
			 * @param	max1 第一区间的最大值
			 * @param	max2 第二区间的最大值
			 * @param	max3 第三区间的最大值
			 * @param	max4 第四区间的最大值
			 * @param	add	是否为向上增长
			 * @return 高度数组
			 */
			public static function  valueConvertHeight(valueArray:Array,max0:Number,max1:Number,max2:Number,max3:Number,max4:Number,add:Boolean=true):Array
			{
				var heightArray:Array = new Array();
				var x:Number = 0;
				if (add == true)
				{
				for (var i:int = 0; i <= valueArray.length; i++)
				{
					x = valueArray[i];
					if (x> max3)
					{
						heightArray[i] = (x - max3) / (max4 - max3) * 25 + 75;
					}
					else if (x > max2)
					{
						heightArray[i] = (x - max2) / (max3 - max2) * 25 + 50;
					}
					else if (x > max1)
					{
						heightArray[i] = (x - max1) / (max2 - max1) * 25 + 25;
					}
					else if(x>max0)
					{
						heightArray[i]=(x-max0)/(max1-max0)*25
					}
					else
					{
						heightArray[i] = x / max0 * 25 - 25;
					}
				}
				}
				else
				{
					for (i = 0; i <= valueArray.length; i++)
					{
						x = valueArray[i];
						if (x< max3)
						{
							heightArray[i] = (max3-x) / (max3 - max4) * 25 + 75;
						}
						else if (x < max2)
						{
							heightArray[i] = (max2-x) / (max2 - max3) * 25 + 50;
						}
						else if (x < max1)
						{
							heightArray[i] = (max1-x) / (max1 - max2) * 25 + 25;
						}
						else if(x<max0)
						{
							heightArray[i]=(x-max0)/(max0-max1)*25
						}
						else
						{
							heightArray[i] = x / max0 * 25 - 25;
						}
					}
				}
				return heightArray;
			}
	}
}