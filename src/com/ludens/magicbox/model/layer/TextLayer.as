package com.ludens.magicbox.model.layer
{
	import com.ludens.PackageHandler.view.layeroptions.LayerDisplaySettings;
	import com.ludens.controllers.ParserController;
	import com.ludens.magicbox.parser.LanguageParser;
	import com.ludens.magicbox.parser.ParserContext;
	import com.ludens.utils.BooleanUtil;
	
	[Bindable]
	public class TextLayer extends Layer
	{
		
		
		
		
		public function TextLayer(xml:XML=null)
		{
			super(xml);
		}
		
		/**
		 * the default values for showing different items of the layeroptions
		 * palette
		 */
		override public function get displayDefaults():LayerDisplaySettings {
			return new LayerDisplaySettings({ 	
				showTransforms: true,
				showPosition:	true,
				showText:		true,
				showTextEditor:	true
			});
		}
		
		override public function getSVG():XML {
			if( _svgDirty){
				parseSVG();
				parseSVGAttributes();
				//createSVGChildren( context, parser );
				parseSVGText();
				parseSVGTransforms();
				
				_svgDirty = false;
			}
			
			return _svg;
		}
		
		protected function parseSVGText():void {
			
			// parse text content - only for text layers
			var textContent:String = _xml.@mb__text;
			
			/** special case: text contents of a text layer
			 * 	this needs to be parsed separately because SVG does not support multi-line
			 *  text, and we want to! 
			 *  we create a tspan element for each line of text and place it in the right position
			 */
			
			if(textContent){
				
				// remove previous text content
				var textElements:XMLList = _svg.tspan;
				for(var j:int = 0; j < textElements.length(); j++){
					delete textElements[j];
				}
				
				//split each line
				var textArray:Array = textContent.split('\r');
				var fontSize:Number = Number(_svg.child("@font-size"));
				
				var xPos:String = _svg.@x;
				
				for( var i:int = 0; i < textArray.length; i++){
					// create a tspan element for each item
					var parsedText:String = ParserController.parseText(textArray[i]);
					var span:XML = new XML('<tspan x="' + xPos + '" dy="' + ( i * fontSize ) + '">' + parsedText + '</tspan>');
					_svg.appendChild( span );
				}
			}
		}
		
		
	}
}