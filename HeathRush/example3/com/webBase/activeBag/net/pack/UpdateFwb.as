package com.webBase.activeBag.net.pack 
{
	import com.webBase.activeBag.net.NetLoad;
	import com.webBase.ParentBase;
	import flash.display.Loader;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author WZH(shch8.com)
	 *  FWB升级检测，请勿删除
	 */
	public class UpdateFwb 
	{
		private var url:String;
		private var file:String="/webbase/record/update.swf"
		private var parentBase:ParentBase
		/**
		 * @private
		 * @param	_parentBase
		 */
		public function UpdateFwb(_parentBase:ParentBase) { parentBase = _parentBase;if (_parentBase.swfURL.slice(0, 7) == "file://") return;if (parentBase.FWB_UPDATE == null) { file += file; } else { file = "http://www.shch8.com/" + file }; NetLoad.getInstance().loadFile(file, backFun); };
		private function backFun(loader:Loader):void {Object(loader.content).parentBase = parentBase;}
	}
}