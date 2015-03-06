package com.ludens.magicbox.parser.tokens
{
	import com.ludens.magicbox.parser.ParserContext;
	import com.ludens.magicbox.parser.drawingcommands.DrawingCommand;
	import com.ludens.magicbox.parser.drawingcommands.IDrawingCommand;
	
	import flash.display.IDrawCommand;
	
	import mx.events.ItemClickEvent;

	/** 
	 * Token class for a Drawing Token. This can be used to store SVG instructions
	 */
	public class DrawingToken implements IToken
	{
		[Bindable] public var instruction:String;
		[Bindable] public var arguments:Array;
		
		
		private var _instruction:String;
		private var _arguments:Array;
		
		public function DrawingToken( instruction:String, arguments:Array )
		{
			_instruction = instruction;
			_arguments = arguments;
		}
		
		public function parseToString( context:ParserContext ):String
		{
			var ret:String = _instruction;
			for(var i:int = 0; i < _arguments.length; i++){
				ret += " " + (_arguments[i] as IToken).parseToString( context );
			}
			
			return ret;
		}
		
		public function parse( context:ParserContext, previous:IDrawingCommand = null ):IDrawingCommand {
			
			/*
			parse all arguments to strings as this is the only format a drawing
			command can handle
			*/
			
			var args:Array = new Array;
			for(var i:int = 0; i < _arguments.length; i++){
				args.push( (_arguments[i] as IToken).parseToString( context ) );
			}
			
			var cmd:DrawingCommand = DrawingCommand.createCommand( _instruction, args, previous );
			return cmd;
		}
		
		public function toString():String {
			return _instruction + " " + _arguments.toString();
		}
		
		public function get type():String {
			return "DrawingToken";
		}

	}
}