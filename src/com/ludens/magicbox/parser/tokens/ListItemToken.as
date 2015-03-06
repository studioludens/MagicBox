package com.ludens.magicbox.parser.tokens
{
	import com.ludens.magicbox.parser.ParserConsole;
	import com.ludens.magicbox.parser.ParserContext;
	import com.ludens.magicbox.parser.ParserError;
	import com.ludens.magicbox.parser.drawingcommands.DrawingCommand;
	import com.ludens.magicbox.parser.drawingcommands.IDrawingCommand;
	import com.ludens.magicbox.parser.expressions.IntegerExpression;
	
	/**
	 * implements the item selector.
	 * .length = the length of the list
	 * .{number} = selecting an item in the list, like list.1
	 */
	public class ListItemToken implements IToken
	{
		private var _list:IToken;
		private var _item:IntegerExpression;
		
		public function ListItemToken(list:IToken, item:IntegerExpression)
		{
			_list = list;
			_item = item;
		}
		
		public function parseGeneral( context:ParserContext):String {
			
			// check if we want the length or a specific value
			var getLength:Boolean = false;
			if( _item.expression == 'length') getLength = true;
			
			
			if( _list is ListVariableToken){
				if(getLength) 	return String((_list as ListVariableToken).length(context));
				else 			{
					var itemPos:int = _item.evaluate(context);
					var listItem:IToken = (_list as ListVariableToken).value(itemPos, context)
					return listItem.parseToString(context);
				}
			} else if( _list is ListToken){
				if( getLength ) return String((_list as ListToken).length);
				else			return (_list as ListToken).value( _item.evaluate(context) ).parseToString(context);
			} else {
				// not a valid list, give an error
				// ERROR: not a valid ListToken
				ParserConsole.traceError(
					new ParserError("Not a valid List", 
						ParserError.ID_INVALID_LIST )
					
				);
				return "";
			}
		}
		
		public function parseToString(context:ParserContext):String
		{
			return parseGeneral( context );
		}
		
		public function parseToToken( context:ParserContext ):IToken {
			// check if we want the length or a specific value
			var getLength:Boolean = false;
			if( _item.expression == 'length') getLength = true;
			
			
			if( _list is ListVariableToken){
				if(getLength) 	return new ValueToken(String((_list as ListVariableToken).length(context)));
				else 			{
					var itemPos:int = _item.evaluate(context);
					var listItem:IToken = (_list as ListVariableToken).value(itemPos, context);
					return listItem;
				}
			} else if( _list is ListToken){
				if( getLength ) return new ValueToken(String((_list as ListToken).length));
				else			return (_list as ListToken).value( _item.evaluate(context) );
			} else {
				// not a valid list, give an error
				// ERROR: not a valid ListToken
				ParserConsole.traceError(
					new ParserError("Not a valid List", 
						ParserError.ID_INVALID_LIST )
					
				);
				return null;
			}
		}
		
		public function isList( context:ParserContext ):Boolean {
			if( _list is ListVariableToken){
				return (_list as ListVariableToken).value(_item.evaluate(context), context) is ListToken;
			} else if( _list is ListToken){
				return (_list as ListToken).value( _item.evaluate(context) ) is ListToken;
			} else {
				return false;
			}
		}
		
		public function parse( context:ParserContext, previous:IDrawingCommand = null  ):IDrawingCommand {
			return null;
		}
		
		public function toString():String {
			return ""; // not implemented
		}
		
		public function get type():String {
			return "ListItemToken";
		}
	}
}