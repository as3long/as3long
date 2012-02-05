/**
 * WeeMVC - Copyright(c) 2008
 * 工具类
 * @author	weemve.org
 * 2010-9-9 20:24
 */

/**
 * @private
 * AS2 特有的工具类。
 */
class org.weemvc.as2.Util {
	
	/**
	 * @private
	 * 将类名字映射成在 AS2 中可以作为 key 的对象
	 * @param	obj	当前命令类 class 或者直接是名字
	 * @return		当前的类的对象
	 */
	public static function getProto(obj:Object):Object {
		var proto:Object;
		//实际上这里是一个 class
		if (typeof(obj) == "function") {
			if(obj){
				proto = obj.prototype;
			}
		}else {
			proto = obj;
		}
		return proto;
	}
}