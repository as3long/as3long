package ghostcat.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	import ghostcat.FrameworkClasses;
	import ghostcat.events.GEvent;
	import ghostcat.util.core.ClassFactory;

	/**
	 * 基类，用于对图元进行包装。replace参数为false时将不会对源图元产生影响，可作为单独的控制类使用
	 * replace参数为true时，将会将Skin替换成此类。
	 * 
	 * 增加嵌套而不使用逻辑类是考虑到实际应用时更方便，而且可以更容易实现更替内容和旋转等操作。
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class GSprite extends Sprite implements IDisplayObjectContainer
	{
		ghostcat.FrameworkClasses;
		
		private var _content:DisplayObject;
		
		private var _replace:Boolean = true;
		
		/**
		 * 是否在移出显示列表的时候删除自身
		 */		
		public var destoryWhenRemove:Boolean = false;
		
		/**
		 * 是否在更换Content时销毁原有Content
		 */
		public var autoDestoryContent:Boolean = true;
		
		/**
		 * 是否用修改Content的大小来取代修改自身大小（可以保留Content的九宫格）
		 */
		public var resizeContent:Boolean = true;
		
		/**
		 * 是否初始化
		 */
		public var initialized:Boolean;
		
		/**
		 * 是否已经被销毁
		 */
		public var destoryed:Boolean = false;
		
		/**
		 * 是否在第一次设置content时接受content的坐标 
		 */		
		public var acceptContentPosition:Boolean = true;
		
		/**
		 * 内容是否初始化
		 */
		protected var contentInited:Boolean = false;
		
		private var _hideContent:Boolean;
		
		
		/**
		 * 参数与setContent方法相同
		 * 
		 */		
		public function GSprite(skin:*=null,replace:Boolean=true)
		{
			super();
			
			//保存舞台实例
//			if (root && !RootManager.initialized)
//				RootManager.root = root as Sprite;
			
			addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
		
			setContent(skin,replace);
		}
		
		/**
		 * 设置替换方式。此属性务必在设置skin之前设置，否则会导致源图像被破坏，达不到replace为false时的效果。 
		 * @return 
		 * 
		 */		
		public function get replace():Boolean
		{
			return _replace;
		}
		
		public function set replace(v:Boolean):void
		{
			_replace = v;
			setContent(_content,v);
		}
		/**
		 * 设置皮肤 
		 * @return 
		 * 
		 */		
		public function get skin():*
		{
			return _content;
		}
		
		public function set skin(v:*):void
		{
			setContent(v,replace);
		}
		
		/**
		 *
		 * 当前容纳的内容
		 * @return 
		 * 
		 */		
		
		public function get content():DisplayObject
		{
			return _content;
		}
		
		public function set content(v:DisplayObject):void
		{
			_content = v;
		}
		
		/**
		 * 是否暂时移除Content 
		 * @return 
		 * 
		 */
		public function get hideContent():Boolean
		{
			return _hideContent;
		}
		
		public function set hideContent(value:Boolean):void
		{
			if (!content)
				return;
			
			_hideContent = value;
			if (value)
			{
				if (content.parent == this)
					removeChild(content)
			}
			else
			{
				if (content.parent != this)
					addChild(content);
			}
		}
		
		public override function set width(value:Number) : void
		{
			if (content && resizeContent)
				content.width = value;
			else
				super.width = value;
		}
		
		public override function set height(value:Number) : void
		{
			if (content && resizeContent)
				content.height = value;
			else
				super.height = value;
		}
		
