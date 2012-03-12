package com.rush360.views 
{
	import com.rush360.events.ShaiZiEvent;
	import flash.display.MovieClip;
	import org.aswing.EmptyLayout;
	import org.aswing.JFrame;
	import org.aswing.JList;
	import org.weemvc.as3.view.IView;
	import org.weemvc.as3.view.View;
	import org.weemvc.as3.view.ViewLocator;
	
	/**
	 * 房间列表
	 * @author huanglong
	 */
	public class RoomListView extends View implements IView
	{
		private var roomDataArr:Array=[];
		private var jList:JList;
		private var jframe:JFrame;
		public function RoomListView(mv:MovieClip) 
		{
			setWeeList([ShaiZiEvent.ROOM_LIST_CHANGE]);
			jframe = new JFrame(); 
			jframe.setTitle('房间列表');
			jframe.setSizeWH(200, 200);
			jframe.getContentPane().setLayout(new EmptyLayout());
			jframe.setLocationXY(630, 0);
			jframe.setResizable(false);
			jframe.show();
			jList = new JList();
			jList.setListData(roomDataArr);
			jList.setSizeWH(180, 180);
			(ViewLocator.getInstance().getView(MainView) as MainView).window.getContentPane().append(jframe);
			jframe.getContentPane().append(jList);
		}
		
		public override function onDataChanged(wee:String, data:Object = null):void 
		{
			roomDataArr = data as Array;
			jList.setListData(roomDataArr);
		}
		
	}

}