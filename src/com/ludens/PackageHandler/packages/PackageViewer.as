package com.ludens.PackageHandler.packages
{
	import com.ludens.PackageHandler.LineGenerator;
	
	import mx.containers.Canvas;

	public class PackageViewer extends Canvas
	{
		[Bindable] public var packageVariables:XML;
		[Bindable] public var packageName:String;
		
		/**
		 * WIDTH and HEIGHT
		 */
		[Bindable] public var totalWidth:Number;
		[Bindable] public var totalHeight:Number;
		
		[Bindable] public var outlineDrawing:IGeometry;
		
		public function PackageViewer()
		{
			super();
		}
		
		public function _h(length:Number, dashSize:Number = 6):String {
			return LineGenerator.dottedHorizontalLine(length, dashSize );
		}
		
		public function _v(length:Number, dashSize:Number = 6):String {
			return LineGenerator.dottedVerticalLine(length, dashSize );
		}
		
	}
}