//		public override function get scrollRect():Rectangle
//		{
//			if (content && resizeContent)
//				return content.scrollRect;
//			else
//				return super.scrollRect;
//		}
//		
//		public override function set scrollRect(value:Rectangle):void
//		{
//			if (content && resizeContent)
//				content.scrollRect = value;
//			else
//				super.scrollRect = value;
//		}
		
		/**
		 * 设置皮肤。
		 * 
		 * @param skin		皮肤	
		 * @param replace	是否替换原图元
		 * 
		 */		
		public function setContent(skin:*,replace:Boolean=true):void
		{
			if (skin is String)
				skin = getDefinitionByName(skin as String);
			
			if (skin is Class)
				skin = new ClassFactory(skin);
			
			if (skin is ClassFactory)
				skin = (skin as ClassFactory).newInstance();
			
			if (_content == skin)
				return;
			
			if (skin is BitmapData)
				skin = new Bitmap(skin as BitmapData)
			
			if (_content && _content.parent == this)
			{
				if (_content is IGBase && autoDestoryContent)
					(_content as IGBase).destory();
				
				if (_content.parent)
					$removeChild(_content);
			}
			
			var oldIndex:int;
			var oldParent:DisplayObjectContainer;
			
			if (replace && skin)
			{
				//新设置内容的时候，获取内容的坐标
				if (acceptContentPosition && !contentInited)
				{
					this.x = skin.x;
					this.y = skin.y;
					
					skin.x = skin.y = 0;
				}
				
				if (_content == null)
				{
					//在最后才加入舞台
					if (skin.parent)
					{
						oldParent = skin.parent;
						oldIndex = skin.parent.getChildIndex(skin);
					}
				}
				
				$addChild(skin);
				
				if (!contentInited)
				{
					this.visible = skin.visible;
					skin.visible = true;
					this.name = skin.name;
				}
			}
			
			_content = skin;
			
			if (oldParent && !(oldParent is Loader) && oldParent != this)
				oldParent.addChildAt(this,oldIndex);
			
			if (content is InteractiveObject)
				(content as InteractiveObject).mouseEnabled = false;
			
			this.contentInited = true;
		}
		
		/**
		 * 替换一个元件并放置在原来的位置
		 * @param target
		 * 
		 */
		public function replaceTarget(target:DisplayObject):void
		{
			if (target && target.parent)
			{
				this.transform.colorTransform = target.transform.colorTransform;
				this.transform.matrix = target.transform.matrix;
				this.filters = target.filters;
				this.blendMode = target.blendMode;
				this.visible = target.visible;
				this.name = target.name;
				this.scrollRect = target.scrollRect;
				this.scale9Grid = target.scale9Grid;
				
				var oldIndex:int = target.parent.getChildIndex(target);
				var oldParent:DisplayObjectContainer = target.parent;
				
				oldParent.removeChild(target);
				oldParent.addChildAt(this,oldIndex);
				
				this.contentInited = true;
			}
		}
		
		/**
		 * 将皮肤的属性转移到对象本身 
		 * 
		 */
		public function moveContentProperty():void
		{
			if (!content)
				return;
			
			this.transform.matrix = this.content.transform.matrix;
			this.transform.colorTransform = this.content.transform.colorTransform;
			this.scrollRect = this.content.scrollRect;
			this.blendMode = this.content.blendMode;
			this.filters = this.content.filters;
			
			this.content.transform.matrix = new Matrix();
			this.content.transform.colorTransform = new ColorTransform();
			this.content.scrollRect = null;
			this.content.blendMode = BlendMode.NORMAL;
			this.content.filters = null;
		}
		
		private function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,addedToStageHandler)
			init();
			
			this.initialized = true;
			
			dispatchEvent(new GEvent(GEvent.CREATE_COMPLETE));
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			if (destoryWhenRemove)
			{
				this.removeEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
				
				destory();
			}
		}
		
		/**
		 *
		 * 初始化方法，在第一次被加入显示列表时调用 
		 * 
		 */		
		protected function init():void
		{
		}
		
		/**
		 * 销毁方法
		 * 
		 */
		public function destory():void
		{
			if (destoryed)
				return;
			
			removeEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
			
			if (content is IGBase && autoDestoryContent)
				(content as IGBase).destory();
			
			if (parent)
				parent.removeChild(this);
			
			destoryed = true;
		}
		
		public function $addChild(v:DisplayObject):DisplayObject
		{
			return super.addChild(v);
		}
		
		public function $addChildAt(v:DisplayObject,index:int):DisplayObject
		{
			return super.addChildAt(v,index);
		}
		
		public function $removeChild(v:DisplayObject):DisplayObject
		{
			return super.removeChild(v);
		}
		
		public function $removeChildAt(index:int):DisplayObject
		{
			return super.removeChildAt(index);
		}
		
		public function $getChildAt(index:int):DisplayObject
		{
			return super.getChildAt(index);
		}
		
		public function $getChildByName(name:String):DisplayObject
		{
			return super.getChildByName(name);
		}
		
		public function $getChildIndex(child:DisplayObject):int
		{
			return super.getChildIndex(child);
		}
	}
}