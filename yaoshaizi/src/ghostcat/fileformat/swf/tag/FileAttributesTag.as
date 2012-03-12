package ghostcat.fileformat.swf.tag
{
	import ghostcat.util.data.ByteArrayReader;
	import ghostcat.fileformat.swf.tag.Tag;

	/**
	 * SWF文件信息
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class FileAttributesTag extends Tag
	{
		/** @inheritDoc*/
		public override function get type() : int
		{
			return 69;
		}
		
		/**
		 * 是否包含MetaData
		 */
		public var hasMetaData:Boolean;
		/**
		 * 是否使用AS3
		 */
		public var actionScript3:Boolean;
		/**
		 * 是否只允许访问网络
		 */
		public var useNetwork:Boolean;
		
		public override function read() : void
		{
			var byteArrayReader:ByteArrayReader = new ByteArrayReader(bytes);
			byteArrayReader.readBits(3);
			hasMetaData = byteArrayReader.readBits(1) == 1;
			actionScript3 = byteArrayReader.readBits(1) == 1;
			byteArrayReader.readBits(2);
			useNetwork = byteArrayReader.readBits(1) == 1;
		}
	}
}