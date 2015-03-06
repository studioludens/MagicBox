package com.ludens.magicbox.parser.tokens
{
	import com.ludens.magicbox.parser.ParserContext;
	import com.ludens.magicbox.parser.drawingcommands.DrawingCommand;
	import com.ludens.magicbox.parser.drawingcommands.IDrawingCommand;

	/** simple token that stores a value
	 */
	public class ValueToken implements IToken
	{
		private var _value:String;
		
		public function ValueToken(value:String)
		{
			_value = value;
		}
		
		public function parseToString( context:ParserContext ):String
		{
			return _value;
		}
		
		public function parse( context:ParserContext, previous:IDrawingCommand = null ):IDrawingCommand {
			return null;
		}
		
		
		public function toString():String {
			return _value;
		}
		
		public function get type():String {
			return "ValueToken";
		}
		
	}
}