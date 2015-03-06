package com.ludens.magicbox.parser.tokens
{
	import com.ludens.magicbox.parser.ParserContext;
	import com.ludens.magicbox.parser.drawingcommands.IDrawingCommand;
	
	public class BooleanValueToken implements IToken
	{
		private var _value:Boolean;
		
		public function BooleanValueToken( value:String )
		{
			if( value == "true" ) _value = true;
			else	_value = false;
		}
		
		public function parse(context:ParserContext, previous:IDrawingCommand=null):IDrawingCommand
		{
			return null;
		}
		
		public function parseToString(context:ParserContext):String
		{
			return _value ? "true" : "false";
		}
		
		public function toString():String
		{
			return _value ? "true" : "false";
		}
		
		public function get type():String
		{
			return "BooleanValueToken";
		}
	}
}