package com.ludens.magicbox.parser.tokens
{
	import com.ludens.magicbox.parser.ParserContext;
	import com.ludens.magicbox.parser.drawingcommands.DCGroup;
	import com.ludens.magicbox.parser.drawingcommands.DrawingCommand;
	import com.ludens.magicbox.parser.drawingcommands.IDrawingCommand;
	
	import flash.display.IDrawCommand;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.core.IToggleButton;

	/** this is the implementation of a group of ITokens
	 * use this to group tokens together
	 */
	public class GroupToken implements IToken
	{
		//private var _tokens:Array;
		
		private var _tokens:Array;

		[Bindable]
		public function get tokens():Array
		{
			return _tokens;
		}

		public function set tokens(value:Array):void
		{
			_tokens = value;
		}
		
		
		public function GroupToken(tokens:Array = null)
		{
			if(!tokens)
				
				_tokens = new Array;
			else
				_tokens = tokens;
		}
		
		public function parseToString(context:ParserContext):String
		{
			// loop through all the tokens in this group, parse each one and concatenate the result
			var ret:String = "";
			for(var i:int = 0; i < _tokens.length; i++){
				ret += (_tokens[i] as IToken).parseToString( context ) + " ";
			}
			
			return ret;
		}
		
		public function parse( context:ParserContext, previous:IDrawingCommand = null  ):IDrawingCommand {
			
			var ret:DCGroup = new DCGroup;
			
			// make a reference to the previous drawing command
			
			var previousDC:IDrawingCommand = previous;
			
			for(var i:int = 0; i < _tokens.length; i++){
				
				var dc:IDrawingCommand = (_tokens[i] as IToken).parse( context, previousDC );
				// only push it on the stack if it's not null
				if( dc != null ){
					ret.push( dc );
					previousDC = dc;
				}
			}
			
			return ret;
		}
		
		public function push(token:IToken):void {
			_tokens.push( token );
		}
		
		public function pop():IToken {
			return _tokens.pop() as IToken;
		}
		
		public function get length():int {
			return _tokens.length;
		}
		
		public function toString():String {
			return _tokens.toString();
		}
		
		
		public function get type():String {
			return "GroupToken";
		}
		
	}
}