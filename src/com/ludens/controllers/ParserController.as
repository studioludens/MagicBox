package com.ludens.controllers
{
	import com.ludens.magicbox.parser.LanguageParser;
	import com.ludens.magicbox.parser.ParserContext;
	import com.ludens.magicbox.parser.drawingcommands.DrawingCommand;
	import com.ludens.magicbox.parser.drawingcommands.IDrawingCommand;
	import com.ludens.magicbox.parser.tokens.IToken;
	import com.ludens.utils.Debug;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * this is a singleton class that simplifies use of the parser for nested objects
	 * 
	 * the ParserController simplifies the use of the Magic Box parser. 
	 * 
	 * tokenize
	 * * * * * * * * * * * * 
	 * It gives you
	 * a tokenize function to create a token tree from the selected commands. This token
	 * tree needs only updating when the initial commands change
	 * 
	 * parsing
	 * * * * * * * * * * * *
	 * evaluates a tokenized string agains a context object. Can either return:
	 * - String (SVG compatible)
	 * - DrawingCommand grouping
	 * 
	 * it allows you to access a ready-made LanguageParser object and the global execution
	 * context (ParserContext) of the current Template
	 * 
	 * 
	 */
	public class ParserController extends EventDispatcher
	{
		
		private var _context:ParserContext;

		[Bindable(event="contextChanged")]
		public function get context():ParserContext
		{
			return _context;
		}

		public function set context(value:ParserContext):void
		{
			if( _context !== value)
			{
				_context = value;
				dispatchEvent(new Event("contextChanged"));
			}
		}
		
		/**
		 * sets a variable in the context.
		 * the updateContext boolean defines if a contextChanged event should be fired
		 */
		public function setContextVariable( variableName:String, variableValue:*, updateContext:Boolean = true ):void {
			// check if the variable exists
			if( _context.hasOwnProperty( variableName ) ){
				// variable already exists
				if( !(_context[variableName] == variableValue ) ){
					// variable value changed, update!
					context[variableName] = variableValue;
					if( updateContext ) dispatchEvent(new Event("contextChanged"));
				}
			} else {
				// variable doesn't exist, create it
				context[variableName] = variableValue;
				if( updateContext ) dispatchEvent(new Event("contextChanged"));
			}
		}
		
		/**
		 * get a variable from the context
		 */
		public function getContextVariable( variableName:String ):* {
			if( _context.hasOwnProperty( variableName ) ){
				return _context[variableName];
			} else {
				Debug.print("context variable not found: " + variableName, this );
			}
		}
		
		public function hasContextVariable(variableName:String):Boolean
		{
			return _context.hasOwnProperty( variableName );
		}
		
		/**
		 * initialize the context object again
		 */
		public function clearContext( updateContext:Boolean = true):void{
			context = new ParserContext();
			if( updateContext ) dispatchEvent(new Event("contextChanged"));
			
		}
		
		/**
		 * let everybody know the context is updated
		 */
		public function updateContext():void {
			dispatchEvent(new Event("contextChanged"));
		}

		private var _parser:LanguageParser;

		[Bindable(event="parserChange")]
		public function get parser():LanguageParser
		{
			return _parser;
		}

		public function set parser(value:LanguageParser):void
		{
			if( _parser !== value)
			{
				_parser = value;
				dispatchEvent(new Event("parserChange"));
			}
		}
		
		/**
		 * get an array of function names for highlighting and such
		 */
		public function get functionNames():Array {
			return _parser.functionNames;
			
		}
		
		
		
		/**
		 * parses an expression to a string
		 * uses the current context to fill in variables and such
		 * 
		 * WARNING: this function is deprecated. Tokenize your expression first and parse
		 * it the classic way
		 *
		 */
		
		public function parseExpression( expression:String ):String {
			return parser.evaluateExpression( expression, context );
		}
		
		/**
		 * parses a text with some variables to string
		 */
		public function parseText( text:String ):String {
			return parser.simpleParse( text, context );
		}
		
		
		/**
		 * convert a command string consisting of one or more commands to a token
		 * tree for later use
		 */
		public function tokenize( commands:String, isExpression:Boolean = false ):IToken {
			if( isExpression )
				return parser.tokenizeExpression( commands );
			else
				return parser.tokenize( commands );
		}
		
		
		public function parseToString( tokens:IToken ):String {
			if( tokens ) return tokens.parseToString( context );
			else return "";
		}
		
		
		public function parseToDC( tokens:IToken ):IDrawingCommand {
			if( tokens ) return tokens.parse( context );
			else return null;
		}
		
		//----------------------------------------------------------
		//
		//	STATIC FUNCTION VERSIONS
		//
		//----------------------------------------------------------
		
		
		/**
		 * parses an expression to a string
		 * uses the current context to fill in variables and such
		 *
		 */
		
		public static function parseExpression( expression:String ):String {
			return ParserController.getInstance().parseExpression( expression );
		}
		
		
		public static function tokenize( commands:String, isExpression:Boolean = false ):IToken {
			return ParserController.getInstance().tokenize( commands, isExpression );
		}
		
		
		public static function parseToString( tokens:IToken ):String {
			return ParserController.getInstance().parseToString( tokens );
		}
		
		
		public static function parseToDC( tokens:IToken ):IDrawingCommand {
			return ParserController.getInstance().parseToDC( tokens );
		}
		
		public static function parseText( text:String ):String {
			return ParserController.getInstance().parseText( text );
		}
		
		
		
		
		//----------------------------------------------------------
		//
		//	CONSTRUCTOR
		//
		//----------------------------------------------------------
		
		
		
		public function ParserController(target:IEventDispatcher=null)
		{
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use SingletonDemo.getInstance() instead of new.");
			}
			
			parser = new LanguageParser();
			parser.initializeExternalFunctions();
			context = new ParserContext();
			
		}
		
		
		//----------------------------------------------------------
		//
		//	SINGLETON PROPERTIES AND METHODS
		//
		//----------------------------------------------------------
		
		// unique instance of CommunicationController
		private static var instance				:ParserController;
		// flag indicating whether instantiation is allowed (this is only allowed the first time, obviously)
		private static var allowInstantiation	:Boolean;
		
		/**
		 * Returns the instance of the communication controller.
		 */
		public static function getInstance():ParserController {
			
			// if we have no instance, create one
			if (instance == null) {
				allowInstantiation = true;
				instance = new ParserController();
				allowInstantiation = false;
			}
			
			
			
			return instance;
		}
		
		
	}
}