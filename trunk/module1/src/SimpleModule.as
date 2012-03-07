package  
{
	import flash.system.ApplicationDomain;
	import mx.modules.IModule;
	import mx.modules.ModuleBase;
	
	/**
	 * ...
	 * @author huanglong
	 */
	import mx.modules.ModuleBase;

    public class SimpleModule extends ModuleBase {
        public function SimpleModule() {
            trace("SimpleModule created");
        }
		
		public function getClass(className:String):Object
		{
			return ApplicationDomain.currentDomain.getDefinition(className);
		}
		
        public function computeAnswer(a:Number, b:Number):Number {
            return a + b;
        }
    }

}