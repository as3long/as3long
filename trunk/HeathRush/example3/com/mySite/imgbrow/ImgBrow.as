package com.mySite.imgbrow
{
	import com.webBase.activeBag.MethodBag;
	import fl.transitions.easing.Regular;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout
	/**
	 * ...
	 * @author WZH(shch8.com)
	 */
	public class ImgBrow extends Sprite
	{
		/*列数*/
		public var listNum:uint = 4
		/*行数*/
		public var rowNum:uint = 2;
		/*间距*/
		public var disNum:uint = 10;
		public var _data:XML
		/*项高度*/
		public var itemWid:uint = 170
		/*项高度*/
		public var itemHei:uint = 160
		/*速度*/
		public var speed:Number = 0.3
		/*延迟*/
		public var delay:Number=0.05
		/*选中的ID*/
		public var selID:int = -1;
		
		/*按钮在中间两侧*/
		public static const MIDDLE:String = "middle"
		/*按钮在底部左边*/
		public static const EOF_RIGHT:String = "eofRight"
		/*按钮在底部右边*/
		public static const EOF_LEFT:String = "eofLeft"
		public var btnPlace:String=MIDDLE;
		
		private var content:Sprite
		private var rightBtn:MovieClip
		private	var leftBtn:MovieClip
		
		private var allPage:uint
		private var pageItemNum:uint
		private var showing:Boolean//是否正在显示
		private var toRight:Boolean;//是否向右运动
		private const EFFECT_SPACE:uint = 100
		private var _currentPage:uint
		private var pb:MethodBag=new MethodBag
		public function ImgBrow() 
		{
			
		}
		/*传入数据*/
		public function set data(value:XML):void {
			_data = value
			if (content) {
				removeChild(content)
				content=null
				}
			installEvent()
			pageItemNum=listNum * rowNum
			allPage = Math.ceil(value.child("*").length() / pageItemNum)
			currentPage = 1
			refreshItem()
		}
		public function get data():XML { return _data };
		public function set currentPage(value:uint):void
		{
			_currentPage=value
		}
		public function get currentPage():uint
		{
			return _currentPage
		}
		/*清除选中状态*/
		public function clearSel():void {
			var item:ImgItem = content.getChildByName("item" + selID) as ImgItem
			if (item) {
				item.addEventListener(MouseEvent.CLICK,itemClick)
				item.selected = false
				selID = -1
			}
		}
		private function refreshItem():void {
			showing=true
			hideItem()
			setTimeout(printItem,400)
		}
		public function hideItem():void {
			var imgItem:ImgItem
			var index:uint
			
			for (var j:uint; j < content.numChildren; j++ ) {
				imgItem = content.getChildAt(j) as ImgItem
				if (imgItem) {
					if (imgItem.alpha > 0.1) {
					pb.effect.tweener(imgItem, { x:toRight?(imgItem.x-EFFECT_SPACE):(imgItem.x+EFFECT_SPACE), alpha:0, transition:Regular.easeOut, time:speed, delay:index *delay,onComplete:itemTweenComplete } )
					index++
					}
					}
			}
			function itemTweenComplete():void {
			this.visible = false
			}
		}
		
		private function itemClick(e:MouseEvent):void {
			clearSel()
			var item:ImgItem=e.target.parent
			item.selected = true
			selID = uint(item.name.slice(4))
			item.removeEventListener(MouseEvent.CLICK,itemClick)
			dispatchEvent(new Event(Event.SELECT))
		}
		private function printItem():void {
			var reSetX:uint=btnPlace==MIDDLE?(leftBtnWid + disNum):0
			var setX:uint = reSetX
			var setY:uint
			var imgItem:ImgItem
			var toX:uint
			var index:uint
			for (var i:uint = pageItemNum * (currentPage-1); i < _data.child("*").length() && index < pageItemNum; i++ ) {
				imgItem=content.getChildByName("item" + i) as ImgItem
				if (imgItem == null) {
					imgItem = createImgItem(i)
					imgItem.name = "item" + i
					imgItem.source = _data.child(i).@pic
					imgItem.title = _data.child(i).@title
					imgItem.id=i
					imgItem.addEventListener(MouseEvent.CLICK,itemClick)
				content.addChild(imgItem)
				}
				setImgItem(imgItem,setX,setY)
				imgItem.visible=true
				imgItem.alpha = 0
				toX =imgItem.x
				imgItem.x=toRight?(setX+EFFECT_SPACE):(setX-EFFECT_SPACE)
				pb.effect.tweener(imgItem,{x:toX,alpha:1,y:imgItem.y,transition:Regular.easeOut,time:speed,delay:(pageItemNum-index)*delay})
				
				if ((index + 1) % listNum == 0) {
					setY+=itemHei+disNum
					setX=reSetX
					}else {
						setX+=itemWid+disNum*2
						}
				index++
			}
			setBtn()
			setTimeout(showEnd,300)
			function showEnd():void {
				showing=false
			}
		}
		/*坐标设置*/
		protected function setImgItem(imgItem:ImgItem, setX:Number = 0, setY:Number = 0):void {
			imgItem.width = itemWid
				imgItem.height = itemHei
				imgItem.x = setX
				imgItem.y = setY
		}
		/*创建ITEM*/
		protected function createImgItem(id:uint):ImgItem {
			var imgItem:ImgItem
			imgItem = new ImgItem
			return imgItem
		}
		public function nextPage():void {
			if(showing)return
			if (currentPage < allPage) {
				toRight=true
			currentPage++
			refreshItem()
			}
		}
		public function prevPage():void {
			if(showing)return
			if (currentPage > 1) {
				toRight=false
			currentPage--
			refreshItem()
			}
		}
		private function setBtn():void {
			if (currentPage == allPage) {
				rightBtn.mouseChildren = false
				rightBtn.alpha=0.5
				}else {
					rightBtn.mouseChildren = true
				rightBtn.alpha=1
					}
			if (currentPage == 1) {
				leftBtn.mouseChildren = false
				leftBtn.alpha=0.5
				}else {
					leftBtn.mouseChildren = true
				leftBtn.alpha=1
					}
		}
		private function installEvent():void {
			if (content == null) {
				content = new Sprite
				addChild(content)
				}
			if(rightBtn==null){
			rightBtn = new RightBtn
			leftBtn = new LeftBtn
			addChild(rightBtn)
			addChild(leftBtn)
			if(btnPlace==MIDDLE){
			leftBtn.y=rightBtn.y = (itemsHei - rightBtn.height) / 2
			rightBtn.x =itemsWid + disNum * 6 + leftBtnWid
			}else if (btnPlace == EOF_LEFT) {
				rightBtn.y=leftBtn.y = itemsHei
				rightBtn.x=leftBtnWid
			}else if (btnPlace == EOF_RIGHT) {
				rightBtn.y=leftBtn.y = itemsHei
				rightBtn.x = listNum * (itemWid ) + disNum * 6 
				leftBtn.x=listNum * (itemWid) + disNum * 6 - leftBtnWid
			}
			leftBtn.btn.addEventListener(MouseEvent.MOUSE_OVER, btnEvent)
			leftBtn.btn.addEventListener(MouseEvent.MOUSE_OUT, btnEvent)
			leftBtn.btn.addEventListener(MouseEvent.CLICK, btnEvent)
			rightBtn.btn.addEventListener(MouseEvent.MOUSE_OVER, btnEvent)
			rightBtn.btn.addEventListener(MouseEvent.MOUSE_OUT, btnEvent)
			rightBtn.btn.addEventListener(MouseEvent.CLICK,btnEvent)
			}
		}
		private function get itemsHei():Number { return rowNum * (itemHei + disNum) };
		private function get itemsWid():Number { return listNum * (itemWid + disNum)  };
		private function get leftBtnWid():uint {
			return leftBtn.getChildByName("btn").width
		}
		private function get rightBtnWid():uint {
			return rightBtn.getChildByName("btn").width
		}
		private function btnEvent(e:MouseEvent):void {
			var tar:MovieClip=e.target.parent
			switch(e.type) {
				case MouseEvent.MOUSE_OVER:
				tar.gotoAndPlay("start")
				break
				case MouseEvent.MOUSE_OUT:
				tar.gotoAndPlay("end")
				break
				case MouseEvent.CLICK:
				if (tar is LeftBtn) {
					prevPage()
					}else {
						nextPage()
						}
				break
				}
		}
	}
	
}