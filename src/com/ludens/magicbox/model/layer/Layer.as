package com.ludens.magicbox.model.layer
{
	import com.ludens.PackageHandler.view.layeroptions.LayerDisplaySettings;
	import com.ludens.controllers.ParserController;
	import com.ludens.magicbox.model.DataObject;
	import com.ludens.magicbox.model.LayerAttribute;
	import com.ludens.magicbox.model.LayerFactory;
	import com.ludens.magicbox.model.layer.attribute.LayerAttributeCollection;
	import com.ludens.magicbox.model.layer.transform.LayerTransform;
	import com.ludens.magicbox.model.layer.transform.LayerTransformCollection;
	import com.ludens.magicbox.model.variable.Variable;
	import com.ludens.magicbox.parser.LanguageParser;
	import com.ludens.magicbox.parser.ParserConsole;
	import com.ludens.magicbox.parser.ParserContext;
	import com.ludens.magicbox.parser.drawingcommands.IDrawingCommand;
	import com.ludens.utils.BooleanUtil;
	import com.ludens.utils.Debug;
	import com.ludens.utils.MagicBoxXMLUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix;
	
	import mx.messaging.management.Attribute;

	[Bindable]
	public class Layer extends DataObject
	{
		
		/**
		 * CONSTANTS
		 */
		public static const TYPE_GROUP:String = "g";
		public static const TYPE_PATH:String = "path";
		public static const TYPE_RECT:String = "rect";
		public static const TYPE_POLYGON:String = "polygon";
		public static const TYPE_LINE:String = "line";
		public static const TYPE_CIRCLE:String = "circle";
		public static const TYPE_ELLIPSE:String = "g";
		public static const TYPE_TEXT:String = "text";
		public static const TYPE_IMAGE:String = "image";
		
		/**
		 * types of SVG paths that are not directly used as layers, but only as
		 * sublayers (with specific info)
		 */
		public static const TYPE_TEXTSPAN:String = "tspan";
		
		/**
		 * public properties
		 */
		
		/**
		 * position & size
		 */
		public function get x():String 								{	return getAttribute( 'mb_x' ); }
		public function set x( value:String ):void					{	setAttribute('mb_x', value); }
		
		public function get y():String 								{	return getAttribute( 'mb_y' ); }
		public function set y( value:String ):void					{	setAttribute('mb_y', value); }
		
		public function get width():String 							{	return getAttribute( 'mb_width' ); }
		public function set width( value:String ):void				{	setAttribute('mb_width', value); }
		
		public function get height():String 						{	return getAttribute( 'mb_height' ); }
		public function set height( value:String ):void				{	setAttribute('mb_height', value); }
		
		/**
		 * fill
		 */
		public function get fill():String 							{	return getAttribute( 'mb_fill' ); }
		public function set fill( value:String ):void				{	setAttribute('mb_fill', value); }
		
		public function get fillOpacity():String 					{	return getAttribute( 'mb_fillOpacity' ); }
		public function set fillOpacity( value:String ):void		{	setAttribute('mb_fillOpacity', value); }
		
		public function get showFill():Boolean 						{	return BooleanUtil.stringToBoolean(getAttribute( 'mb__showFill' )); }
		public function set showFill( value:Boolean ):void			{	setAttribute('mb__showFill', BooleanUtil.booleanToString(value)); }
		/**
		 * stroke
		 */
		public function get stroke():String 						{	return getAttribute( 'mb_stroke' ); }
		public function set stroke( value:String ):void				{	setAttribute('mb_stroke', value); }
		
		public function get strokeOpacity():String 					{	return getAttribute( 'mb_strokeOpacity' ); }
		public function set strokeOpacity( value:String ):void		{	setAttribute('mb_strokeOpacity', value); }
		
		public function get strokeWidth():String 					{	return getAttribute( 'mb_strokeWidth' ); }
		public function set strokeWidth( value:String ):void		{	setAttribute('mb_strokeWidth', value); }
		
		public function get showStroke():Boolean 					{	return BooleanUtil.stringToBoolean(getAttribute( 'mb__showStroke' )); }
		public function set showStroke( value:Boolean ):void		{	setAttribute('mb__showStroke', BooleanUtil.booleanToString(value)); }
		
		/**
		 * visibility
		 */
		public function get visibility():String 					{	return getAttribute( 'mb_visibility' ); }
		public function set visibility( value:String ):void			{	setAttribute('mb_visibility', value); }
		
		/**
		 * transform
		 */
		public function get showTransform():Boolean 				{	return BooleanUtil.stringToBoolean(getAttribute( 'mb__showTransform' )); }
		public function set showTransform( value:Boolean ):void		{	setAttribute('mb__showTransform', BooleanUtil.booleanToString(value)); }
		
		
		/**
		 * PROPERTIES FOR TEXT LAYER
		 */
		/**
		 * text
		 */
		public function get text():String 									{	return getAttribute( 'mb__text' ); }
		public function set text( value:String ):void						{	setAttribute('mb__text', value); }
		
		/**
		 * font family
		 */
		public function get fontFamily():String 							{	return getAttribute( 'mb_fontFamily' ); }
		public function set fontFamily( value:String ):void					{	setAttribute('mb_fontFamily', value); }
		
		/**
		 * font size
		 */
		public function get fontSize():String 								{	return getAttribute( 'mb_fontSize' ); }
		public function set fontSize( value:String ):void					{	setAttribute('mb_fontSize', value); }
		
		
		/**
		 * text anchor (alignment)
		 */
		public function get textAnchor():String 							{	return getAttribute( 'mb_textAnchor' ); }
		public function set textAnchor( value:String ):void					{	setAttribute('mb_textAnchor', value); }
		
		/**
		 * is the text static? i.e. doesn't have to be parsed
		 */
		public function get staticText():Boolean 							{	return BooleanUtil.stringToBoolean(getAttribute( 'mb__staticText' )); }
		public function set staticText( value:Boolean ):void				{	setAttribute('mb__staticText', BooleanUtil.booleanToString(value)); }
		
		
		/**
		 * PROPERTIES FOR PATH LAYER
		 */
		
		/**
		 * data
		 */
		public function get d():String 									{	return getAttribute( 'mb_d' ); }
		public function set d( value:String ):void						{	setAttribute('mb_d', value); }
		
		public function get staticData():Boolean 						{	return BooleanUtil.stringToBoolean(getAttribute( 'mb__staticData' )); }
		public function set staticData( value:Boolean ):void			{	setAttribute('mb__staticData', BooleanUtil.booleanToString(value)); }
		
		/**
		 * Data return in different formats
		 */
		
		/**
		 * return drawing data as a simple polygon array
		 * 
		 * returns null when there is no data to draw
		 * 
		 */
		public function get poly():Array {
			
			if( hasAttribute( 'mb_d' ) ){
				// get the drawing commands and transform it into a polygon
				
				var dc:IDrawingCommand = getParsedAttributeDC('mb_d');
				if( dc ) return dc.poly;
			}
			
			// if we don't have a data value, just return null
			return null;
			
		}
		
		
		
		
		/**
		 * the type of layer
		 */
		public function get layerType():String {
			if(_xml) 	return _xml.localName();
			else 		return "unknown";
		}
		
		
		private var _parent:Layer;

		/**
		 * the layer parent
		 */
		public function get parent():Layer
		{
			return _parent;
		}
		/**
		 * @private
		 */
		public function set parent(value:Layer):void
		{
			_parent = value;
		}
		
		
		

		
		/**
		 * children array
		 */
		protected var _children:LayerCollection = new LayerCollection;
		
		public function get children():LayerCollection {
			return _children;
		}
		
		public function set children( value:LayerCollection ):void {
			_children = value;
			
			_svgDirty = true;
			_xmlDirty = true;
		}
		
		public function get hasChildren():Boolean {
			return children.length > 0;
		}
		
		/**
		 * attributes array
		 */
		protected var _attributes:LayerAttributeCollection;
		
		public function get attributes():LayerAttributeCollection {
			return _attributes;
		}
		
		public function set attributes( value:LayerAttributeCollection ):void {
			_attributes = value;
			//createAttributes();
			_svgDirty = true;
			_xmlDirty = true;
		}
		
		/**
		 * transforms array
		 */
		protected var _transforms:LayerTransformCollection
		
		public function get transforms():LayerTransformCollection {
			return _transforms;
		}
		
		public function set transforms( value:LayerTransformCollection):void {
			_transforms = value;
		}
		
		
		/**
		 * easy accessor functions for attributes
		 * 
		 * we need these because attributes can be asynchronisly parsed
		 */
		public function setAttribute( attributeName:String, attributeValue:String ):void {
			
			var attr:LayerAttribute = LayerAttribute(attributes.get( attributeName ));
			
			if( attr ){
				attr.value = attributeValue;
			} else {
				// if it's not found, add it!
				attributes.addItem( new LayerAttribute( attributeName, attributeValue ) );
				//Debug.print("setAttribute " + attributeName + " not found", this );
			}
			
			_svgDirty = true;
			_xmlDirty = true;
			
		}
		
		public function getAttribute( attributeName:String ):String {
			
			//Debug.print("getAttribute " + attributeName + " value = ", this );
			
			var attr:LayerAttribute = LayerAttribute(attributes.get( attributeName ));
			if( attr ){
				return attr.value;
			} else {
				//Debug.print("getAttribute " + attributeName + " not found", this );
				
				// we can create it with a default value
				//attributes.addItem( new LayerAttribute(attributeName, LayerFactory.getAttributeDefaultValue( attributeName ) ) );
				return null;
			}
			
		}
		
		public function hasAttribute( attributeName:String ):Boolean {
			return attributes.containsId( attributeName );
		}
		
		public function getParsedAttribute( attributeName:String ):String {
			
			var attr:LayerAttribute = LayerAttribute(attributes.get( attributeName ));
			
			if( attr ){
				return attr.parsedValue;
			} else {
				
				Debug.print("getParsedAttribute " + attributeName + " not found", this );
				return null;
			}
			//return LayerAttribute(attributes.get( attributeName )).parsedValue;
		}
		
		/**
		 * return a parsed attribute as a number
		 */
		public function getParsedAttributeNumber( attributeName:String ):Number {
			var value:String = getParsedAttribute( attributeName );
			if( value ) return Number(value);
			else		return 0;
		}
		
		/**
		 * get a parsed attribute as drawing commands
		 */
		public function getParsedAttributeDC( attributeName:String ):IDrawingCommand {
			var attr:LayerAttribute = LayerAttribute(attributes.get( attributeName ));
			
			if( attr ) {
				return ParserController.parseToDC( attr.tokenizedValue );
			} else {
				return null;
			}
		}
		
		/**
		 * Interface functions
		 */
		public function get iconClass():Class {
			// TODO: return default class
			return LayerFactory.GeneralIcon;
		}
		
		/**
		 * dummy for data binding
		 */
		public function set iconClass(value:Class):void {
			
		}
		
		/**
		 * the default values for showing different items of the layeroptions
		 * palette
		 */
		public function get displayDefaults():LayerDisplaySettings {
			return new LayerDisplaySettings({ 	
						showTransforms: true,
						showStroke:		true,
						showFill:		true,
						showData:		true,
						showPosition:	false,
						showSize:		false,
						showText:		false
			});
		}
		
		/**
		 * SVG parsing functions
		 */
		protected var _svg:XML;
		
		protected var _svgDirty:Boolean = true;
		
		
		/**
		 * xml variable 
		 * 
		 * the xml variable sets the xml contents of the layer
		 */
		protected var _xml:XML;
		protected var _xmlDirty:Boolean;
		

		// has the xml changed? if yes, re-compute
		//protected var _xmlDirty:Boolean = true;
		
		
		public function set xml(xml:XML):void {
			
			if( _xml == xml ) return;
			
			
			
			_xml = xml;
			
			// do we really need to do this?
			this.loadXML( _xml );
			_xmlDirty = false;
			
			// TODO: only set this when something has really changed
			_svgDirty = true;
			
			
			createAttributes();
			createChildren();
			createTransforms();
		}
		
		public function get xml():XML {
			if( _xmlDirty ){
				_xml = this.toXML();
				_xmlDirty = false;
			}
			return _xml;
		}
		
		public override function toXML():XML {
			
			var ret:XML = super.toXML();
			
			// attributes
			for each( var v:LayerAttribute in attributes ){
				ret['@' + v.id] = v.value;
			}
			
			if( transforms && transforms.length > 0) {
				// transforms
				var tr:XML = new XML("<transforms/>");
				for each( var t:LayerTransform in transforms ){
					tr.appendChild( t.toXML() );
				}
				ret.appendChild( tr );
			}
			
			
			// children as well
			for each( var c:Layer in children ){
				ret.appendChild( c.xml );
			}
			
			
			return ret;
			
		}
		
		/**
		 * child layers
		 */
		
		
		
		
		
		
		/** parse all the attributes of the layer
		 */
		protected function createAttributes():void {
			
			for each( var attribute:XML in _xml.attributes()){
				
				// check if the attribute already exists
				var attributeName:String = attribute.name();
				
				var attr:LayerAttribute = new LayerAttribute( attribute.name(), attribute.valueOf() );
				
				
				
				_attributes.addItem( attr ) ;
			}
		}
		
		
		
		/**
		 * parse all the children of the layer
		 */
		protected function createChildren():void {
			
			for each( var child:XML in _xml.children()){
				
				// don't parse transforms children
				if( child.localName() == 'transforms' ) continue;
				
				// check if the child already exists
				
				// add the child to the child array
				_children.addItem( new Layer( child ) );
			}
		}
		

		/**
		 * parse all the children of the layer
		 */
		protected function createTransforms():void {
			
			if( ! _xml.transforms.transform.length() > 0) return;
			
			var transforms:XMLList = _xml.transforms.transform;
			
			for each( var transform:XML in _xml.transforms.transform){
				// check if the child already exists
				
				// add the child to the child array
				_transforms.addItem( new LayerTransform( transform ) );
			}
		}
		
		/**
		 * CONSTRUCTOR
		 */
		public function Layer(xml:XML = null)
		{
			//this.id = id;
			
			// set the default collections
			
			this.attributes = new LayerAttributeCollection;
			this.transforms = new LayerTransformCollection;
			
			// should we initialize the children as well?
			this.children = new LayerCollection;
			
			// if we have specified an xml object to load, do so
			if( xml ) this.xml = xml;
			
			// when the context has changed, the layer will update it's attribute
			ParserController.getInstance().addEventListener("contextChanged", function(e:Event):void{
				//Debug.print("contextChanged " + id , this );
				_svgDirty = true;
				_xmlDirty = true;
			});
			
		}
		
		
		
		
		/**
		 * get the svg parsed string
		 */
		public function getSVG( ):XML {
			
			var recomputed:Boolean = false;
			
			if( _svgDirty){
				parseSVG( );
				parseSVGAttributes( );
				parseSVGChildren( );
				parseSVGTransforms( );
				
				_svgDirty = false;
				recomputed = true;
			}
			
			//Debug.print("getSVG :" + _svg.toXMLString() + " dirty = " + recomputed, this );
			return _svg;
		}
		
		protected function parseSVG():void {
			
			// the return string
			_svg = new XML('<' + layerType + '/>');
			
			// give it an id if it has one
			_svg['@id'] = id;
		}
		
		
		protected function parseSVGAttributes():void {
			
			for each( var attribute:LayerAttribute in attributes){
				
				if( attribute.isSvgAttribute){
					
					// skip stroke and fill attributes when showStroke or showFill is false
					if( !showFill 	&& attribute.isFillTypeAttribute 	) continue;
					if( !showStroke && attribute.isStrokeTypeAttribute 	) continue;
					
					
					// this is a value that can be set by exceptions. these exceptions are listed below
					// when it is set, the attribute's parsedValue will not be used but the exceptionValue
					// will be used instead
					var exceptionValue:String = "";
					
					if( staticData && attribute.isDataAttribute ) 	exceptionValue = attribute.value;
					
					if( !showFill ) {
						if( attribute.isFillTypeAttribute ) continue;
						if( attribute.isFillAttribute ) 								exceptionValue = "none";
					}
					if( !showStroke ){
						if( attribute.isStrokeTypeAttribute ) continue;
						if( attribute.isStrokeAttribute ) 								exceptionValue = "none";
					}
					
					
					// set the stroke width attribute to a minimum value
					if( attribute.id == "mb_strokeWidth" && attribute.value == "0" )	exceptionValue = "0.001mm"; 
					
					
					// do the actual parsing of the attribute
					//attribute.parse();
					
					// choose if we are using the exceptionValue. this makes processing a lot quicker
					if( exceptionValue.length > 0 )	_svg['@' + attribute.svgName ] = exceptionValue;
					else					_svg['@' + attribute.svgName ] = attribute.parsedValue;
					
				}
			}
		}
		
		
		protected function parseSVGTransforms():void {
			
			//Debug.print("parsing Transforms", this );
			/*
			 * transformations
			 * parse them separately
			 */
			_svg.@transform = transforms.getSVGText();
		}
		
		protected function parseSVGChildren( ):void {
		
			/**
			 * child layers
			 */
			for( var k:int = 0; k < _children.length; k++){
				_svg.appendChild( Layer(_children[k]).getSVG() );
			}
			
		}
		
		/**
		 * utility functions
		 */
		
		
		
		/**
		 * Factory function
		 */
		public static function fromXML( xml:XML ):Layer {
			
			// this should probably type the layer as well
			
			var l:Layer = LayerFactory.createFromXML( xml );

			return l;
		}
		
		
		public override function toString():String {
			var ret:String = "\nLayer( \n";
			
			
			var attr:Array = new Array;
			
			for each( var a:LayerAttribute in attributes ){
				attr.push(a.toString());
				
			}
			
			return ret + attr.join("\n") + "\n)";
		}
		
	}
}