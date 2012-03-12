package ghostcat.manager
{
	import flash.events.Event;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.core.IPropertyChangeNotifier;
	import mx.events.PropertyChangeEvent;
	import mx.utils.ObjectProxy;
	import mx.binding.BindingManager;

	/**
	 * 引入FLEX的数据绑定，需要给属性标记[Bindable]元标签
	 * @author flashyiyi
	 * 
	 */
	public final class GBindingManager
	{
		mx.binding.BindingManager
		mx.core.IPropertyChangeNotifier
		mx.utils.ObjectProxy
		/**
		 * 绑定一个属性到数据上，数据变化时属性会自动同步 
		 * @param site
		 * @param prop
		 * @param host
		 * @param chain
		 * @param commitOnly
		 * @param twoWay	双向绑定
		 * @return 
		 * 
		 */
		public static function bindProperty(site:Object, prop:String,host:Object, chain:String,commitOnly:Boolean = false,twoWay:Boolean = false):ChangeWatcher
		{
			if (twoWay)
				BindingUtils.bindProperty(host,chain,site, prop,commitOnly);
			
			return BindingUtils.bindProperty(site, prop,host,chain,commitOnly);
		}
		
		/**
		 * 绑定一个函数到数据上，数据变化时会触发 
		 * @param setter
		 * @param host
		 * @param chain
		 * @param commitOnly
		 * @return 
		 * 
		 */
		public static function bindSetter(setter:Function, host:Object,chain:Object,commitOnly:Boolean = false):ChangeWatcher
		{
			return BindingUtils.bindSetter(setter, host,chain,commitOnly);
		}
		
		/**
		 * 手动发布绑定事件 
		 * @param source
		 * @param property
		 * @param oldValue
		 * @param newValue
		 * @return 
		 * 
		 */
		public static function createUpdateEvent(source:Object,property:Object,oldValue:Object,newValue:Object):PropertyChangeEvent
		{
			return PropertyChangeEvent.createUpdateEvent(source,property,oldValue,newValue);
		}
	}
}