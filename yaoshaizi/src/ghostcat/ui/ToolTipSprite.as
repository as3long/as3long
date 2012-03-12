package ghostcat.ui
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import ghostcat.display.GBase;
	import ghostcat.display.IToolTipManagerClient;
	import ghostcat.events.TickEvent;
	import ghostcat.ui.tooltip.IToolTipSkin;
	import ghostcat.ui.tooltip.ToolTipSkin;
	import ghostcat.util.Util;
	import ghostcat.util.core.ClassFactory;

	/**
	 * 提示类，需要手动加载到某个容器内，将一直处于最高层。
	 * 此类会一直检测鼠标下的物体，实现IToolTipManagerClient就会根据其toolTipObj自动弹出。
	 * 
	 * 皮肤用ToolTipSprite.defaultSkin来设置
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ToolTipSprite extends GBase
	{
		/**
		 * 默认光标皮肤 
		 */
		public static var defaultSkin:* = ToolTipSkin;
		/**
		 * 延迟显示的毫秒数 
		 */		
		public var delay:int = 250;
		
		/**
		 * 连续显示间隔的毫秒数 
		 */		
		public var cooldown:int = 250;
		
		/**
		 * 限定触发提示的类型
		 */
		public var onlyWithClasses:Array;
		
		/**
		 * ToolTip目标
		 */		
		public var target:DisplayObject;
		
		private var toolTipObjs:Object;//已注册的ToolTipObj集合
		
		private var delayTimer:Timer;//延迟显示计时器
		
		private var delayCooldown:Timer;//连续显示计时器
		
		private static var _instance:ToolTipSprite;
		
		/**
		 * 皮肤必须为IToolTipSkin
		 * 
		 * @param obj
		 * 
		 */
		public function ToolTipSprite()
		{
			super();
			
			this.acceptContentPosition = false;
			this.mouseEnabled = this.mouseChildren = false;
			this.enabledTick = true;
			
			if (!_instance)
				_instance = this;
		}
		
		public static function get instance():ToolTipSprite
		{
			return _instance;
		}
		
		public function get obj():GBase
		{
			return content as GBase;
		}
		
		/**
		 * 注册一个ToolTipObj
		 * 
		 * @param name	名称
		 * @param v	对象
		 * 
		 */		
		public function registerToolTipObj(name:String,v:*):void
		{
			toolTipObjs[name] = v;
		}
		
		/**
		 * 设置内容
		 * @return 
		 * 
		 */		
		public override function get data():*
		{
			return obj.data;
		}

		public override function set data(v:*):void
		{
			obj.data = v;
		}

		protected override function init() : void
		{
			super.init();
			
			stage.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			stage.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
		}
		
		protected override function tickHandler(event:TickEvent) : void
		{
			if (content && target)
				(content as IToolTipSkin).positionTo(target);
		}
		
		private function mouseOutHandler(event:MouseEvent):void
		{
//			hide();
		}
		
		private function mouseOverHandler(event:MouseEvent):void
		{
			var newTarget:DisplayObject = findToolTipTarget(event.target as DisplayObject);
			if (newTarget != target)
			{
				target = newTarget;
				
				if (target)
					delayShow(delay);
				else if (this.content)
					hide();
			}
		}
		
		private function findToolTipTarget(displayObj : DisplayObject) : DisplayObject
		{
			var currentTarget:DisplayObject = displayObj;
			
			while (currentTarget && currentTarget.parent != currentTarget)
			{
				if (currentTarget is IToolTipManagerClient
					&& (currentTarget as IToolTipManagerClient).toolTip 
					&& (onlyWithClasses == null || Util.isIn(cursor,onlyWithClasses)))
					return currentTarget;
				
				currentTarget = currentTarget.parent;
			}
			return null;
		}
		
		/**
		 * 延迟显示
		 * @param t	时间
		 * 
		 */		
		public function delayShow(t:int):void
		{
			if (delayCooldown)//还在连续显示状态
			{
				delayCooldown.delay = 1;
				t = 1;
			}
			
			if (delayTimer)
			{
				delayTimer.delay = t;
			}
			else
			{
				delayTimer = new Timer(t,1);
				delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,show);
				delayTimer.start();
			}
		}
		
		private function show(event:TimerEvent):void
		{
			delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,show);
			delayTimer = null;
			
			if (target is IToolTipManagerClient)
			{
				var client:IToolTipManagerClient = target as IToolTipManagerClient;
				showToolTip(target,client.toolTip,client.toolTipObj);
			}
		}
		
		/**
		 * 显示出ToolTip
		 * 
		 * @param target	目标
		 * @param toolTip
		 * @param toolTipObj	
		 * 
		 */
		public function showToolTip(target:DisplayObject,toolTip:*,toolTipObj:*=null):void
		{
			this.target = target;
			
			var obj:* = toolTipObj;
			if (obj is String)
				obj = toolTipObjs[obj];
			
			if (obj is Class)
				obj = new obj();
			
			if (!obj)
				obj = defaultSkin;
			
			setContent(obj);
			(content as IToolTipSkin).data = toolTip;
			(content as IToolTipSkin).show(target);
		}
		
		/**
		 * 更新内容 
		 * 
		 */
		public function refresh():void
		{
			if (target is IToolTipManagerClient)
			{
				var client:IToolTipManagerClient = target as IToolTipManagerClient;
				(content as IToolTipSkin).data = client.toolTip;
			}
		}
		
		/**
		 * 隐藏提示 
		 * 
		 */		
		public function hide():void
		{
			setContent(null);
			
			if (delayCooldown)
			{
				delayCooldown.delay = cooldown;
			}
			else
			{
				delayCooldown = new Timer(cooldown,1);
				delayCooldown.addEventListener(TimerEvent.TIMER_COMPLETE,removeCooldown);
				delayCooldown.start();
			}
		}
		
		private function removeCooldown(event:TimerEvent):void
		{
			delayCooldown.removeEventListener(TimerEvent.TIMER_COMPLETE,removeCooldown);
			delayCooldown = null;
		}
		
		
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			stage.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			stage.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
		
			super.destory();
		}
	}
}
