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
	 * 用户列表
	 * @author huanglong
	 */
	public class UserListView extends View implements IView 
	{
		private var userDataArr:Array=[];
		private var jList:JList;
		private var jframe:JFrame;
		public function UserListView(mv:MovieClip) 
		{
			setWeeList([ShaiZiEvent.USER_LIST_CHANGE]);
			jframe = new JFrame(); 
			jframe.setTitle('玩家列表');
			jframe.setSizeWH(200, 200);
			jframe.getContentPane().setLayout(new EmptyLayout());
			jframe.setLocationXY(430, 250);
			jframe.setResizable(false);
			jframe.show();
			jList = new JList();
			jList.setListData(userDataArr);
			jList.setSizeWH(180, 180);
			(ViewLocator.getInstance().getView(MainView) as MainView).window.getContentPane().append(jframe);
			jframe.getContentPane().append(jList);
		}
		
		public override function onDataChanged(wee:String, data:Object = null):void 
		{
			userDataArr = data as Array;
			jList.setListData(userDataArr);
		}
		
	}

}