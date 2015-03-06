package com.ludens.PackageHandler.view
{
	import com.ludens.magicbox.parser.ParserConsole;
	import com.ludens.magicbox.parser.ParserError;
	import com.ludens.magicbox.parser.events.ParserDebugEvent;
	import com.ludens.magicbox.parser.events.ParserErrorEvent;
	
	import flash.events.Event;
	
	import spark.components.TextArea;
	
	public class DebugConsole extends TextArea
	{
		private var parserConsole:ParserConsole;
		
		public function DebugConsole()
		{
			super();
		}
		
		protected override function createChildren():void {
			
			super.createChildren();
			
			parserConsole = ParserConsole.getInstance();
			parserConsole.addEventListener(ParserErrorEvent.ERROR, parserErrorHandler );
			parserConsole.addEventListener(ParserErrorEvent.NEW_PARSE, parserNewHandler);
			parserConsole.addEventListener(ParserDebugEvent.DEBUG, parseDebugHandler );
			
			this.editable = false;
		}
		
		protected function parseDebugHandler(event:ParserDebugEvent):void
		{
			this.text += event.text + "\n";
		}
		
		private function parserErrorHandler(e:ParserErrorEvent):void {
			// add the error string
			this.text += "[ERROR] " + e.error.errorID + " " + e.error.message + " : " + e.error.errorString + "\n";
			// and scroll down
			
		}
		
		private function parserNewHandler(e:ParserErrorEvent):void {
			this.text = "";
		}
	}
}