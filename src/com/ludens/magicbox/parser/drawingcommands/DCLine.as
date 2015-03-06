package com.ludens.magicbox.parser.drawingcommands
{
	import flash.geom.Point;

	/**
	 * represents a line
	 */
	public class DCLine extends DrawingCommand
	{
		public var dx:Number = 0;
		public var dy:Number = 0;
		
		public function DCLine(dx:Number, dy:Number, previous:IDrawingCommand = null, absolute:Boolean = false )
		{
			super();
			
			this.dx = dx;
			this.dy = dy;
			this.absolute = absolute;
			this.previous = previous;
			
			// set endPoint
			_endPoint = new Point( dx, dy );
		}
		
		public override function toString():String {
			return (absolute ? "L" : "l" ) + dx + "," + dy + " ";
		}
		
	}
}