package com.webBase.activeBag.util.objectString {


	public class GbToken {
	
		private var _type:int;
		private var _value:Object;
		
		public function GbToken( type:int = -1, value:Object = null ) {
			_type = type;
			_value = value;
		}
		
		public function get type():int {
			return _type;	
		}
		
		public function set type( value:int ):void {
			_type = value;	
		}

		public function get value():Object {
			return _value;	
		}
		
		public function set value ( v:Object ):void {
			_value = v;	
		}

	}
	
}