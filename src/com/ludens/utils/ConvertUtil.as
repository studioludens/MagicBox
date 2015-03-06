package com.ludens.utils
{
	public class ConvertUtil
	{
		public static function  hex2dec( hex:String  ) : String  {
			var bytes:Array = [];
			while( hex.length > 2 ) {
				var byte:String = hex.substr( -2 );
				hex = hex.substr(0, hex.length-2 );
				bytes.splice( 0, 0, int("0x"+byte) );
			}
			return bytes.join(" ");
		}
		
		private static function d2h( d:int ) : String {
			var c:Array = [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' ];
			if( d > 255 ) d = 255;
			var l:int = d / 16;
			var r:int = d % 16;
			return c[l]+c[r];
		}
		
		public static function dec2hex( dec:String ) : String {
			var hex:String = "#";
			var bytes:Array = dec.split(" ");
			for( var i:int = 0; i < bytes.length; i++ )
				hex += d2h( int(bytes[i]) );
			return hex;
		}
	}
}