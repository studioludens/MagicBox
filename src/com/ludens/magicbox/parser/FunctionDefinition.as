package com.ludens.magicbox.parser
{
	import com.ludens.controllers.ParserController;
	import com.ludens.magicbox.parser.drawingcommands.DrawingCommand;
	import com.ludens.magicbox.parser.drawingcommands.IDrawingCommand;
	import com.ludens.magicbox.parser.tokens.FunctionToken;
	import com.ludens.magicbox.parser.tokens.IToken;
	import com.ludens.utils.BooleanUtil;

	/**
	 * a class to store the properties of a function definition
	 * used by the parser to check if a function exists
	 */
	public class FunctionDefinition
	{
		
		
		/** the parameters is an array of Strings describing the type
		 * of parameters
		 */
		
		private var _name:String;
		private var _code:String;
		private var _type:String;
		private var _arguments:Array = new Array;
		
		private var _tokenizedCode:IToken;
		
		
		/**
		 * initialize the function definition with an object or xml 
		 */
		public function FunctionDefinition(xml:XML = null)
		{
			
			if( xml ){
				// assign properties
				_name = xml.@name;
				_arguments = new Array;
				
				// arguments
				for each(var arg:XML in xml.arguments.argument){
					_arguments.push( { 	name: String(arg.@name),
						type: String(arg.@type),
						required: BooleanUtil.stringToBoolean( arg.@required ),
						defaultValue: String( arg.@default )
					});
				}
				
				_code = xml.code;
				_type = xml.@type;
			}
			
		}
		
		public function tokenize( parentParser:LanguageParser):IToken {
			// tokenize
			
			_tokenizedCode = parentParser.tokenize( _code );
			return _tokenizedCode;
		}
		
		/**
		 * needs an object like:
		 * { 	name: String(arg.@name),
									type: String(arg.@type),
									required: Boolean(arg.@required)
		*/
		public function addArgument( argument:Object ):void {
			_arguments.push( argument );
		}
		
		/**
		 *  return an array of argument objects
		 */
		public function get arguments():Array {
			return _arguments;
		}
		
		/**
		 * the language code for the function
		 * has to be a valid language string
		 */
		public function set code( value:String ):void {
			_code = value;
		}
		
		public function get code():String {
			return _code;
		}
		
		/**
		 * the language type for the function
		 * has to be a valid language string
		 */
		public function set type( value:String ):void {
			_type = value;
		}
		
		public function get type():String {
			return _type;
		}
		
		/**
		 * the (!unique!) identifier for the function
		 * has to be a valid name
		 */
		public function set name( value:String):void {
			_name = value;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function toXML():XML {
			var ret:XML =  new XML('<mblFunction name="' + _name + '" type="mbl" />');
			
			ret.appendChild( "<attributes/>");
			
			// parse all attributes
			ret.appendChild("<code>" + _code + "</code>");
			
			return ret;
			
		}
		
		/** execute the function with the required attributes
		 * 
		 *  should we create a new context or use the existing context?
		 *  we are now using the existing context as a base, this can result in
		 *  conflicts between variable names and function names. however, it also allows
		 *  us to write recursive functions (check if this is true)
		 */
		public function execute( context:ParserContext, argumentValues:Array):IDrawingCommand {
			
			// assign the proper values to the arguments
			
			// create a copy of the context
			var newContext:ParserContext = context.clone();
			
			// assign all variables to the context
			for(var i:int = 0; i < _arguments.length; i++){
				// TODO: probably check for the variable type
				newContext[_arguments[i].name] = argumentValues[i];
			}
			
			var parsedCommands:IDrawingCommand = _tokenizedCode.parse(newContext);
			
			// reset context
			
			//context.turtle = newContext.tu
			return parsedCommands;
			
		}
		
	}
}