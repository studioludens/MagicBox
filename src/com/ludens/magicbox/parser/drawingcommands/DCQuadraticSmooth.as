package com.ludens.magicbox.parser.drawingcommands
{
	import flash.geom.Point;

	/**
	 * represents a smooth quadratic curve
	 */
	public class DCQuadraticSmooth extends DrawingCommand
	{
		public var x:Number, y:Number;
		
		public function DCQuadraticSmooth(x:Number, y:Number, previous:IDrawingCommand = null, absolute:Boolean = false)
		{
			
			super();
			
			this.x = x;
			this.y = y;
			this.absolute = absolute;
			this.previous = previous;
			
			// set endPoint
			_endPoint = new Point( x, y );
		}
		
		public override function toString():String {
			return (absolute ? "T" : "t" ) + "," + x + "," + y + " ";
		}
	}
}