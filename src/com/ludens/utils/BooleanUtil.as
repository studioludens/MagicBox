package com.ludens.utils
{
	public class BooleanUtil
	{
		public static function stringToBoolean( value:String ):Boolean {
			switch(value) {     
				case "1":     
				case "true":     
				case "yes":         
					return true;     
				case "0":     
				case "false":     
				case "no":        
					return false;     
				default:
					return Boolean(value); 
			}
		}
		
		public static function booleanToString( value:Boolean ):String {
			if( value ){
				return "true";
			} else {
				return "false";
			}
		}
		
		
	}
}