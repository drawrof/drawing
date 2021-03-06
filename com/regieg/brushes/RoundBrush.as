package com.regieg.brushes
{
	import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.MouseEvent;
	import flash.filters.*;
    
	public class RoundBrush extends Line
	{	
		public function RoundBrush(_stage,_root,_palette):void
		{
			super(_stage,_root,_palette);
			name = 'RoundBrush';
		}
		
		override public function init_filters():Array
		{
			// Dim Glow
			var glow:GlowFilter = new GlowFilter();
			glow.color = 0xCCCCCC;
			glow.alpha = 0.15;
			glow.blurX = 25;
			glow.blurY = 25;
			
			return [glow];
		}
		
		override public function draw_line(e:MouseEvent):void
		{	
			if (is_first) {
				// Move to current mouse position
				moveTo(e.stageX,e.stageY);
				is_first = false;
			}	
	
			var colour = palette[random(palette_max,true)];
			var _size = size + random(size * 2);
			
			// Change the alpha for the circle
			lineStyle(_size, colour,alpha,true,'normal','round');
			curveTo(e.stageX,e.stageY,e.stageX + random(curve),e.stageY + random(curve));
			
			e.updateAfterEvent();
		}		
	}
}