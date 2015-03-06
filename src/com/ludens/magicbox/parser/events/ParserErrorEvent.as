package com.ludens.magicbox.parser.events
{
	import com.ludens.magicbox.parser.ParserError;
	
	import flash.events.Event;
	
	public class ParserErrorEvent extends Event
	{
		public var error:ParserError;
		public static const ERROR:String = "error";
		public static const NEW_PARSE:String = "newparse";
		
		public function ParserErrorEvent(type:String, error:ParserError=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.error = error;
			//TODO: implement function
			super(type, bubbles, cancelable);
		}
	}
}