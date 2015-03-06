package com.ludens.magicbox.model.layer
{
	import com.ludens.PackageHandler.view.layeroptions.LayerDisplaySettings;
	import com.ludens.magicbox.model.LayerFactory;
	import com.ludens.magicbox.parser.LanguageParser;
	import com.ludens.magicbox.parser.ParserContext;
	
	public class RectLayer extends Layer
	{
		
		
		
		public function RectLayer(xml:XML=null)
		{
			super(xml);
		}
		
		/**
		 * Interface functions
		 */
		override public function get iconClass():Class {
			// TODO: return default class
			return LayerFactory.RectIcon;
		}
		
		/**
		 * the default values for showing different items of the layeroptions
		 * palette
		 */
		override public function get displayDefaults():LayerDisplaySettings {
			return new LayerDisplaySettings({ 	
				showTransforms: true,
				showStroke:		true,
				showFill:		true,
				showPosition:	true,
				showSize:		true
			});
		}
		
		/**
		 * override the poly function
		 * 
		 * to get the dimensions of the rectangle
		 */
		override public function get poly():Array {
			
			var _poly:Array = new Array;
			
			var x:Number 		= getParsedAttributeNumber('mb_x');
			var y:Number 		= getParsedAttributeNumber('mb_y');
			var width:Number 	= getParsedAttributeNumber('mb_width');
			var height:Number 	= getParsedAttributeNumber('mb_height');
			
			_poly.push( [x, y] );
			_poly.push( [width+x, y ] );
			_poly.push( [width+x, height+y ] );
			_poly.push( [x, height+y] );
			
			return [_poly];
		}

	}
}