package com.regieg.brushes
{
	import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.MouseEvent;
	import flash.filters.*;
    
	public class Dots extends Line
	{		
		public function Dots(_stage,_root,_palette):void
		{
			super(_stage,_root,_palette);
			name = 'Dots';
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
			moveTo(e.stageX + 1,e.stageY + 1);
			
			// Reset the linestyle
			lineStyle(random(size), palette[random(palette_max,true)],alpha,true,'normal','round',null,0);
			lineTo(e.stageX,e.stageY);
			
			e.updateAfterEvent();
		}
	}
}