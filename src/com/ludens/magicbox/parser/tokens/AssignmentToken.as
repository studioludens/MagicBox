package com.ludens.magicbox.parser.tokens
{
	import com.ludens.magicbox.parser.LanguageParser;
	import com.ludens.magicbox.parser.ParserConsole;
	import com.ludens.magicbox.parser.ParserContext;
	import com.ludens.magicbox.parser.ParserError;
	import com.ludens.magicbox.parser.drawingcommands.DrawingCommand;
	import com.ludens.magicbox.parser.drawingcommands.IDrawingCommand;
	
	/**
	 * implements the assignment operator, for assigning values to variables
	 */
	public class AssignmentToken implements IToken
	{
 		
		private var _variableName:String;

		[Bindable]
		public function get variableName():String
		{
			return _variableName;
		}

		public function set variableName(value:String):void
		{
			_variableName = value;
		}

		private var _valueToken:IToken;

		[Bindable]
		public function get valueToken():IToken
		{
			return _valueToken;
		}

		public function set valueToken(value:IToken):void
		{
			_valueToken = value;
		}
		
		
		
		public function AssignmentToken(variableName:String, valueToken:IToken)
		{
			_variableName = variableName;
			_valueToken = valueToken;
		}
		
		/**
		 * this is a general parsing function that will be called on all parse paths
		 */
		public function parseGeneral(context:ParserContext):void {
			
			// do a check if we try to assign to a  function
			if( context[_variableName] is Function ){
				
				// if so, give an error, because this is
				// obviously impossible
				ParserConsole.traceError( 
					new ParserError( "Cannot assign a value to a function", ParserError.ID_INVALID_ASSIGNMENT, _variableName ));
				return;
			}
			// do the assignment
			var value:String = _valueToken.parseToString( context );
			
			// if it's a list token, don't simplify the list yet
			if( _valueToken is ListToken ){
				context[_variableName] = _valueToken;
				
				// and add each item to the context separately 
				for(var i:int = 0; i < (_valueToken as ListToken).values.length; i++){
					var listItem:String = ((_valueToken as ListToken).values[i] as IToken).parseToString( context );
					if( LanguageParser.isNumber( value ) ){
						context[_variableName + "__" + i] = Number(listItem);
					} else {
						context[_variableName + "__" + i] = listItem;
					}
					
				}
				context[_variableName + "__length"] = (_valueToken as ListToken).values.length;
			} else if( _valueToken is ListItemToken ){
				if( (_valueToken as ListItemToken).isList( context ) )
					context[_variableName] = (_valueToken as ListItemToken).parseToToken( context );
				else{
					value = (_valueToken as ListItemToken).parseToString( context );
					if( LanguageParser.isNumber( value ) ){
						context[_variableName] = Number(value);
					} else {
						context[_variableName] = value;
					}
					
				}
				
			} /*else if( _valueToken is VariableToken ){
				if( (_valueToken as VariableToken).isList( context ) )
				context[_variableName] = (_valueToken as VariableToken).parseToToken( context );
				else
				context[_variableName] = (_valueToken as VariableToken).parseToString( context );
				}*/
				// preferrably set the variable as a number. 
			else if( LanguageParser.isNumber( value ) ){
				context[_variableName] = Number(value);
			} else {
				// if it's not a number
				// set it as a string
				context[_variableName] = value;
			}
		}
		
		public function parseToString(context:ParserContext):String
		{
			
			parseGeneral( context );
			
			return "";
		}
		
		public function parse( context:ParserContext, previous:IDrawingCommand = null  ):IDrawingCommand {
			
			parseGeneral( context );
			
			return null;
		}
		
		public function toString():String {
			return _variableName + "=" + _valueToken.toString();
		}
		
		public function get type():String {
			return "AssignmentToken";
		}

	}
}