package com.ludens.PackageHandler.view.measurement
{
	import mx.containers.Canvas;
	
	public class Ruler extends Canvas
	{
		private var stepSizes:Array = [ 1, 5, 10, 25, 50, 100 ];
		
		private var currentStepSize:Number = 10;
		
		/* origin on the ruler */
		private var _origin:Number = 0;

		public function get origin():Number {
			return _origin;
		}

		public function set origin(value:Number):void {
			_origin = value;
		}

		
		public function Ruler()
		{
			super();
		}
		
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			if( this
		}
	}
}