package com.ludens.PackageHandler
{
	import com.ludens.magicbox.parser.drawingcommands.DCGroup;
	import com.ludens.magicbox.parser.drawingcommands.DCLine;
	import com.ludens.magicbox.parser.drawingcommands.DCMove;
	import com.ludens.magicbox.parser.drawingcommands.DrawingCommand;

	public class LineGenerator
	{
		public function LineGenerator()
		{
		}
		
		public static const DEFAULT_DASH_LENGTH:Number = 6;
		public static const DEFAULT_SPACE_LENGTH:Number = 6;
		
		/**
		 * output SVG instructions for a horizontal dotted or dashed line. This can be used when printing
		 * or manufacturing on a machine that doesn't know how to interpret the SVG dashed stroke decorators
		 * 
		 * @arg width The width of the line to draw (in units)
		 * @arg size The size of the dashes
		 */
		public static function dottedHorizontalLine(width:Number, size:Number):String {
			
			var output:String = "";
			
			var num:int = int(width / (size*2));
			var rem:Number = width % (size*2);
			
			
			for(var i:int = 0; i < Math.abs(num); i++){
				if(width < 0){ // length smaller than 0? go left!
					output += "m " + -size + ",0 ";
					output += "h " + -size + " ";
				} else {
					output += "m " + size + ",0 ";
					output += "h " + size + " ";
				}

			}
		
			output += " m " + rem + ",0 ";
			
			return output;
		}
		
		public static function dottedHorizontalLineDC(width:Number, size:Number):DrawingCommand {
			
			var output:DCGroup = new DCGroup();
			
			var num:int = int(width / (size*2));
			var rem:Number = width % (size*2);
			
			
			for(var i:int = 0; i < Math.abs(num); i++){
				if(width < 0){ // length smaller than 0? go left!
					output.move(-size, 0).hline(-size);
				} else {
					output.move(size, 0).hline(size);
				}
				
			}
			
			output.move(rem, 0);
			
			return output;
		}
		
		/**
		 * output SVG instructions for a horizontal dotted or dashed line. This can be used when printing
		 * or manufacturing on a machine that doesn't know how to interpret the SVG dashed stroke decorators
		 * 
		 * @arg width The width of the line to draw (in units)
		 * @arg size The size of the dashes
		 */
		public static function dottedVerticalLine(height:Number, size:Number):String {
			
			var output:String = "";
			
			var num:int = int(height / (size*2));
			var rem:Number = height % (size*2);
			
			
			for(var i:int = 0; i < Math.abs(num); i++){
				if(height > 0){ // length smaller than 0? go left!
					output += "m 0," + size + " ";
					output += "v " + size + " ";
				} else {
					output += "m 0," + -size + " ";
					output += "v " + -size + " ";
				}
				
			}
			
			output += " m 0," + rem + " ";
			
			return output;
		}
		
		public static function dottedVerticalLineDC(height:Number, size:Number):DrawingCommand {
			
			var output:DCGroup = new DCGroup();
			
			var num:int = int(height / (size*2));
			var rem:Number = height % (size*2);
			
			
			for(var i:int = 0; i < Math.abs(num); i++){
				if(height > 0){ // length smaller than 0? go left!
					output.move(0, size ).vline(size);
				} else {
					output.move(0, -size ).vline(-size);
				}
				
			}
			
			output.move(0, rem);
			
			return output;
		}
		
		/**
		 * output SVG instructions for a horizontal dotted or dashed line. This can be used when printing
		 * or manufacturing on a machine that doesn't know how to interpret the SVG dashed stroke decorators
		 * 
		 * @arg width The width of the line to draw (in units)
		 * @arg size The size of the dashes
		 */
		public static function dottedLine( width:Number, height:Number, dashLength:Number, spaceLength:Number = 5 ):String {
			
			var output:String = "";
			
			// total line length
			var lineLength:Number = Math.sqrt( width * width + height * height );
			
			
			// calculate the number of dashes to draw. 
			var num:int = int(lineLength / (dashLength*2));
			
			var theta:Number = Math.atan2( width, height );
			// 
			var step_x:Number = dashLength * Math.sin( theta );
			var step_y:Number = dashLength * Math.cos( theta );
			
			
			
			// calculate the remainder
			var rem:Number = lineLength % (dashLength*2);
			
			var rem_x:Number = rem * Math.sin( theta );
			var rem_y:Number = rem * Math.cos( theta );
			
			
			
			for(var i:int = 0; i < Math.abs(num); i++){
				
				
				output += "m " + step_x + "," + step_y + " ";
				output += "l " + step_x + "," + step_y + " ";
			}
				
			
			
			output += " m " + rem_x + "," + rem_y + " ";
			
			return output;
			
		}
		
		public static function dottedLineDC( width:Number, height:Number, dashLength:Number, spaceLength:Number = 5 ):DrawingCommand {
			
			var output:DCGroup = new DCGroup();
			
			// total line length
			var lineLength:Number = Math.sqrt( width * width + height * height );
			
			
			// calculate the number of dashes to draw. 
			var num:int = int(lineLength / (dashLength*2));
			
			var theta:Number = Math.atan2( width, height );
			// 
			var step_x:Number = dashLength * Math.sin( theta );
			var step_y:Number = dashLength * Math.cos( theta );
			
			
			
			// calculate the remainder
			var rem:Number = lineLength % (dashLength*2);
			
			var rem_x:Number = rem * Math.sin( theta );
			var rem_y:Number = rem * Math.cos( theta );
			
			
			
			for(var i:int = 0; i < Math.abs(num); i++){
				output.move(step_x, step_y).line(step_x,step_y);
			}

			output.move(rem_x,rem_y);
			
			return output;
			
		}

	}
}