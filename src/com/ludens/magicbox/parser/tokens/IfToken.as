package com.ludens.magicbox.parser.tokens
{
	import com.ludens.magicbox.parser.ParserContext;
	import com.ludens.magicbox.parser.drawingcommands.DrawingCommand;
	import com.ludens.magicbox.parser.drawingcommands.IDrawingCommand;
	import com.ludens.magicbox.parser.expressions.BooleanExpression;

	public class IfToken implements IToken
	{
		private var _expression:BooleanExpression;
		private var _ifTrue:IToken;
		private var _ifFalse:IToken;
		
		public function IfToken(expression:BooleanExpression, ifTrue:IToken, ifFalse:IToken = null)
		{
			_expression = expression;
			_ifTrue = ifTrue;
			_ifFalse = ifFalse;
		}
		
		public function parseToString( context:ParserContext ):String
		{
			
			if( _expression.evaluate( context ) ){
				return _ifTrue.parseToString( context );
			} else {
				if(_ifFalse != null) return _ifFalse.parseToString( context );
			}
			
			return "";
		}
		
		public function parse( context:ParserContext, previous:IDrawingCommand = null  ):IDrawingCommand {
			
			if( _expression.evaluate( context ) ){
				return _ifTrue.parse( context, previous );
			} else {
				if(_ifFalse != null) return _ifFalse.parse( context, previous );
			}
			
			return null;
		}
		
		public function toString():String {
			var ret:String = "if(" + _expression.toString() + ") [" + _ifTrue.toString() + " ]";
			if( _ifFalse ) {
				ret += "[ " + _ifFalse.toString() + " ]";
			}
			
			return ret;
		}
		
		public function get type():String {
			return "IfToken";
		}
	}
}