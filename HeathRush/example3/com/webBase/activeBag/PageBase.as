package com.webBase.activeBag
{
	import com.webBase.activeBag.control.ControlBag;
	import com.webBase.event.*;
	import com.webBase.ParentBase;
	import com.webBase.parts.ChildFile;
	import com.webBase.swfList.*;
	import com.webBase.swfList.modules.IloadInfo;
	import com.webBase.swfList.modules.ModuleControl;
	import com.webBase.activeBag.baseName;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	
	/**
	 * 2009-12-1 17:22
	 * @author WZH(shch8.com)
	 * 加载基类,处理SWF之间通信与加载
	 * 
	 */
	public class PageBase extends MethodBag
	{
		use namespace baseName;
		private var _parentSwf:DisplayObject;
		/**
		 * @private
		 */
		protected var swfCollect:SwfCollect = new SwfCollect;
		/**
		 * @private
		 */
		public const FWB_VERSION:String = "2.5"//版号 2011-01-10 22:42
		/**
		 * @private
		 */
		public const FWB_UPDATE:String = "http://www.shch8.com";
		//升级检测请勿删除---->
		private var _swfFileData:SwfFile;
		private var _cache:Boolean;
		private var _childPlayEnd:Boolean;//当前的SWF被移除时，子页是否要播放结束动画
		baseName var currentPath:String//当前子SWF路径
		public var isLoading:Boolean;//当前正在打开新页
		public function PageBase() 
		{
			
			this.addEventListener(Event.ADDED_TO_STAGE, initStage);
		}
		/**
		 * Swf文件加载
		 * @param	path	swf路径
		 * @param	param	要加载的下级SWF参数信息
		 * @param	stateArray	状态数组
		 */
		baseName function loadSwf(path:String, param:ChildFile = null, stateArray:Array = null):void {
			var swfFile:SwfFile 
			if (_cache) {
				swfFile = swfCollect.getSwf(path);
				if (swfFile) {
					loadEnd(swfFile.file.content as PageBase)
					return
				}
			}else if (swfCollect.isExist(path)) {
				throw(path + "文件已经存在");
				return
			}
			currentPath = path;
			var swfLoader:Loader = new Loader;
			swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loadError);
			swfLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgress);
			swfLoader.name = path;
			swfLoader.load(new URLRequest(path));
			
			if (!cache)swfCollect.clearOther();		
			swfFile = new SwfFile;
			swfFile.file = swfLoader;
			swfFile.path = path;
			swfFile.param = param;
			swfFile.stateArray = stateArray;
			swfCollect.push(swfFile);
		}
		
		/**
		 * 当前的SWF被移除时，如果有子页，直接移除还是播放结束动画后移除*/
		public function get childPlayEnd():Boolean { return _childPlayEnd; };
		public function set childPlayEnd(value:Boolean):void { _childPlayEnd= value; };
		
		/**
		 * 设置可生效的FlashPlayer版本 添加时间：2010-11-19 19:44*/
		public function get playerVersion():Number { return SwfCollect.playerVersion; };
		public function set playerVersion(value:Number):void { SwfCollect.playerVersion = value; };
		/**
		 * 是否使用文件池缓存所加载的SWF*/
		public function set cache(value:Boolean):void {
			if (isRoot)_cache = value;
		};
		public function get cache():Boolean {
			return _cache
			if (isRoot) { return _cache } else { return rootPage.cache } };
		baseName function get isRoot():Boolean {
			return ((parent is Stage)&&_parentSwf == null)
			}
		/**
		 * SWF模块加载
		 * @param	path	SWF路径
		 * @param	isCache	是否使用文件池缓存所加载的SWF
		 * @return
		 */
		public function loadModule(path:String,isCache:Boolean=false):IloadInfo
		{
			if (isRoot) {
			return new ModuleControl(path,isCache) as IloadInfo;
			}else if(stage){
				var pb:ParentBase = stage.getChildAt(0) as ParentBase;
				if (pb) {
					return pb.loadModule(path);
				}else {
					throw("加载器不合法")
					}
				}else {
					throw("请添加到舞台以后再执行loadModule加载模块")
					}
			return null;
		}
		private function initStage(event:Event = null):void {
			stage.align = "TL";
			ControlBag.stage=stage
			init();
			stage.addEventListener(Event.RESIZE, resizeFun);
			if (_swfFileData == null) return;
			if(_swfFileData.param){
			this.dispatchEvent(new ParamEvent(ParamEvent.GET_PARAM, _swfFileData.param));
			}
				if (_swfFileData.stateArray) {
					this.dispatchEvent(new StateEvent(StateEvent.GET_STATE,_swfFileData.stateArray));
				}
				
			}
		private function resizeFun(event:Event):void {
			if(stage){
			InviteEventSen.sen(this, new PageSizeEvent(PageSizeEvent.RESIZE, stage.stageWidth, stage.stageHeight));
			if(callResize is Function)callResize()
			}
			}
		/**
		 * 加入舞台时，用于子类覆盖*/
		protected function init():void {
			
			}
		/**加载进度*/
		baseName function loadProgress(event:ProgressEvent):void {
			dispatchEvent(new LoadSwfEvent(LoadSwfEvent.PROGRESS, event));
			if(callProgress is Function)callProgress()
			}
		/**
		 * 停止加载，并删除已加载的数据
		 * @param	path
		 * @private
		 * */
		baseName function loadStop(path:String):void {
			if (path == "") return;
			var loader:SwfFile = swfCollect.getSwf(path);
			if (loader.runState == SwfFile.LOADING) {
				loader.file.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete);
				loader.file.removeEventListener(IOErrorEvent.IO_ERROR,loadError);
				loader.file.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadProgress);
				loader.file.close();
				removeSwf(loader.file.name);
				loader.runState = SwfFile.CLOSE;
				}
			}
		/**
		 * 子级通知父级，结束动画播放完成
		 * 用于子类调用
		 * @param	removeObj
		 * @param	isRemove
		 * @private
		 * */
		baseName function endPlayEnd(removeObj:Object, isRemove:Boolean = true):void {
			var swfFile:SwfFile = swfCollect.getSwf(removeObj);
			if (swfFile == null) return;
			var path:String = swfFile.path;
			if (isCache()) {
				if(swfFile.file.parent!=null)
				swfFile.file.parent.removeChild(swfFile.file);
				}else {
					swfCollect.remove(path,isRemove)
			}
			function isCache():Boolean {
				var pb:PageBase = swfFile.file.content as PageBase;
				if (pb != null) {
					if (pb.currentSwf != null) {
						return false;
						}
					}
				return cache
			}
			dispatchEvent(new ParentEvent(ParentEvent.REMOVE_CHILD, swfFile));
			if (callRemovePage is Function) callRemovePage();
		}
		/**子SWF中调用，用来移除自己，限于子级调用
		 * */
		public function removeMe():void {
			if (removeTime != null) {
				removeTime.removeEventListener(TimerEvent.TIMER_COMPLETE, timerRemove);
				removeTime.stop()
				removeTime = null;
				}else {
					return;
					}
			
			var pageBase:PageBase = parentSwf as PageBase;
			if(pageBase!=null)pageBase.endPlayEnd(this, true);
		}
		
		//实现阶层移除,非启用
		private function removeSwfFile(e:ParentEvent):void {
			e.target.removeEventListener(ParentEvent.REMOVE_CHILD, removeSwfFile);
			swfCollect.unload(currentSwf)
			currentSwf = null
			removeSwf(currentPath,true)
		}
		private var removeTime:Timer;
		private function timerRemove(e:TimerEvent):void { removeMe() };
		/**
		 * 结束动画移除的限定时间
		 */
		baseName function openRemoveTime():void {
			removeTime = new Timer(3000,1)
			removeTime.addEventListener(TimerEvent.TIMER_COMPLETE, timerRemove);
			removeTime.start();
		}
		/**移除子Swf
		 * @param path:String <default=""> SWF路径
		 * @param usePlayEnd:Boolean <default=true> 是否先播放结束动画
		 * @param isRemove <default=null> 是否代理移除*/
		baseName function removeSwf(path:String = "", usePlayEnd:Boolean = false, isRemove:Boolean = true):void {
			if (path != "") {
				var swfFile:SwfFile = swfCollect.getSwf(path) as SwfFile;
				if (swfFile == null) return;
				if (usePlayEnd) {//播放结束动画
					var pageBase:PageBase = swfFile.file.content as PageBase;
					if (pageBase != null) {
						var parentBase:ParentBase = swfFile.file.content as ParentBase
						if (parentBase!=null) {
							if(parentBase.currentSwf!=null){
								if(parentBase.currentSwf.content is ParentBase){
										if (childPlayEnd) {
											parentBase.removeSwf(parentBase.currentPath,true)
											/*var pb:PageBase = parentBase.currentSwf.content as PageBase
											pb.dispatchEvent(new ChildEvent(ChildEvent.END_PLAY));
											if (pb.callPlayEnd is Function) pb.callPlayEnd();*/
											}else{
												swfCollect.unload(parentBase.currentSwf);
												}
										}else{
											swfCollect.unload(parentBase.currentSwf);
										}
							}
							if (parentBase.callPlayEnd is Function) parentBase.callPlayEnd();
						}
						var mc:MovieClip = swfFile.file.content as MovieClip;
						if (swfFile.file.content.hasEventListener(ChildEvent.END_PLAY)) {
							swfFile.file.content.dispatchEvent(new ChildEvent(ChildEvent.END_PLAY));
							}else {
								if (mc!=null) {
									mc.addEventListener(Event.ENTER_FRAME, mcEnterFrame)
								}
								//2010-7-8 8:41 新增在未添加
								}
							if (mc as PageBase) {//添加结束动画的限定时间
								(mc as PageBase).openRemoveTime()
								}
							}
					}else {
						endPlayEnd(swfFile.path,isRemove)
					}
			}
			function mcEnterFrame(e:Event):void
			{
				if (mc.currentFrame == mc.totalFrames) {
					mc.stop()
					mc.removeEventListener(Event.ENTER_FRAME, mcEnterFrame);
					if (mc.stage && mc as PageBase) {
						(mc as PageBase).removeMe();
						}
					}else {
						mc.play()
						}
			}
		}
		
		/**SWF获取,获取Loader对象
		 * @param path:String
		 * @return Loader
		 * @private
		 * */
		baseName function getLoader(path:String):Loader {
			return swfCollect.getSwf(path).file;
			}
		/**获取子文件的文件类对象.
		 * @param path:String	XML菜单表中的ID，
		 * 如：<menu id="about" title="关于" file="about.swf" height="600" /> getChildObj("about")
		 * @return Object
		 * @private
		 * */
		baseName function getChildObj(path:String):Object {
			return swfCollect.getSwf(path).file.content;
		}
		/**
		 * 获取父级SWF
		 * @private
		 */
		public function set parentSwf(value:DisplayObject):void {
			_parentSwf = value;
			}
		public function get parentSwf():DisplayObject {
			return _parentSwf;
		}

		private function get rootPage():PageBase { if (stage) return stage.getChildAt(0) as PageBase; return this; };
		/**
		 * 由父级触发的，垃圾清除，如果有声音或视频等，在此处先清除
		 * @private
		 */
		baseName function clearRefuse():void {
			this.dispatchEvent(new ChildEvent(ChildEvent.CLEAR));
			swfCollect.clearAll();
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.removeEventListener(Event.RESIZE, resizeFun);
			if(removeTime!=null){
			removeTime.removeEventListener(TimerEvent.TIMER_COMPLETE, timerRemove);
				removeTime.stop()
				removeTime = null;
			}
			if (_parentSwf != null) {
				_parentSwf = null;
				}
			}
		/**
		 * @private
		 * @param	value
		 * @return
		 */
		baseName function getSwfFile(value:String):SwfFile {
			return swfCollect.getSwf(value);
			}
		/**
		 * @private
		 */
		baseName function set swfFileData(value:SwfFile):void {
			_swfFileData = value;
		}
		baseName function get swfFileData():SwfFile{
			return _swfFileData;
		}
		private function loadComplete(event:Event):void {
			//setTimeout(loadEnd,500,event.target.content)
			loadEnd(event.target.content);
		}
		private function loadEnd(getSwf:Object):void
		{
			isLoading=false
			 var swfFile:SwfFile = swfCollect.getSwf(getSwf);
			 var pageBase:PageBase=getSwf as PageBase
			 if (pageBase != null) {
				pageBase.parentSwf = this;
				pageBase.swfFileData = swfFile;
			 }
			if (swfFile != null) {
				swfFile.runState = SwfFile.COMPLETE;
				currentSwf = swfFile.file
				
				InviteEventSen.sen(this, new ParentEvent(ParentEvent.ADD_CHILD, swfFile),dispatchCall,checkFun)
				function dispatchCall():void {
					if (callAddPage is Function) {
					callAddPage()
					}
				}
				function checkFun():Boolean {
					if (callAddPage is Function) return true
					return false
				}
			}
		}
		/**当前所加载的SWF的Loader对象*/
		public function get currentSwf():Loader { return null; };
		public function set currentSwf(value:Loader):void {};
		
		private function loadError(event:IOErrorEvent):void {
			InviteEventSen.sen(this, new LoadSwfEvent(LoadSwfEvent.ERROR));
			isLoading=false
			}
	}
	
}