package com.mySite 
{
	import ui.Xingqi;
	import com.webBase.event.ChildEvent;
	import com.webBase.ParentBase;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author wzh (shch8.com)
	 */
	public class MyBlogs extends ParentBase
	{
		private var xingqi:Xingqi;
		private var _xml:XML;
		override protected function init():void 
		{
			this.addEventListener(ChildEvent.END_PLAY, startPlay)//开始播放结束动画
			
			net.loadXML("data/blog.xml", getData)
		}
		
		private function getData(xml:XML):void 
		{
			_xml=xml
			//trace(xml);
			xingqi=new Xingqi();
			xingqi.y=100;
			for(var i:int=0;i<7;i++)
			{
				//trace(i);
				xingqi["_x"+(i+1)]._image.source=_xml.child(i).@pic;
				xingqi["_x"+(i+1)]._title.text=_xml.child(i).@title;
				xingqi["_x"+(i+1)]._xingqi.text=_xml.child(i).@xingqi;
				xingqi["_x"+(i+1)]._info.text=_xml.child(i).@info;
				xingqi["_x"+(i+1)].addEventListener(MouseEvent.MOUSE_OVER, mouse_over);
			}
			this.addChild(xingqi);
		}
		
		private function mouse_over(e:Event):void
		{
			e.currentTarget.addEventListener(MouseEvent.MOUSE_OUT,mouse_out);
			effect.tweener(e.currentTarget, {scaleX:1.2,scaleY:1.2} );
		}
		
		private function mouse_out(e:Event):void
		{
			effect.tweener(e.currentTarget, {scaleX:1,scaleY:1} );
		}
		
		private function startPlay(value:ChildEvent=null):void {
			effect.tweener(xingqi, { alpha:0, onComplete:removeMe } )
		}
	}
}