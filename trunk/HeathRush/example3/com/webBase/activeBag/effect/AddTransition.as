package com.webBase.activeBag.effect 
{
	import com.webBase.activeBag.effect.transitions.Tweener;
	import fl.motion.Color;
	import fl.transitions.Tween;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 * 
	 * 例子:
	 * import com._public._method.AddTransition;
	 * 
     * var changeBg:Object = new Object;
			changeBg.startAlpha = 0;
			changeBg.overAlpha = 1;
			changeBg.clickAlpha = 1;
			changeBg.startColor = 0xC29C6A;
			changeBg.overColor=0xC29C6A
			changeBg.clickColor=0x666666
			changeBg.time=0.3
			changeBg.transition = Regular.easeIn;
			new AddTransition(setObj as DisplayObject, setObj.bg as DisplayObject, changeBg);
			//改变透明度
			var txtObj:Object = new Object;
			txtObj.overColor =0;
			txtObj.startColor =  0x4F3A20;
			txtObj.clickColor=0xffff00
			txtObj.time=0.2
			txtObj.transition = Regular.easeOut;
			new AddTransition(setObj as DisplayObject, setObj.txt as DisplayObject, txtObj);
			//改变颜色
	 */
	public class AddTransition 
	{
		private var _obj:Object = new Object;
		private var _currentColor:uint = 0;
		private var _target:DisplayObject;
		private var _evtTarget:DisplayObject
		private var _autoOut:Boolean=true;//当鼠标移出对象时,是否自动触发Out事件
		private var _autoOver:Boolean = true;//当鼠标移入对象时,是否自动触发Over事件
		private var _autoClick:Boolean = true;//当鼠标移入对象时,是否自动触发Over事件
		public function AddTransition(target:DisplayObject,changeTarget:DisplayObject,obj:Object):void
		{
			valueObj = obj;
			_target = changeTarget;
			_evtTarget = target;
			target = null;
			changeTarget = null;
			obj = null;
			_evtTarget.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			_evtTarget.addEventListener(MouseEvent.MOUSE_DOWN, onOver);
			if((_obj.clickAlpha!=null||_obj.clickColor!=null)&&_autoClick)
			_evtTarget.addEventListener(MouseEvent.CLICK, onClick);
			reSet();
		}
		public function set autoOut(value:Boolean):void
		{
			_autoOut = value;
		}
		public function set autoOver(value:Boolean):void
		{
			_autoOver = value;
			if (!_autoOver) {
				_evtTarget.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
				_evtTarget.addEventListener(MouseEvent.MOUSE_DOWN, onOver);
			}
		}
		public function set autoClick(value:Boolean):void
		{
			_autoClick = value;
			if(!_autoClick)_evtTarget.removeEventListener(MouseEvent.CLICK, onClick);
		}
		public function set valueObj(value:Object):void
		{
			if (value.time == null) value.time = 0.5;
			_obj = value;
		}
		/*效果清除*/
		public function clear():void {
			_evtTarget.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			_evtTarget.removeEventListener(MouseEvent.MOUSE_DOWN, onOver);
			_evtTarget.removeEventListener(MouseEvent.CLICK, onClick);
			_evtTarget.removeEventListener(MouseEvent.ROLL_OUT, onOut);
			}
		/*效果重置*/
		public function reSet():void {
			if(_obj.startColor){
			var colorTransformer:ColorTransform=new ColorTransform;
				colorTransformer.color=_obj.startColor
				_target.transform.colorTransform = colorTransformer;
			}
				if (_obj.startAlpha != null)
				_target.alpha=_obj.startAlpha
			}
		/*强制定位到滑入状态*/
		public function setOver():void
		{
			onOver(null);
		}
		/*强制定位到滑出状态*/
		public function setOut():void
		{
			onOut(null);
		}
		/*强制定位到滑出状态*/
		public function setClick():void
		{
			onClick(null);
		}
		private function onOver(evt:MouseEvent):void
		{
			_evtTarget.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			_evtTarget.removeEventListener(MouseEvent.MOUSE_DOWN, onOver);
			if(_autoOut)_evtTarget.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			if (_obj.overAlpha != null) {
				Tweener.addTween(_target, { alpha:_obj.overAlpha, time:_obj.time , transition:_obj.transition } );
				return;
			}
			if(_obj.overColor!=null){
			tweenColor(_target, _obj.startColor, _obj.overColor)
			_currentColor = _obj.overColor;
			}
			if (_obj.overFun != undefined)
			{
				_obj.overFun(_evtTarget);
			}
		}
		private function onOut(evt:MouseEvent):void
		{
			_evtTarget.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			if (_autoOver) {
				_evtTarget.addEventListener(MouseEvent.MOUSE_OVER, onOver);
				_evtTarget.addEventListener(MouseEvent.MOUSE_DOWN, onOver);
			}
			if (_obj.startAlpha != null) {
				Tweener.addTween(_target, { alpha:_obj.startAlpha, time:_obj.time, transition:_obj.transition } );
				return;
			}
			if(_obj.startColor!=null){
			tweenColor(_target, _obj.overColor, _obj.startColor);
			_currentColor = _obj.startColor;
			}
			if (_obj.outFun != undefined)
			{
				_obj.outFun(_evtTarget);
			}
		}
		private function onClick(evt:MouseEvent):void
		{
			if (_obj.clickAlpha != null) {
				Tweener.addTween(_target, { alpha:_obj.clickAlpha, time:_obj.time, transition:_obj.transition } );
				return;
			}
				if(_obj.startColor!=null){
			tweenColor(_target, _obj.overColor, _obj.clickColor)
			_currentColor = _obj.clickColor;
				}
			if (_obj.clickFun != undefined)
			{
				_obj.clickFun(_evtTarget);
			}
		}
		public function dispose():void
		{
			_evtTarget.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			_evtTarget.removeEventListener(MouseEvent.MOUSE_DOWN, onOver);
			_evtTarget.removeEventListener(MouseEvent.ROLL_OUT, onOut);
			_evtTarget.removeEventListener(MouseEvent.CLICK, onClick);
			_evtTarget = null;
			_target = null;
			_obj = null;
		}
		private function tweenColor(_tar:DisplayObject, startColor:Number, endColor:Number):void {
			if (isNaN(endColor)) return;
			var endObj:Object = new Object();
			endObj.timerNum = 0;
			function onUpdate() {
				var colorTransformer:ColorTransform=new ColorTransform;
				colorTransformer.color=Color.interpolateColor(startColor,endColor,endObj.timerNum);
				_tar.transform.colorTransform = colorTransformer;
				}
			Tweener.addTween(endObj, {timerNum:1,time:_obj.time,onUpdate:onUpdate,transition:_obj.transition});
			}
	}
}