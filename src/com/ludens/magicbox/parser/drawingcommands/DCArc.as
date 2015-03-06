package com.ludens.magicbox.parser.drawingcommands
{
	import flash.geom.Point;

	/**
	 * represents an arc
	 */
	public class DCArc extends DrawingCommand
	{
		public var rx:Number, ry:Number, xAxisRotation:Number, largeArcFlag:Number, sweepFlag:Number, x:Number, y:Number;
		
		public function DCArc( rx:Number, ry:Number, xAxisRotation:Number, largeArcFlag:Number, sweepFlag:Number, x:Number, y:Number, previous:IDrawingCommand = null, absolute:Boolean = false )
		{
			super();
			
			this.rx = rx;
			this.ry = ry;
			this.xAxisRotation = xAxisRotation;
			this.largeArcFlag = largeArcFlag;
			this.sweepFlag = sweepFlag;
			this.x = x;
			this.y = y;
			this.absolute = absolute;
			this.previous = previous;
			
			// set endPoint
			_endPoint = new Point( x, y );
		}
		
		public override function toString():String {
			return (absolute ? "A" : "a" ) + "," + rx + "," + ry + " " + xAxisRotation + " " + largeArcFlag + "," + sweepFlag + " " + x + "," + y + " ";
		}
	}
}