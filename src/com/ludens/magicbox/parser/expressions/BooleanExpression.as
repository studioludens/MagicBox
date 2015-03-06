package com.ludens.magicbox.parser.expressions
{
	import com.ludens.magicbox.parser.ParserConsole;
	import com.ludens.magicbox.parser.ParserContext;
	import com.ludens.magicbox.parser.ParserError;
	
	import r1.deval.D;
	import r1.deval.parser.ParseError;

	public class BooleanExpression
	{
		private var _expression:String;
		
		public function BooleanExpression(expression:String)
		{
			_expression = expression;
		}
		
		/**
		 * evaluates the expression to a boolean using D.eval function
		 * in a specific context
		 */
		public function evaluate(context:ParserContext):Boolean {
			
			try {
				var expression:String = _expression.replace(/\$/g, "_").replace(/@/g,"");
				return D.evalToBoolean( expression, context );
			} catch( e:Error ){

				ParserConsole.traceError( 
					new ParserError( 
						"The expression you used is invalid - should result in true or false", 
						ParserError.ID_BAD_EXPRESSION, 
						_expression) );
			}
			
			return false;
			
		}
		
		public function toString():String {
			return _expression;
		}
	}
}