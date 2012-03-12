package ghostcat.operation
{
	import ghostcat.operation.effect.IEffect;
	import ghostcat.util.ReflectUtil;

	/**
	 * 设置属性
	 * @author flashyiyi
	 * 
	 */
	public class SetPropertyOper extends Oper implements IEffect
	{
		private var _target:*;

		public function get target():*
		{
			return _target;
		}

		public function set target(value:*):void
		{
			_target = value;
		}

		/**
		 * 值
		 */
		public var values:*;
		
		public function SetPropertyOper(target:*=null,values:* =null)
		{
			super();
			
			this.target = target;
			this.values = values;
		}
		/** @inheritDoc*/
		public override function execute() : void
		{
			super.execute();
			
			var target:*;
			if (_target is String)
				target = ReflectUtil.eval(_target);
			else
				target = _target;
			
			for (var p:String in values)
				target[p] = values[p];
			
			result();
		}
	}
}