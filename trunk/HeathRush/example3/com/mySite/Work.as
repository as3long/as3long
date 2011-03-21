package com.mySite 
{
	import com.mySite.imgbrow.ImgBrow;
	import com.mySite.imgbrow.ImgView;
	import com.webBase.event.ChildEvent;
	import com.webBase.ParentBase;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author wzh (shch8.com)
	 */
	public class Work extends ParentBase
	{
		private var itmeLen:uint = 5;
		private var imgView:ImgView;
		private var imgBrow:ImgBrow
		private var _xml:XML
		override protected function init():void 
		{
			this.addEventListener(ChildEvent.END_PLAY, startPlay)//开始播放结束动画
			
			net.loadXML("data/work.xml", getData)
		}
		private function getData(xml:XML):void {
			_xml=xml
			imgBrow = new ImgBrow()
			imgBrow.data = xml;
			imgBrow.y = 100
			imgBrow.addEventListener(Event.SELECT,selImg)
			addChild(imgBrow)
			if (states.length != 0) {//页面刚载入时,如果有状态值则显示所指图片
				showImg(uint(states[0]))
				}
		}
		//选中图片时,显示大图并设置状态值
		private function selImg(e:Event):void {
			showImg(imgBrow.selID)
			clearState()//先清除状态值
			addState(imgBrow.selID)//添加状态值,使用图片系列ID为状态值
		}
		private function showImg(selID:uint):void {
			if (imgView == null) {
				imgView = new ImgView;
				imgView.x = 250;
				imgView.y = 100
				imgView.linkBtn.addEventListener(MouseEvent.CLICK, linkEvent)
				imgView.addEventListener(Event.CLOSE,closeEvent)
				addChild(imgView)
				}
			imgView.source = _xml.child(selID).@pic;
			imgView.title = _xml.child(selID).@title;
		}
		//关闭时，清除状态值
		private function closeEvent(e:Event):void {
			clearState()
			imgBrow.clearSel()
		}
		private function linkEvent(e:MouseEvent):void {
			getURL("http://www.shch8.com/v3/brow/"+_xml.child(imgBrow.selID).@link)
		}
		private function startPlay(value:ChildEvent=null):void {
			effect.tweener(imgBrow, { alpha:0, onComplete:removeMe } )
		}
	}
	
}