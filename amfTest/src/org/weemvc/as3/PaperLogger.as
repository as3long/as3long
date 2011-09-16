/**
 * WeeMVC - Copyright(c) 2008
 * 输出日志
 * @author	weemve.org
 * 2009-9-12 15:01
 */
package org.weemvc.as3 {
	import org.weemvc.as3.WeemvcError;
	
	/**
	 * 输出日志相关信息。
	 * 
	 * <p>
	 * 目前此类主要输出 WeeMVC 相关的异常警告。例如：
	 * </p>
	 * <ul>
	 * <li>重复添加已添加过的命令类、视图类、模型类</li>
	 * <li>重复删除已删除过的命令类、视图类、模型类</li>
	 * <li>使用未添加的命令类、视图类、模型类</li>
	 * </ul>
	 * <p>
	 * 默认的是将这些警告 trace 出来，另外您还可以自行添加日志类，将其输出到其他任何地方。
	 * </p>
	 * 
	 * @see org.weemvc.as3.model.ModelLocator	Controller
	 * @see org.weemvc.as3.view.ViewLocator		ViewLocator
	 * @see org.weemvc.as3.control.Controller	Controller
	 * @see org.weemvc.as3.core.Notifier		Notifier
	 */
	public class PaperLogger {
		/** @private **/
		static private var m_instance:PaperLogger = null;
		/** @private **/
		//这里 logger 是静态类
		protected var m_traceLogger:Object;
		
		/**
		 * 日志输出类构造函数。
		 * 
		 * @internal	注意：throws 标签 tab 不友好，所以不能用 tab 来做分隔
		 * @throws org.weemvc.as3.WeemvcError 单件的<code>PaperLogger</code>被实例化多次
		 */
		public function PaperLogger() {
			if (m_instance) {
				throw new WeemvcError(WeemvcError.SINGLETON_PAPERLOGGER_MSG, PaperLogger);
			}else {
				m_instance = this;
				addLogger(Log);
			}
		}
		
		/**
		 * 返回日志输出类的实例，若没有创建则创建，若已创建，则返回该实例。
		 * 
		 * @return	当前的日志输出类实例。
		 */
		static public function getInstance():PaperLogger {
			if (!m_instance) {
				m_instance = new PaperLogger();
			}
			return m_instance;
		}
		
		/**
		 * 添加其他日志类。
		 * 
		 * <p><b>注意：因为其他日志类设计为静态类和静态方法，所以这里没有使用接口来规范。</b></p>
		 * @example 下面例子说明怎样添加其他信息类，来将该信息输出到其他地方。
		 * <listing version="3.0">
		 * package {
		 * 	public class UnitDebug {
		 *		public static function record(msg:String):void {
		 *			trace(msg);
		 *		}
		 *	}
		 * }
		 * //设置 WeeMVC 的日志输出类
		 * PaperLogger.getInstance().addLogger(UnitDebug);
		 * </listing>
		 * 
		 * @param	logger	包含静态方法record的其他日志类
		 */
		public function addLogger(logger:Class):void {
			//因为 record 是函数类型，所以只能判断是否为 null
			if (logger && (logger.record != null)) {
				m_traceLogger = logger;
			}
		}
		
		/**
		 * 移除当前的日志类。
		 */
		public function removeLogger():void {
			if (m_traceLogger) {
				m_traceLogger = null;
			}
		}
		
		/**
		 * 输出信息。
		 * 
		 * @param	info			当前要输出的信息
		 * @param	currentClass	当前输出内容的类
		 * @param	... rest		其他要输出的任何信息
		 */
		public function log(info:String, currentClass:Class = null, ... rest):void {
			m_traceLogger.record(WeemvcError.formatMessage("WeeMVC Warning# ", info, currentClass, rest));
		}
	}
}

internal class Log {
	
	public static function record(msg:String):void {
		trace(msg);
	}
}