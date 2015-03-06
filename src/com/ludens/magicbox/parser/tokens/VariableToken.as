package com.ludens.magicbox.parser.tokens
{
	import com.ludens.magicbox.parser.ParserConsole;
	import com.ludens.magicbox.parser.ParserContext;
	import com.ludens.magicbox.parser.ParserError;
	import com.ludens.magicbox.parser.drawingcommands.DrawingCommand;
	import com.ludens.magicbox.parser.drawingcommands.IDrawingCommand;
	
	/**
	 * contains the reference to a variable in the current context
	 */
	public class VariableToken implements IToken
	{
		private var _variableName:String;
		
		public function VariableToken(variableName:String)
		{
			_variableName = variableName.replace(/\$/g, "_").replace(/@/g,"");
		}
		
		public function parseToString(context:ParserContext):String
		{
			// TODO: check if this works with objects other than strings

			if(context.hasOwnProperty( _variableName )){
				if(context[_variableName] is ListToken){
					// parse as a list
					return (context[_variableName] as ListToken).parseToString( context );
				} else {
					// just return the simple value
					return context[_variableName];
				}
			} else {
				
				ParserConsole.traceError( 
					new ParserError( 
						"The variable could not be found", 
						ParserError.ID_UNKNOWN_VARIABLE, 
						_variableName) );
				//return _variableName;
				return "";
			}
		}
		
		public function parse( context:ParserContext, previous:IDrawingCommand = null  ):IDrawingCommand {
			return null;
		}
		
		public function numberValue(context:ParserContext):Number {
			return Number( context[_variableName] );
		}
		
		public function isList( context:ParserContext ):Boolean{
			if(context.hasOwnProperty( _variableName ) && context[_variableName] is ListToken) return true;
			else	return false;
		}
		
		/*
		public function parseToToken( context:ParserContext ):IToken {
			
		}
		*/
		
		public function listValue( context:ParserContext ):Array {
			if(context.hasOwnProperty( _variableName ) && context[_variableName] is ListToken){
				return (context[_variableName] as ListToken).parsedValues( context );
			} else {
				return new Array;
			}
		}
		
		/**
		 * only works if it is a list
		 */
		public function parseToListToken( context:ParserContext ):ListToken {
			if(context.hasOwnProperty( _variableName ) && context[_variableName] is ListToken){
				return (context[_variableName] as ListToken)
			} else {
				return new ListToken(new Array(Number( context[_variableName])));
			}
		}
		
		public function value(context:ParserContext):String {
			return context[_variableName];
		}
		
		public function toString():String {
			return _variableName;
		}
		
		public function get type():String {
			return "VariableToken";
		}
	}
}