/**
 * WeeMVC - Copyright(c) 2008
 * 单例模式的数据集合
 * @author	weemve.org
 * 2009-1-11 21:40
 */
import org.weemvc.as2.Util;
import org.weemvc.as2.core.WeemvcLocator;
import org.weemvc.as2.model.IModelLocator;
import org.weemvc.as2.WeemvcError;
import org.weemvc.as2.PaperLogger;

/**
 * 模型集合类。
 * 
 * <p>
 * WeeMVC 的所有模型的集合类。
 * </p>
 * 
 * @see org.weemvc.as2.model.IModelLocator	IModelLocator
 * @see org.weemvc.as2.model.IModel			IModel
 */
class org.weemvc.as2.model.ModelLocator extends WeemvcLocator implements IModelLocator {
	/** @private **/
	static private var m_instance:IModelLocator = null;
	
	/**
	 * 模型集合类构造函数。
	 * 
	 * @throws org.weemvc.as2.WeemvcError 单件的<code>ModelLocator</code>被实例化多次
	 */
	public function ModelLocator() {
		if (m_instance) {
			throw new WeemvcError(WeemvcError.SINGLETON_MODEL_MSG, "ModelLocator");
		}else {
			m_instance = this;
			m_weeMap = {};
		}
	}
	
	/**
	 * 返回模型集合类的实例，若没有创建则创建，若已创建，则返回该实例。
	 * 
	 * @return	当前的模型集合类实例。
	 */
	static public function getInstance():IModelLocator {
		if (!m_instance) {
			m_instance = new ModelLocator();
		}
		return m_instance;
	}
	
	/**
	 * <p><b>注意：如果此模型类不存在，WeeMVC 会发出<code>WeemvcError.MODEL_NOT_FOUND</code>警告。</b></p>
	 * @copy	org.weemvc.as2.model.IModelLocator#getModel()
	 */
	public function getModel(modelClass:Object) {
		var modelName:Object = Util.getProto(modelClass);
		if (!hasExists(modelName)) {
			PaperLogger.getInstance().log(WeemvcError.MODEL_NOT_FOUND, "ModelLocator", [modelName]);
		}
		return retrieve(modelName);
	}
	
	/**
	 * <p><b>注意：如果要添加模型类已经添加，WeeMVC 会发出<code>WeemvcError.ADD_MODEL_MSG</code>警告。</b></p>
	 * @copy	org.weemvc.as2.model.IModelLocator#addModel()
	 */
	public function addModel(modelClass:Object, data):Void {
		var modelName:Object = Util.getProto(modelClass);
		if (!hasExists(modelName)) {
			if (data) {
				add(modelName, new modelClass(data));
			}else {
				add(modelName, new modelClass());
			}
		}else {
			PaperLogger.getInstance().log(WeemvcError.ADD_MODEL_MSG, "ModelLocator", [modelName]);
		}
	}
	
	public function hasModel(modelClass:Object):Boolean {
		var modelName:Object = Util.getProto(modelClass);
		return hasExists(modelName);
	}
	
	/**
	 * <p><b>注意：如果此模型类不存在，WeeMVC 会发出<code>WeemvcError.MODEL_NOT_FOUND</code>警告。</b></p>
	 * @copy	org.weemvc.as2.model.IModelLocator#removeModel()
	 */
	public function removeModel(modelClass:Object):Void {
		var modelName:Object = Util.getProto(modelClass);
		if (hasExists(modelName)) {
			remove(modelName);
		}else {
			PaperLogger.getInstance().log(WeemvcError.MODEL_NOT_FOUND, "ModelLocator", [modelName]);
		}
	}
}