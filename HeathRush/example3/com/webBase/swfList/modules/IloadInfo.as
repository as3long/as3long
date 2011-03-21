package com.webBase.swfList.modules 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	/**
	 * ...
	 * @author wzh (shch8.com)
	 */
	public interface IloadInfo extends IEventDispatcher
	{
	function get error():Boolean;
	function get cache():Boolean;
	function set cache(value:Boolean):void;
    function get loaded():Boolean;
    function get url():String;
	function set url(value:String):void;
	function get content():DisplayObjectContainer;
	function get loader():Loader;
    function load(url:String="", context:LoaderContext = null):void;
    function close():void;
    function unload():void;
	
	}
	
}