package com.ludens.magicbox.parser
{
	public class ParserError extends Error
	{
		
		// encountered an unknown error
		public static const ID_UNKNOWN:int = 1001;
		
		// thrown when reaching an expression 
		public static const ID_BAD_EXPRESSION:int = 1002;
		
		// thrown when reaching too many levels of nesting
		public static const ID_TOO_MANY_NESTS:int = 1003;
		
		//  thrown when encountering an invalid token
		public static const ID_INVALID_TOKEN:int = 1004;
		
		
		
		//  thrown when encountering the wrong number of arguments
		public static const ID_WRONG_ARGUMENTS:int = 1005;
		
		// thrown when encountering an unknown variable
		public static const ID_UNKNOWN_VARIABLE:int = 1006;
		
		
		
		// thrown when encountering an unknown argument type for a function call
		public static const ID_FUNCTION_UNKNOWN_ARGUMENT_TYPE:int = 1010;
		
		// thrown when encountering a different number of arguments than the function needs
		public static const ID_FUNCTION_WRONG_ARGUMENT_COUNT:int = 1011;
		
		// thrown when we ask something from a variable that is not a valid list
		public static const ID_INVALID_LIST:int = 1020;
		
		// thrown when we ask something from a variable that is not a valid list
		public static const ID_INVALID_LIST_VALUE:int = 1021;
		
		// thrown when we ask something from a variable that is not a valid list
		public static const ID_FUNCTION_INVALID_LIST_ARGUMENT:int = 1022;
		
		
		
		// thrown when trying to assign to an invalid variable
		public static const ID_INVALID_ASSIGNMENT:int = 1030;
		
		
		// thrown when we try to create a function that already exists
		public static const ID_FUNCTION_EXISTS:int = 1040;
		
		
		public var errorString:String = "";
		
		public function ParserError(message:*="", id:*=0, errorString:String = "")
		{
			this.errorString = errorString;
			super(message, id);
			
		}
	}
}