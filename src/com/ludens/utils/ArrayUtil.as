package com.ludens.utils
{
	import flash.geom.Rectangle;

	public class ArrayUtil
	{
		public function ArrayUtil()
		{
		}
		
		/**
		 * generates an array with unique values, returns a shallow clone of the array
		 */
		public static function unique( array:Array ):Array {
			
			var a:Array = array.slice();
			
			a.sort();
			var i:int = 0;
			while(i < a.length) {
				while(i < a.length+1 && a[i] == a[i+1]) {
					a.splice(i, 1);
				}
				i++;
			}
			
			return a;
		}
		
		/**
		 * generates an array with unique rectangles
		 * 
		 * has a grace distance to make sure rounding errors are taken care of
		 */
		public static function uniqueRects( array:Array ):Array {
			
			var MAX_DISTANCE:Number = 0.0001;
			
			var a:Array = array.slice();
			
			a.sort();
			var i:int = 0;
			while(i < a.length) {
				
				while(	i < a.length+1 
						&& a[i+1]
						&& Math.abs( Rectangle(a[i]).x - Rectangle(a[i+1]).x ) < MAX_DISTANCE
						&& Math.abs( Rectangle(a[i]).y - Rectangle(a[i+1]).y ) < MAX_DISTANCE
						&& Math.abs( Rectangle(a[i]).width - Rectangle(a[i+1]).width ) < MAX_DISTANCE
						&& Math.abs( Rectangle(a[i]).height - Rectangle(a[i+1]).height ) < MAX_DISTANCE
					) 
				{
					a.splice(i, 1);
				}
				i++;
			}
			
			return a;
		}
	}
}