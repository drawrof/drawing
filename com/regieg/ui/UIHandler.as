package com.regieg.ui
{
	import flash.events.*;
	import flash.display.Stage;
	import com.regieg.brushes.*;
	import fl.controls.ColorPicker;  
	import fl.events.ColorPickerEvent;  
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import caurina.transitions.Tweener;

	public class UIHandler
	{
		private var stage;
		private var root; 
		private const LEFT = 37;
		private const RIGHT = 39;
		private const UP = 38;
		private const DOWN = 40;
		private const PG_UP = 33;
		private const PG_DN = 34;
		
		private const ONE = 49;
		private const TWO = 50;
		private const THREE = 51;
		private const FOUR = 52;
		private const FIVE = 53;
		private const SIX = 54;
		private const SEVEN = 55;
		private const EIGHT = 56;
		private const NINE = 57;
		private const SPACE = 32;
		
		private const HELP = 72;
		private const SAVE = 83;
		private const REFRESH = 82;
		private const CLEAR = 67;
		
		private var brushes;
		
	    // register the listener function
		public function UIHandler(_stage:Stage,_root)
	    {
			stage = _stage;
			root = _root;
			
			// Various Keyboard Controls
			stage.addEventListener(KeyboardEvent.KEY_UP, key_pressed);
			
			// Resize Event
			stage.addEventListener(Event.RESIZE, resize);
			
			// Ensure the toolbar is always on top
			stage.addEventListener(MouseEvent.MOUSE_UP, update_toolbar_z); 
			
			// Colorpicker
			root.toolbar.colorpicker.addEventListener(ColorPickerEvent.CHANGE, color_picked); 
			
			// Update Scale Mode
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// Hide Message
			root.message.alpha = 0;
	    }

	   // listener funtion
		public function key_pressed(ev:KeyboardEvent):void
		{
			switch (ev.keyCode)
			{
				// Brush Switcher
				case ONE:
				case TWO:
				case THREE:
				case FOUR:
				case FIVE:
				case SIX:
				case SEVEN:
				case EIGHT:
				case NINE:
					change_brush(ev.keyCode)
					break;
				
				// Brush Alpha
				case LEFT:
					change_brush_alpha(root.brush.alpha - 0.05);
					break;
				
				case RIGHT:
					change_brush_alpha(root.brush.alpha + 0.05);
					break;
				
				// Brush Size
				case UP:
					change_brush_size(root.brush.size + 1)
					break;
				
				case DOWN:
					change_brush_size(root.brush.size - 1)
					break;
				
				// Brush size in 10s
				case PG_UP:
					change_brush_size(root.brush.size + 10);
					break;
				
				case PG_DN:
					change_brush_size(root.brush.size - 10);
					break;
				
				// Save, Refresh, Clear etc...
				case SAVE:
					root.io.save();
					break;
					
				case REFRESH:
					root.io.refresh();
					break;
					
				case CLEAR:
					root.io.clear();
					break;
								
				case SPACE:
					toggle_toolbar();
					break;
					
				case HELP:
					toggle_help();
					break;
			}
			
	    }
	
		public function color_picked(e:ColorPickerEvent):void
		{
			var new_colour:Array = ["0x"+e.target.hexValue];
			
			root.brush.change_palette(new_colour);
			root.colours = new_colour;
			reset_focus();
		}
	
		public function toggle_toolbar(force_hide = false)
		{ 		
			if (root.toolbar.alpha == 0 && !force_hide) {
				Tweener.addTween(root.toolbar, {alpha: 1, time: 0.5});
			} else {
				if (root.toolbar.alpha != 0) {
					Tweener.addTween(root.toolbar, {alpha: 0, time: 1});
				}
			}
			
			reset_focus();
		}
		
		public function resize(e = false)
		{
			// Toolbar
			root.toolbar.background.width = stage.stageWidth;
			root.toolbar.x = 0;
			root.toolbar.y = 0;
			root.toolbar.colorpicker.x = stage.stageWidth - 23;
			
			// Messages
			root.message.background.width = stage.stageWidth;
			root.message.background.height = stage.stageHeight;
			root.message.dynamic_text.x = (stage.stageWidth - root.message.dynamic_text.width) / 2;
			root.message.dynamic_text.y = (stage.stageHeight - root.message.dynamic_text.height) / 2;
			
			// Help
			root.help.x = (stage.stageWidth - root.help.width) / 2;
			root.help.y = (stage.stageHeight - root.help.height) / 2;
		}
		
		public function update_toolbar()
		{
			var alpha_text = Math.floor(root.brush.alpha * 100) + '%';
			var name_text = root.brush.name;
			var size_text = root.brush.size + 'px';
			root.toolbar.brush.settings.text = size_text + ' ' + name_text + ' at ' + alpha_text;
		}
		
		public function update_toolbar_z(e = null):void
		{
			stage.addChild(root.toolbar);
		}		
	
		public function change_brush_size(size:Number):void
		{
			if (size > 0) {
				root.brush.size = size;
				update_toolbar();
			}			
		}
		
		public function change_brush_curve(curve:Number):void
		{
			if (curve > 0) {
				root.brush.curve = curve;
				update_toolbar();
			}
		}
		
		public function change_brush_alpha(alpha:Number):void
		{
			// Force Two Decimal Places
			alpha = Math.round(alpha * 100) / 100;

			if (alpha >= 0 && alpha <= 1) {
				root.brush.alpha = alpha;
				update_toolbar();
			}
		}

		public function change_brush(keycode):void
		{
			var changed = false;
			
			root.brush.disable();
							
			// Save some properties
			var previous_size = root.brush.size;
			var previous_alpha = root.brush.alpha;

			switch (keycode) 
			{
				case ONE:
				case "Line":
					changed = 'Line';
				break;
				
				case TWO:
				case "SimpleLine":
					changed = 'SimpleLine';
				break;
				
				case THREE:
				case "BubbleLine":
					changed = 'BubbleLine';
				break;
				
				case FOUR:
				case "Bubbles":
					changed = 'Bubbles';
				break;
				
				case FIVE:
				case "RoundBrush":
					changed = 'RoundBrush';
				break;
				
				case SIX:
				case "SharpLine":
					changed = 'SharpLine';
				break;
				
				case SEVEN:
				case "Dots":
					changed = 'Dots';
				break;
			}
						
			if (changed) {
				
				// Update a few properties of the brush
				root.brush = root.brushes[changed];
				root.brush.size = previous_size;
				root.brush.alpha = previous_alpha;
				root.brush.enable();
				
				// Update the toolbar
				update_toolbar();
				
				// Save what just happend
				root.io.add('cb:'+changed);
			}
		}
		
		public function show_message(message:String)
		{
			// Prevent the toolbar from coming back on top
			stage.removeEventListener(MouseEvent.MOUSE_UP, update_toolbar_z);
			stage.removeEventListener(KeyboardEvent.KEY_UP, key_pressed); 
			root.brush.disable();
			
			// Set the message, put it up top
			root.message.dynamic_text.text = message;
			stage.addChild(root.message);
			
			stage.addEventListener(Event.ADDED, keep_message_on_top);
			
			// Show it
			Tweener.addTween(root.message, {alpha: 1, time: 1});
		}
		
		public function hide_message()
		{
			// Let the toolbar come back on top
			stage.addEventListener(MouseEvent.MOUSE_UP, update_toolbar_z); 
			stage.addEventListener(KeyboardEvent.KEY_UP, key_pressed);
			root.brush.enable();
			
			stage.removeEventListener(Event.ADDED, keep_message_on_top);
						
			// Hide it
			Tweener.addTween(root.message, {alpha: 0, time: 1, delay: 1});
		}
		
		public function toggle_help()
		{
			
			stage.addChild(root.help);
			
			if (root.help.alpha == 0) {
				root.brush.disable();
				Tweener.addTween(root.help, {alpha: 1, time: 0.5});
			} else {
				root.brush.enable();
				Tweener.addTween(root.help, {alpha: 0, time: 1});
			}
		}
		
		public function keep_message_on_top(e)
		{
			stage.addChild(root.message);
		}
				
		public function reset_focus()
		{
			// Remove focus from the stupid component
			// I feel sort of sick today.
			stage.focus = stage;
		}
	}
}
