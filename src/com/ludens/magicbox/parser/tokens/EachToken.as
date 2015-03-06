package com.ludens.magicbox.parser.tokens
{
	import com.ludens.magicbox.parser.ParserConsole;
	import com.ludens.magicbox.parser.ParserContext;
	import com.ludens.magicbox.parser.ParserError;
	import com.ludens.magicbox.parser.drawingcommands.DCGroup;
	import com.ludens.magicbox.parser.drawingcommands.DrawingCommand;
	import com.ludens.magicbox.parser.drawingcommands.IDrawingCommand;

	public class EachToken implements IToken
	{
		/**
		 * can be a ListToken (directly filled with values) or 
		 * a VariableToken referring to an actionscript array
		 */
		private var _iterator:IToken;
		private var _content:IToken;
		
		public function EachToken(iterator:IToken, content:IToken)
		{
			_iterator = iterator;
			_content = content;
		}
		
		public function parseToString(context:ParserContext):String
		{
			var ret:String = "";
			// make a clone of the context
			var newContext:ParserContext = context.clone();
			
			var newDepth:int = newContext.increaseDepth();
			
			var values:Array;
			
			if(_iterator is ListToken){
				values = (_iterator as ListToken).values;
			} else if( _iterator is ListVariableToken) {
				values = (_iterator as ListVariableToken).values( context );
			} else {
				
				// ERROR: not the right type of token
				ParserConsole.traceError(
					new ParserError("Argument to Each is not a List or a valid variable", 
						ParserError.ID_INVALID_TOKEN) 
				);
			}
			
			for each( var val:IToken in values ){
				
				// don't parse listtokens. Probably don't parse any tokens at all
				if( val is ListToken ){
					newContext["_"] = val;
					
					// and add each item to the context separately 
					for(var i:int = 0; i < (val as ListToken).values.length; i++){
						newContext["___" + i] = ((val as ListToken).values[i] as IToken).parseToString( context );
					}
					newContext["___length"] = (val as ListToken).values.length;
					
				} else { 
					newContext["_"] = val.parseToString( context );
				}

				ret += _content.parseToString( newContext );
			}
			
			return ret;
		}
		
		public function parse( context:ParserContext, previous:IDrawingCommand = null  ):IDrawingCommand {
			
			// return array of drawing commands
			var ret:DCGroup = new DCGroup;
			// make a clone of the context
			var newContext:ParserContext = context.clone();
			
			var newDepth:int = newContext.increaseDepth();
			
			var values:Array;
			
			if(_iterator is ListToken){
				values = (_iterator as ListToken).values;
			} else if( _iterator is ListVariableToken) {
				values = (_iterator as ListVariableToken).values( context );
			} else {
				
				// ERROR: not the right type of token
				ParserConsole.traceError(
					new ParserError("Argument to Each is not a List or a valid variable", 
						ParserError.ID_INVALID_TOKEN) 
				);
			}
			
			for each( var val:IToken in values ){
				
				// don't parse listtokens. Probably don't parse any tokens at all
				if( val is ListToken ){
					newContext["_"] = val;
					
					// and add each item to the context separately 
					for(var i:int = 0; i < (val as ListToken).values.length; i++){
						newContext["___" + i] = ((val as ListToken).values[i] as IToken).parseToString( context );
					}
					newContext["___length"] = (val as ListToken).values.length;
					
				} else { 
					newContext["_"] = val.parseToString( context );
				}
				
				ret.push( _content.parse( newContext, previous ) );
			}
			
			return ret;
		}
		
		public function toString():String {
			return "each(" + _iterator.toString() + ") [" + _content.toString() + "]";
		}
		
		public function get type():String {
			return "EachToken";
		}
		
		
	}
	
	
}