package ghostcat.gxml.jsonspec
{
	/**
	 * 解析器所使用的接口
	 * @author flashyiyi
	 * 
	 */
	public interface IJSONSpec
	{
		/**
		 * 基础对象，用于反射外部属性
		 * @return 
		 * 
		 */
		function get root():*;
		function set root(v:*):void;
		
		/**
		 * 创建对象
		 * 
		 * @param source	数据源
		 * 
		 */
		function createObject(value:*):*
		
		/**
		 * 附加子对象
		 * 
		 * @param source 父对象
		 * @param child	子对象
		 * @param value	数据源
		 * 
		 */
		function addChild(source:*,child:*,value:*):void
		
		/**
		 * 给子对象赋初值
		 * 
		 * @param source 父对象
		 * @param child	子对象
		 * @param value	数据源
		 * 
		 */
		function applyProperties(source:*,child:*,value:*):void
	}
}