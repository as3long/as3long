// Copyright @ shch8.com All Rights Reserved At 2008-12-16
//开发：商创技术（www.shch8.com）望月狼
/*
·子对象控制

 例：
 ChildCtrl.getInstance().removeAll(editArea);//清空子对象

 */
package com.webBase.activeBag.control 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.LocalConnection;
	public class ChildCtrl {
		private static var Instance:ChildCtrl = new ChildCtrl;
		private var layerNum:uint;
		private var getObject:Object;
		private var ctrlClip:Object;
		public static function getInstance():ChildCtrl {
			return Instance;
		}
		/*清空子对象*/
		public function removeAll(removeObj:DisplayObjectContainer):void {
			if(removeObj==null)return
			if(removeObj.numChildren==0)return
			layerNum = 0;
			ctrlClip = removeObj
			removeFun();
		}
		/*移到最顶层*/
		public function layerTop(parentObj:DisplayObjectContainer,childName:DisplayObject):void {
			parentObj.setChildIndex(childName, parentObj.numChildren - 1);
		}
		public function runClear():void {
				try {
 				  new LocalConnection().connect('wzh');
  				  new LocalConnection().connect('wzh');
				} catch (e:*) {
					/*trace("clear")*/
				}
			}
		private function removeFun():void {
			getObject = ctrlClip.getChildAt(layerNum);
			if (getObject != null) {
				getObject.addEventListener(Event.REMOVED,removeNext)
				ctrlClip.removeChild(getObject);
			}
		}
		private function removeNext(event:Event=null):void {
			layerNum++;
			getObject.removeEventListener(Event.REMOVED, removeNext);
			if (layerNum < ctrlClip.numChildren) {
				removeFun();
			}
		}
	}
}