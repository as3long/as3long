package com.rush360.actions 
{
	import com.projectcocoon.p2p.events.ClientEvent;
	import com.projectcocoon.p2p.events.GroupEvent;
	import com.projectcocoon.p2p.events.MessageEvent;
	import com.projectcocoon.p2p.LocalNetworkDiscovery;
	import com.rush360.models.CharModel;
	import com.rush360.models.UserListModel;
	import com.rush360.tool.GameDataProxy;
	import com.rush360.views.UserListView;
	import flash.events.Event;
	import org.weemvc.as3.control.ICommand;
	import org.weemvc.as3.control.SimpleCommand;
	
	/**
	 * ...
	 * @author huanglong
	 */
	public class ProxyGetData extends SimpleCommand implements ICommand 
	{
		public var channel:LocalNetworkDiscovery;
		public function ProxyGetData() 
		{
			channel = new LocalNetworkDiscovery();
			channel.key = 'e33c484cd86c05a1e212a399-2d0aa6450c4d';
			//channel.loopback = true;
			channel.useCirrus = true;
			channel.clientName = "Client" + (Math.random() * 1000).toFixed(0);
			channel.addEventListener(GroupEvent.GROUP_CONNECTED, onGroupConnected);
			channel.addEventListener(GroupEvent.GROUP_CLOSED, onGroupClosed);
			channel.addEventListener(ClientEvent.CLIENT_ADDED, onClientAdded);
			channel.addEventListener(ClientEvent.CLIENT_UPDATE, onClientUpdate);
			channel.addEventListener(ClientEvent.CLIENT_REMOVED, onClientRemoved);
			channel.addEventListener(MessageEvent.DATA_RECEIVED, onDataReceived);
			GameDataProxy.getInstance().channel = channel;
			(modelLocator.getModel(UserListModel) as UserListModel).addUser(channel.clientName);
		}
		
		private function onGroupConnected(event:GroupEvent):void
		{
			log("Group Connected");
		}
		
		private function onGroupClosed(event:GroupEvent):void
		{
			log("Group Closed");
		}
		
		private function onClientAdded(event:ClientEvent):void
		{
			//(modelLocator.getModel(UserListModel) as UserListModel).addUser(event.client.clientName);
			channel.sendMessageToAll('1^&user'+channel.clientName);
			log("Client " + event.client.peerID + " connected. Clients connected: " + channel.clients.length);
		}
		
		private function onClientUpdate(event:ClientEvent):void
		{
			log("Client " + event.client.peerID + " changed clientName to " + event.client.clientName);
		}
		
		private function onClientRemoved(event:ClientEvent):void
		{
			(modelLocator.getModel(UserListModel) as UserListModel).removeUser(event.client.clientName);
			log("Client " + event.client.clientName + " disconnected. Clients connected: " + channel.clients.length);
		}
		private function onDataReceived(event:MessageEvent):void
		{
			if (String(event.message.data.toString()).indexOf('^&user')!=-1)
			{
				(modelLocator.getModel(UserListModel) as UserListModel).addUser(String(event.message.data.toString()).split('^&user', 2)[1]);
			}
			else
			{//log("Client " +  + " says: '" + event.message.data.toString() + "'");
				(modelLocator.getModel(CharModel) as CharModel).addString(event.message.client.clientName + ':' + event.message.data.toString());
			}
		}
		
		private function log(str:String):void
		{
			//logTextField.appendText("\n----------------------------------------\n" + str);
			//logTextField.scrollV = logTextField.maxScrollV;
		}
		
		override public function execute(data:Object = null):void 
		{
			super.execute(data);
			trace('处理数据接收,接到数据后改变CharModel');
			channel.connect();
		}
		
	}

}