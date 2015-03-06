package com.ludens.magicbox.parser.tokens
{
	import com.ludens.magicbox.parser.ParserConsole;
	import com.ludens.magicbox.parser.ParserContext;
	import com.ludens.magicbox.parser.ParserError;
	import com.ludens.magicbox.parser.drawingcommands.DrawingCommand;
	import com.ludens.magicbox.parser.drawingcommands.IDrawingCommand;
	
	/**
	 * contains the reference to an array variable in the current context
	 */
	public class ListVariableToken implements IToken
	{
		private var _variableName:String;
		
		public function ListVariableToken(variableName:String)
		{
			// remove @'s and replace $ by _
			_variableName = variableName.replace(/\$/g, "_").replace(/@/g,"");
		}
		
		public function values(context:ParserContext):Array {
			
			
			if(context[_variableName] && context[_variableName] is ListToken){
				return (context[_variableName] as ListToken).values;
			} else {
				// ERROR: not a valid ListToken
				ParserConsole.traceError(
					new ParserError("Not a valid List", 
						ParserError.ID_INVALID_LIST, _variableName)
					
				);
				
				
				return new Array;
				
			}
				
		}
		
		public function parseToListToken( context:ParserContext ):ListToken {
			if(context[_variableName] && context[_variableName] is ListToken){
				return (context[_variableName] as ListToken);
			} else {
				return null;
			}
		}
		
		
		public function value(position:int, context:ParserContext):IToken {
			if(context[_variableName] && context[_variableName] is ListToken){
				// return the item in the list
				return (context[_variableName] as ListToken).value(position);
			} else {
				// ERROR: not a valid ListToken
				ParserConsole.traceError(
					new ParserError("Not a valid List", 
						ParserError.ID_INVALID_LIST, _variableName)
					
				);
				
				
				return new ValueToken("0");
			}
		}
		
		public function parseToString(context:ParserContext):String
		{
			// check if the variable is in fact a list
			
			var _values:Array = context[_variableName] as Array;
			
			var ret:String = "";
			for each( var value:IToken in _values){
				ret += value.parseToString( context );
				ret += " ";
			}
			
			
			return ret;
		}
		
		public function parse( context:ParserContext, previous:IDrawingCommand = null ):IDrawingCommand {
			return null;
		}
		
		public function length(context:ParserContext):int {
			// return the length of the array we refer to
			if(context[_variableName] && context[_variableName] is ListToken){
				// return the item in the list
				return (context[_variableName] as ListToken).length;
			} else {
				// ERROR: not a valid ListToken
				ParserConsole.traceError(
					new ParserError("Not a valid List for operator .length", 
						ParserError.ID_INVALID_LIST, _variableName)
					
				);
				
				
				return 0;
			}
			
		}
		
		/**
		 * parsed list function
		 */
		public function parsedValues( context:ParserContext ):Array {
			var ret:Array = new Array;
			
			var _values:Array = values( context );
			
			for(var i:int = 0; i < _values.length; i++){
				if (_values[i] is ListToken){
					ret.push( (_values[i] as ListToken).parsedValues( context ) );
				} else if( _values[i] is ListVariableToken){
					ret.push( (_values[i] as ListVariableToken).parsedValues( context ) );
				} else {
					ret.push( (_values[i] as IToken).parse( context ) );
				}
			}
			
			return ret;
		}
		
		public function toString():String {
			return ""; // not implemented
		}
		
		public function get type():String {
			return "ListVariableToken";
		}
	}
}