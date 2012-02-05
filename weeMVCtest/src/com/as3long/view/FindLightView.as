package com.as3long.view 
{
	import com.as3long.actions.FindLightCommand;
	import com.as3long.event.FindLightEvent;
	import com.as3long.model.vo.LightPointVo;
	import com.as3long.view.components.CoolButton;
	import com.as3long.view.components.PicView;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.weemvc.as3.view.IView;
	import org.weemvc.as3.view.View;
	
	/**
	 * 找亮点视图
	 * @author huanglong
	 */
	public class FindLightView extends View implements IView
	{
		private var _main:MovieClip;
		private var _picView:PicView;
		private var _data:LightPointVo = new LightPointVo();
		private var _pointMc:MovieClip = new MovieClip();
		private var _addPintBtn:CoolButton = new CoolButton('清除');
		private var _savePointBtn:CoolButton = new CoolButton('保存亮点');
		public function FindLightView(main:MovieClip) 
		{
			_main = main;
			_picView = new PicView();
			_main.addChild(_picView);
			_addPintBtn.x = _main.stage.stageWidth - _addPintBtn.width-5;
			_savePointBtn.x = _main.stage.stageWidth - _savePointBtn.width-5;
			_savePointBtn.y = 40;
			_main.addChild(_addPintBtn);
			_main.addChild(_savePointBtn);
			_addPintBtn.addEventListener('onClick', addPoint);
			_main.addEventListener(MouseEvent.MOUSE_DOWN, on_mouseDown);
			_main.addEventListener(MouseEvent.MOUSE_UP, on_mouseUp);
			_savePointBtn.addEventListener('onClick', savePoint);
			setWeeList([FindLightEvent.SET_PICURL, FindLightEvent.ADD_LIGHT,FindLightEvent.REMOVE_ALLLIGHT]);
		}
		
		private function addPoint(e:Event):void 
		{
			sendWee(FindLightCommand, FindLightEvent.REMOVE_ALLLIGHT);
		}
		
		private function savePoint(e:Event):void 
		{
			trace("保存亮点");
		}
		
		private function on_mouseUp(e:MouseEvent):void 
		{
			if (e.eventPhase == 3)
			{
				_data.width = Math.abs(e.stageX - _data.x);
				if (e.stageX < _data.x)
				{
					_data.x = e.stageX;
				}
				_data.height = Math.abs(e.stageY - _data.y);
				if (e.stageY < _data.y)
				{
					_data.y = e.stageY;
				}
				//_main.stage.removeEventListener(MouseEvent.MOUSE_MOVE, on_mouseMove);
				//trace('鼠标谈起',_data.toString());
				sendWee(FindLightCommand, _data);
			}
		}
		
		private function on_mouseDown(e:MouseEvent):void 
		{
			if (e.eventPhase == 3)
			{
				_data.x = e.stageX;
				_data.y = e.stageY;
				//trace('鼠标按下',_data.toString());
				//_main.stage.addEventListener(MouseEvent.MOUSE_MOVE, on_mouseMove);
			}
		}
		
		private function on_mouseMove(e:MouseEvent):void 
		{
			
		}
		
		override public function onDataChanged(wee:String, data:Object = null):void 
		{
			super.onDataChanged(wee, data);
			var arr:Array = data as Array;
			if (wee == FindLightEvent.SET_PICURL)
			{
				_picView.url = String(data);
			}
			else if (wee == FindLightEvent.ADD_LIGHT||wee==FindLightEvent.REMOVE_ALLLIGHT)
			{
				//trace('视图', data);
				if (_pointMc.parent == null)
				{
					_main.addChild(_pointMc);
				}
				else
				{
					_pointMc.graphics.clear();
				}
				var len:int = arr.length;
				for (var i:int = 0; i < len; i++ )
				{
					_pointMc.graphics.beginFill(0xFF8040, 0.8);
					_pointMc.graphics.drawRect(arr[i].x, arr[i].y, arr[i].width, arr[i].height);
					_pointMc.graphics.endFill();
				}
			}
		}
		
		
		
	}

}