package com.ludens.magicbox.parser.tokens
{
	import com.ludens.magicbox.parser.ParserConsole;
	import com.ludens.magicbox.parser.ParserContext;
	import com.ludens.magicbox.parser.ParserError;
	import com.ludens.magicbox.parser.drawingcommands.DrawingCommand;
	import com.ludens.magicbox.parser.drawingcommands.IDrawingCommand;
	
	import mx.core.IToggleButton;

	/** implementation of a list (similar to an array)
	 */
	public class ListToken implements IToken
	{
		private var _values:Array;
		
		public function ListToken(values:Array)
		{
			_values = values;
		}
		
		public function parseToString(context:ParserContext):String
		{
			var ret:String = "";
			for each( var value:IToken in _values){
				ret += value.parseToString( context );
				ret += " ";
			}

			
			return ret;
			
		}
		
		public function parse( context:ParserContext, previous:IDrawingCommand = null  ):IDrawingCommand {
			return null;
		}
		
		
		public function get values():Array {
			return _values;
		}
		
		public function set values(value:Array):void{
			values = value;
		}
		
		/**
		 * parsed list function
		 */
		public function parsedValues( context:ParserContext ):Array {
			var ret:Array = new Array;
			
			for(var i:int = 0; i < _values.length; i++){
				if (_values[i] is ListToken){
					ret.push( (_values[i] as ListToken).parsedValues( context ) );
				} else if( _values[i] is ListVariableToken){
					ret.push( (_values[i] as ListVariableToken).parsedValues(context) );
				} else {
					ret.push( (_values[i] as IToken).parseToString( context ) );
				}
			}
			
			return ret;
		}
		
		/** special List functions
		 * 
		 */
		public function get length():int {
			return _values.length;
		}
		
		public function push( value:IToken ):void {
			_values.push( value );
		}
		
		public function pop( ):IToken {
			return _values.pop() as IToken;
		}
		
		/**
		 * remember, lists are 1-based
		 */
		public function value(position:int):IToken {
			if(_values.length >= position && position > 0){
				return _values[position-1] as IToken;
			} else {
				// ERROR: list value does not exist
				ParserConsole.traceError(
					new ParserError("List does not contain a value at position", 
						ParserError.ID_INVALID_LIST_VALUE, String(position))
					
				);
				
				return new ValueToken("0");
				
			}
			
		}
		
		public function toString():String {
			return _values.toString(); // not implemented
		}
		
		public function get type():String {
			return "ListToken";
		}
	}
}