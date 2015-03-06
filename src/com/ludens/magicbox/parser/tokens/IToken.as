package com.ludens.magicbox.parser.tokens
{
	import com.ludens.magicbox.parser.ParserContext;
	import com.ludens.magicbox.parser.drawingcommands.DrawingCommand;
	import com.ludens.magicbox.parser.drawingcommands.IDrawingCommand;

	public interface IToken
	{
		
		/**
		 * parse the token and all child tokens to a tree of drawing commands
		 */
		function parse( context:ParserContext, previous:IDrawingCommand = null ):IDrawingCommand;
		
		/**
		 * parse the token and all child tokens to an SVG compatible string
		 */
		function parseToString( context:ParserContext ):String;
		
		function toString():String;
		
		function get type():String;
	}
}