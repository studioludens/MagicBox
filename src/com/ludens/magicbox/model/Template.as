package com.ludens.magicbox.model
{
	
	import com.ludens.controllers.ParserController;
	import com.ludens.magicbox.model.layer.Layer;
	import com.ludens.magicbox.model.layer.LayerCollection;
	import com.ludens.magicbox.model.variable.Variable;
	import com.ludens.magicbox.model.variable.VariableCollection;
	import com.ludens.magicbox.parser.LanguageParser;
	import com.ludens.magicbox.parser.ParserConsole;
	import com.ludens.magicbox.parser.ParserContext;
	import com.ludens.magicbox.parser.ParserError;
	import com.ludens.magicbox.parser.drawingcommands.DrawingCommand;
	import com.ludens.magicbox.parser.tokens.IToken;
	import com.ludens.magicbox.parser.tokens.ListToken;
	import com.ludens.magicbox.parser.tokens.TextToken;
	import com.ludens.utils.BooleanUtil;
	import com.ludens.utils.ConvertUtil;
	import com.ludens.utils.Debug;
	import com.ludens.utils.MagicBoxXMLUtil;
	import com.ludens.utils.SVGPathUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	
	import mx.collections.IList;
	import mx.collections.XMLListCollection;
	

	public class Template extends EventDispatcher
	{
		
		
		/**
		 * the language parser that will parse all of the data in the template
		 */
		private var _parser:LanguageParser;
		
		/**
		 * Info about the template
		 */
		
		private var _info:XML;
		
		private var _defaultInfo:XML = <info>
				<title>Magic Box Design</title>
				<id>magicbox.empty</id>
				<author></author>
				<website>http://magic-box.org/</website>
				<tutorial></tutorial>
				<description>A default design</description>
			</info>;
		
		
		[Bindable]
		public function get info():XML {
			return _info;
		}
		
		public function set info(value:XML):void {
			_info = value;
			
			dispatchChangeEvent();
		}
		
		
		private var _variablesXML:XMLList;
		
		
		/**
		 * Variables of the template
		 */
		[Bindable]
		public function get variablesXML():XMLList	{
			return _variablesXML;
		}
		
		public function set variablesXML(value:XMLList):void {
			_variablesXML = value;
			
			// empty the layer collection
			variables.removeAll();
			
			// add all layers to the LayerCollection
			for each( var variable:XML in value ){
				var v:Variable = Variable.fromXML( variable );
				variables.addItem( v );
			}
			
			
			dispatchChangeEvent();
		}
		
 		
		private var _variables:VariableCollection;

		/**
		 * a collection of interface variables that this Template will use
		 */
		[Bindable]
		public function get variables():VariableCollection
		{
			return _variables;
		}

		public function set variables(value:VariableCollection):void
		{
			_variables = value;
		}
		
		private var _variableNames:Array;

		/**
		 * a simple list of variable names to use for code highlighting and the like
		 */
		[Bindable]
		public function get variableNames():Array
		{
			return _variableNames;
		}

		public function set variableNames(value:Array):void
		{
			_variableNames = value;
		}
		
		
		private var _layersXML:XMLList;

		/**
		 * Layers of the template
		 * DEPRECATED
		 */
		[Bindable]
		public function get layersXML():XMLList {
			return _layersXML;
		}

		public function set layersXML(value:XMLList):void {
			_layersXML = value;
			
			// empty the layer collection
			layers.removeAll();
			
			// add all layers to the LayerCollection
			for each( var layer:XML in value ){
				var l:Layer = LayerFactory.createFromXML( layer );
				layers.addItem( l );
			}
			
			dispatchChangeEvent();
		}
		
 		private var _layers:LayerCollection;

		/**
		 * layers collection. this holds all of the layers in this Template
		 */
		[Bindable]
		public function get layers():LayerCollection
		{
			return _layers;
		}

		public function set layers(value:LayerCollection):void
		{
			_layers = value;
			
			dispatchChangeEvent();
		}
		
		
		/**
		 * Layer object list of the template
		 */
		
		
		public function Template( variables:VariableCollection = null, layers:LayerCollection = null )
		{
			//_variablesXML = variables;
			//_layersXML = layers;
			
			this._variables = variables;
			this._layers = layers;
			
			
			
			//_parser = new LanguageParser();
			
			if( !this.variables ){
				// initialize default variables
				this.variables = VariableCollection.getDefault();
			}
			
			if( !this.layers ){
				this.layers = LayerCollection.getDefault();
			}
			
			// set default info
			this.info = _defaultInfo;
			
			_parser = ParserController.getInstance().parser;
			
			dispatchChangeEvent();
		}
		
		/**
		 * get an XML string describing the template
		 */
		public function getXML():String {
			
			var outputXML:XML = XML('<parametricbox version="2.0"></parametricbox>');
			
			// design info group
			
			//var infoGroup:XML = XML("<info></info>");
			//infoGroup.appendChild();
			outputXML.appendChild(info);
			
			// variables group
			var varGroup:XML = XML('<variables></variables>');
			varGroup.appendChild( variables.xml );
			outputXML.appendChild(varGroup);
			
			// layers group
			var layGroup:XML = XML('<layers></layers>');
			layGroup.appendChild( layers.xml );
			outputXML.appendChild(layGroup);
			
			//Debug.print("outputXML = " + outputXML);
			
			return '<?xml version="1.0" encoding="utf-8"?>\n' + outputXML.toXMLString();
		}
		
	
		/**
		 * get an SVG string. a transformation matrix can be applied to the output. this allows for
		 * easy scaling and positioning on an output surface for example. Use an identity matrix
		 * as input to get no scaling and translation
		 * 
		 * @arg transform: the transformation matrix to be applied on the SVG path data
		 */
		public function getSVG( ):XML {
			
			
			var SVGString:String = "";
			
			var _svg:XML = <svg width="100%" height="100%" version="1.1" xmlns="http://www.w3.org/2000/svg"></svg>;
			
			//SVGString += Template.SVG_HEADER.replace("$width", "100%").replace("$height","100%");
				
			_svg.appendChild(<desc>Magic box - output file</desc>);
			
			//SVGString += "" + "\n";
			
			// main group
			
			
			var maingroup:XML = <g transform="scale(2.83464567)"></g>;
			
			_svg.appendChild(maingroup);
			
			// convert to mm
			/** SCALING DOESN'T WORK PROPERLY AFTER THIS MOD **/
			
			
			// loop through all the layers (recursively) and get the proper SVG
			
			/*
			for each( var layer:XML in _layersXML ) {
				var layerXMLString:String = getLayerSVG( layer, context, transform ).toXMLString();
				SVGString += layerXMLString + "\n";
				
			}*/
			
			for each( var layer:Layer in _layers ) {
				maingroup.appendChild(layer.getSVG());
				
			}
			
			//Debug.print("XML string: " + getXML(), this);
			//Debug.print("SVG string: " + _svg.toXMLString(), this);
			
			return _svg;
		} 
		
		
		
		/**
		 * these functions are used to do undo and redo
		 */
		public function getState():Object {
			
			var state:Object = new Object();
			state.variables = _variables;
			state.layers = _layers;
			
			return state;
		}
		
		public function setState( state:Object ):void {
			
			if( state.hasOwnProperty( "variables" ) )
				_variablesXML = state["variables"];
				
			if( state.hasOwnProperty( "layers" ) )
				_layersXML = state["layers"];
				
			dispatchChangeEvent();
		}
		
		
		private function dispatchChangeEvent():void {
			
			var event:Event = new Event( Event.CHANGE );
			dispatchEvent( event );
		}
		
		private function isStrokeAttribute( attribute:String):Boolean {
			return attribute.search("stroke") > -1;
		}
		
		private function isFillAttribute( attribute:String):Boolean {
			return attribute.search("fill") > -1;
		}
		
		/** returns true when an attribute is parsable. 
		 *  - excludes colour attributes (because they contain the # character and are not parsable anyways)
		 */
		private function isParsableAttribute( attribute:String ):Boolean {
			return attribute != 'mb_fill' && attribute != "mb_stroke" && attribute != 'mb_fontFamily' && attribute != 'mb_textAnchor' && attribute != 'mb_points';
		}
		
		/**
		 * matches a textual attribute that should not be parsed by the LanguageParser
		 */
		private function isTextAttribute( attribute:String):Boolean {
			return 	attribute == "visibility" || 
					attribute == "display" ||
					attribute == "fill" ||
					attribute == "stroke";
		}
		
		/**
		 * has the attribute changed?
		 */
		private function attributeHasChanged( attributeName:String,layer:XML ):Boolean{
			
			//Debug.print( layer["@mb___" + attributeName] );
			return String(layer["@mb___" + attributeName]) == 'true';
		}
	
		/**
		 * converts an SVG layer to a Magic Box compatible layer
		 */
		
		public static function svgToMagicBoxLayer( xml:XML ):XML {
			
			var layerType:String = xml.localName();
			
			var output:XML = new XML("<" + layerType + "></" + layerType + ">");
			
			// default properties
			output["@id"] = "import_layer";
			output["@mb_visibility"] = "visible";
			
			// if it's text, first parse the text value
			if( layerType == "text"){
				output["@mb__text"] = String(xml.valueOf());
			}
			
			// run through all the properties
			for each( var attribute:XML in xml.attributes()){
				
				// only parse magic box compatible properties
				
				// check if something exists
				
				var attributeName:String = attribute.name();
				var mbAttributeName:String = MagicBoxXMLUtil.convertXMLAttributeName( attributeName );
				var attributeValue:String = attribute.valueOf();
				
				
				
				if( attributeName == "fill" && attributeValue != "none"){
					// a fill is present, show it
					output["@mb__showFill"] = "true";
				}
				
				if( attributeName == "stroke" || attributeName == "stroke-width"){
					// a fill is present, show it
					output["@mb__showStroke"] = "true";
				}
				
				if( attributeName == "transform"){
					// show transformations
					output["@mb__showTransform"] = "true";
					// parse transformations
					Debug.print( "parsing transformations on layer " + xml.localName() + " " + attributeValue );
					var transforms:XML = MagicBoxXMLUtil.parseTransformation( attributeValue );
					Debug.print( "to " + transforms );
					output.appendChild( transforms );
				} else if( attributeName == "d"){
					output["@mb_d"] = SVGPathUtil.prettifyPathData( attributeValue );
				} else if( attributeName != "id"){
						// convert them to magic box compatible properties
						output["@" + mbAttributeName] = attribute.valueOf();
				} else {
					// special case for id, just parse it
					output["@" + attributeName] = attribute.valueOf();
				}
				
			}
			
			// parse all the sublayers
			for each( var child:XML in xml.children() ){
				output.appendChild( Template.svgToMagicBoxLayer( child ) );
			}
			
			//return the xml
			return output;
		}
		
		/**
		 * prepares the context object for use
		 * this function will loop through all the vriables in the variable list
		 * and adds the specific variable values to the context object
		 * 
		 */
		public function prepareContext():void {
			// TODO: implement this function
			
			//var _context:ParserContext = new ParserContext;
			
			var pc:ParserController = ParserController.getInstance();
			pc.clearContext( false );
			
			
			// check the variables array and parse the contents of the pathInput textarea
			for each(var item:Variable in _variables ){
				
				// try parsing it
				var itemValue:String = String(item.value);
				var itemName:String = String(item.name);
				
				// check if we are not assigning to a function
				if(pc.hasContextVariable(itemName) && pc.getContextVariable(itemName) is Function){
					// if so, give an error, because this is
					// obviously impossible
					
					ParserConsole.traceError( 
						new ParserError( "Cannot assign a value to a function", ParserError.ID_INVALID_ASSIGNMENT, itemName ));
					// and continue with the next one
					continue;
				}
				
				if(item.type == Variable.TYPE_EXPRESSION){
					
					// add it to the context
					pc.setContextVariable( itemName, pc.parseExpression( itemValue ), false );
				} else if( item.type == Variable.TYPE_LIST ){
					// parse it as a list
					var listToken:ListToken = _parser.tokenize( "{" + itemValue + "}" ) as ListToken;
					pc.setContextVariable( itemName, listToken, false);
					
					// and add each item to the context separately 
					for(var i:int = 0; i < listToken.values.length; i++){
						
						// TODO: make this look proper!!
						pc.setContextVariable( itemName + "__" + i, (listToken.values[i] as IToken).parseToString( pc.context ), false );
					}
					pc.setContextVariable( itemName + "__length", listToken.values.length, false);
					
				} else if( item.type == Variable.TYPE_TEXT ){
					// just simple text
					var textToken:IToken = new TextToken( itemValue );
					pc.setContextVariable( itemName, textToken, false);
				}else {
					// add it to the context as a number
					pc.setContextVariable( itemName, Number(itemValue), false);
				}
				
				
			}
			
			// propagate the updated context to all parts of the system
			pc.updateContext();
			
			// set variable names
			variableNames = variables.variableNames;
			
		}
		
		/**
		 * CONSTANTS
		 */
		public static const SVG_HEADER:String = '<?xml version="1.0" standalone="no"?>' + "\n" +
			'<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">' + "\n" +
			'<svg width="$width" height="$height" version="1.1" xmlns="http://www.w3.org/2000/svg">' + "\n";
		
		public static const SVG_FOOTER:String = '</svg>';
	}
}