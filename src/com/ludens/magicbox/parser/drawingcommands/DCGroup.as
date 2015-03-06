package com.ludens.magicbox.parser.drawingcommands
{
	import com.ludens.utils.Debug;
	
	import flash.geom.Point;
	
	import mx.utils.ObjectUtil;

	/**
	 * a group of drawing commands
	 */
	public class DCGroup extends DrawingCommand
	{
		/**
		 * commands represents an array of IDrawingCommands
		 */
		public var commands:Array;
		
		
		public function DCGroup( commands:Array = null, previous:IDrawingCommand = null )
		{
			if( commands){
				
				this.commands = commands;
				if( commands.length > 0 ){
					this.commands[0].previous = previous;
				}
			}
			else
				this.commands = new Array;
			
			this.previous = previous;
			
			super();
		}
		
		public function push( command:IDrawingCommand ):DCGroup {
			command.previous = last;
			commands.push( command );
			return this;
		}
		
		/**
		 * exactly the same function as push, only easier to read in code
		 */
		public function add( command:IDrawingCommand ):DCGroup {
			return push( command );
		}
		
		public function get last():IDrawingCommand {
			if( commands.length == 0 )
				// return the previous command of the group
				return previous;
			else
				return commands[commands.length-1];
		}
		
		/**
		 * override the endPoint function so we can return the endPoint of the last item in the
		 * commands array
		 */
		public override function get endPoint():Point {
			if( last ) 	return last.endPoint;
			else		return _endPoint;
		}
		
		override public function set previous(value:IDrawingCommand):void
		{
			// TODO Auto Generated method stub
			super.previous = value;
			// also update the first command in the group
			if( commands.length > 0 ){
				commands[0].previous = super.previous;
			}
		}
		
		
		
		
		public override function get poly():Array {
			
			var ret:Array = new Array;
			
			var currentPoly:Array = new Array;
			
			
			for( var i:int = 0; i < commands.length; i++ ){
				
				if( commands[i] is DCMove || commands[i] is DCClose ){
					// it's a move command, this breaks the current polygon
					// start a new one
					// for a polygon to be added to the final , it has to have at least three points
					
					//if( currentPoly.length > 3 )
					ret.push( ObjectUtil.clone( currentPoly ));
					// add the first item to the list					currentPoly = moveCommand.poly[0];
					currentPoly = new Array;
				}
				
				
				// we're just adding to the existing polygon
				var newPoly:Array = IDrawingCommand(commands[i]).poly;
				
				if( newPoly ){
					
					currentPoly = currentPoly.concat( newPoly[0] );
					
					if( newPoly.length > 1 ){
						// we have more elements, add them separately
						for( var j:int = 1; j < newPoly.length; j++ ){
							ret.push( ObjectUtil.clone( currentPoly ));
							currentPoly = new Array;
							currentPoly = currentPoly.concat( newPoly[j] );
						}
					}
					
				}
					
			}
			
			// add currentPoly to the return value
			ret.push( currentPoly );
			
			//Debug.print( "Generated poly: (" + ret.length + ") " + ret.toString(), this );
			return ret;
		}
		
		
		
		/**
		 * Shorthand drawing functions
		 * these functions make it easy to quickly build up a
		 * drawing in code. They return the whole object so can be 
		 * chainable
		 */
		
		/**
		 * draw a line
		 */
		public function line( x:Number, y:Number, absolute:Boolean = false ):DCGroup {
			push( new DCLine( x, y, last, absolute ) );
			return this;
		}
		
		/**
		 * draw a vertical line
		 */
		public function vline( height:Number, absolute:Boolean = false ):DCGroup {
			push( new DCLine( 0, height, last, absolute ) );
			return this;
		}
		
		/**
		 * draw a horizontal line
		 */
		public function hline( width:Number, absolute:Boolean = false ):DCGroup {
			push( new DCLine( width, 0, last, absolute ) );
			return this;
		}
		
		
		
		/**
		 * move the cursor
		 */
		public function move( x:Number, y:Number, absolute:Boolean = false ):DCGroup {
			push( new DCMove( x, y, last, absolute ) );
			return this;
		}
		
		/**
		 * close the shape
		 */
		public function close():DCGroup {
			push( new DCClose( last ) );
			return this;
		}
		
		/**
		 * draw an arc
		 */
		public function arc( rx:Number, ry:Number, xAxisRotation:Number, largeArcFlag:Number, sweepFlag:Number, x:Number, y:Number, absolute:Boolean = false ):DCGroup {
			push( new DCArc( rx, ry, xAxisRotation, largeArcFlag, sweepFlag, x, y, last, absolute ) );
			return this;
		}
		
		/**
		 * quadratic bezier
		 */
		public function quad( x1:Number, y1:Number, x:Number, y:Number, absolute:Boolean = false ):DCGroup {
			push( new DCQuadratic( x1, y1, x, y, last, absolute ) );
			return this;
		}
		
		/**
		 * smooth quadratic bezier
		 */
		public function squad( x:Number, y:Number, absolute:Boolean = false ):DCGroup {
			push( new DCQuadraticSmooth( x, y, last, absolute ) );
			return this;
		}
		
		/**
		 * cubic bezier
		 */
		public function cubic( x1:Number, y1:Number, x2:Number, y2:Number, x:Number, y:Number, absolute:Boolean = false ):DCGroup {
			push( new DCCubic( x1, y1, x2, y2, x, y, last, absolute ) );
			return this;
		}
		
		/**
		 * smooth cubic bezier
		 */
		public function scubic( x2:Number, y2:Number, x:Number, y:Number, absolute:Boolean = false ):DCGroup {
			push( new DCCubicSmooth( x2, y2, x, y, last, absolute ) );
			return this;
		}
		
		
		/** override functions **/
		
		public override function toString():String {
			// loop through all commands in the commands array
			var ret:String = "";
			
			for( var i:int = 0; i < commands.length; i++){
				if( commands[i] != null )
					ret += (commands[i] as DrawingCommand).toString();
			}
			return ret;
		}
	}
}