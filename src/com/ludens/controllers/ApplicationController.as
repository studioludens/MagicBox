package com.ludens.controllers
{
	import com.candymandesign.flash.validators.XMLValidator;
	import com.lorentz.SVG.*;
	import com.ludens.PackageHandler.*;
	import com.ludens.PackageHandler.events.*;
	import com.ludens.PackageHandler.view.*;
	import com.ludens.controllers.ApplicationController;
	import com.ludens.magicbox.model.*;
	import com.ludens.magicbox.model.layer.GroupLayer;
	import com.ludens.magicbox.model.layer.IGroupLayer;
	import com.ludens.magicbox.model.layer.Layer;
	import com.ludens.magicbox.model.layer.LayerCollection;
	import com.ludens.magicbox.model.variable.Variable;
	import com.ludens.magicbox.model.variable.VariableCollection;
	import com.ludens.magicbox.parser.*;
	import com.ludens.magicbox.parser.tokens.*;
	import com.ludens.utils.*;
	import com.randomfractals.paint.utils.SVGUtil;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.*;
	
	import flashx.textLayout.edit.SelectionFormat;
	import flashx.textLayout.elements.TextFlow;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ICollectionView;
	import mx.collections.XMLListCollection;
	import mx.containers.Canvas;
	import mx.containers.Panel;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.core.MovieClipAsset;
	import mx.effects.*;
	import mx.events.*;
	import mx.managers.PopUpManager;
	import mx.printing.FlexPrintJob;
	import mx.printing.FlexPrintJobScaleType;
	import mx.rpc.soap.LoadEvent;
	import mx.utils.XMLUtil;
	
	import soulwire.display.PaperSprite;
	
	import spark.effects.*;
	

	/*
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	*/
	
	/** this is the main class that controlls the business logic of the application
	 * it will contain all global functions, and will reference the main application directly
	 * 
	 * it is a singleton
	 */
	public class ApplicationController
	{
		
		/** reference to the main application
		 */
		private var app:MagicBox;
		
		/**
		 * */
		
		private var SVGPreview:SVGRenderer;
		
		private var flipCard:PaperSprite;
		private var flipFrontImage:Bitmap;
		private var flipBackImage:Bitmap;
		
		/**
		 * language processing objects
		 */
		private var _context:ParserContext;
		private var _parser:LanguageParser;
		
		
		
		/** initialize the controller
		 */
		public function init(application:MagicBox):void {
			this.app = application;
		}
		
		
		/*************************************************
		 * 
		 * BUSINESS LOGIC
		 * 
		 * -- all functions start with 'do'
		 * 
		 *************************************************/
		
		public function doCreationComplete():void {
			
			// initialize the language objects
			
			// text selection color
			TextFlow.defaultConfiguration.focusedSelectionFormat = new SelectionFormat(0xCCCCCC);
			
			
			flipCard = new PaperSprite( );
			flipCard.filters = [ app.cardDropShadow ];
			app.flipBox.rawChildren.addChild( flipCard );
			
			
			// layer options menu
			app.layerOptions.addEventListener(Event.CHANGE, layerDataChangeHandler);
			app.layerOptions.addEventListener( PathSelectionEvent.CARET_CHANGED, updateCaretHandler );
			
			// variable list
			app.variablesList.addEventListener(DescriptorEvent.DELETE, removeVariablesDescriptorHandler);
			
			app.layersList.addEventListener(DescriptorEvent.DELETE, removeLayerDescriptorHandler);
			
			
			// load the xml from the flash vars
			if(FlexGlobals.topLevelApplication.parameters.hasOwnProperty('url')){
				// load the design from a url
				var loader:URLLoader = new URLLoader();
				var request:URLRequest = new URLRequest( String(FlexGlobals.topLevelApplication.parameters.url) );
				loader.load(request);
				loader.addEventListener(Event.COMPLETE, onXMLLoadComplete);
			}
			
			if(FlexGlobals.topLevelApplication.parameters.hasOwnProperty('state')){
				
				var state:String = FlexGlobals.topLevelApplication.parameters.state;
				
				if( state == "editor"){
					// should load editor
					app.currentState = "editor";
					
					Debug.print("setting state: editor", this);
				} else if( state == "viewer" ){
					// should load viewer
					app.currentState = "viewer";
					Debug.print("[MagicBox] setting state: viewer", this);
				}
			}
			
			//currentState = "viewer";
			
			// hide layerOptions, to prevent an error when first starting the application
			app.layersList.selectedIndex = 0;
			
			///var variablesCollection:XMLListCollection = new XMLListCollection( app.variablesXML );
			//var layersCollection:XMLListCollection = new XMLListCollection( app.layersXML );
			
			app.template.addEventListener( Event.CHANGE, templateChangeHandler );
			
			saveState();
			
			updateDrawingData();
			
			
		}
		
		public function doAddedToStage():void {
			
			app.stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler );
			app.stage.addEventListener( KeyboardEvent.KEY_UP, keyUpHandler );
			
			app.stage.addEventListener( ResizeEvent.RESIZE, resizeHandler );
		}
		
		/*************************************************
		 * 
		 * PRINTING
		 * 
		 *************************************************/
		public function doPrint():void {
			var pc:PrintController = PrintController.getInstance();
			pc.print( SVGPreview );
		}
		
		
		
		
		
		
		public function doFlip():void {
			
			if( !app.userInterface || !flipCard )
				return;
			
			app.userInterface.visible = false;
			flipCard.rotationY = 0;
			app.flipBox.visible = true;
			
			
			if( flipFrontImage && flipFrontImage.bitmapData )
				flipFrontImage.bitmapData.dispose();
			if( !flipFrontImage )
				flipFrontImage = new Bitmap( null, "auto", true );
			
			flipFrontImage.bitmapData = new BitmapData( app.width, app.height, true, 0 );
			flipFrontImage.bitmapData.draw( app.userInterface );
			
			if( app.currentState == "editor" )
				app.currentState = "viewer";
			else
				app.currentState = "editor";
			
			app.validateNow();
			
			if( flipBackImage && flipBackImage.bitmapData )
				flipBackImage.bitmapData.dispose();
			if( !flipBackImage )
				flipBackImage = new Bitmap( null, "auto", true );
			
			flipBackImage.bitmapData = new BitmapData( app.width, app.height, true, 0 );
			flipBackImage.bitmapData.draw( app.userInterface );
			
			flipCard.front = flipFrontImage;
			flipCard.back = flipBackImage;
			
			
			var pp:PerspectiveProjection = new PerspectiveProjection();
			pp.fieldOfView = 30;
			pp.projectionCenter = new Point( 0,0 );
			
			flipCard.transform.perspectiveProjection = pp;
			
			
			
			if( app.shiftIsPressed )
				app.flipDuration = 6000;
			else
				app.flipDuration = 1000;
			
			
			app.flipEffect.play( [flipCard] );
		}
		
		
		
		public function swapEffectEndHandler( e:EffectEvent ):void {
			
			app.userInterface.visible = true;
			app.flipBox.visible = false;
			
			app.invalidateDisplayList();
			app.menuBar.invalidateDisplayList();
			
			updateDrawingData();
		}
		
		
		private var undoPressed:Boolean = false;
		private var redoPressed:Boolean = false;
		
		private var keyRepeatDelay:int = 500;	
		private var millis:int = 0;
		
		protected function keyDownHandler( event:KeyboardEvent ):void {
			
			//app.super.keyDownHandler( event );
			
			var keyCode:int = event.keyCode;
			
			if( ( keyCode == 89 || keyCode == 90 ) 
				&& event.ctrlKey ) {
				
				if( keyCode == 89 )
					redoPressed = true;
				
				if( keyCode == 90 )
					undoPressed = true;
				
				//millis = getTimer();
				app.addEventListener( Event.ENTER_FRAME, enterFrameHandler );
			}
			
			if( keyCode == 16 )
				app.shiftIsPressed = true;
		}
		
		protected function keyUpHandler( event:KeyboardEvent ):void {
			
			//super.keyUpHandler( event );
			
			var keyCode:int = event.keyCode;
			//trace( keyCode );
			
			if( ( keyCode == 89 || keyCode == 90 ) 
				&& event.ctrlKey ) {
				
				if( keyCode == 89 )
					redo();
				
				if( keyCode == 90 )
					undo();
				
				app.removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
			}
			
			if( keyCode == 16 )
				app.shiftIsPressed = false;
			
			undoPressed = false;
			redoPressed = false;
			 
		}
		
		public function resizeHandler( e:Event ):void {
			
			
			trace( "[MagicBox] stage resize handler called" );
			app.callLater( updateDrawingData );
		}
		
		private function enterFrameHandler( e:Event ):void {
			
			//if( getTimer() - millis > keyRepeatDelay ) {
				
				if( undoPressed )
					undo();
				if( redoPressed )
					redo();
			//}
		}
		
		
		private function templateChangeHandler( e:Event ):void {
			
			updateDrawingData();
		}
		
		
		/**
		 * Handles changes made to the layer options
		 */
		public function layerDataChangeHandler(e:Event):void {
			
			// update drawing
			updateDrawingData();			
		}
		
		/** 
		 * VARIABLE LIST FUNCTIONS 
		 * 
		 **/
		
		
		/*
		public function variableOptionsClickHandler(e:MouseEvent):void {
		showEditVariableWindow(variablesList.selectedItem as XML);
		}
		*/
		
		/**
		 * Handles updates to the variables.
		 */
		public function variablesListChangeHandler(e:Event):void {
			
			// update drawing
			updateDrawingData();
		}
		
		
		/**
		 * Add a variable item to the list.
		 */
		public function addButtonClickHandler(e:Event):void {
			var variableData:XML = new XML('<variable name="variableName" type="slider" min="0" max="100" value="10"/>');
			
			// add it to the xml list and we should be good
			//app.variablesDescriptor.addItem(variableData);
			app.template.variables.addItem( new Variable("var1","slider",10,0,100,"") );
		}
		
		
		/**
		 * Handles the removal of the selection variable item
		 */
		public function removeVariablesDescriptorHandler(e:DescriptorEvent):void {
			
			// remove item
			
			app.template.variables.removeItemAt( app.variablesList.selectedIndex );
			
			//app.variablesDescriptor.removeItemAt(app.variablesList.selectedIndex);
			
			// update drawing
			updateDrawingData();
		}
		
		
		
		
		/** 
		 * 
		 * LAYER PANEL FUNCTIONS 
		 * 
		 **/
		
		
		/**
		 * Handles selection of a layer item from the layer menu
		 */
		public function layerListChangeHandler(e:Event):void {
			
			// update layer options menu
			//app.layerOptions.data = app.layersList.selectedItem;
			
			// update drawing
			updateDrawingData();
		}
		
		/**
		 * adds a layer to the template
		 */
		private function addLayer(layer:Layer):void
		{
			
			app.template.layers.addItem( layer );
			
			updateDrawingData();
			
		}	
		
		
		/**
		 * add a layer with a specific type to the layers list
		 */
		public function addLayerWithType( type:String ):void {
			
			Debug.print("[addLayer] adding layer with type: " + type, this );
			
			var newLayer:Layer = LayerFactory.createFromType( type );
			
			
			// get selected layer
			if( Layer(app.layersList.selectedItem) is IGroupLayer ){
				// if a group layer is selected, add it as a child of that layer
				
				// force update
				Layer(app.layersList.selectedItem).children.addItem( newLayer);
				//app.template.layers.addItem( newLayer );
				
			} else {
				
				//app.template.layers.addItem( newLayer );
				app.layersList.dataProvider.addItemAt( newLayer, app.layersList.selectedIndex+1 );
			}
			
			updateDrawingData();
		}
		
		/**
		 * Remove a layer item from the list
		 */
		public function removeLayerDescriptorHandler(e:DescriptorEvent):void {
			
			//layersList.selectedIndex = 0;
			// delete from xml list
			try {
				var itemToRemove:Layer = Layer(app.layersList.selectedItem);
				
				
				Debug.print("Removing Layer | id = " + itemToRemove.id, this);
				
				//Debug.print("Item parent: " + itemToRemove.parent(), this);
				
				app.template.layers.removeItemRecursive( itemToRemove );
				
				
			} catch(e:Error){
				Debug.print("Error removing item!",this);
			}
			
			// select the first layer if any exist
			if( app.layersList.numChildren > 0 )
				app.layersList.selectedIndex = 0;
			
			// update drawing
			updateDrawingData();
		}
		
		/**
		 * create a copy of the selected layer
		 */
		public function duplicateLayer():void {
			// get selected layer
			var selectedLayer:Layer = Layer(app.layersList.selectedItem);
			
			// make a copy
			var newLayer:Layer = Layer(selectedLayer.clone());
			
			// add it to the list after the other layer
			
			app.template.layers.addItem( newLayer );
			//app.layersList.dataDescriptor.addChildAt( selectedLayer.parent(), newLayer, selectedLayer.childIndex()+1, app.layersDescriptor);
		}
		
		
		/*******
		 * STATE FUNCTIONS
		 */
		
		
		
		public function saveState():void {
			
			//trace( XMLList(template.getState()["variables"]).toXMLString() );
			
			app.undoRedo.saveState( app.template.getState() );
		}
		
		public function undo():void {
			
			app.template.setState( app.undoRedo.undo( app.template.getState() ) );
			updateDescriptors();
		}
		
		public function redo():void {
			
			app.template.setState( app.undoRedo.redo( app.template.getState() ) );
			updateDescriptors();
		}
		
		
		public function updateDescriptors():void {
			
			var selectedLayerIndex:int = app.layersList.selectedIndex;
			var selectedVariableIndex:int = app.variablesList.selectedIndex;
			
			//app.layersDescriptor.source = app.template.layersXML;
			
			//EDIT: alex, changed to an object structure instead of XML
			//app.variables.source = app.template.variables;
			
			//app.variablesDescriptor.source = app.template.variablesXML;
			
			//app.infoXML = app.template.info;
			
			if( selectedLayerIndex < app.layersList.numChildren )
				app.layersList.selectedIndex = selectedLayerIndex;
			if( selectedVariableIndex < app.variablesList.numChildren )
				app.variablesList.selectedIndex = selectedVariableIndex;
			
			//updateDrawingData();
		}
		
		
		
		/** 
		 * 
		 * DRAWING FUNCTIONS 
		 * 
		 **/
		
		
		/**
		 * this function combines the values of the variables
		 * with the path data for the current path and makes it
		 * into a valid degrafa path string
		 */
		public function updateDrawingData():void {
			
			// TODO: only prepare the context when we have changes in the context
			
			// let the error console know we are starting a new parsing round
			ParserConsole.startNewParse();
			
			// trace the time it takes to prepare the context
			// DEBUG stuff
			var dStart:Date = new Date();
			var msStart:int = dStart.time;
			
			app.template.prepareContext();
			
			var dEnd:Date = new Date();
			var msEnd:int = dEnd.time;
			
			Debug.print("Time to prepare context: " + (msEnd - msStart) + " ms ", this);
			
			
			var maxBounds:Rectangle = new Rectangle( Number.POSITIVE_INFINITY,Number.POSITIVE_INFINITY,0,0 );
			
			
			
			// refresh the SVG preview if it already exists
			
			if( SVGPreview && app.editorContent.contains( SVGPreview ) )
				app.editorContent.removeChild( SVGPreview );
				//app.removeChild( SVGPreview );
			
			
			// do all kinds of fancy stuff if the SVG string is actually valid
			
			// trace the time it takes to create the SVG
			// DEBUG stuff
			
			//try {
				var dStart2:Date = new Date();
				var msStart2:int = dStart2.time;
				
				
				var SVGXML:XML = app.template.getSVG();
				
				var dEnd2:Date = new Date();
				var msEnd2:int = dEnd2.time;
				
				Debug.print("Time to generate SVG: " + (msEnd2 - msStart2) + " ms ", this);
			/*
			} catch( e:Error ){
				Debug.print("[MagicBox] error creating SVG", this);
				return;
			}*/
			
			
			
			
			
			// feed the parsed data to the SVGRenderer class and actually draw it onto the screen
			try {
				
				// trace the time it takes to render the SVG
				// DEBUG stuff
				var dStart3:Date = new Date();
				var msStart3:int = dStart3.time;
				
				SVGPreview = new SVGRenderer( SVGXML, true );
				
				var dEnd3:Date = new Date();
				var msEnd3:int = dEnd3.time;
				
				Debug.print("Time to render SVG: " + (msEnd3 - msStart3) + " ms ", this);
				
				app.editorContent.addChild( SVGPreview );
				
			} catch (e:Error ){
				Debug.print("[MagicBox] error rendering SVG", this);
				return;
			}
			
			// neatly scale the SVG to fit the screen
			//doFitToScreen();
			
			
			
		}
		
		/** neatly fit the drawing to the screen
		 */
		public function doFitToScreen():void {
			
			/*
			// scale to fit if desired
			if( app.scaleToFit_CB.selected ) {
				
				var scalePadding:Number = 40;
				
				var scaleXRatio:Number = (app.pr.width - 2*scalePadding) / SVGPreview.width;
				var scaleYRatio:Number = (app.pr.height - 2*scalePadding) / SVGPreview.height;
				var scaleRatio:Number = Math.min( 1, Math.min( scaleXRatio, scaleYRatio ) );
				
				SVGPreview.scaleX = SVGPreview.scaleY = scaleRatio;
				
				
				var SVGBounds:Rectangle = SVGPreview.getBounds( app.previewBox );
				
				
				app.previewBox.width = SVGBounds.width;
				app.previewBox.height = SVGBounds.height;
				
				
				SVGPreview.x = -SVGBounds.x;
				SVGPreview.y = -SVGBounds.y;
				
				app.scaleDisplayBox.scaleX = app.scaleDisplayBox.scaleY = scaleRatio;
				
			}
			else {
				
				app.previewBox.percentWidth = 100;
				app.previewBox.percentHeight = 100;
				
				SVGPreview.x = 0;
				SVGPreview.y = 0;
			}*/
		}
		
		/** calculate the drawing up to the current position of the cursor
		 *  and show it with a nice circle
		 * 
		 *  TODO: implement this function with the new parser
		 */
		
		public function doShowCurrentPosition():void {
			//var pathDataBefore:String = editInputWindow.textBeforeCaret;
			
			/*
			var lastPoint:Point = new Point(0,0);
			
			// variables for the path to cursor
			//pathDataBefore = pathUtil.parseParamString(pathDataBefore, context);
			var curPoint:Point = new Point(0,0);
			*/
			
			// get path data up to cursor
			/*
			var caretPos:int = app.layerOptions.pathSelectionBeginIndex;
			var pathDataToCaret:String = (app.layerOptions.data ? String(app.layerOptions.data.@parsedData).substring(0, caretPos) : "");
			*/
			/*
			var parsedPathData:String = '<?xml version="1.0" standalone="no"?>' +
			'<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">' +
			'<svg width="100%" height="100%" version="1.1" xmlns="http://www.w3.org/2000/svg">' + 
			"<path d='M 0 0 " + pathUtil.parseParamString(pathDataToCaret, context) + "'/></svg>";
			
			
			var renderer:SVGRenderer = new SVGRenderer( new XML(parsedPathData) );
			*/
			//var graphicsPath:GraphicsPath = pathRenderer.getGraphicsPath( GraphicsPathWinding.NON_ZERO );
			
			//var graphicsData:Vector.<Number> = graphicsPath.data;
			
			/*
			var actions:Array = renderer.svgObject.children[0].d;
			var isUpperCase:RegExp = /[A-Z]/;
			
			var endPoint:Point = new Point(0,0);
			
			// get the end point of the path data to the current caret position
			for each( var action:Object in actions ) {
			
			var newX:Number = 0;
			var newY:Number = 0;
			
			if( action.args.length > 1 ) {
			newX = action.args[ action.args.length-2 ];
			newY = action.args[ action.args.length-1 ];
			}
			else if( action.type == "H" || action.type == "h" )
			newX = action.args[0];
			else if( action.type == "V" || action.type == "v" )
			newY = action.args[0];
			
			if( String(action.type).match( isUpperCase ) )
			endPoint = new Point( newX, newY );
			else
			endPoint = new Point( endPoint.x + newX, endPoint.y + newY );
			}
			
			//trace( endPoint );
			
			*/
			
			/*
			if( app.currentState == "editor" )
			// show a circle at the end point of the parsed string
			XML( SVGXML.children()[ SVGXML.length() ] ).
			prependChild( XML( '<circle cx="' + endPoint.x + '" cy="' + endPoint.y + '" r="1" stroke="red" stroke-width="1" fill="red"/>' ) );
			*/
		}
		
		
		
		private function updateCaretHandler( e:Event ):void {
			
			updateDrawingData();
		}
		
		
		/**
		 * FILE FUNCTIONS - SAVE & LOAD
		 */
		
		public var loadFileRef:FileReference;
		public var saveFileRef:FileReference;	
		
		
		public const DEFAULT_FILE_NAME:String = "magic_box_template.mbt";
		public var currentFileName:String = DEFAULT_FILE_NAME;
		public var defaultSVGFileName:String = "magic_box_design.svg";
		
		
		
		public function getNewTemplate():void {
			
			Alert.show( "all unsaved data to your current template will be lost.",
				"are you sure you want to create a new template?", 
				( Alert.OK | Alert.CANCEL ), 
				app, newTemplateCloseHandler );
		}
		
		private function newTemplateCloseHandler( e:CloseEvent ):void {
			
			if( e.detail == Alert.OK ) {
				app.template.variables = VariableCollection.getDefault();
				app.template.layers = LayerCollection.getDefault();
				
				
				updateDescriptors();
			}
		}
		
		
		/**
		 * Save to .mbt
		 */
		public function saveAsXMLHandler():void {
			
			saveFileRef = new FileReference();				
			saveFileRef.save( app.template.getXML(), currentFileName );	
		}
		
		
		public function saveAsSVGHandler():void {
			
			// the context object is where the functions will get executed in
			app.template.prepareContext();
			
			var SVGString:String = app.template.getSVG( );
			
			saveFileRef = new FileReference();				
			saveFileRef.save( SVGString, defaultSVGFileName );	
		}
		
		
		/**
		 * XML loading functions
		 */
		
		public function loadXMLHandler():void{
			
			loadFileRef = new FileReference();
			
			// add event listeners for file reference 
			loadFileRef.addEventListener( Event.SELECT, fileSelectHandler, false, 0, true );
			loadFileRef.addEventListener( Event.COMPLETE, fileLoadCompleteHandler, false, 0, true );
			
			// file filter
			var filter:FileFilter = new FileFilter( "magic box templates - .mbt", "*.mbt" );
			
			loadFileRef.browse( [ filter ] );
			
			/*
			var loadFile:File = new File();
			loadFile.browseForOpen("Open Magic Box File",[new FileFilter("Magic Box Templates", "*.mbt")]);
			loadFile.addEventListener(Event.SELECT, fileOpenLoadXML);
			*/
		}
		
		
		private function fileSelectHandler( e:Event ):void {
			
			if( !loadFileRef )
				return;
			
			loadFileRef.load();
		}
		
		private function fileLoadCompleteHandler( e:Event ):void {
			
			Debug.print("file loaded!", this ) ;
			
			
			var xml:XML = new XML(loadFileRef.data);
			
			loadXML(xml);
			
		}
		
		/**
		 * this functions loads the XML from a source (can be local or web)
		 * 
		 * we should probably check if the version we want to load is high enough
		 * 
		 */
		private function loadXML( xml:XML ):void {
			
			Debug.print("loading XML: " + xml);
			
			// get hte variables and the layers in
			//app.variablesXML = xml.variables.variable;
			
			// load variables and layers
			app.template.variables.removeAll();
			app.template.variables.loadXML( xml.variables.variable );
			
			app.template.layers.removeAll();
			app.template.layers.loadXML( xml.layers.children() );
			
			
			//app.layersXML = xml.layers.children();
			
			//if(xml.hasOwnProperty("info"))
			//	app.infoXML = XML(xml.info); 
			app.template.info = XML(xml.info);
			
			
			//if( app.layersDescriptor.length > 0 )
			if( app.template.layers.length > 0 )
				app.layersList.selectedIndex = 0;
			
			// we should give an indication that the xml has updated
			// shouldn't this happen automatically?
			updateDrawingData();
		}
		
		
		//private var readStream:FileStream;
		
		private function onXMLLoadComplete( e:Event ):void {
			
			var loader:URLLoader = e.target as URLLoader;
			if (loader != null)
			{
				var xml:XML = new XML(loader.data);
				Debug.print("Loaded: " + xml.toXMLString(), this);
				
				// load it into the app
				loadXML( xml );
				
			}
			else
			{
				Debug.print("loader is not a URLLoader!", this);
			}
			
		}
		
		/**
		 * IMPORT SVG FUNCTIONS
		 */
		public function doImportSVG():void{
			// get the svg data from the import window
			
			var newLayerXML:XML = app.svgImportWindow.selectedLayer;
			
			if( newLayerXML == null) return;
			
			var mbLayerXML:XML = Template.svgToMagicBoxLayer( newLayerXML );
			// and add it as a new layer in the editor
			addLayer(LayerFactory.createFromSVG(mbLayerXML) );
			
		}
		
			
		
		public function showSVGImportWindow():void {
			
			Debug.print("Importing SVG and showing SVG Window", this );
			app.svgImportWindow.visible = true;
			
		}
		
		
		/**
		 * save file as XML
		 */
		/*
		private function saveToFile(f:File, str:String):void {
		var stream:FileStream = new FileStream();
		
		stream.openAsync(f, FileMode.WRITE);
		stream.addEventListener(IOErrorEvent.IO_ERROR, saveFileError);
		
		
		stream.writeUTFBytes(str);
		stream.close();
		
		}
		*/
		
		
		private function saveFileError(e:IOErrorEvent):void {
			// do an alert here
			trace("[MagicBox] --File Save failed!");
		}
		
		
		private function setBackgroundColor( value:int ):void {
			
			var singleHex:String = value.toString(16);
			singleHex = (singleHex.length == 1) ? "0" + singleHex : singleHex;
			var hex:String = "#" + singleHex + singleHex + singleHex;
			
			app.setStyle( "backgroundColor", hex );
		}
		
		
		
		/**
		 * Singleton Class INFO
		 */
		private static var instance:ApplicationController = new ApplicationController();
		
		
		
		
		public function ApplicationController() {
			if( instance ) throw new Error( "Singleton and can only be accessed through Singleton.getInstance()" );
		}
		
		public static function getInstance():ApplicationController {
			return instance;
		}
		
		


	}
}