package ghostcat.ui.containers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import ghostcat.events.ItemClickEvent;
	import ghostcat.ui.UIConst;
	import ghostcat.ui.scroll.GScrollPanel;
	import ghostcat.util.core.ClassFactory;
	
	[Event(name="change",type="flash.events.Event")]
	[Event(name="item_click",type="ghostcat.events.ItemClickEvent")]
	
	/**
	 * 通过包装GScrollPanel，提供了滚动条的List。不支持背景。
	 * 
	 * 标签规则：滚动条规则和ScrollPanel相同，其中的render对象会被当作ItemRender的skin来处理（它必须有链接名），其余的部分则是自己的skin，决定自身初始大小，并不会被滚动
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GList extends GScrollPanel
	{
//		public static var defaultItemRender:ClassFactory = new ClassFactory(GButton);
		/**
		 * 列表容器 
		 */
		public var listContent:GListBase;
		private var listFields:Object = {renderField:"render",vScrollBarField:"vScrollBar",hScrollBarField:"hScrollBar"};
		
		private var _itemRender:*;
		private var _type:String;
		
		public function GList(skin:*=null,replace:Boolean = true, type:String = UIConst.VERTICAL,itemRender:* = null,fields:Object = null)
		{
			if (!fields)
				fields = listFields;
			
			this.type = type;
			
//			if (!itemRender)
//				itemRender = defaultItemRender;

			if (itemRender is Class)
				itemRender = new ClassFactory(itemRender);
			
			_itemRender = itemRender;
			
			super(skin,replace,NaN,NaN,fields);
		}
		/** @inheritDoc*/
		public override function setContent(skin:*, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
			
			var renderSkin:DisplayObject;
			var renderField:String = fields[renderField];
			
			if (renderField)
				renderSkin = content[renderField] as DisplayObject;
			
			if (renderSkin && renderSkin.parent)
				renderSkin.parent.removeChild(renderSkin);
			
			if (renderSkin is DisplayObject)
				renderSkin = renderSkin["constructor"];
			
			listContent = new GListBase(renderSkin,replace,_type,_itemRender);
			listContent.self = this;
			addChild(listContent);
			
			content = listContent;//用listContent取代原来的content
			
			listContent.addEventListener(Event.CHANGE,eventpaseHandler);
			listContent.addEventListener(ItemClickEvent.ITEM_CLICK,eventpaseHandler);
			
		}
		/** @inheritDoc*/
		protected override function updateSize() : void
		{
			super.updateSize();
			
			listContent.width = this.width;
			listContent.height = this.height;
			this.scrollRect = new Rectangle(0,0,width,height);
		}
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			listContent.removeEventListener(Event.CHANGE,eventpaseHandler);
			listContent.removeEventListener(ItemClickEvent.ITEM_CLICK,eventpaseHandler);
		
			super.destory();
		}
		
		private function eventpaseHandler(event:Event):void
		{
			dispatchEvent(event);//转移事件
		}
		
		/**
		 * 设置ItemRender
		 * @param v
		 * 
		 */
		public function set itemRender(v:*):void
		{
			_itemRender = v;
			if (listContent)
				listContent.itemRender = v;
		}
		
		public function get itemRender():*
		{
			return listContent ? listContent.itemRender : _itemRender;
		}
		
		
		
		/**
		 * 类型 
		 * @param v
		 * 
		 */
		public function set type(v:String) : void
		{
			_type = v;
			
			if (listContent) 
				listContent.type = v;
		}
		
		public function get type():String
		{
			return listContent ? listContent.type : _type;
		}
		
		/**
		 * 是否自动更新Item的大小 
		 */
		public function get autoReszieItemContent():Boolean
		{
			return listContent.autoReszieItemContent;
		}

		public function set autoReszieItemContent(v:Boolean):void
		{
			listContent.autoReszieItemContent = v;
		}
		
		/**
		 * 是否点击选中 
		 */
		public function get toggleOnClick():Boolean
		{
			return listContent.toggleOnClick;
		}
		
		public function set toggleOnClick(v:Boolean):void
		{
			listContent.toggleOnClick = v;
		}
		
		/**
		 * 是否隐藏空对象
		 */
		public function get hideNullItem():Boolean
		{
			return listContent.hideNullItem;
		}
		
		public function set hideNullItem(v:Boolean):void
		{
			listContent.hideNullItem = v;
		}
		
		/** @inheritDoc*/
		public override function set data(v:*) : void
		{
			listContent.data = v;
		}
		
		public override function get data() : *
		{
			return listContent.data;
		}
		
		/**
		 * 选择的数据 
		 * @return 
		 * 
		 */
		public function get selectedData():*
		{
			return listContent.selectedData;
		}

		public function set selectedData(v:*):void
		{
			listContent.selectedData = v;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * 选择的行 
		 * @return 
		 * 
		 */
		public function get selectedRow():int
		{
			return listContent.selectedRow;
		}

		public function set selectedRow(v:int):void
		{
			listContent.selectedData = v;
		}
		
		/**
		 * 选择的列 
		 * @return 
		 * 
		 */
		public function get selectedColumn():int
		{
			return listContent.selectedColumn;
		}

		public function set selectedColumn(v:int):void
		{
			listContent.selectedColumn = v;
		}
		
		/**
		 * 选择的元素 
		 * @return 
		 * 
		 */
		public function get selectedItem():DisplayObject
		{
			return listContent.selectedItem;
		}
		
		/**
		 * 总列数 
		 * @return 
		 * 
		 */
		public function get columnCount():int
		{
			return listContent.columnCount;
		}
		
		public function set columnCount(v:int):void
		{
			listContent.columnCount = v;
		}
		
		/**
		 * 总行数 
		 * @return 
		 * 
		 */
		public function get rowCount():int
		{
			return listContent.rowCount;
		}

		/**
		 * 列表实际宽度 
		 * @return 
		 * 
		 */
		public function get listWidth() : Number
		{
			return listContent.width;
		}
		
		/**
		 * 列表实际高度
		 * @return 
		 * 
		 */
		public function get listHeight() : Number
		{
			return listContent.height;
		}
		
		/**
		 * 列宽
		 * @return 
		 * 
		 */
		public function get columnWidth():Number
		{
			return listContent.columnWidth;
		}
		
		public function set columnWidth(v:Number):void
		{
			listContent.columnWidth = v;
		}
		
		/**
		 * 行高 
		 * @return 
		 * 
		 */
		public function get rowHeight():Number
		{
			return listContent.rowHeight;
		}
		
		public function set rowHeight(v:Number):void
		{
			listContent.rowHeight = v;
		}
	}
}