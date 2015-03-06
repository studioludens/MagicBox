package com.ludens.magicbox.parser.drawingcommands
{
	import flash.geom.Point;

	public class DCQuadratic extends DrawingCommand
	{
		public var x1:Number, y1:Number, x:Number, y:Number;
		
		public function DCQuadratic( x1:Number, y1:Number, x:Number, y:Number, previous:IDrawingCommand = null, absolute:Boolean = false)
		{
			
			super();
			
			this.x1 = x1;
			this.y1 = y1;
			this.x = x;
			this.y = y;
			this.absolute = absolute;
			this.previous = previous;
			
			// set endPoint
			_endPoint = new Point( x, y );
		}
		
		public override function toString():String {
			return (absolute ? "Q" : "q" ) + x1 + "," + y1 + "," + x + "," + y + " ";
		}
	}
}