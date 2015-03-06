package com.ludens.magicbox.parser.tokens
{
	import com.ludens.magicbox.parser.ParserContext;
	import com.ludens.magicbox.parser.drawingcommands.DrawingCommand;
	import com.ludens.magicbox.parser.drawingcommands.IDrawingCommand;
	
	/**
	 * a simple token that represents text
	 */
	public class TextToken implements IToken
	{
		private var _text:String;
		
		public function TextToken(text:String)
		{	
			_text = text;
		}
		
		public function parseToString(context:ParserContext):String
		{
			return _text;
		}
		
		public function parse( context:ParserContext, previous:IDrawingCommand = null ):IDrawingCommand {
			return null;
		}
		
		
		public function toString():String {
			return _text;
		}
		
		public function get type():String {
			return "TextToken";
		}
		
	}
}