package com.ludens.utils
{
	import flash.utils.*;
	/** a generic debugger class that can be used to print specific debugging messages
	 * to the console, or to a text field in the interface
	 */
	public class Debug
	{
		public function Debug()
		{
		}
		
		public static function print(s:String, object:* = null):void {
			var d:Date = new Date();
			if(object){
				var className:String = getQualifiedClassName(object);
				
				if( className.lastIndexOf("::") >= 0 )
					className = className.slice(className.lastIndexOf("::") + 2);

				trace( d.hours + ":" + d.minutes + ":" + d.seconds + ":" + d.milliseconds + " [" + className + "] " + s);
			} else {
				trace(d.hours + ":" + d.minutes + ":" + d.seconds + ":" + d.milliseconds + " " + s);
			}
			
		}
	}
}