package com.ludens.magicbox.parser.tokens
{
	import com.ludens.magicbox.parser.ParserContext;
	import com.ludens.magicbox.parser.drawingcommands.DCGroup;
	import com.ludens.magicbox.parser.drawingcommands.DrawingCommand;
	import com.ludens.magicbox.parser.drawingcommands.IDrawingCommand;
	import com.ludens.magicbox.parser.expressions.IntegerExpression;
	
	import flash.display.IDrawCommand;

	/** implements the repeat command
	 * 
	 * repetition starts at 1 and runs to the amount of times defined in the expression variable
	 * the value is stored in the $ variable
	 */
	public class RepeatToken implements IToken
	{
		private var _expression:IntegerExpression;
		private var _content:IToken;
		
		public function RepeatToken(expression:IntegerExpression, content:IToken )
		{
			_expression = expression;
			_content = content;
		}
		
		
		
		public function parseToString( context:ParserContext ):String
		{
			// evaluate the expression to an integer to get the right amount of repeats
			var num:int = _expression.evaluate( context );
			
			// make a clone of the context
			var newContext:ParserContext = context.clone();
			
			// increase the depth
			var newDepth:int = newContext.increaseDepth();
			
			
			// return value
			var ret:String = "";
			
			for(var i:int = 0; i < num; i++){
				// add specific variable indicators for the iterator value
				// HACK: D.eval does not accept the $ sign as a variable name
				// we really want to use it, so we pre-parse it as _, which is
				// a valid variable name
				newContext['_'] = (i + 1);
				// evaluate the content
				ret += _content.parseToString( newContext ) + " ";
				
			}
			
			return ret;
		}
		
		public function parse( context:ParserContext, previous:IDrawingCommand = null  ):IDrawingCommand {
			
			// evaluate the expression to an integer to get the right amount of repeats
			var num:int = _expression.evaluate( context );
			
			// make a clone of the context
			var newContext:ParserContext = context.clone();
			
			// increase the depth
			var newDepth:int = newContext.increaseDepth();
			
			
			// return value
			var ret:DCGroup = new DCGroup;
			
			var previousDC:IDrawingCommand = previous;
			
			for(var i:int = 0; i < num; i++){
				// add specific variable indicators for the iterator value
				// HACK: D.eval does not accept the $ sign as a variable name
				// we really want to use it, so we pre-parse it as _, which is
				// a valid variable name
				newContext['_'] = (i + 1);
				// evaluate the content
				
				var dc:IDrawingCommand = _content.parse( newContext, previousDC );
				if( dc ){
					ret.push( dc );
					previousDC = dc;
				}
				
				
			}
			
			return ret;
		}
		
		public function toString():String {
			return "repeat(" + _expression.toString() + ")[ " + _content.toString() + " ]";
		}
		
		public function get type():String {
			return "RepeatToken";
		}
	}
}