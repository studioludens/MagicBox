package com.ludens.PackageHandler.export.pdf
{
	import flash.utils.ByteArray;

	/**
	 * exports an SVG drawing to a PDF File.
	 * 
	 * uses AlivePDF
	 * 
	 * (c)2011 Alexander Rulkens, studio:ludens
	 * 
	 * 
	 */
	public class PDFExporter
	{
		private var _svg:XML;
		
		public function PDFExporter( svg:XML = null )
		{
			if( svg ) loadSVG( svg );
		}
		
		public function loadSVG( svg:XML ):void {
			// load the svg in the 
		}
		
		/**
		 * export generates a PDF document as ByteData. You can save it to the user's
		 * computer or upload it to a server
		 */
		public function export():ByteArray {
			
		}
		
	}
}