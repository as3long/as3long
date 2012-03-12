package ghostcat.gxml.spec
{
	import flash.utils.getQualifiedClassName;
	
	import ghostcat.gxml.spec.ItemSpec;
	import ghostcat.util.ReflectUtil;
	import ghostcat.util.ReflectXMLUtil;

	/**
	 * 解析数据组
	 * 
	 * XML结构为：
	 * <items>
	 * <item id="1" a="属性1" b="属性2"/>
	 * <item id="2" a="属性1" b="属性2"/>
	 * </items>
	 * 
	 * 需要用classNames属性重定义items,item代表的类，其中items应当是ItemGroup或者继承于ItemGroup的对象，而item则对应相应的数据类，应当有一个id属性
	 * 例如：classNames = {items:ItemGroup,item:PropItem};
	 * 
	 * createObject方法将返回一个ItemGroup对象容纳以id为标示的数据组
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ItemGroupSpec extends ItemSpec
	{
		public function ItemGroupSpec()
		{
			super();
		}
		
		/** @inheritDoc */
		public override function addChild(source:*,child:*,xml:XML):void
		{
			if (source is ItemGroup && isClass(xml))
				(source as ItemGroup).add(child);
			else
				super.addChild(source,child,xml);
		}
		
		/**
		 * 创建ItemGroup
		 *  
		 * @param source
		 * @param type
		 * @return 
		 * 
		 */
		public function createItemGroup(source:XMLList,type:Class):*
		{
			var group:ItemGroup = new ItemGroup();
			var typeName:QName = ReflectUtil.getQName(type);
			for each (var v:XML in source)
			{
				v.setName(typeName);
				group.add(createObject(v));
			}
			return group;
		}
	}
}