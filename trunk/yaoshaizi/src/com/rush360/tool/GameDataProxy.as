package com.rush360.tool 
{
	import com.projectcocoon.p2p.LocalNetworkDiscovery;
	/**
	 * ...
	 * @author huanglong
	 */
	public class GameDataProxy 
	{
		public var channel:LocalNetworkDiscovery;
		public function GameDataProxy() 
		{
			
		}
		
		private static var _instance:GameDataProxy;
		public static function getInstance():GameDataProxy
		{
			if (_instance == null)
			{
				_instance = new GameDataProxy();
			}
			return _instance;
		}
		
	}

}