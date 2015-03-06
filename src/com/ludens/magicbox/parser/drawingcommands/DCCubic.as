package com.ludens.magicbox.parser.drawingcommands
{
	import flash.geom.Point;

	/**
	 * represents a cubic curve
	 */
	public class DCCubic extends DrawingCommand
	{
		public var x1:Number, y1:Number, x2:Number, y2:Number, x:Number, y:Number;
		
		public function DCCubic(x1:Number, y1:Number, x2:Number, y2:Number, x:Number, y:Number, previous:IDrawingCommand = null, absolute:Boolean = false)
		{
			this.x1 = x1;
			this.y1 = y1;
			this.x2 = x2;
			this.y2 = y2;
			this.x = x;
			this.y = y;
			this.absolute = absolute;
			this.previous = previous;
			
			// set endPoint
			_endPoint = new Point( x, y );
			
			super();
		}
		
		public override function toString():String {
			return (absolute ? "C" : "c" ) + x1 + "," + y1 + "," + x2 + "," + y2 + "," + x + "," + y + " ";
		}
	}
}