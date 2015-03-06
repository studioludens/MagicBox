package com.ludens.PackageHandler.view.measurement
{
	import mx.containers.Canvas;
	
	public class MeasurementCanvas extends Canvas
	{

		/* Origin on X axis */
		private var _originX	:Number = 0;

		public function get originX():Number {
			return _originX;
		}

		public function set originX(value:Number):void {
			_originX = value;
		}
		
		
		/* Origin on Y axis */
		private var _originY	:Number = 0;

		public function get originY():Number {
			return _originY;
		}

		public function set originY(value:Number):void {
			_originY = value;
		}
		
		
		
		/* Scale ratio of measurements (compared to pixels) */
		private var _scaleRatio	:Number = 1;

		public function get scaleRatio():Number {
			return _scaleRatio;
		}

		public function set scaleRatio(value:Number):void {
			_scaleRatio = value;
		}

		
		public function MeasurementCanvas()
		{
			super();
		}
		
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			
		}
	}
}