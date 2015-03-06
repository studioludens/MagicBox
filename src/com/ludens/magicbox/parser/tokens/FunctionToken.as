package com.ludens.magicbox.parser.tokens
{
	import com.ludens.magicbox.parser.FunctionDefinition;
	import com.ludens.magicbox.parser.LanguageParser;
	import com.ludens.magicbox.parser.ParserConsole;
	import com.ludens.magicbox.parser.ParserContext;
	import com.ludens.magicbox.parser.ParserError;
	import com.ludens.magicbox.parser.drawingcommands.DrawingCommand;
	import com.ludens.magicbox.parser.drawingcommands.IDrawingCommand;
	import com.ludens.utils.BooleanUtil;
	
	import spark.primitives.Path;
	
	public class FunctionToken implements IToken
	{
		/** 
		 * a function built into the parser context (quick)
		 * - like math functions
		 */
		public static const FUNCTION_TYPE_BUILTIN:String = "builtin";
		
		/** 
		 * a function described in the magic box language
		 */
		public static const FUNCTION_TYPE_NATIVE:String = "native";
		
		/** 
		 * a function described in the magic box language
		 */
		public static const FUNCTION_TYPE_MBL:String = "mbl";
		
		/**
		 * for now, we only have 2 argument types, numbers and strings.
		 * probably lists will be useful too
		 */
		public static const ARGUMENT_TYPE_NUMBER:String = "number";
		public static const ARGUMENT_TYPE_STRING:String = "string";
		public static const ARGUMENT_TYPE_BOOLEAN:String = "boolean";
		public static const ARGUMENT_TYPE_LIST:String = "list";
		public static const ARGUMENT_TYPE_DYNAMIC:String = "dynamic";
		
		private var _name:String;
		private var _type:String;
		
		/**
		 * the arguments passed to the function. They should all be IToken objects
		 */
		private var _arguments:Array;
		
		/**	
		 * an array of the same length as _arguments describing the types of arguments
		 * passed to the function.
		 */
		private var _argumentTypes:Array;
		
		/**
		 * definition of the function in question if it's a mbl function
		 */
		private var _functionDefinition:FunctionDefinition;
		
		
		public function FunctionToken(name:String, type:String, arguments:Array, argumentTypes:Array, functionDefinition:FunctionDefinition = null)
		{
			_name = name;
			_type = type;
			_arguments = arguments;
			_argumentTypes = argumentTypes;
			
			if(functionDefinition) _functionDefinition = functionDefinition;
		}
		
		public function parseGeneral( context:ParserContext, previous:IDrawingCommand = null ):* {
			// parse the arguments. this should be an array of IToken objects
			var parsedArguments:Array = new Array;
			for( var i:int = 0; i < _arguments.length; i++){
				// parse the argument
				var argValue:String = (_arguments[i] as IToken).parseToString( context );
				
				// convert it to the right type
				if(_argumentTypes[i] == FunctionToken.ARGUMENT_TYPE_NUMBER){
					parsedArguments.push( Number(argValue) );
				} else if(_argumentTypes[i] == FunctionToken.ARGUMENT_TYPE_STRING){
					parsedArguments.push( String(argValue) );
				} else if(_argumentTypes[i] == FunctionToken.ARGUMENT_TYPE_BOOLEAN){
					parsedArguments.push( BooleanUtil.stringToBoolean(argValue) );
				} else if(_argumentTypes[i] == FunctionToken.ARGUMENT_TYPE_DYNAMIC){
					// we don't know what type of argument it is, try it
					
					if	   ( _arguments[i] is VariableToken && VariableToken(_arguments[i]).isList(context)){
						parsedArguments.push( (_arguments[i] as VariableToken).parseToListToken(context) );
					} else if ( _arguments[i] is VariableToken && !VariableToken(_arguments[i]).isList(context)){
						parsedArguments.push( Number(argValue) );
					}
					else if( _arguments[i] is ListToken ) parsedArguments.push( (_arguments[i] as ListToken) );
					else if( _arguments[i] is ListVariableToken ) parsedArguments.push( (_arguments[i] as ListVariableToken).parseToListToken(context) );
					else {
						
						parsedArguments.push( Number(argValue) );
					}
					
				} else if(_argumentTypes[i] == FunctionToken.ARGUMENT_TYPE_LIST){
					if	   ( _arguments[i] is VariableToken ) parsedArguments.push( (_arguments[i] as VariableToken).listValue( context ) );
					else if( _arguments[i] is ListToken ) parsedArguments.push( (_arguments[i] as ListToken).parsedValues( context ) );
					else if( _arguments[i] is ListVariableToken ) parsedArguments.push( (_arguments[i] as ListVariableToken).parsedValues( context ) );
					else {
						ParserConsole.traceError(
							new ParserError("Argument to the function should be a list or a list variable", 
								ParserError.ID_FUNCTION_INVALID_LIST_ARGUMENT) 
						);
						parsedArguments.push( new Array );
					}
				} else { // unknown argument type, throw an error
					// ERROR: not the right type of token
					ParserConsole.traceError(
						new ParserError("Unknown Argument type, can be 'string' or 'number' or 'boolean'", 
							ParserError.ID_FUNCTION_UNKNOWN_ARGUMENT_TYPE) 
					);
				}
			}
			
			if( _type == FunctionToken.FUNCTION_TYPE_BUILTIN){
				
				// create a function object
				var callFunction:Function = context[_name] as Function;
				
				//ParserConsole.traceDebug("Calling builtin function '" + _name + "' with " + parsedArguments.length + " arguments");
				var r:* = callFunction.apply(context, parsedArguments);
				//var ret:String = String(r);// as String;
				// call the function in the context
				
				//ParserConsole.traceDebug("Function returns '" + ret + "'");
				
				
				return r;
				
			} else if( _type == FunctionToken.FUNCTION_TYPE_MBL){
				
				// in the magic box language
				var fRet:IDrawingCommand = _functionDefinition.execute( context, parsedArguments );
				
				if( fRet ) fRet.previous = previous;
				return fRet;
				
				
			} else if( _type == FunctionToken.FUNCTION_TYPE_NATIVE){
				// do a native parse
				
				// for now, create an D.eval object and parse the string
			}
			return null;	
		}
		
		public function parseToString(context:ParserContext):String
		{
			var ret:* = parseGeneral( context );
			if( ret is DrawingCommand ){
				return (ret as DrawingCommand).toString();
			} else if( ret == null ){
				return "";
			} else {
				return String( ret );
			}
			
		}
		
		public function parse( context:ParserContext, previous:IDrawingCommand = null  ):IDrawingCommand {
			
			var ret:* = parseGeneral( context, previous );
			
			if( ret is DrawingCommand ){
				IDrawingCommand(ret).previous = previous;
				return ret;
			} else {
				return null;
			}
		}
		
		public function toString():String {
			return "function(" + _name + ")[ " + " " + _arguments.toString() + " ]";
		}
		
		public function get type():String {
			return "FunctionToken";
		}
	}
}