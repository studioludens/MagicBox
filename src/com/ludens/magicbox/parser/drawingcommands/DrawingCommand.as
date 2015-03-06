package com.ludens.magicbox.parser.drawingcommands
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;

	/**
	 * this is an abstract class that needs to be overridden by specific drawing instructions
	 */
	public class DrawingCommand implements IDrawingCommand
	{
		
		
		
		public var absolute:Boolean = false;
		
		
		public function DrawingCommand( previous:IDrawingCommand = null )
		{
			this.previous = previous;
		}
		
		protected var _startPoint:Point = new Point(0,0);
		
		/**
		 * the end point as defined by the drawing command
		 * this will be changed by the specific drawing commands
		 */
		protected var _endPoint:Point = new Point(0,0);
		
		/**
		 * interface IDrawingCommand implementation
		 */
		
		
		
		
		
		public function get startPoint():Point {
			if( previous ) 	return previous.endPoint;
			else			return _startPoint;
			
		}
		
		public function get endPoint():Point {
			if( previous ){
				if( !absolute ) return previous.endPoint.add(_endPoint); // relative, the startPoint doesn't matter
				else			return _endPoint;
				
			}
			return _endPoint;
		}
		
		private var _previous:IDrawingCommand;
		
		public function set previous( value:IDrawingCommand ):void {
			_previous = value;
		}
		
		public function get previous():IDrawingCommand {
			return _previous;
		}
		
		
		
		public function toString():String {
			return "";
		}
		
		
		public function getBounds():Rectangle {
			return new Rectangle(startPoint.x, startPoint.y, endPoint.x, endPoint.y);
		}
		
		/**
		 * get a polygon of points from this drawing command
		 * (absolute)
		 */
		public function get poly():Array {
			if( previous )
				return new Array( [[endPoint.x, endPoint.y]] );
			else
				return new Array( [[startPoint.x, startPoint.y], [endPoint.x, endPoint.y]] );
		}
		
		/**
		 * this function creates a typed command based on the instruction parameter
		 * can be one of the SVG drawing commands
		 */
		public static function createCommand( instruction:String, arguments:Array, previous:IDrawingCommand = null ):DrawingCommand {
			
			// do some error checking on the arguments
			
			var requiredArguments:int = 0;
			switch( instruction ){
				
				// with no arguments
				case "Z":
				case "z":
					break;
				
				// with one argument
				case "H":
				case "h":
				case "V":
				case "v":
					requiredArguments = 1;
					break;
				
				// with two arguments
				case "M":
				case "m":
				case "L":
				case "l":
				case "T":
				case "t":
					requiredArguments = 2;
					break;
				
				// with four arguments
				case "S":
				case "s":
				case "Q":
				case "q":
					requiredArguments = 4;
					break;
				case "C":
				case "c":
					requiredArguments = 6;
					break;
				case "A":
				case "a":
					requiredArguments = 7;
					break;
			}
			
			// fill up the arguments array with 0's
			while( arguments.length < requiredArguments ){
				arguments.push(0);
			}
			
			switch( instruction ){
				
				/* MOVE */
				case "M":
					return new DCMove( arguments[0], arguments[1], previous, true );
					break;
				case "m":
					return new DCMove( arguments[0], arguments[1], previous, false );
					break;
				
				/* H LINE */
				case "H":
					return new DCLine( arguments[0], 0, previous, true );
					break;
				case "h":
					return new DCLine( arguments[0], 0, previous, false );
					break;
				
				/* V LINE */
				case "V":
					return new DCLine( 0, arguments[0], previous, true );
					break;
				case "v":
					return new DCLine( 0, arguments[0], previous, false );
					break;
				
				/* LINE */
				case "L":
					return new DCLine( arguments[0], arguments[1], previous, true );
					break;
				case "l":
					return new DCLine( arguments[0], arguments[1], previous, false );
					break;
				
				/* ARC */
				case "A":
					return new DCArc( 	arguments[0], 
										arguments[1], 
										arguments[2], 
										arguments[3], 
										arguments[4], 
										arguments[5],
										arguments[6],
										previous, true
										);
					break;
				case "a":
					return new DCArc( 	arguments[0], 
										arguments[1], 
										arguments[2], 
										arguments[3], 
										arguments[4], 
										arguments[5],
										arguments[6],
										previous, false
									);
					break;
				
				/* CUBIC */
				case "C":
					return new DCCubic(
										arguments[0],
										arguments[1],
										arguments[2],
										arguments[3],
										arguments[4],
										arguments[5],
										previous, true
										);
					break;
				case "c":
					return new DCCubic(
										arguments[0],
										arguments[1],
										arguments[2],
										arguments[3],
										arguments[4],
										arguments[5],
										previous, false
									);
					break;
				
				/* CUBIC SMOOTH */
				case "S":
					return new DCCubicSmooth( 
										arguments[0],
										arguments[1],
										arguments[2],
										arguments[3],
										previous, true
									);
					break;
				case "s":
					return new DCCubicSmooth( 
										arguments[0],
										arguments[1],
										arguments[2],
										arguments[3],
										previous, false
									);
					break;
				
				/* QUADRATIC */
				case "Q":
					return new DCQuadratic(
										arguments[0],
										arguments[1],
										arguments[2],
										arguments[3],
										previous, true
									);
					break;
				case "q":
					return new DCQuadratic(
										arguments[0],
										arguments[1],
										arguments[2],
										arguments[3],
										previous, false
									);
					break;
				
				/* QUADRATIC SMOOTH  */
				case "T":
					return new DCQuadraticSmooth(
										arguments[0],
										arguments[1],
										previous, true
									);
					break;
				case "t":
					return new DCQuadraticSmooth(
										arguments[0],
										arguments[1],
										previous, false
									);
					break;
				
				/* CLOSE  */
				case "Z":
				case "z":
					return new DCClose( previous );
					break;
			}
			// fall back
			// probably throw error
			return new DrawingCommand;
		}
	
		
	}
}