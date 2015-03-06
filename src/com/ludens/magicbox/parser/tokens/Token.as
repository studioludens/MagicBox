package com.ludens.magicbox.parser.tokens
{
	import com.ludens.magicbox.parser.ParserContext;
	import com.ludens.magicbox.parser.drawingcommands.DrawingCommand;
	import com.ludens.magicbox.parser.drawingcommands.IDrawingCommand;

	public class Token implements IToken
	{
		
		public function Token()
		{
		}
		
		public function parse( context:ParserContext, previous:IDrawingCommand = null  ):IDrawingCommand {
			return null;
		}
		
		public function parseToString( context:ParserContext ):String {
			return "";
		}
	}
}