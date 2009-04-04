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

package com.regieg.brushes
{
	import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.MouseEvent;
	import flash.filters.*;
    
	public class Line
	{
		public var is_first = true;
		public var stage;
		public var root;
		public var canvas;
		public var palette:Array;
		public var filters:Array;
		public var colour;
		public var palette_max:Number;
		public var size:Number = 1;
		public var curve:Number = 1;
		public var alpha:Number = 1;
		public var actions:String = '';
		public var name:String = 'Line';
		
		public function Line(_stage,_root,_palette):void
		{
			stage = _stage;
			root = _root;
			palette = _palette;
			filters = init_filters();
			palette_max = _palette.length;
			
			enable();
		}
		
		public function enable()
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, start_drawing); 
			stage.addEventListener(MouseEvent.MOUSE_UP, stop_drawing);
		}
		
		public function disable()
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, start_drawing); 
			stage.removeEventListener(MouseEvent.MOUSE_UP, stop_drawing);
		}
		
		public function start_drawing(e:MouseEvent):void
		{
			// Initialize a new canvas object
			canvas = new Sprite();
			stage.addChild(canvas);
			
			// Add Filters
			canvas.filters = filters;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, draw_line);
		}
		
		public function stop_drawing(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, draw_line);
			is_first = true;
		}
		
		public function init_filters():Array
		{
			return new Array();
		}
				
		public function moveTo(x,y)
		{
			canvas.graphics.moveTo(x,y);
			root.io.add('mt:'+x+','+y);
		}
		
		public function lineStyle(size, colour, alpha, hinting = false, scale = 'normal', caps = null, joints = null, miter = 3)
		{
			canvas.graphics.lineStyle(size,colour,alpha,hinting,scale,caps,joints,miter);
			root.io.add('ls:'+size+ ',' +colour+ ',' +alpha+ ',' +hinting+ ',' +scale+ ',' +caps+ ',' +joints+ ',' +miter);
		}
		
		public function curveTo(controlX,controlY,anchorX,anchorY)
		{
			canvas.graphics.curveTo(controlX,controlY,anchorX,anchorY);
			root.io.add('ct:'+controlX+','+controlY+','+anchorX+','+anchorY)
		}
		
		public function drawCircle(x,y,radius)
		{
			canvas.graphics.drawCircle(x,y,radius);
			root.io.add('dc:'+x+','+y+','+radius)
		}
		
		public function draw_line(e:MouseEvent):void
		{	
			if (is_first) {
				// Move to current mouse position
				moveTo(e.stageX,e.stageY);
				is_first = false;
			}	
			
			var new_colour = palette[random(palette_max,true)]
			
			// Reset the linestyle
			lineStyle(size, new_colour,alpha);
			curveTo(e.stageX,e.stageY,e.stageX + curve,e.stageY + curve);
			
			e.updateAfterEvent();
		}
		
		public function change_palette(colours:Array):void
		{
			palette = colours;
			palette_max = colours.length;
		}
		
		public function random(max,integer:Boolean = false):int
		{
			if (integer) {
				return Math.floor(Math.random()*max);
			} else {
				return Math.random()*max;
			}
		}
	}
}