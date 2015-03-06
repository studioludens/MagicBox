package com.ludens.utils
{
	import com.ludens.magicbox.parser.ParserContext;
	
	import flash.geom.Point;
	
	import mx.utils.StringUtil;
	import com.ludens.magicbox.parser.*;
	
	import r1.deval.D;
	
	/**
	 * provides some useful SVG Path Utilities
	 * 
	 */
	public class SVGPathUtil
	{
		private var _pathData:String;
		
		public function SVGPathUtil()
		{
			//_pathData = pathData;
		}
		
		/**
		 * convert path data to an array
		 */
		public function pathDataToArray(value:String):Array{
			
					
			//trim whitespace at start:
			value = value.replace(/^[\s]+/, "");
			value=value.replace(/[\s]+|\-|[MmLlCcQqZzAaSsHhVvTt]/g,getReplaceValue);
			value = value.replace(/,{2,}/g, ",");
			return value.split(",");
			
		}
		
		
		/**
		* 
		* Helper function used when parsing the path data string
		**/
		private function getReplaceValue(matchedSubstring:String, itemIndex:Number, theString:String):String {	
			
			switch (matchedSubstring.charAt(0)){
				case " ":
				case ",":
				case "\t":
				case "\n":
				case "\r":
				case "\f":
					return ",";
					break;
				case "-":
					//don't put a comma in front of a negative exponent
					if (theString.charAt(itemIndex - 1).toUpperCase() == 'E') {
						return matchedSubstring;
					} else return "," + matchedSubstring;
					break;				
				default:
					if (!itemIndex){
						return matchedSubstring + ",";														
					}
					return "," + matchedSubstring + ",";	
					break;
			}
						
		}
		
		/**
    		 * parses a simple language describing parameters and a
    		 * couple of functions
    		 * 
    		 * TODO: 
    		 * - move to a seperate class
    		 * - make it less dirty
			 * - allow for nested repetition
    		 * 
    		 * explanation:
    		 * the function can interpret variable names, functions in a context
    		 * 
    		 * implements:
    		 * - { Expression } : will parse Expression string with D.evalString
    		 * - :varname / @varname : will substitute for the variable value (like logo)
    		 * - (Number String) : will repeat String Number times
    		 * - ({Expression} String) : will parse  String if Expression = true (not implemented yet)
    		 *   - example: (20 h 10 m 10,0) will get you a dashed line (20 dashes, 10mm per dash)
    		 * 
    		 * @param value: the string to be parsed
    		 * @param context: an object which will be the context of the execution
    		 * 
    		 * 
    		 * 
    		 */
    		public function parseParamString(value:String, context:Object = null):String {
    			var text:String = "";
    			
    			// initial string
				var initText:String = cleanUpParamString( value );
    			
				//trace("[PPS] clean param string: " + initText);
    			// test if we have the same number of beginning and end brackets
    			var numLeftBrackets:int = 0;
    			var numRightBrackets:int = 0;
    			
    			
    			// current position
    			var i:int = 0;
    			
    			// length of the string to parse
    			var l:int = initText.length;
    			
    			
    			
    			while(i < l){
    				var char:String = initText.charAt(i);
    				var charCode:int = initText.charCodeAt(i);
					var nextChar:String = (i+1 < l ? initText.charAt(i+1) : "");
    				// parse all the items
    				
					/**
					 * EXPRESSIONS
					 */
					
					
					/* parse the expression */
					if(char == '{'){
						
						var expressionText:String = "";
						
						// increment the counter
						
						// we have at least one left bracket
						var numBrackets:int = 1;
						
						// find the end of the expression
						// and get the expression text
						// and update the pointer
						while(numBrackets > 0 && i < l){
							i++;
							char = initText.charAt(i);
							
							if(char == '{') numBrackets++;
							if(char == '}') numBrackets--;
							
							if(numBrackets > 0)
								expressionText += char;
							
							
						}
						
						//trace("[PPS] expression text: " + expressionText);
						
						// parse the text
						expressionText = parseExpressionText( expressionText, context );
						text += expressionText;
						// we are not in an expression any more
						
						//trace("[PPS] parsed expression text: " + expressionText);
					}
					
					/**
					 * VARIABLES
					 */
					else if( char == '@' || char == ':'){
						
						// get the varible contents
						var variableName:String = "";
						
						// increment the counter
						i++;
						var firstIndex:int = i;
						// we have at least one left bracket
						
						// find the end of the variable
						// and get the variable text
						// and update the pointer
						while(char != ' ' && char != "\r" && char != "\n" && i < l){
							i++;
							char = initText.charAt(i);
						}
						variableName = initText.substring( firstIndex, i);
						
						//trace("[PPS] variableName: " + variableName);
						
						if(context && context[variableName]) {
							text += context[variableName] + " ";
						}
						
					}
					
					/**
					 * LOOPS
					 */
					
					else if(char == '('){
						// parse loop
						
						// first, parse parameter
						
						// get the varible contents
						var loopParameter:String = "";
						
						// increment the counter
						i++;
						firstIndex = i;
						// we have at least one left bracket
						
						// find the end of the variable
						// and get the variable text
						// and update the pointer
						while(char != ' ' && char != "\r" && char != "\n" && i < l){
							i++;
							char = initText.charAt(i);
						}
						loopParameter = initText.substring( firstIndex, i);

						// go and parse the loop body
						
						var loopBody:String = "";
						
						
						// we have at least one left bracket
						numBrackets = 1;
						
						// find the end of the expression
						// and get the expression text
						// and update the pointer
						while(numBrackets > 0 && i < l){
							
							char = initText.charAt(i);
							
							if(char == '(') numBrackets++;
							if(char == ')') numBrackets--;
							
							if(numBrackets > 0)
								loopBody += char;
							i++;
							
						}
						
						var loopCount:int = int(parseParamString( loopParameter, context ));
						
						//trace("[PPS] loop parameter: " + loopParameter);
						
						// then, parse loop body
						
						//trace("[PPS] loop body: " + loopBody);
						
						var j:int = 0;
						
						while(j < loopCount){
							
							var newContext:ParserContext = context.clone();
							newContext["i"] = j;
							newContext["theta"] = ( j / loopCount) * (Math.PI * 2);
							newContext["d_theta"] = ( j / loopCount) * (Math.PI * 2);
							
							/*
							context["i"] = j;
							context["theta"] = ( j / loopCount) * (Math.PI * 2);
							context["d_theta"] = ( j / loopCount) * (Math.PI * 2);
							*/
							
							text += parseParamString( loopBody, newContext );
							j++;
						}
						//

						
					}
					else {
						text += char;
					}
    				
					
					//trace("[PPS] text: " + text);
    				i++;
    			}
    			
    			
    				
    			text = checkParamString( text, numLeftBrackets, numRightBrackets );
				
    			
    			
    			// we should have a proper string now
    			
				
    			return text;
    		}
			
			/**
			 * parse the expression text using the D.eval function and return the result
			 * 
			 */
			public function parseExpressionText( text:String, context:Object ):String {
				
				var expressionText:String = text;
				// try to parse as a number first
				try {
					//trace("[PPS] expression before: " + expressionText);
					
					//var expressionAsNumber:Number = D.evalToNumber( expressionText , context );
					/*
					if(expressionAsNumber != 0){
					expressionText = String(expressionAsNumber);
					trace("[PPS] expression is Number: " + expressionAsNumber);
					} else {
					*/
					expressionText = '""+(' + expressionText + ')+""';
					expressionText = D.evalToString( expressionText , context );
					//trace("[PPS] expression is Text: " + expressionText);
					//}
				} catch( e:Error ){
					trace("[PPS] parse error: " + expressionText);
					// empty the expression
					expressionText = "";
				}
				
				return expressionText;
			}
			
			public function checkParamString( text:String, numLeftBrackets:int, numRightBrackets:int ):String {
				
				var diff:int = numLeftBrackets - numRightBrackets;
				
				
				if(diff < 0){ // too many right brackets
					// count from right to the diff - 1 right bracket }
					
					trace("[PPS] Error: Too many right backets!");
					var pos:int = text.length - 1; // set the position to the last character
					
					// work backwards to find the nth occurence
					/*
					this works by decreasing the diff every time we find a }
					when diff is 0, we get the position of that character
					and trim the string from there
					
					*/
					
					while(pos >= 0 && diff != 0){
						if(text.charAt(pos) == '}'){
							// found one
							// decrease diff
							diff++;
						}
						pos--;
					}
					
					// and truncate the string to there
					text = text.substring(0,pos);
				}
				if(diff > 0){ // too many left brackets
					// count from right to the diff - 1 left bracket {
					
					trace("[PPS] Error: Too many left backets!");
					
					pos = text.length - 1; // set the position to the last character
					
					// work backwards to find the nth occurence
					/*
					this works by decreasing the diff every time we find a {
					when diff is 0, we get the position of that character
					and trim the string from there
					
					*/
					
					while(pos >= 0 && diff != 0){
						if(text.charAt(pos) == '{'){
							// found one
							// decrease diff
							diff--;
						}
						pos--;
					}
					
					// and truncate the string to there
					text = text.substring(0,pos);
				}
				
				return text;
			}
			
			/**
			 * remove comments and other stuff from the parameter string
			 * 
			 */
			public function cleanUpParamString( text:String ):String {
				
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
			
			
			/**
			 * computes the last point when given a string of path data
			 * 
			 * e.g. after drawing a line it returs the point at which the line stops
			 * 
			 * parses all the commands one by one and each time computes the end point
			 * 
			 * TODO: optimize
			 * - we can get the last position of an absolute drawing command and go on from there
			 */
			public function computeLastPoint(pathData:String):Point{
				
				// get an array of the path data
				var pathDataArray:Array = pathDataToArray(pathData);
				
				// this point will get updated in the process
				// at the end, it's the last point that counts
				var lastPoint:Point = new Point(0,0);
				
				var length:int = pathDataArray.length;
				var i:int=0;
				
				for (;i<length;i++)
				{
					switch(pathDataArray[i])
					{
						
						case "L":
							// compute new point location
							lastPoint = new Point(pathDataArray[i+1],pathDataArray[i+2]);
							i+=2;
							//if the next item in the array is a number 
							//assume that the line is a continued array
							//so create a new line segment for each point 
							//pair until we get to another item
							if (!isNaN(Number(pathDataArray[i+1]))){
								while (!isNaN(Number(pathDataArray[i+1]))){
									// compute new point location
									lastPoint = new Point(pathDataArray[i+1],pathDataArray[i+2]);
									i += 2;
								}
							}
							break;
						
						case "l":
							// compute new point location
							lastPoint.x += Number(pathDataArray[i+1]);
							lastPoint.y += Number(pathDataArray[i+2]);
							i += 2;
							//if the next item in the array is a number 
							//assume that the line is a continued array
							//so create a new line segment for each point 
							//pair until we get to another item
							if (!isNaN(Number(pathDataArray[i+1]))){
								while (!isNaN(Number(pathDataArray[i+1]))){
									// compute new point location
									lastPoint.x += pathDataArray[i+1];
									lastPoint.y += pathDataArray[i+2];
									i += 2;
								}
							}
							break;
						case "h":
							// compute new point location
							lastPoint.x += Number(pathDataArray[i+1]);
							i += 1;
							if (!isNaN(Number(pathDataArray[i+1]))){
								while (!isNaN(Number(pathDataArray[i+1]))){
									// compute new point location
									lastPoint.x += pathDataArray[i+1];
									i += 1;
								}
							}
							break;
						case "H":
							// compute new point location
							lastPoint.x = Number(pathDataArray[i+1]);
							i += 1;
							if (!isNaN(Number(pathDataArray[i+1]))){
								while (!isNaN(Number(pathDataArray[i+1]))){
									// compute new point location
									lastPoint.x = pathDataArray[i+1];
									i += 1;
								}
							}
							break;
						case "v":
							// compute new point location
							lastPoint.y += Number(pathDataArray[i+1]);
							i += 1;
							if (!isNaN(Number(pathDataArray[i+1]))){
								while (!isNaN(Number(pathDataArray[i+1]))){
									// compute new point location
									lastPoint.y += pathDataArray[i+1];
									i += 1;
								}
							}
							break;
						case "V":
							lastPoint.y = Number(pathDataArray[i+1]);
							i += 1;
							if (!isNaN(Number(pathDataArray[i+1]))){
								while (!isNaN(Number(pathDataArray[i+1]))){
									// compute new point location
									lastPoint.y = pathDataArray[i+1];
									i += 1;
								}
							}
							break;
						case "q":
							// compute new point location
							lastPoint.x += Number(pathDataArray[i+3]);
							lastPoint.y += Number(pathDataArray[i+4]);
							i += 4;
							if (!isNaN(Number(pathDataArray[i+1]))){
								while (!isNaN(Number(pathDataArray[i+1]))){
									// compute new point location
									lastPoint.x += Number(pathDataArray[i+3]);
									lastPoint.y += Number(pathDataArray[i+4]);
									i += 4;
								}
							}
							break;
						case "Q":
							// compute new point location
							lastPoint.x = Number(pathDataArray[i+3]);
							lastPoint.y = Number(pathDataArray[i+4]);
							i += 4;
							if (!isNaN(Number(pathDataArray[i+1]))){
								while (!isNaN(Number(pathDataArray[i+1]))){
									// compute new point location
									lastPoint.x = Number(pathDataArray[i+3]);
									lastPoint.y = Number(pathDataArray[i+4]);
									i += 4;
								}
							}
							break;		
						case "t":
							// compute new point location
							lastPoint.x += Number(pathDataArray[i+1]);
							lastPoint.y += Number(pathDataArray[i+2]);
							i += 2;
							if (!isNaN(Number(pathDataArray[i+1]))){
								while (!isNaN(Number(pathDataArray[i+1]))){
									// compute new point location
									lastPoint.x += Number(pathDataArray[i+1]);
									lastPoint.y += Number(pathDataArray[i+2]);
									i += 2;
								}
							}
							break;
						case "T":
							// compute new point location
							lastPoint.x = Number(pathDataArray[i+1]);
							lastPoint.y = Number(pathDataArray[i+2]);
							
							i += 2;
							if (!isNaN(Number(pathDataArray[i+1]))){
								while (!isNaN(Number(pathDataArray[i+1]))){
									// compute new point location
									lastPoint.x = Number(pathDataArray[i+1]);
									lastPoint.y = Number(pathDataArray[i+2]);
									i += 2;
								}
							}
							break;
						case "c":
							/*
							segmentStack.push(new CubicBezierTo(
							pathDataArray[i+1],pathDataArray[i+2],
							pathDataArray[i+3],pathDataArray[i+4],
							pathDataArray[i+5],pathDataArray[i+6],null,"relative"))
							*/
							i += 6;
							if (!isNaN(Number(pathDataArray[i+1]))){
								while (!isNaN(Number(pathDataArray[i+1]))){
									/* segmentStack.push(new CubicBezierTo(
									pathDataArray[i+1],pathDataArray[i+2],
									pathDataArray[i+3],pathDataArray[i+4],
									pathDataArray[i+5],pathDataArray[i+6],null,"relative")) */
									i += 6;
								}
							}
							break;
						case "C":
							/*segmentStack.push(new CubicBezierTo(
							pathDataArray[i+1],pathDataArray[i+2],pathDataArray[i+3],
							pathDataArray[i+4],pathDataArray[i+5],pathDataArray[i+6]))*/
							i += 6;
							if (!isNaN(Number(pathDataArray[i+1]))){
								while (!isNaN(Number(pathDataArray[i+1]))){
									/* segmentStack.push(new CubicBezierTo(
									pathDataArray[i+1],pathDataArray[i+2],
									pathDataArray[i+3],pathDataArray[i+4],
									pathDataArray[i+5],pathDataArray[i+6])) */
									i += 6;
								}
							}
							break;
						case "s":
							/* segmentStack.push(new CubicBezierTo(
							0,0,pathDataArray[i+1],pathDataArray[i+2],
							pathDataArray[i+3],pathDataArray[i+4],null,"relative",true)) */
							i += 4;
							if (!isNaN(Number(pathDataArray[i+1]))){
								while (!isNaN(Number(pathDataArray[i+1]))){
									/* segmentStack.push(new CubicBezierTo(
									0,0,pathDataArray[i+1],pathDataArray[i+2],
									pathDataArray[i+3],pathDataArray[i+4],null,"relative",true)) */
									i += 4;
								}
							}
							break;
						case "S":
							/* segmentStack.push(new CubicBezierTo(
							0,0,pathDataArray[i+1],pathDataArray[i+2],
							pathDataArray[i+3],pathDataArray[i+4],null,"absolute",true)) */
							i += 4;
							if (!isNaN(Number(pathDataArray[i+1]))){
								while (!isNaN(Number(pathDataArray[i+1]))){
									/* segmentStack.push(new CubicBezierTo(
									0,0,pathDataArray[i+1],pathDataArray[i+2],
									pathDataArray[i+3],pathDataArray[i+4],null,"absolute",true)) */
									i += 4;
								}
							}
							break;
						case "a":
							/* segmentStack.push(new EllipticalArcTo(
							pathDataArray[i+1],
							pathDataArray[i+2],
							pathDataArray[i+3],
							pathDataArray[i+4],
							pathDataArray[i+5],
							pathDataArray[i+6],
							pathDataArray[i+7],null,"relative")); */
							i += 7;
							break;
						case "A":
							/* segmentStack.push(new EllipticalArcTo(
							pathDataArray[i+1],
							pathDataArray[i+2],
							pathDataArray[i+3],
							pathDataArray[i+4],
							pathDataArray[i+5],
							pathDataArray[i+6],
							pathDataArray[i+7])); */
							i += 7; 
							break;
						case "m":
							lastPoint.x = Number(pathDataArray[i+1]);
							lastPoint.y = Number(pathDataArray[i+2]);
							
							i += 2;
							
							//if the next item in the array is a number 
							//assume that the items are a continued array
							//of line segments so create a new line segment 
							//for each point pair until we get to another item
							if (!isNaN(Number(pathDataArray[i+1]))){
								while (!isNaN(Number(pathDataArray[i+1]))){
									lastPoint.x = Number(pathDataArray[i+1]);
									lastPoint.y = Number(pathDataArray[i+2]);
									i += 2;
								}
							}
							break;
						case "M":
							// compute new point location
							lastPoint = new Point(pathDataArray[i+1],pathDataArray[i+2]);
							
							i += 2;
							
							//if the next item in the array is a number 
							//assume that the items are a continued array
							//of line segments so create a new line segment 
							//for each point pair until we get to another item
							if (!isNaN(Number(pathDataArray[i+1]))){
								while (!isNaN(Number(pathDataArray[i+1]))){
									
									// compute new point location
									lastPoint = new Point(pathDataArray[i+1],pathDataArray[i+2]);
									i += 2;
								}
							}
							break;
						case "z":
						case "Z":
							/* 						segmentStack.push(new ClosePath()); */
							break;
						default:
							
							break;
					}
				}
				
				
				return lastPoint;
				
			}
			
			/**
			 * adds line breaks to path data to allow for easier reading
			 */
			public static function prettifyPathData( text:String ):String {
				
				var pos:int = 0;
				
				var output:String = "";
				
				
				// the length of the text to parse
				var l:int = text.length;
				
				while(pos < l){
					var char:String = text.charAt(pos);
					var nextChar:String = (pos+1<l ? text.charAt(pos+1) : "");
					
					// start of a 
					if( char == " " || 
						char == "," || 
						char == "\r" ||
						char == "\n" ||
						char == "\t"){
						
						output += char;
					} else if( LanguageParser.isDrawingInstruction( char ) ){
						if(pos != 0) output += "\n" + char;
						else		 output += char;
						
						// check if the next char is a space. if not, and not at the end
						// of the string, add one
						if(nextChar.length > 0 && nextChar != " ")
							output += " ";
						
					} else {
						output += char;
					}
					
					pos++;
				}
				
				return output;
				
			}

	}
}