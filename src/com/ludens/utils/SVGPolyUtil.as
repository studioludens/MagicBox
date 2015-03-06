package com.ludens.utils
{
	import pl.bmnet.gpcas.geometry.Poly;

	/**
	 * utility class with useful functions for polygons
	 */
	public class SVGPolyUtil
	{
		public function SVGPolyUtil()
		{
		}
		
		public static function arrayToPath( poly:Array ):String {
			
			// loop through all polygons
			
			for( var i:int = 0; i < poly.length; i++){
				// this is a polygon
				
			}
			
			return "";
			
		}
		
		/**
		 * converts an array of polygons to a path
		 * 
		 * a polys is an array of poly objects
		 * a poly object is an array of points (represented as an array with
		 * 2 items)
		 */
		public static function polysToPath( polys:Array ):String {
			// loop through all polygons
			
			if( !polys ) return "";
			
			var ret:String = "";
			
			// add the coordinates to the string, use shorthand svg notation
			for( var i:int = 0; i < polys.length; i++){
				// this is a polygon
				var poly:Array = polys[i];
				// get all points in a polygon
				
				// move to the first position
				ret += "M" + poly[0][0] + "," + poly[0][1] + " L";
				for( var j:int = 1; j < poly.length; j++){
					ret += poly[j][0] + "," + poly[j][1] + " ";
				}
				// close polygon
				ret += "Z ";
				
			}
			
			return ret;
		}
	}
}