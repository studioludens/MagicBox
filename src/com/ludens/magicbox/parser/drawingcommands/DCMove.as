package com.ludens.magicbox.parser.drawingcommands
{
	import flash.geom.Point;

	/**
	 * represents a move
	 */
	public class DCMove extends DrawingCommand
	{
		public var dx:Number;
		public var dy:Number;
		
		public function DCMove( dx:Number, dy:Number, previous:IDrawingCommand = null, absolute:Boolean = false  )
		{
			this.dx = dx;
			this.dy = dy;
			this.absolute = absolute;
			this.previous = previous;
			
			// set endPoint
			_endPoint = new Point( dx, dy );
		}
		
		
		public override function toString():String {
			return (absolute ? "M" : "m" ) + dx + "," + dy + " ";
		}
		
		public override function get poly():Array {
			return new Array( [[endPoint.x, endPoint.y]] );
		}
		
	}
}