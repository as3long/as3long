/**
 * WeeMVC - Copyright(c) 2008
 * 模型集合接口
 * @author	weemve.org
 * 2009-5-11 17:48
 */

/**
 * 模型集合类接口。
 * 
 * <p>
 * WeeMVC 的所有模型的集合类。
 * </p>
 * 
 * @see org.weemvc.as2.model.ModelLocator	ModelLocator
 */
interface org.weemvc.as2.model.IModelLocator {
	
	/**
	 * 获得指定的模型类。
	 * 
	 * @param	modelClass	指定要获得的模型类名，都要实现<code>IModel</code>接口
	 * @return				当前的模型类实例，这里没有指定类型是为了方便返回的实例直接使用
	 */
	function getModel(modelClass:Object);
	
	/**
	 * 添加模型类。
	 * 
	 * @param	modelClass	指定要添加的模型类名，都要实现<code>IModel</code>接口
	 * @param	data		传递给此模型类构造函数的任何参数
	 */
	public function addModel(modelClass:Object, data):Void;
	
	/**
	 * 移除模型类。
	 * 
	 * @param	modelClass	指定要移除的模型类名，都要实现<code>IModel</code>接口
	 */
	function removeModel(modelClass:Object):Void;
	
	/**
	 * 判断指定的模型类是否存在。
	 * 
	 * @param	modelClass	指定的模型类名，都要实现<code>IModel</code>接口
	 * @return	是否存在
	 */
	function hasModel(modelClass:Object):Boolean;
}