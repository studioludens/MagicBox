package com.ludens.magicbox.parser.tokens
{
	import com.ludens.magicbox.parser.ParserContext;
	import com.ludens.magicbox.parser.drawingcommands.IDrawingCommand;
	import com.ludens.utils.ClipUtil;
	import com.ludens.utils.Debug;
	import com.ludens.utils.SVGPolyUtil;
	
	/**
	 * represents a boolean operation on a path
	 * 
	 * the following keywords are used:
	 * 
	 * union
	 * difference
	 * intersection
	 * xor
	 */
	public class BooleanToken implements IToken
	{
		
		private var _type:String;
		private var _tokens:IToken;
		
		
		public function BooleanToken( tokens:IToken, type:String )
		{
			_tokens = tokens;
			_type = type;
			// probably check if it's a valid type
			
		}
		
		public function parseGeneral( context:ParserContext, previous:IDrawingCommand=null ):* {
			
			var dc:IDrawingCommand = _tokens.parse( context, previous );
			if( !dc ) return null;
			
			var poly:Array = dc.poly;
			
			var ret:* = ClipUtil.clip( _type, ClipUtil.arrayToPolys(poly) );
			
			return ret;
		}
		
		public function parse(context:ParserContext, previous:IDrawingCommand=null):IDrawingCommand
		{
			return ClipUtil.arrayToDC( parseGeneral( context, previous ) );
		}
		
		public function parseToString(context:ParserContext):String
		{
			var polys:Array = parseGeneral( context );
			//Debug.print("parseToString not implemented!", this );
			
			var ret:String = SVGPolyUtil.polysToPath( polys );
			Debug.print("parseToString : " + ret, this );
			
			return ret;
			//return null; //SVGPolyUtil.parseGeneral( context, null );
		}
		
		public function toString():String {
			return _type + "[ " + _tokens.toString() + " ]";
		}
		
		public function get type():String {
			return "BooleanToken";
		}
	}
}