/**		
 * 
 *	ColourUtils v1.00
 *	30/09/2008 12:46
 * 
 *	© JUSTIN WINDLE | soulwire ltd
 *	http://blog.soulwire.co.uk
 * 
 *  This class is licensed under Creative Commons Attribution 3.0 License:  
 *  http://creativecommons.org/licenses/by/3.0/
 * 
 *  You are free to utilise this class in any manner you see fit, but it is
 *  provided ‘as is’ without expressed or implied warranty. The author should
 *  be acknowledged and credited appropriately wherever this work is used.
 * 
 **/
package com.regieg.colour
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class ColourSampler
	{
	
		//___________________________________________________________		_____
		//————————————————————————————————————————————— CLASS MEMBERS		VALUE
		
		public static var preprocessInput:				Boolean				= true;
		
		//___________________________________________________________
		//——————————————————————————————————————————————— CONSTRUCTOR
		
		public function ColourSampler() 
		{
			var error:Error = new Error();
			
			error.name		= 'ColourUtils Error';
			error.message	= 'Do not instantiate this class';
			
			throw error;
		}
		
		//___________________________________________________________
		//——————————————————————————————————————————————————— METHODS
		
		/**
		 * Calculates whether colourA and colourB are similar within a given tolerance
		 * 
		 * @param	colour1		The first colour
		 * @param	colour2		The second colour
		 * @param	tolerance	The tolerance of the algorythm
		 * @return	Boolean		Whether the given colours a similar
		 */
		
		public static function similar( colour1:uint, colour2:uint, tolerance:Number = 0.01 ):Boolean
		{
			var RGB1:Object = Hex24ToRGB( colour1 );
			var RGB2:Object = Hex24ToRGB( colour2 );
			
			tolerance = tolerance * ( 255 * 255 * 3 ) << 0;
			
			var distance:Number = 0;
			
			distance += Math.pow( RGB1.red - RGB2.red, 2 );
			distance += Math.pow( RGB1.green - RGB2.green, 2 );
			distance += Math.pow( RGB1.blue - RGB2.blue, 2 );
			
			return distance <= tolerance;
		}
		
		/**
		 * Compares a given colour to a set of colours an evaluates whether or not
		 * the colour is sufficiently unique
		 * 
		 * @param	colour		The colour to analyse
		 * @param	colours		An array of colours to compare the colour to
		 * @param	tolerance	The tolerance of the algorythm
		 * @return	Boolean		Whether the given colour is sufficiently unique
		 */
		
		public static function different( colour:uint, colours:Array, tolerance:Number = 0.01 ):Boolean
		{
			for (var i:int = 0; i < colours.length; i++) 
			{
				if ( similar( colour, colours[i], tolerance ) )
				{
					return false;
				}
			}
			return true;
		}
		
		/**
		 * Returns an array of the most common unique colours
		 * 
		 * @param	source		The image to process
		 * @param	maximum		The maximum number of colours
		 * @param	tolerance	The tolerance of the algorythm
		 * @return	Array		An array of common unique colours
		 */
		public static function colourPalette( source:BitmapData, maximum:int = 16, tolerance:Number = 0.01 ):Array
		{
			var copy:BitmapData = source.clone();
			var palette:Array = uniqueColours( orderColours( copy ), maximum, tolerance );
			copy.dispose();
			
			return palette; 
		}
		
		/**
		 * Returns an array of unique colours up to a given maximum
		 * 
		 * @param	colours		The colours to compare
		 * @param	maximum		The maximum amount of colours to return
		 * @param	tolerance	The tolerance of the algorythm
		 * @return	Array		An array of unique colours
		 */
		
		public static function uniqueColours(colours:Array, maximum:int, tolerance:Number = 0.01 ):Array
		{
			var unique:Array = [];
			
			for (var i:int = 0; i < colours.length && unique.length < maximum; i++) 
			{
				if ( different( colours[i], unique, tolerance ) )
				{
					unique.push( colours[i] );
				}
			}
			
			return unique;
		}
		
		/**
		 * Generates and array of objects representing each colour present
		 * in an image. Each object has a 'colour' and a 'count' property
		 * 
		 * @param	source		The image to index
		 * @param	sort		Whether to sort results by their count
		 * @param	order		If sort is true, results will be sorted in this order
		 * @return	Array		An array of { colour:int, count:int } objects
		 */
		
		public static function indexColours( source:BitmapData, sort:Boolean = true, order:uint = Array.DESCENDING ):Array
		{
			if ( preprocessInput )
			{
				reduceColours( source, 64 );
			}
			
			var n:Object = {};
			var a:Array = [];
			var p:int;
			
			for (var x:int = 0; x < source.width; x++) 
			{
				for (var y:int = 0; y < source.height; y++) 
				{
					p = source.getPixel(x, y);
					n[p] ? n[p]++ : n[p] = 1;
				}
			}
			
			for (var c:String in n)
			{
				a.push ( { colour:c, count:n[c] } );
			}
			
			if ( !sort ) return a;
			
			function byCount( a:Object, b:Object ):int
			{
				if ( a.count > b.count ) return 1;
				if ( a.count < b.count ) return -1;
				return 0;
			}
			
			return a.sort( byCount, order );
		}
		
		/**
		 * Returns an array of colours ordered by how often they occur in the source image
		 * 
		 * @param	source		The image to analyse
		 * @param	order		The order to sort the results in
		 * @return	Array		An sorted array of colours
		 */
		
		public static function orderColours( source:BitmapData, order:uint = Array.DESCENDING ):Array
		{
			var colours:Array = [];
			var index:Array = indexColours( source, true, order );
			
			for (var i:int = 0; i < index.length; i++) 
			{
				colours.push( index[i].colour );
			}
			
			return colours;
		}
		
		/**
		 * Calculates the average colour in a BitmapData Object
		 * 
		 * @param	source		The BitmapData Object to analyse
		 * @return	uint		The average colour in the BitmapData
		 */
		
		public static function averageColour( source:BitmapData ):uint
		{
			var R:Number = 0;
			var G:Number = 0;
			var B:Number = 0;
			var n:Number = 0;
			var p:Number;
			
			for (var x:int = 0; x < source.width; x++) 
			{
				for (var y:int = 0; y < source.height; y++) 
				{
					p = source.getPixel(x, y);
					
					R += p >> 16 & 0xFF;
					G += p >> 8  & 0xFF;
					B += p       & 0xFF;
					
					n++
				}
			}
			
			R /= n;
			G /= n;
			B /= n;
			
			return R << 16 | G << 8 | B;
		}
		
		/**
		 * Extracts the average colours from an image by dividing the source
		 * into segments and then finding the average colour in each segment
		 * 
		 * @param	source		The source image to analyse
		 * @param	colours		The amount of colours to extract
		 * @return	Array		An array of averaged colours
		 */
		
		public static function averageColours( source:BitmapData, colours:int ):Array
		{
			var averages:Array = new Array();
			var columns:int = Math.round( Math.sqrt( colours ) );
			
			var row:int = 0;
			var col:int = 0;
			
			var x:int = 0;
			var y:int = 0;
			
			var w:int = Math.round( source.width / columns );
			var h:int = Math.round( source.height / columns );
			
			for (var i:int = 0; i < colours; i++) 
			{
				var rect:Rectangle = new Rectangle( x, y, w, h );
				
				var box:BitmapData = new BitmapData( w, h, false );
				box.copyPixels( source, rect, new Point() );
				
				averages.push( averageColour( box ) );
				box.dispose();
				
				col = i % columns;
				
				x = w * col;
				y = h * row;
				
				if ( col == columns - 1 ) row++;
			}
			
			return averages;
		}
		
		/**
		 * Reduces the input BitmapData's colour palette
		 * 
		 * @param	source	The BitmapData to change
		 * @param	colours	The number of colours to reduce the BitmapData to
		 */
		
		public static function reduceColours( source:BitmapData, colours:int = 16 ):void
		{
			var Ra:Array = new Array(256);
			var Ga:Array = new Array(256);
			var Ba:Array = new Array(256);

			var n:Number = 256 / ( colours / 3 );
			
			for (var i:int = 0; i < 256; i++)
			{
				Ba[i] = Math.floor(i / n) * n;
				Ga[i] = Ba[i] << 8;
				Ra[i] = Ga[i] << 8;
			}
			
			source.paletteMap( source, source.rect, new Point(), Ra, Ga, Ba );
		}
		
		/**
		 * Converts a 24bit Hexidecimal to a red, green, blue Object
		 * 
		 * @param	hex		A 24bit Hexidecimal to convert
		 * @return	Object	An Object containign values for red, green and blue
		 */
		
		public static function Hex24ToRGB( hex:uint ):Object
		{
			var R:Number = hex >> 16 & 0xFF;
			var G:Number = hex >> 8 & 0xFF;
			var B:Number = hex & 0xFF;
			
			return { red:R, green:G, blue:B };
		}
		
	}
	
}