package com.ludens.magicbox.parser.drawingcommands
{
	/**
	 * represents the close shape command
	 */
	public class DCClose extends DrawingCommand
	{
		public function DCClose(previous:IDrawingCommand = null)
		{
			this.previous = previous;
				
			super();
			
			// TODO: implement endPoint here. How??
		}
		
		public override function toString():String {
			return "Z ";
		}
		
		public override function get poly():Array {
			return null;
		}
		
	}
}