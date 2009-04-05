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
	import flash.display.Sprite;

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
		
		public function clear()
		{
			clear_canvas();
			call('Clearing...','clear');
			queue = '';
		}
		
		public function clear_canvas()
		{
			root.ui.toggle_toolbar(true);
			
			while (stage.numChildren > 0) 
			{
				stage.removeChildAt(0);
			}
			
			root.ui.update_toolbar_z();
		}
		
		public function sync_canvas(e:Event)
		{
			clear_canvas();			
			root.ui.show_message('Syncing...');
			
			var actions = e.target.data.split('|');
			
			// reset the brush
			var old_brush = root.brush.name;
			var old_brush_size = root.brush.size;
			var old_brush_alpha = root.brush.alpha;
			var old_brush_palette = root.brush.palette;
			
			root.ui.change_brush('Line');
			root.brush.size = 1;
			root.brush.alpha = 1;
			root.brush.change_palette([0x000000]);

			for each (var value in actions) {	
				parse_action(value);
			}
			
			root.ui.change_brush(old_brush);
			root.brush.size = old_brush_size;
			root.brush.alpha = old_brush_alpha;
			root.brush.change_palette(old_brush_palette);
			root.ui.update_toolbar();
			root.ui.update_toolbar_z();
			
			queue = '';
			
			root.ui.hide_message();
		}
		
		public function parse_action(value:String)
		{
			// Parse Action
			var action = value.substr(0,2);
			var args = value.substr(3);
			args = args.split(',');
			
			// Basic typecasting
			for (var i = 0; i < args.length; i++) {
				if (args[i] == 'null') {
					args[i] = null;
				}
			}
			
			switch(action)
			{
				case 'ac':
					root.brush.add_canvas();
					break;
					
				case 'cb':
					root.ui.change_brush(args[0]);
					break;
					
				case 'mt':
					root.brush.moveTo(args[0],args[1]);
					break;
					
				case 'ct':
					root.brush.curveTo(args[0],args[1],args[2],args[3]);
					break;
					
				case 'ls':
					root.brush.lineStyle(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
					break;
					
				case 'dc':
					root.brush.drawCircle(args[0],args[1],args[2]);
					break;
					
				case 'lt':
					root.brush.lineTo(args[0],args[1]);
					break;
			}
		}
				
		public function refresh(e = null)
		{
			call('Refreshing...',null,sync_canvas);
			queue = '';
		}
			
		public function id()
		{
			return ExternalInterface.call("get_id");
		}

		public function add(action:String):void
		{
			queue += '|'+action;
		}
	}
}