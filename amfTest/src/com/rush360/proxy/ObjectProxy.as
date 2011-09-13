package com.rush360.proxy
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	/**
	 * ObjectProxy:实现object和任何对象的绑定,通过代理之后的对象可以和任何对象绑定
	 */
	public dynamic class ObjectProxy extends Proxy
	{
		/**
		 * 需要绑定的实例
		 */
		private var _item:*;
		/**
		 * 绑定的属性集合
		 */
		protected var _bindings:Array = [];
		/**
		 * 绑定的方法集合
		 */
		protected var _bindingFuns:Array = [];
		
		/**
		 *...
		 * @param	com 要实现的对象
		 */
		public function ObjectProxy(com:*)
		{
			_item = com;
		}
		
		/**
		 * 绑定一个对象,注意:要绑定的对象的属性或者方法应该一致,由于参数无法获取动态长度
		 * @param	o 要绑定的对象
		 * @param	pro 要绑定对象的属性(方法)
		 * @param	t 当前对象的属性(方法)
		 */
		public function bind(o:Object, pro:String, t:String = null):void
		{
			if (t == null)
				t = pro;
			_bindings.push({o: o, pro: pro, t: t});
		}
		
		public function bindFun(fun:Function, t:String):void
		{
			//if(t==null)t=pro;
			_bindingFuns.push({fun: fun, t: t});
		}
		
		/**
		 * 解除绑定 , 必须三个条件都符合
		 * @param	o 要绑定的对象
		 * @param	pro 要绑定对象的属性(方法)
		 * @param	t 当前对象的属性(方法)
		 */
		public function unBind(o:Object, pro:String, t:String = null):*
		{
			if (t == null)
				t = pro;
			for (var i:int = 0; i < _bindings.length; i++)
			{
				if (_bindings[o] == o && _bindings[pro] == pro && _bindings[t] == t)
				{
					return _bindings.splice(i, 1);
				}
			}
			return null;
		}
		
		/**
		 * 执行方法 ,同时执行绑定的方法
		 * @param	methodName 执行的函数名字
		 * @param	... args 参数
		 * @return	执行函数的返回值
		 */
		override flash_proxy function callProperty(methodName:*, ... args):*
		{
			var res:* = _item[methodName].apply(_item, args);
			//
			for (var i:*in _bindings)
			{
				if (_bindings[i].t == methodName)
				{
					_bindings[i].o[_bindings[i].pro].apply(_bindings[i].o, args);
				}
			}
			for (var j:*in _bindingFuns)
			{
				if (_bindingFuns[j].t == methodName)
				{
					_bindingFuns[j].fun.apply(_item, args);
				}
			} //
			return res;
		}
		
		/**
		 * 获取属性
		 * @param	name 属性名字
		 * @return	属性值
		 */
		override flash_proxy function getProperty(name:*):*
		{
			return _item[name];
		}
		
		/**
		 * 设置属性 同时执行绑定的属性设置
		 * @param	name 属性的名字
		 * @param	value 属性值
		 */
		override flash_proxy function setProperty(name:*, value:*):void
		{
			_item[name] = value;
			for (var i:*in _bindings)
			{
				if (_bindings[i].t == name)
				{
					_bindings[i].o[_bindings[i].pro] = value;
				}
			}
			for (var j:*in _bindingFuns)
			{
				if (_bindingFuns[j].t == name)
				{
					_bindingFuns[j].fun(value);
				}
			}
		}
	}
}