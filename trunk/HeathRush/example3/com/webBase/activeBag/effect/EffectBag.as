package com.webBase.activeBag.effect 
{
	import com.webBase.activeBag.effect.transitions.Tweener;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author WZH(shch8.com)
	 */
	public class EffectBag 
	{
		/**
		 * 影片剪辑按钮
		 * @param	target	添加的影片
		 * @param	hitArea	感应对象，为空表示使用所添加的影片作为感应对象
		 * @param	endTag	结束点的帧标签
		 */
		public final function movieBtn(target:MovieClip,hitArea:InteractiveObject=null,endTag:String="tag"):MovieBtn
		{
			return new MovieBtn(target,hitArea,endTag)
		}
		/**
		 * 使用Tweener缓动类
		 * 具体使用方法与Tweener一样，请查看：http://www.shch8.com/v3/brow/204.html
		 * @param	tweenObj	
		 * @param	setObj
		 */
		public function tweener(tweenObj:Object,setObj:Object):void
		{
			if (setObj.time == null) setObj.time = 0.9;
			Tweener.addTween(tweenObj, setObj);
		}
		/**
		 * 按钮过渡效果，当鼠标滑入滑出某一显示对象时产生过渡变化
		 * @param	target
		 * @param	changeTarget
		 * @param	obj
		 * @example
		 * var changeBg:Object = new Object;
			changeBg.startAlpha = 0;
			changeBg.overAlpha = 1;
			changeBg.clickAlpha = 1;
			changeBg.startColor = 0xC29C6A;
			changeBg.overColor=0xC29C6A
			changeBg.clickColor=0x666666
			changeBg.time=0.3
			changeBg.transition = Regular.easeIn;
			buttonEffect(setObj as DisplayObject, setObj.bg as DisplayObject, changeBg);
			//改变透明度
			var txtObj:Object = new Object;
			txtObj.overColor =0;
			txtObj.startColor =  0x4F3A20;
			txtObj.clickColor=0xffff00
			txtObj.time=0.2
			txtObj.transition = Regular.easeOut;
			buttonEffect(setObj as DisplayObject, setObj.txt as DisplayObject, txtObj);
			//改变颜色
		 */
		public function buttonEffect(target:DisplayObject,changeTarget:DisplayObject,obj:Object):void
		{
			new AddTransition(target,changeTarget,obj)
		}
	}
	
}