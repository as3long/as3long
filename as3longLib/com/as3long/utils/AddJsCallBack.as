package com.as3long.utils 
{
	import flash.external.ExternalInterface;
	import flash.utils.setTimeout;
	/**
	 * 解决addCallBack在TT浏览器及其他国产浏览器中引发的问题
	 * 具体描述为 第二次刷新flash时（在客户端缓存中读取swf时）SecurityError 异常
	 * @author 黄龙
	 */
	public class AddJsCallBack 
	{
		private static var retryNum:Number = 0;
		public function AddJsCallBack() 
		{
			
		}
		
		public static function addCallBack(functionName:String, closure:Function):void
		{
			if (ExternalInterface.available)
			{
				try
				{
					ExternalInterface.addCallback(functionName, closure);
				}
				catch (e:SecurityError)
				{
					retryNum++;
					if (retryNum > 3000)
					{
						return;
					}
					setTimeout(addCallBack, 50, functionName,closure);
				}
			}
		}
	}

}