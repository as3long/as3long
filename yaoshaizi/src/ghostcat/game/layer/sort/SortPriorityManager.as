package ghostcat.game.layer.sort
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import ghostcat.community.sort.DepthSortUtil;
	import ghostcat.game.item.sort.ISortCalculater;
	import ghostcat.game.layer.GameLayer;
	import ghostcat.util.Util;
	import ghostcat.util.display.BitmapUtil;
	
	/**
	 * 根据对象的priority属性排序，priority属性可以通过设置对象的sortCalculater属性自动更新
	 * @author flashyiyi
	 * 
	 */
	public class SortPriorityManager implements ISortManager
	{
		public var layer:GameLayer;
		/**
		 * 排序依据 
		 */
		public var sortFields:*;
		public function SortPriorityManager(layer:GameLayer,sortFields:* = "priority")
		{
			this.layer = layer;
			this.sortFields = sortFields;
		}
		
		public function sort(child:*):void
		{
			var i:int;
			var l:int;
			if (layer.isBitmapEngine)
			{
				var list:Array = layer.childrenInScreen;
				l = list.length;
				var oldIndex:int = list.indexOf(v);
				for (i = 0; i < l; i++)
				{
					if (oldIndex != i)
					{
						if (sortFunction(child,v))
						{
							list.splice(oldIndex,1);
							if (i < oldIndex)
								list.splice(i,0,v);
							else
								list.splice(i + 1,0,v);
							
							break;
						}
					}
				}
			}
			else
			{
				l = layer.numChildren;
				for (i = 0; i < l; i++)
				{
					var v:DisplayObject = layer.getChildAt(0);
					if (v.parent == layer && layer.getChildIndex(v) != i)
					{
						if (sortFunction(child,v))
						{
							layer.setChildIndex(child,i);
							break;
						}
					}
				}
				
				if (layer.getChildIndex(v) != l - 1)
					layer.addChild(child);
			}
		}
		
		protected function sortFunction(child1:DisplayObject, child2:DisplayObject):Boolean
		{
			if (sortFields is String)
			{
				return child1[sortFields] < child2[sortFields];
			}
			else if (sortFields is Function)
			{
				return sortFields(child1,child2) == -1;
			}
			else if (sortFields is Array) 
			{
				for (var j:int = 0;j < sortFields.length;j++)
				{
					var p:String = sortFields[j];
					if (child1[p] != child2[p])
						return child1[p] < child2[p];
				}
				return false;
			}
			return false;
		}
		
		public function sortAll():void
		{
			var data:Array = layer.childrenInScreen;
			if (layer.isBitmapEngine)
			{
				if (sortFields is String)
					data.sortOn([sortFields],Array.NUMERIC);
				else if (sortFields is Array)
					data.sortOn(sortFields,Array.NUMERIC);
				else if (sortFields is Function)
					data.sort(sortFields,Array.NUMERIC);
				else
					data.sort(Array.NUMERIC);
			}
			else
			{
				var result:Array;
				if (sortFields is String)
					result = data.sortOn([sortFields],Array.NUMERIC|Array.RETURNINDEXEDARRAY);
				else if (sortFields is Array)
					result = data.sortOn(sortFields,Array.NUMERIC|Array.RETURNINDEXEDARRAY);
				else if (sortFields is Function)
					result = data.sort(sortFields,Array.NUMERIC|Array.RETURNINDEXEDARRAY);
				else
					result = data.sort(Array.NUMERIC|Array.RETURNINDEXEDARRAY);
				
				for (var i:int = 0; i < result.length; i++)
				{
					var v:DisplayObject = data[result[i]] as DisplayObject;
					if (v.parent == layer && layer.getChildIndex(v) != i)
						layer.setChildIndex(v,i);
				}
			}
		}
	}
}