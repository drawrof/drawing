package com.regieg.image
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	
	public class ImageLoader
	{
		function ImageLoader(path,callback):void
		{
			var loader:Loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, callback);
			loader.load(new URLRequest(path));
		}
	}
}