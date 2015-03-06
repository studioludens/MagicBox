package com.ludens.magicbox.parser
{
	import com.ludens.magicbox.parser.events.ParserDebugEvent;
	import com.ludens.magicbox.parser.events.ParserErrorEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/** provides support for interactive debugging of Magic Box language code
	 */
	[Event(name="error", type="com.ludens.magicbox.parser.events.ParserErrorEvent")]
	[Event(name="newparse", type="com.ludens.magicbox.parser.events.ParserErrorEvent")]
	[Event(name="debug", type="com.ludens.magicbox.parser.events.ParserDebugEvent")]
	
	public class ParserConsole extends EventDispatcher
	{
		/**
		 * Singleton Class INFO
		 */
		private static var instance:ParserConsole = new ParserConsole();
		
		
		public function ParserConsole() {
			if( instance ) throw new Error( "Singleton and can only be accessed through Singleton.getInstance()" );
		}
		
		
		public static function getInstance():ParserConsole {
			return instance;
		}
		
		public function fireErrorEvent( e:ParserError ):void {
			var evt:Event = new ParserErrorEvent(ParserErrorEvent.ERROR,e);
			dispatchEvent( evt );
		}
		
		public function fireDebugEvent( debugText:String ):void {
			var evt:Event = new ParserDebugEvent( ParserDebugEvent.DEBUG, debugText );
			dispatchEvent( evt );
		}
		
		/**
		 * start a new parsing round
		 */
		public static function startNewParse():void {
			
			var evt:Event = new ParserErrorEvent(ParserErrorEvent.NEW_PARSE);
			
			var cons:ParserConsole = ParserConsole.getInstance();
			cons.dispatchEvent( evt );
			
			
			
		}
		
		public static function traceError( e:ParserError ):void{
			
			
			
			var d:Date = new Date();
			trace( d.hours + ":" + d.minutes + ":" + d.seconds + ":" + d.milliseconds + " [ERROR] " + e.errorID + " " + e.message + " : " + e.errorString );
		
			// also outut it as an event to listen to
			var cons:ParserConsole = ParserConsole.getInstance();
			cons.fireErrorEvent(e);
			
		}
		
		public static function traceDebug( message:String, level:int = 0):void{
			var d:Date = new Date();
			trace( d.hours + ":" + d.minutes + ":" + d.seconds + ":" + d.milliseconds + " [DEBUG] " + message );
			
			var cons:ParserConsole = ParserConsole.getInstance();
			cons.fireDebugEvent( message );
		}
	}
}