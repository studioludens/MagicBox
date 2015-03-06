package com.ludens.magicbox.parser.expressions
{
	import com.ludens.magicbox.parser.ParserConsole;
	import com.ludens.magicbox.parser.ParserContext;
	import com.ludens.magicbox.parser.ParserError;
	
	import r1.deval.D;
	import r1.deval.parser.ParseError;

	/** a value object for an expression that should be evaluated as an integer
	 */
	public class IntegerExpression
	{
		private var _expression:String;
		
		
		public function IntegerExpression( expression:String )
		{
			_expression = expression;
		}
		
		public function get expression():String {
			return _expression;
		}
		
		public function evaluate( context:ParserContext ):int {

			try {
				var expression:String = _expression.replace(/\$/g, "_").replace(/@/g,"");
				return D.evalToInt( expression, context );
			} catch( e:ParseError ){
				
				
				ParserConsole.traceError( 
						new ParserError( 
							"The expression you used is invalid", 
							ParserError.ID_BAD_EXPRESSION, 
							_expression) );
			}
			
			return 0;
			
		}
		
		public function toString():String {
			return _expression; // not implemented
		}
	}
}