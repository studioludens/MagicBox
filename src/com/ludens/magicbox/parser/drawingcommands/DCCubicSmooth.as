package com.ludens.magicbox.parser.drawingcommands
{
	import flash.geom.Point;

	public class DCCubicSmooth extends DrawingCommand
	{
		public var x2:Number, y2:Number, x:Number, y:Number;
		
		public function DCCubicSmooth( x2:Number, y2:Number, x:Number, y:Number, previous:IDrawingCommand = null, absolute:Boolean = false)
		{
			super();
			
			this.x2 = x2;
			this.y2 = y2;
			this.x = x;
			this.y = y;
			
			this.absolute = absolute;
			this.previous = previous;
			
			// set endPoint
			_endPoint = new Point( x, y );
		}
		
		public override function toString():String {
			return (absolute ? "S" : "s" ) + x2 + "," + y2 + "," + x + "," + y + " ";
		}
	}
}