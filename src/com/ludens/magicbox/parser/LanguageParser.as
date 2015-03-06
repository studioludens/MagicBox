package com.ludens.magicbox.parser
{
	import com.ludens.magicbox.parser.expressions.BooleanExpression;
	import com.ludens.magicbox.parser.expressions.IntegerExpression;
	import com.ludens.magicbox.parser.tokens.*;
	import com.ludens.utils.Debug;
	
	import flash.utils.ByteArray;
	
	import r1.deval.D;

	/**
	 * the main parser for the Magic Box language
	 */
	public class LanguageParser
	{
		
		/**
		 * variable containing the state of the state machine parsing the language string
		 */
		private var _state:String = "";
		private var _instructionStack:Array;
		
		/** different states of the parser
		 */
		
		private static var STATE_VARIABLE:int 	= 10;
		private static var STATE_EXPRESSION:int = 20;
		private static var STATE_REPEAT:int 	= 30;
		
		private static var STATE_REPEAT_BLOCK:int = 31;
		
		private static var STATE_DRAWING_INSTRUCTION:int = 40;
		
		
		private static var _drawingInstructions:Array = 	new Array(	"m", "M",
															"z", "Z",
															"l", "L",
															"h", "H",
															"v", "V",
															"c", "C",
															"s", "S",
															"q", "Q",
															"t", "T",
															"a", "A"
															);
		private var _reservedInstructions:Array = 	new Array( "if", "repeat", "each", "set", "define", "union", "difference", "xor", "intersection" );
		
		/**
		 * simple array of function names (for highlighting)
		 */
		private var _functionNames:Array = new Array;
		
		/**
		 * XML of function definition objects
		 */
		
		[Embed(source="assets/xml/defaultFunctions.xml", mimeType="application/octet-stream")]
		protected const FunctionsXML:Class;
		
		/**
		 * definitions of all the external functions in XML format
		 */
		private var _functionDefinitions:XMLList;
		
		/** 
		 * a list of all the functions available in the language at one time
		 */
		private var _allFunctions:Array;
		
		
		/**
		 * constructor can be initialized with a parent parser, which we will take over all the important
		 * values
		 */
		public function LanguageParser( parentParser:LanguageParser = null)
		{
			
			ParserConsole.traceDebug("LanguageParser created");
			//else
			//	ParserConsole.traceDebug("LanguageParser created for Function");
			
			
			
		}
		
		public function initializeExternalFunctions():void {
			
			// initialize the function definitions
			var byteArray:ByteArray = new FunctionsXML();
			var functionsXML:XML = new XML(byteArray.readUTFBytes(byteArray.length));
			_functionDefinitions = functionsXML.mblFunction;
			
			tokenizeExternalFunctions();
		}
		
		/** The Lexer 
		 * do a lexical analysis before the real tokenize function. This will divide the string up
		 * in easy to parse chunks. it uses a couple of rules.
		 *  a " ", "," "\r", "\t" or a "\n" will start a new token
		 * also, expressions enclosed with ( and ) will be treated as one token
		 */
		public function preTokenize( text:String ):Array {
			
			var pos:int = 0;
			var currentInstruction:String = "";
			
			// clear instruction stack
			var __instructionStack:Array = new Array;
			
			// the length of the text to parse
			var l:int = text.length;
			
			while(pos < l){
				var char:String = text.charAt(pos);
				
				
				// start of a 
				if( char == " " || 
					char == "," || 
					char == "\r" ||
					char == "\n" ||
					char == "\t"){
					
					// push the instruction on the stack
					if(currentInstruction.length > 0){
						__instructionStack.push( currentInstruction );
						currentInstruction = "";
					}
				} else if( char == '('){
					
					// push the instruction before the ( on the stack
					if(currentInstruction.length > 0){
						__instructionStack.push( currentInstruction );
						currentInstruction = "";
					}
					
					// parse the rest of the string to gather the whole expression
					// expressions can contain ( and )
					// so, we need to find a matching pair of ()
					var expressionText:String = "";
					var numBrackets:int = 1;
					
					// increase position pointer to next character
					pos++;
					
					while(numBrackets > 0 && pos < l){
						
						char = text.charAt(pos);
						
						if(char == '(') numBrackets++;
						if(char == ')') numBrackets--;
						
						if(numBrackets > 0)
							expressionText += char;
						pos++;
						
					}
					
					// we now have the whole expression 
					if(expressionText.length > 0){
						__instructionStack.push( expressionText );
						currentInstruction = "";
					} else {
						ParserConsole.traceDebug("[WARNING] Expression at position " + pos + " is empty",1);
					}
					// move the position pointer one back to get all of the next token
					// a bit of a HACK
					pos--;
					
				} else if( char == '['){
					
					// push the instruction before the [ on the stack
					if(currentInstruction.length > 0){
						__instructionStack.push( currentInstruction );
						currentInstruction = "";
					}
					
					// parse the rest of the string to gather the whole group of commands
					// groups can contain [ and ] (subgroups)
					// so, we need to find a matching pair of ()
					var groupText:String = "";
					var numSquareBrackets:int = 1;
					
					// increase position pointer to next character
					pos++;
					
					while(numSquareBrackets > 0 && pos < l){
						
						char = text.charAt(pos);
						
						if(char == '[') numSquareBrackets++;
						if(char == ']') numSquareBrackets--;
						
						if(numSquareBrackets > 0)
							groupText += char;
						pos++;
						
					}
					
					// we now have the whole group of commands 
					if(groupText.length > 0){
						__instructionStack.push( groupText );
						currentInstruction = "";
					} else {
						ParserConsole.traceDebug("[WARNING] Group at position " + pos + " is empty",1);
					}
					
					// move the position pointer one back to get all of the next token
					// a bit of a HACK
					pos--;
				} else if( char == '{'){
					// we have a List definition
						
					// push the instruction before the { on the stack
					if(currentInstruction.length > 0){
						__instructionStack.push( currentInstruction );
						currentInstruction = "";
					}
					
					// parse the rest of the string to gather the whole group of commands
					// lists can contain { and } (subgroups)
					// so, we need to find a matching pair of {}
					var listText:String = "{";
					var numListBrackets:int = 1;
					
					// increase position pointer to next character
					pos++;
					
					while(numListBrackets > 0 && pos < l){
						
						char = text.charAt(pos);
						
						if(char == '{') numListBrackets++;
						if(char == '}') numListBrackets--;
						
						if(numListBrackets > 0)
							listText += char;
						pos++;
						
					}
					
					// we now have the whole group of commands 
					if(listText.length > 0){
						__instructionStack.push( listText );
						currentInstruction = "";
					} else {
						ParserConsole.traceDebug("[WARNING] Group at position " + pos + " is empty",1);
					}
					
					// move the position pointer one back to get all of the next token
					// a bit of a HACK
					pos--;
						
				} else {
					// add the character to the current instruction
					currentInstruction += char;
				}
				
				pos++;
			}
			
			// check the last bit of the string
			if(currentInstruction.length > 0){
				__instructionStack.push( currentInstruction );
			}
			
			// we now pushed all instructions on an easy to parse stack!
			return __instructionStack;
		}
		
		public function tokenize( languageString:String ):IToken {
			
			//ParserConsole.traceDebug("LanguageParser.tokenize called on " + languageString.substr(0,10).replace("\r", "") + "...");
			
			// clean up the language string
			var text:String = removeComments( languageString );
			// create an instruction stack
			var stack:Array = preTokenize( text );
			
			var returnToken:GroupToken = new GroupToken();
			
			/* loop through all instructions in the stack and parse them one by one
			*/
			while(stack.length > 0){
				// get the first instruction from the stack (instead of pop, which gives you the last)
				var instruction:String = stack.shift();
				
				if( isDrawingInstruction( instruction ) || isCompactDrawingInstruction( instruction ) ){
					// we have a drawing instruction. 
					
					
					
					var arguments:Array = new Array;
					
					// is it compact? split it
					if( isCompactDrawingInstruction( instruction ) ){
						var simpleInstruction:String = instruction.charAt(0);
						var firstArgument:String = instruction.slice( 1 );
						
						// set the instruction
						instruction = simpleInstruction;
						// push the first argument on the argument stack
						arguments.push( parseToken( firstArgument ) );
					}
					
					//the next instructions should be 
					// arguments, until we encounter another drawing instruction or
					// special (reserved) instruction
					
					while( 	stack.length > 0 && 
							isValidDrawingArgument( stack[0] ) && 
							! ( isDrawingInstruction( stack[0] ) || isCompactDrawingInstruction( stack[0] ) || isReservedInstruction( stack[0]) || isFunction( stack[0] ) ) ){
						
						// get new argument and add it to the arguments array
						arguments.push(parseToken(stack.shift()));
					}
					
					var token:DrawingToken = new DrawingToken( instruction, arguments );
					// add to return stack
					returnToken.push( token );
					
					
				} else if( isReservedInstruction(instruction) ) {
					// it's one of the control structures
					if( 		instruction == "set"){			// set variable
						if(stack.length > 1){					// needs 2 instructions, variable to set & value
							var variable:String = stack.shift();
							var contents:String = stack.shift();
							if(isVariable( variable ) && isValidVariableAssignment( contents )){
								var contentToken:IToken = parseToken( contents );
								var assToken:AssignmentToken = new AssignmentToken( variable, contentToken );
								returnToken.push( assToken );
							} else {
								//TODO: give an error
								// because the 
								ParserConsole.traceError(
									new ParserError("Not a valid variable assignment: " + variable + " = " + contents, 
													ParserError.ID_INVALID_TOKEN) 
										);
							}
						} else {
							ParserConsole.traceError(
								new ParserError("Variable assignment, not enough arguments, need 2", 
									ParserError.ID_WRONG_ARGUMENTS) 
							);
						}
					} else if( 	instruction == "repeat"){		// repeat x times
						
						if(stack.length > 1){					// needs 2 instructions, variable to set & value
							var repeat:String = stack.shift();
							var repeatContents:String = stack.shift();
							
							// recursive parse of the contents of the [ ] block
							var repeatContentToken:IToken = tokenize( repeatContents );
							var repeatToken:RepeatToken = new RepeatToken(
																new IntegerExpression( repeat ),
																repeatContentToken );
							returnToken.push( repeatToken );
								
						} else {
							ParserConsole.traceError(
								new ParserError("Repeat instruction, not enough arguments, need 2", 
									ParserError.ID_WRONG_ARGUMENTS) 
							);
						}
					} else if(	instruction == "each"){			// loop through list
						
						if(stack.length > 1){					// needs 2 instructions, variable to set & value
							var eachVariable:String = stack.shift();
							var eachContents:String = stack.shift();
							
							// recursive parse of the contents of the [ ] block
							var eachContentToken:IToken = tokenize( eachContents );
							var eachToken:EachToken = new EachToken(
								new ListVariableToken( eachVariable ),
								eachContentToken );
							returnToken.push( eachToken );
							
						} else {
							ParserConsole.traceError(
								new ParserError("Each instruction, not enough arguments, need 2", 
									ParserError.ID_WRONG_ARGUMENTS) 
							);
						}
						
					} else if(	instruction == "if"){			// condition
						
						if(stack.length > 1){					// needs 2 instructions, variable to set & value
							
							// TODO: implement "else" block
							var ifExpressionString:String = stack.shift();
							var ifContents:String = stack.shift();
							
							// recursive parse of the contents of the [ ] block
							var ifContentToken:IToken = tokenize( ifContents );
							var ifExpression:BooleanExpression = new BooleanExpression( ifExpressionString );
							
							// check if there's an else instruction following
							var elseContentToken:IToken = null;
							
							// remove the else keyword if it exists
							if( stack[0] == 'else'){ 
								stack.shift();
								// the next instruction or set of instructions is considered the content
								// for the else
								if( stack.length > 0){
									// we have an else instruction
									// tokenize the else part
									var elseContents:String = stack.shift();
									elseContentToken = tokenize( elseContents );
								} 
							}
							
							
							
							var ifToken:IfToken = new IfToken( 
								ifExpression, 
								ifContentToken,
								elseContentToken
								);
							
							returnToken.push( ifToken );
							
						} else {
							ParserConsole.traceError(
								new ParserError("If instruction, not enough arguments, need 2", 
									ParserError.ID_WRONG_ARGUMENTS) 
							);
						}
						
					} else if ( instruction == "define"){
						/* needs 3 arguments in the stack,
						   - function name
						   - function arguments (in () )
						   - function code ( parsable code )
						*/
						if( stack.length > 2){
							
							var functionName:String = stack.shift();
							var functionArguments:String = stack.shift();
							var functionCode:String = stack.shift();
							
							if( _allFunctions[functionName] && _allFunctions[functionName].type != FunctionToken.FUNCTION_TYPE_MBL){
								// function already exists, and cannot be changed!
								ParserConsole.traceError(
									new ParserError("Function already exists:" + functionName, 
										ParserError.ID_FUNCTION_EXISTS) 
								);
							} else {
								
								// create the definition
								var functionDefinition:FunctionDefinition = new FunctionDefinition();
								
								// check if they're all valid
								if( isVariable(functionName) ){
									functionDefinition.name = functionName;
								} else {
									//throw an error
									
								}
								// set the default type
								functionDefinition.type = FunctionToken.FUNCTION_TYPE_MBL;
								
								// code
								
								functionDefinition.code = functionCode;
								
								// arguments
								
								
								// simplified function definition
								var argList:Array = preTokenize( functionArguments );
								
								// funcion arguments as objects
								
								
								for each( var argName:String in argList){
									functionDefinition.addArgument( {
										name: argName,
										required: true,
										type: "dynamic"
										
									});
								}
								
								//_functionDefinitions.appendChild( functionDefinition.toXML() );
								
								// tokenizing it, speeding it up
								functionDefinition.tokenize( this );
								
								if( !_allFunctions[functionName]){
									
									// if it doesn't exist, create it
									_allFunctions[functionName] = functionDefinition;
									// add it to the list of names (should check if it doesn't already exists!
									_functionNames.concat(functionName);
								} else {
									// if it exists, and is a mbl type, override it
									if( _allFunctions[functionName].type == FunctionToken.FUNCTION_TYPE_MBL){
										// this can potentially be dangerous, replacing an already existing function
										_allFunctions[functionName] = functionDefinition;
										// add it to the list of names (should check if it doesn't already exists!
										_functionNames.concat(functionName);
										
									}
									
								}
							}
							
						} else {
							ParserConsole.traceError(
								new ParserError("Define function, not enough arguments, need 2", 
									ParserError.ID_WRONG_ARGUMENTS) 
							);
							
						}
						
					} else if( isBooleanInstruction( instruction ) ){
						
						if(stack.length > 0){					// needs 1 instruction, a group of instructions
							var booleanContents:String = stack.shift();
							
							// recursive parse of the contents of the [ ] block
							var booleanContentToken:IToken = tokenize( booleanContents );
							var booleanToken:BooleanToken = new BooleanToken( booleanContentToken, instruction );
							returnToken.push( booleanToken );
							
						} else {
							ParserConsole.traceError(
								new ParserError("Boolean instruction, not enough arguments, need 1", 
									ParserError.ID_WRONG_ARGUMENTS) 
							);
						}
					}
				
				} else if ( isList( instruction ) ) {
					
					// it's a list
					var listToken:ListToken = tokenizeList( instruction );
					
					// add it to the output
					returnToken.push( listToken );
					
				} else if ( isFunction( instruction )){
					
					// it's a function call
					var functionToken:FunctionToken = parseFunctionArguments( instruction, stack );
					
					// add it to the output if parsing went ok
					if(functionToken) 
						returnToken.push( functionToken );
					
					
				} else if( isListItem( instruction ) ) {
					// parse list item
					
					var listItemToken:IToken = parseListItemToken( instruction );
					
					// create the token
					returnToken.push( listItemToken );
					
					
					
				} else {
					// another instruction that we don't know
					
					// for now, just push it on the stack
					if( isVariable( instruction ) ){
						returnToken.push( new VariableToken( instruction ) );
					} else if( isNumber( instruction ) ){
						returnToken.push( new ValueToken( instruction ) );
					} else if( isExpression( instruction )){
						returnToken.push(new ExpressionToken( instruction ) );
					} 
				}
				
			}
			
			// simplify the token structure.
			// if the group token only has one token in it,
			// only return that one
			if( returnToken.length == 1 ){
				return returnToken.pop();
			}
			
			// else, neatly return the groupToken
			return returnToken;
		}
		
		/**
		 * convert a string representing a list into a proper structure of tokens
		 * 
		 * a list can contain other lists. each element in the list can be a value, expression or another list
		 */
		public function tokenizeList( contents:String ):ListToken {
			// tokenize a list
			
			// remove the first { indicator from the list
			var text:String = contents.substr(1);
			
			// split a list into separate elements. each separated with a ,
			
			// but watch out, because if we encounter another { we are in a sublist
			
			var listItemText:String = "";
			var l:int = text.length; // length of the string
			
			var listValues:Array = new Array;
			var numListBrackets:int = 0;
			
			// increase position pointer to next character
			var pos:int = 0;
			
			while(pos < l){
				
				var char:String = text.charAt(pos);
				
				if(char == ',' && numListBrackets == 0){
					// we are at a splitter , so add the text up until now to the array
					listValues.push( listItemText );
					// and clear the text for the next round
					listItemText = "";
				}
				
				if(char == '{') numListBrackets++;
				if(char == '}') numListBrackets--;
				
				if(char != ',' && numListBrackets == 0)
					listItemText += char;
				
				if(numListBrackets > 0)
					listItemText += char;
				
				
				pos++;
				
			}
			
			// and add the last item to the list
			listValues.push( listItemText );
			
			// prepare the return token
			var returnToken:ListToken = new ListToken( new Array );
			
			// we should have a nice array of values, even if the array consists of list elements and such.
			
			// check it!
			//trace("[LanguageParser] tokenizeList: " + listValues.join(" | "));
			
			
			/* next step is to list all the values and apply the parser to each value
				
				this way, we can create lists in lists and lists of instructions
			*/
			for each( var value:String in listValues ){
				// parse each item in the list recursively
				returnToken.push( tokenize( value ) );
			}
			
			
			return returnToken;
		}
		
		/**
		 * tokenize all the external functions described in the functions xml
		 * this speeds up execution of the functions
		 */
		public function tokenizeExternalFunctions():void {
			// loop through the function definitions
			
			_allFunctions = new Array;
			
			//ParserConsole.traceDebug( "tokenizing external functions" );
			
			for each( var func:XML in _functionDefinitions){
				
				// create new function definition
				_allFunctions[String(func.@name)] = new FunctionDefinition( func );
				
				// check if any of them are mbl functions
				if( func.@type == 'mbl' ){

					// tokenize it, speeding it up
					( _allFunctions[String(func.@name)] as FunctionDefinition).tokenize( this );
					
				}
				// add the function name to the list of names (for highlighting)
				_functionNames.push( String(func.@name) );
			}
			
		}
		
		/** get an array of external functions
		 */
		public function get allFunctions():Array {
			return _allFunctions;
		}
		
		public function get functionNames():Array {
			return _functionNames;
		}
		
		/**
		 * get all the required arguments for this function from the stack.
		 * it returns a neat FunctionToken to be included in the parse structure
		 * if the function arguments are invalid, return null
		 * 
		 * - this function modifies the stack!!
		 */
		public function parseFunctionArguments( instruction:String, stack:Array ):FunctionToken {
			
			// get the function definition from the XML
			// has to have the right arguments, otherwise we are going to have errors!
			
			//var functionDefinition:XML = getFunctionDefinition( instruction );
			
			var functionDefinition:FunctionDefinition = _allFunctions[ instruction ];
			
			var functionName:String = functionDefinition.name;
			var functionType:String = functionDefinition.type;
			
			var args:Array = functionDefinition.arguments;
			
			// how many arguments do we need?
			var numArgs:int = args.length;
			var numReqArgs:int = 0;
			
			
			
			// get the number of required arguments
			for each( var thisArg:Object in args){
				if ( thisArg.hasOwnProperty( "required") && thisArg.required == true){
					numReqArgs++;
				}
			}
			
			var numOptionalArgs:int = numArgs - numReqArgs;
			
			
			// argument counters
			var _numArgs:int = numArgs;
			var _numOptionalArgs:int = numOptionalArgs;
			var _numReqArgs:int = numReqArgs;
			
			
			
			
			//ParserConsole.traceDebug("found a function: " + instruction + " with " + numReqArgs + " required and " + numOptionalArgs + " optional arguments");
			
			var functionArguments:Array = new Array;
			var functionArgumentTypes:Array = new Array;
			
			// check if the stack is long enough
			if(stack.length < numReqArgs){
				// stack is too small! give an error!
				ParserConsole.traceError(
					new ParserError("Function needs at least "+ numReqArgs + " arguments", 
						ParserError.ID_WRONG_ARGUMENTS, instruction) 
				);
				
				return null;
			}
			// parse the required arguments
			while(_numReqArgs > 0){
				
				var arg:String = stack.shift();
				// parse argument
				var argToken:IToken = parseToken( arg );
				// add to the argument list
				functionArguments.push( argToken );
				
				_numReqArgs--;
			}
			
			// index of optional argument - start with the first argument after the required arguments
			// this is needed to get the default value in the xml list
			var optArgumentIndex:int = numReqArgs;
			
			// now the optional arguments
			while(_numOptionalArgs > 0){
				
				var argOpt:String = "";
				
				// only go on if we have enough items on the stack
				if(stack.length == 0 || !isValidFunctionArgument(stack[0])){
					
					// get the default value
					var defaultValue:String = args[optArgumentIndex].defaultValue;
					argOpt = defaultValue;
				} else {
				
					argOpt = stack.shift();
				
				}
				
				// parse argument
				var argTokenOpt:IToken = parseToken( argOpt );
				// add to the argument list
				functionArguments.push( argTokenOpt );
				
				_numOptionalArgs--;
				// increment the index
				optArgumentIndex++;
			}
			
			// parse the argument types
			for(var j:int = 0; j < numArgs; j++){
				functionArgumentTypes.push( String(args[j].type) );
			}
			
			// create the object
			if( functionType == 'mbl' ) {
				return new FunctionToken( 	functionName, 
											functionType,
											functionArguments,
											functionArgumentTypes,
											_allFunctions[functionName] as FunctionDefinition
										);
			} else {
				return new FunctionToken( 	functionName, 
					functionType,
					functionArguments,
					functionArgumentTypes
				);
			}
			
		}
		
		/**
		 * this simply evaluates an expression, no frills. Most properties of the interfaces can
		 * be scripted and will be evaluated by this function
		 */
		public function evaluateExpression( expression:String, context:ParserContext):String {
			//ParserConsole.traceDebug( "Evaluating Expression: " + expression );
			return new ExpressionToken( expression ).parseToString( context );
		}
		
		/**
		 * this function creates an expressionToken from the expression to be later parsed
		 */
		public function tokenizeExpression( expression:String ):IToken {
			return new ExpressionToken( expression );
		}
		
		/** SIMPLE PARSE - just for parameters
		 *  in text strings
		 */
		public function simpleParse( text:String, context:ParserContext ):String {
			var ret:String = text.replace(/@([a-zA-Z_]+[a-zA-Z0-9_]*)/g, function():String{
				// return the variable value
				var val:String = arguments[1];
				if(context[val]){
					var valItem:* = context[val];
					// return rounded to two decimal places
					if(valItem is Number) return String(Math.round(valItem*100)/100);
					if(valItem is IToken) return (valItem as IToken).parseToString( context );
					if(valItem is String) return valItem;
				}
				// else just return the unparsed item
				return "@" + val;
			});
			return ret;
		}
		
		/** Utility functions **/
		
		/** creates a token based on the contents. It tries to make as simple a Token
		 *  as possible, so it starts from the ValueToken, after that the VariableToken
		 * and then the ExpressionToken
		 */
		public function parseToken( contents:String ):IToken {
			if( isBoolean( contents ) ){
				return new BooleanValueToken( contents );
			} else if( isNumber( contents ) ){
				return new ValueToken( contents );
			} else if( isVariable( contents ) ) {
				return new VariableToken( contents );
			} else if( isList( contents ) ){
				return this.tokenizeList( contents );
			} else if ( isListItem( contents ) ){
				return parseListItemToken( contents );
			} else {
				return new ExpressionToken( contents );
			}
		}
		
		/** parse the special list item operator
		 */
		public function parseListItemToken( contents:String ):ListItemToken {
			// get the two parts
			var parts:Array = contents.split(".");
			
			
			// part one has to be a list or a variable assignment
			
			var listSelectToken:IToken;
			if( isList( parts[0] )){
				listSelectToken = tokenizeList( parts[0] );
			} else if( isVariable( parts[0] ) ){
				listSelectToken = new ListVariableToken( parts[0] );
			} else {
				// this isn't supposed to happen!
				ParserConsole.traceError(
					new ParserError("List name is not valid", 
						ParserError.ID_INVALID_LIST, parts[0]) 
				);
			}
			
			// part 2 has to be a variable name, a number or 'length'
			// we don't really care, just make an IntegerExpression out of it
			var listItemExpression:IntegerExpression = new IntegerExpression( parts[1] );
			
			return new ListItemToken( listSelectToken, listItemExpression );
		}
		
		/** check if the instruction is an SVG drawing instruction **/
		public function isDrawingInstruction( instruction:String ):Boolean {
			
			for each( var instr:String in _drawingInstructions){
				if( instr == instruction) return true;
			}
			return false;
		}
		
		/** check if the instruction is an SVG drawing instruction **/
		public static function isDrawingInstruction( instruction:String ):Boolean {
			
			for each( var instr:String in _drawingInstructions){
				if( instr == instruction) return true;
			}
			return false;
		}
		
		/**
		 * check if the instruction is compact, ie L100, without a space in between
		 */
		public function isCompactDrawingInstruction( instruction:String):Boolean {
			if( instruction.length > 1 
				&& isDrawingInstruction( instruction.charAt(0)  )
				&& isNumber( instruction.slice(1) )
				)
				return true;
			else
				return false;

		}
		
		/**
		 * check if the instruction is compact, ie L100, without a space in between
		 */
		public static function isCompactDrawingInstruction( instruction:String):Boolean {
			if( instruction.length > 1 
				&& isDrawingInstruction( instruction.charAt(0)  )
				&& isNumber( instruction.slice(1) )
			)
				return true;
			else
				return false;
			
		}
		
		/** check if the instruction is a reserved instruction **/
		public function isReservedInstruction( instruction:String ):Boolean {
			
			for each( var instr:String in _reservedInstructions){
				if( instr == instruction) return true;
			}
			return false;
		}
		
		/**
		 * returns true if the instruction is one of the four boolean instructions
		 */
		public function isBooleanInstruction( instruction:String ):Boolean {
			
			if( instruction == "union" || instruction == "difference" || instruction == "intersection" || instruction == "xor" )
				return true;
			else
				return false;
		}
		
		
		/** check if the instruction is a valid argument **/
		public function isValidDrawingArgument( instruction:String ):Boolean {
			// valid drawing arguments can be variables, numbers or expressions
			return isVariable( instruction ) || isNumber( instruction ) || isExpression( instruction );
		}
		
		/** check if the instruction is a valid variable assignment **/
		public function isValidVariableAssignment( instruction:String ):Boolean {
			return isVariable( instruction ) || isNumber( instruction ) || isExpression( instruction ) || isList( instruction);
		}
		
		/** check if the instruction is a valid argument **/
		public function isValidFunctionArgument( instruction:String ):Boolean {
			// valid drawing arguments can be variables, numbers or expressions
			return !isReservedInstruction( instruction ) && !isDrawingInstruction( instruction ) && !isFunction( instruction );
		}
		
		public function isNumber( instruction:String ):Boolean{
			return !isNaN( Number(instruction) );
		}
		
		
		
		/**
		 * static version of the isNumber function.
		 */
		public static function isNumber( instruction:String ):Boolean{
			return !isNaN( Number(instruction) );
		}
		
		
		
		
		
		/**
		 * check if the instruction is a valid variable name
		 * 
		 * can contain letters, caps & _ & -
		 */
		public function isVariable( instruction:String ):Boolean {
			
			var regEx:RegExp = new RegExp( /^[a-zA-Z_]+[a-zA-Z0-9_]*$/ );
			
			// filter out instructions like M100
			if( isCompactDrawingInstruction( instruction ) ) return false;
				
			return regEx.test( instruction ) || (instruction == "$");
		}
		
		/** check if the instruction is a valid expression
		 * 
		 * 	TODO: implement a check here to see if it's actually an expression
		 */
		public function isExpression( instruction:String ):Boolean {
			return true;
		}
		
		
		/**
		 * check if the instruction is a valid boolean token
		 * ( true or false )
		 */
		public function isBoolean( instruction:String ):Boolean {
			return instruction == "true" || instruction == "false";
		}
		
		/** check if the instruction is a valid function
		 * 
		 * function definitions are stored in an array of objects
		 * _functionDefinitions
		 */
		public function isFunction( instruction:String ):Boolean {
			for each( var functionDef:FunctionDefinition in _allFunctions ){
				if( functionDef.name == instruction ){
					return true;
				}
			}
			
			return false;
			
		}
		

		
		/** get the correct function descriptor
		 */
		public function getFunctionDefinition( funcName:String ):FunctionDefinition {
			var func:FunctionDefinition;
			
			for each( var functionDef:FunctionDefinition in _allFunctions ){
				if( functionDef.name == funcName ){
					return functionDef;
				}
			}
			
			// oops, function does not exist!
			return null;
		}
		
		public function get functionDefinitions():XMLList {
			return _functionDefinitions;
		}
		
		/**
		 * check if the instruction is a list
		 * a list gone through the pre-parser starts with 
		 * { and has all the elements separated by ,
		 */
		public function isList( instruction:String ):Boolean {
			if(instruction.charAt(0) == "{") 	return true;
			else								return false;
		}
		
		/**
		 * check if the instruction is a list item
		 * it has the general shape {list}.{position}
		 * you can also get it's length, by {list}.length
		 */
		public function isListItem( instruction:String ):Boolean {
			// split the items
			if( instruction.split(".").length == 2){
				var parts:Array = instruction.split(".");
				// check part 1
				if(    ( isVariable(parts[0]) || isList(parts[0]) ) 
					&& ( isVariable(parts[1]) || isNumber( parts[1]) )
					)   return true;
				else	return false;
			} else {
				return false;
			}
		}
		/**
		 * remove comments and other stuff from the parameter string
		 * 
		 */
		public function removeComments( text:String ):String {
			
			var pos:int = 0;
			var output:String = "";
			var inComment:Boolean = false;
			
			while(pos < text.length){
				
				var char:String = text.charAt(pos);
				var charCode:int = text.charCodeAt(pos);
				
				if(char == '#'){
					// we have a comment, strip it
					inComment = true;
				}
				
				
				if(inComment && char == "\r" || char == "\n"){
					// end of comment
					inComment = false;
				}
				
				// if we're not in a comment, add this text to the output
				if(!inComment) {
					if(char == "\r" || char == "\n" || char == "\t")
						output += " ";
					else
						output += char;
				}
				
				pos++;
			}
			
			return output;
			
		}
	}
}