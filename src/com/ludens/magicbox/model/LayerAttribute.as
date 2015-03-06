package com.ludens.magicbox.model
{
	import com.ludens.controllers.ParserController;
	import com.ludens.magicbox.parser.LanguageParser;
	import com.ludens.magicbox.parser.ParserConsole;
	import com.ludens.magicbox.parser.ParserContext;
	import com.ludens.magicbox.parser.tokens.IToken;
	import com.ludens.utils.Debug;
	import com.ludens.utils.MagicBoxXMLUtil;
	
	import flash.events.Event;

	/**
	 * represents an attribute of a layer
	 * because attributes can be dynamically calculated we have an intermediate object
	 * 
	 * calculated values of an object can be retreived by using the parsedAttribute attribute
	 * 
	 * the options object defines a number of objects that are necessary for a right way of caclulating the
	 * correct parsed value
	 * 
	 * - context
	 * - parser
	 * - showFill
	 * - showStroke
	 * 
	 */
	[Bindable]
	public class LayerAttribute extends DataObject
	{
		
		/**
		 * it's an attribute that should be included in the svg
		 */
		public var isSvgAttribute:Boolean = false;
		

		public var isDataAttribute:Boolean;
		
		public var isStrokeAttribute:Boolean;
		public var isStrokeTypeAttribute:Boolean;
		
		public var isFillAttribute:Boolean;
		public var isFillTypeAttribute:Boolean;
		
		
		
		public var svgName:String;
		
		
		
		/**
		 * is it static, i.e. not to be parsed?
		 */
		//protected var _static:Boolean = false;
		
		//protected var _showFill:Boolean = false;
		//protected var _showStroke:Boolean = true;
		
		
		
		public function LayerAttribute( id:String, 
										value:String )
		{
			this.id = id;
			
			svgName = MagicBoxXMLUtil.simplifyXMLAttributeName(id);
			isSvgAttribute = (isMBAttribute && !isMBInterfaceAttribute);
			
			
			initProperties();
			
			this.value = value;
			// set the dirty flag to true, so the value gets recalculated when
			// the parsedValue is retrieved
			//_valueDirty = true;
			
			// when the context has changed, the layer will update it's attribute
			ParserController.getInstance().addEventListener("contextChanged", function(e:Event):void{
				//Debug.print("contextChanged " + id , this );
				_contextDirty = true;
			});
			
		}
		
		private function initProperties():void
		{
			
			
			// set the type of attribute this is
			// make sure some attributes are parsed as expression
			
			isFillAttribute = 	(id == "mb_fill");
			isStrokeAttribute = (id == "mb_stroke");
			isDataAttribute = 	(id == "mb_d" );
			
			// for using in fills and such
			
			// every fill type attribute (except for fill)
			isFillTypeAttribute = (id.search("fill") > -1 ) && !isFillAttribute;
			isStrokeTypeAttribute = id.search("stroke") > -1 && !isStrokeAttribute;
			
		}
		
		private function initParseType():void {
			
			
			if( isDataAttribute )				parseType = LayerAttribute.PARSE_AS_DATA;
			else if( isParsableAttribute )		parseType = LayerAttribute.PARSE_AS_EXPRESSION;
			else								parseType = LayerAttribute.PARSE_AS_STATIC;
		}
		
		
		/**
		 * attribute value
		 */
		
		protected var _value:String;
		protected var _valueDirty:Boolean = true;
		
		public function get value():String {
			return _value;
		}
		
		public function set value( val:String ):void {
			
			
			if( val != _value ){
				_value = val;
				
				if( !isNaN( Number( _value ) ) ) {
					// it's a number, don't bother parsing
					parseType = PARSE_AS_STATIC;
					
				} else {
					initParseType();
				}
				
				_valueDirty = true;
				_tokenizedValueDirty = true;
				//Debug.print("setting value of " + id + " to = " + val, this );
				dispatchEvent(new Event("layerAttributeChanged"));
			}
		}
		
		
		
		
		private var _tokenizedValue:IToken;
		
		private var _tokenizedValueDirty:Boolean = true;
		
		
		// should the tokenized value be updated?
		
		public function get tokenizedValue():IToken
		{
			
			if( _tokenizedValueDirty ){
				
				//Debug.print("updating tokenizedValue from value = " + _value,this);
				if( parseType == PARSE_AS_DATA ) _tokenizedValue = ParserController.tokenize(_value);
				if( parseType == PARSE_AS_EXPRESSION ) _tokenizedValue = ParserController.tokenize(_value, true);
				
				//Debug.print("tokenizedValue update |  " + id + " : " + _value,this);
				
				_tokenizedValueDirty = false;
			}
			return _tokenizedValue;
		}

		
		/**
		 * the parsed value gets updated when the context changes
		 */
		private var _parsedValue:String;
		
		/**
		 * gets set if the context is dirty
		 */
		private var _contextDirty:Boolean = true;

		/**
		 * parsed attribute value
		 */
		public function get parsedValue():String
		{
			
			if( _valueDirty || _contextDirty ) {
				parse();
				_valueDirty = false;
				_contextDirty = false;
				
				//Debug.print("parsedValue update    | " + id + " : " + _parsedValue, this );
			} 
			
			return _parsedValue;
			
		}
		
		/**
		 * how should we parse the value?
		 * 
		 * can return:
		 * - "data" - parse as programmatic data that result in drawing commands (string)
		 * - "expression" - parse as a simple expression returning a string value
		 * - "static" - doesn't get parsed
		 * - 
		 */
		
		public static const PARSE_AS_DATA:String 		= "data";
		public static const PARSE_AS_EXPRESSION:String 	= "expr";
		public static const PARSE_AS_STATIC:String 		= "stat";
		
		//private var _parseAs:String;
		
		// default parsing of an attribute is static
		private var _parseType:String = PARSE_AS_STATIC;

		public function get parseType():String
		{
			return _parseType;
		}

		public function set parseType(value:String):void
		{
			if( _parseType != value ){
				_parseType = value;
				_valueDirty = true;
			}
			
		}
		
		
		
		public function parse( ):void {
			
			_parsedValue = "";
			
			switch( parseType ){
				case PARSE_AS_STATIC:
					_parsedValue = _value;
					break;
				case PARSE_AS_DATA:
				case PARSE_AS_EXPRESSION:
					_parsedValue = ParserController.parseToString(tokenizedValue);
					break;
			}
			
			
			//Debug.print("[LayerAttribute.parse] id = " + id  + ", value = " + _parsedValue, this );
			
		}
		
		/**
		 * helper functions
		 *
		 */
		
		
		
		
		
		/**
		 * it's a magic box attribute
		 */
		public function get isMBAttribute():Boolean {
			return id.substr(0,3) == "mb_" ? true : false;
		}
		
		public function get isMBInterfaceAttribute():Boolean {
			return id.substr(0,4) == "mb__" ? true : false;
		}
		
		
		
		
		/** returns true when an attribute is parsable. 
		 *  - excludes colour attributes (because they contain the # character and are not parsable anyways)
		 * and the mb_d property (because it can contain programming data
		 */
		public function get isParsableAttribute( ):Boolean {
			return id != 'mb_fill' 
				&& id != 'mb_stroke'
				&& id != 'mb_fontFamily' 
				&& id != 'mb_textAnchor' 
				&& id != 'mb_visibility'
				&& id != 'id';
		}
		
		/**
		 * matches a textual attribute that should not be parsed by the LanguageParser
		 */
		private function isTextAttribute():Boolean {
			return 	id == "visibility" || 
				id == "display" ||
				id == "fill" ||
				id == "stroke";
		}
		
		public override function toString():String {
			return "\t" 
				+ "< " 		+ parseType
					+ " | " + isSvgAttribute 
					+ " | " + isFillAttribute 
					+ " | " + isFillTypeAttribute 
					+ " | " + isStrokeAttribute 
					+ " | " + isStrokeTypeAttribute 
				+ " > \t"
				+ id + " = " + value;
		}
		
	}
}