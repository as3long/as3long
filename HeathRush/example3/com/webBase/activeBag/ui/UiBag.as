package com.webBase.activeBag.ui 
{
	import com.webBase.activeBag.control.ControlBag;
	import flash.display.Stage;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author WZH(shch8.com)
	 */
	public class UiBag
	{
		public function UiBag() 
		{
			
		}
		/**
		 * 注释工具
		 * @param	area		感应对象
		 * @param	message		提示文字(支持HTML标签)
		 * @param	limitWid	固定宽度
		 */
		public function tip(area:Object, message:String, limitWid:Number = 0):Boolean {  
			if(FreeTip.tip==null){
			if (ControlBag.stage) {
				FreeTip.init(ControlBag.stage);
				FreeTip.delay = 2;
				FreeTip.speed = 2;
				FreeTip.glow = false;
				FreeTip.specular = true;
				FreeTip.setStyle(0x000,0.8,4);//样式设置
				FreeTip.setTextFormat(new TextFormat("宋体",12,0xeeeeee))//文本样式设置
				}else {
					WebTrace.trace("注释工具安装失败，所加注释："+message)
					return false;
					}
			}
			FreeTip.register(area, message, limitWid)
			return true
		}
	}
	
}