/*
* Drawing Format, pipe separated commands
*
* moveTo: 		'mt:x,y'
* curveTo: 		'ct:controlx,controly,anchorx,anchory'
* lineStyle: 	'ls:size,colour,alpha'
* drawCircle:	'dc:x,y,radius'
*
*
*
*
*/

package com.regieg.io
{
	import flash.display.Stage;
    import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.net.*;
	import flash.external.ExternalInterface;

	public class IOHandler
	{
		public var stage:Stage;
		public var root;
		public var queue:String = '';
		public var timer = null;
		private const INTERVAL = 20000;
		private const URL = '/io.php';
		
		
		public function IOHandler(_stage,_root)
		{
			stage = _stage;
			root = _root;
		}
				
		public function call(message,data = null,callback = null)
		{
			root.ui.show_message(message);
			
			// Instantiate
			var variables:URLVariables = new URLVariables();
			var request:URLRequest = new URLRequest(URL + '?' + new Date().time);
			var loader:URLLoader = new URLLoader();
			
			// Configure
			if (data != null) {
				variables.queue = data; 
			}
			
			variables.id = id();
			request.method = URLRequestMethod.POST;
			request.data = variables;

			// Request
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			
			if (callback != null) {
				loader.addEventListener(Event.COMPLETE, callback);
			} else {
				loader.addEventListener(Event.COMPLETE, called);
			}
			
			loader.load(request);
		}
		
		public function called(e)
		{
			root.ui.hide_message();
		}
		
		public function save()
		{
			if (queue != '') {
				var local_queue = queue;
				queue = '';
				call('Saving...',local_queue);
			} 
		}
		
		public function sync_canvas()
		{
			
		}
		
		public function refresh()
		{
			call('Refreshing Canvas...',null,sync_canvas);
		}
			
		public function id()
		{
			return ExternalInterface.call("get_id");
		}

		public function add(action:String):void
		{
			if (queue == '') {
				queue = action;
			} else {
				queue += '|'+action;
			}
		}
	}
}