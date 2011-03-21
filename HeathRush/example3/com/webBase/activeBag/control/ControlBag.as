package com.webBase.activeBag.control 
{
	import com.webBase.activeBag.ui.WebTrace;
	import com.webBase.JSconnect.SWFAddress;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.FrameLabel;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	
	/**
	 * ...
	 * @author WZH(shch8.com)
	 */
	public class ControlBag 
	{
		/**
		 * @private
		 */
		public static var stage:Stage;
		/**
		 * 缓存对象，方法有：
		 * saveData:保存对象
		 * getData:获取对象
		 * clearData:清除所有已存储对象
		 * @return
		 */
		public function get cache():Cache {
			return Cache.getInstance()
		}
		/**
		 * 影片剪辑回播
		 * @param	mc		需要回播的影片
		 * @param	to		播放结束点，可以是帧数或帧标签，为空表示播放到最后一帧
		 * @param	from	播放开始点，可以是帧数或帧标签，为空表示从当前帧开始
		 */
		public final function playBack(mc:MovieClip,to:Object=null, from:Object = null):void
		{
			var back:BackPlay = new BackPlay(mc)
			back.backTo(to,from)
		}
		
		/**
		 * 全屏模式控制
		 * @param	intoCallBack	进入全屏时回调的函数，函数名不加括号，不能有参数的函数
		 * @param	exitCallBack	退出全屏时回调的函数，函数名不加括号，不能有参数的函数
		 * @example 
		 * control.fullScreen(intoFun,exitFun)
		 * function intoFun():void{
		 * traceWin("进入全屏模式")
		 * }
		 * function exitFun():void{
		 * traceWin("退出全屏模式")
		 * }
		 */
		public final function fullScreen(intoCallBack:Function=null,exitCallBack:Function=null):void
		{
			if (stage) {
				FullScreen.getInstance().Instance(stage);
				if (intoCallBack is Function) FullScreen.getInstance().intoFull = intoCallBack;
				if (exitCallBack is Function) FullScreen.getInstance().exitFull = exitCallBack;
				FullScreen.getInstance().displayState();
			}
		}
		
		/**
		 * 清空所有子对象
		 * @param	removeObj	需要清空子对象的容器
		 */
		public final function removeAllClip(removeObj:DisplayObjectContainer):void
		{
			 ChildCtrl.getInstance().removeAll(removeObj);
		}
		/**
		 * 将某一显示对象置顶
		 * @param	parentObj	包含此对象的容器
		 * @param	moveObj		需要置顶的对象名
		 * @example
		 * control.moveTop(this,testChild);//将当前容器中，testChild移到时顶
		 */
		public final function moveTop(parentObj:DisplayObjectContainer,child:Object):void
		{
			var getObj:DisplayObject;
			if (child is DisplayObject) {
				getObj = child as DisplayObject;
			}else if(child is String){
				getObj=parentObj.getChildByName(child as String) as DisplayObject;
			}
			if(getObj) ChildCtrl.getInstance().layerTop(parentObj,getObj);
		}
		/**
		 * 为帧上添加代码
		 * @param	mc			被添加的影片剪辑
		 * @param	frame		帧名或帧标签
		 * @param	callBack	当播放在此帧时回调的方法
		 **/
		public final function frameScript(mc:MovieClip,frame:Object,callBack:Function):void
		{
			var frameID:uint = uint(frame);
			if (frameID == 0) {
				frameID = getFrameID(mc, String(frame))
				}
			if (frameID == 0 || frameID > mc.totalFrames) WebTrace.trace(mc.name + "上未找到" + frame + "帧", false);
			mc.addFrameScript(frameID,callBack);  
		}
		/**       
		* @param    mc          要搜索的影片剪辑       
		* @param    labelName   标签名       
		* @author WZH(shch8.com)     
		* @return   返回uint型帧号，如果没搜索到则返回null       
		*通过帧标签搜索帧号*/         
		private function getFrameID(mc:MovieClip,labelName:String):uint {          
			var labels:Array = mc.currentLabels;          
			for (var i:uint = 0; i < labels.length; i++) {          
				var label:FrameLabel = labels[i];    
				//trace(label.frame)
				if (label.name == labelName) {    
					
					return label.frame;          
				}          
			}          
			return 0;          
		}   
		
		/**
		 * 获取页面标题
		 * @return
		 */
		public final function getTitle():String 
		{
			return SWFAddress.getTitle();
		}
		/**
		 * 设置页面标题
		 * @param	value
		 */
		public final function setTitle(value:String):void
		{
			return SWFAddress.setTitle(value);
		}
		/**
		 * 获取页面地址
		 * @return
		 */
		public final function getPath():String 
		{
			return SWFAddress.getBaseURL() + "/#" + SWFAddress.getPath();
		}
		/**
		 * 设置IE页面的宽度
		 * @param	value
		 */
		public final function setWidth(value:uint):void
		{
			SWFAddress.setWidth(value);
		}
		/**
		 * 设置IE页面的高度
		 * @param	value
		 */
		public final function setHeight(value:uint):void
		{
			SWFAddress.setHeight(value);
		}
		/**
		 * IE向前翻一页
		 */
		public final function back():void 
		{
			SWFAddress.back()
		}
		/**
		 * IE向后翻一页
		 */
		public final function forward():void 
		{
			SWFAddress.forward()
		}
		/**
		 * 关闭窗口
		 */
		public final function closeWin():void 
		{
			SWFAddress.closeWin()
		}
		/**
		 * 加入收藏夹，可兼容不同浏览器
		 * @param	url		收藏的网址，默认为当前地址
		 * @param	title	收藏标题，默认为当前标题
		 */
		public final function addFavorite(url:String="",title:String=""):void 
		{
			if (url == "") url =getPath();
			if (title == "") title = SWFAddress.getTitle();
			SWFAddress.AddFavorite(url, title);
		}
	}
	
}