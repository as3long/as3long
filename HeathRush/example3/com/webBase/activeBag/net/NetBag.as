package com.webBase.activeBag.net 
{
	import com.webBase.activeBag.net.pack.BgSound;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLLoader;
	
	/**
	 * ...
	 * @author WZH(shch8.com)
	 */
	public class NetBag 
	{
		private var _bgSound:BgSound;
		/**
		 * XML或者txt文件加载
		 * @param	filePath	文件路径
		 * @param	callback	回调函数,如果加载XML,函数参数为XML,如function getXML(xml:XML)
		 * @param	gbCode		是否使用中文编码,默认是
		 * @param	useXML		是否返回XML格式,默认是
		 * @return  URLLoader
		 */
		public final function loadXML(filePath:String, callback:Function = null,gbCode:Boolean=true,useXML:Boolean=true):URLLoader
		{
			return NetLoad.getInstance().loadXML(filePath, callback, gbCode, useXML);
		}
		/**
		 * 加载外部文件，jpg,png,gif图片及SWF文件
		 * @param	filePath	文件路径
		 * @param	callback	回调函数,参数为Loader对象,如:function getLoader(value:Loader):void{}
		 * @return	Loader
		 */
		public final function loadFile(filePath:String, callback:Function = null):Loader
		{
			return NetLoad.getInstance().loadFile(filePath, callback);
		}
		/**
		 * 声音加载,返回LoadSound对象,可以控制播放停止暂停和音量
		 * volume(Num:Number)音量设置,值为0-100
		 * @param	filePath	音乐路径,播放次数-1为循环播放,使用渐渐效果)
		 * @param	cycle		播放次数-1为循环播放
		 * @param	soundEffect	是否使用渐渐效果,如果使用,开始和结束播放时声音会渐渐消失或渐渐打开
		 * @param	context		缓冲秒数默认1秒-单位“秒”
		 * @return  LoadSound	返回LoadSound对象
								LoadSound导入路径:import com.webBase.activeBag.Method.LoadSound;
		 						LoadSound的方法:
									play() 播放声音
									pause()声音暂停
									stop()声音停止
		 */
		public final function get bgSound():BgSound
		{
			if (_bgSound == null)_bgSound = new BgSound;
			return _bgSound;
		}
		/**
		 * 加载背景图片,格式为jpg,png或gif图片
		 * @param	filePath	图片路径
		 * @param	width		背景宽
		 * @param	height		背景高
		 * @param	mode		显示模式：matrix:矩阵平埔(默认)，stretch:拉伸,center:居中
		 * @return
		 */
		public final function loadBg(filePath:String,width:uint=300,height:uint=200,mode:String="matrix"):Sprite 
		{
			return LoadBg.getInstance().load(filePath, width, height, mode);
		}
	}
	
}