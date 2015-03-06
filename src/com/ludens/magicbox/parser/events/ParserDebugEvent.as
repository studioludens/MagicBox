package com.ludens.magicbox.parser.events
{
	import flash.events.Event;
	
	public class ParserDebugEvent extends Event
	{
		public var text:String;
		
		public static const DEBUG:String = "debug";
		
		public function ParserDebugEvent(type:String, text:String = "", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.text = text;
			
			super(type, bubbles, cancelable);
		}
	}
}