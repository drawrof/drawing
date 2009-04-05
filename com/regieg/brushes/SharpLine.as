package com.regieg.brushes
{
	import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.MouseEvent;
	import flash.filters.*;
    
	public class SharpLine extends Line
	{		
		public function SharpLine(_stage,_root,_palette):void
		{
			super(_stage,_root,_palette);
			name = 'SharpLine';
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
						
			// Reset the linestyle
			lineStyle(random(size), palette[random(palette_max,true)],alpha,true,'normal','none');
			curveTo(e.stageX,e.stageY,e.stageX + random(curve),e.stageY + random(curve));
			
			e.updateAfterEvent();
		}
	}
}