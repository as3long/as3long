/**
 * WeeMVC - Copyright(c) 2008
 * 模型集合接口
 * @author	weemve.org
 * 2009-5-11 17:48
 */
package org.weemvc.as3.model {
	
	/**
	 * 模型集合类接口。
	 * 
	 * <p>
	 * WeeMVC 的所有模型的集合类。
	 * </p>
	 * 
	 * @see org.weemvc.as3.model.ModelLocator	ModelLocator
	 */
	public interface IModelLocator {
		
		/**
		 * 获得指定的模型类。
		 * 
		 * @param	modelName	指定要获得的模型类，都要实现<code>IModel</code>接口
		 * @return				当前的模型类实例
		 */
		function getModel(modelName:Class):*;
		
		/**
		 * 添加模型类。
		 * 
		 * @param	modelName	指定要添加的模型类，都要实现<code>IModel</code>接口
		 * @param	data		传递给此模型类构造函数的任何参数
		 */
		function addModel(modelName:Class, data:Object = null):void;
		
		/**
		 * 移除模型类。
		 * 
		 * @param	modelName	指定要移除的模型类，都要实现<code>IModel</code>接口
		 */
		function removeModel(modelName:Class):void;
		
		/**
		 * 判断指定的模型类是否存在。
		 * 
		 * @param	modelName	指定的模型类，都要实现<code>IModel</code>接口
		 * @return	是否存在
		 */
		function hasModel(modelName:Class):Boolean;
	}
}