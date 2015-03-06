package com.ludens.magicbox.parser.tokens
{
	import com.ludens.magicbox.parser.*;
	import com.ludens.magicbox.parser.drawingcommands.DrawingCommand;
	import com.ludens.magicbox.parser.drawingcommands.IDrawingCommand;
	import com.ludens.utils.Debug;
	
	import r1.deval.D;
	import r1.deval.parser.ParseError;

	public class ExpressionToken implements IToken
	{
		private var _expression:String;
		
		private var _preparedExpression:String;
		
		private var _isNumber:Boolean = false;
		
		public function ExpressionToken(expression:String)
		{
			_expression = expression;
			
			// check if the expression is ony a number. if so, we don't have to parse it
			// using the D.eval parser but can just return the expression cast to a number
			var match:Array = _expression.match(/^[0-9]+(?:\.[0-9]*)?$/);
			
			if( match && match.length > 0){
				//Debug.print("expression is a number: " + _expression, this );
				_isNumber = true;
			} else {
				
				// it's not a number
				
				// prepare expression
				// change $ into _ (because D.eval cannot understand it)
				// also convert variableName.# to variableName__# 
				_preparedExpression = _expression
					.replace(/\$/g, "_")
					.replace(/@/g,"")
					.replace(/\b([a-zA-Z_]+[0-9]*)\.([0-9]+|length)\b/g,"$1__$2");
				
				// check if expression starts with /, if so, the D.eval parser crashes
				// so, remove it
				while( _preparedExpression.charAt(0) == "/" ){
					// remove first character
					_preparedExpression = _preparedExpression.slice(1);
				}
			}
			
			
			
			
			
		}
		
		public function parseGeneral( context:ParserContext ):* {
			
			var _oldExpression:String = new String(_expression);
			
			//TODO: do a check for undefined variables. Now, the system returns 'null' which is not what we want
			
			// if it's a number, just return it (saves a lot of CPU cycles!!)
			if( _isNumber ) return _expression;
			
			try {
				
				var _evaluatedExpression:Object = D.eval( _preparedExpression , context );
				
				return _evaluatedExpression;
			} catch( e:Error ){
				
				ParserConsole.traceError( 
					new ParserError( 
						"The expression you used is invalid", 
						ParserError.ID_BAD_EXPRESSION, 
						_oldExpression) );
				// just return the original value
				return _expression;
			}
			// we should not reach this
			return null;
		}
		
		public function parseToString(context:ParserContext):String
		{
			var parsed:Object = parseGeneral(context);
			if( parsed && !(parsed is Function)) return String(parsed);
			else			return "0";
			
		}
		
		public function parse( context:ParserContext, previous:IDrawingCommand = null  ):IDrawingCommand {
			parseGeneral(context);
			return null;
		}
		
		public function toString():String {
			return _expression;
		}
		
		public function get type():String {
			return "ExpressionToken";
		}
	}
}