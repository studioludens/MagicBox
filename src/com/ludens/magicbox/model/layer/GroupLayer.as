package com.ludens.magicbox.model.layer
{
	import com.ludens.PackageHandler.view.layeroptions.LayerDisplaySettings;
	import com.ludens.magicbox.model.LayerFactory;
	import com.ludens.magicbox.parser.LanguageParser;
	import com.ludens.magicbox.parser.ParserContext;

	public class GroupLayer extends Layer implements IGroupLayer
	{
		
		public function GroupLayer(xml:XML=null)
		{
			super(xml);
		}
		
		/**
		 * Interface functions
		 */
		override public function get iconClass():Class {
			// TODO: return default class
			return LayerFactory.GroupIcon;
		}
		
		/**
		 * the default values for showing different items of the layeroptions
		 * palette
		 */
		override public function get displayDefaults():LayerDisplaySettings {
			return new LayerDisplaySettings({ 	
				showTransforms: true,
				showStroke:		true,
				showFill:		true
			});
		}
		
		override public function getSVG():XML {
			if( _svgDirty){
				parseSVG();
				parseSVGAttributes();
				parseSVGTransforms();
				parseSVGChildren();
				
				// get all svg for the child layers
				
				
				_svgDirty = false;
			}
			
			return _svg;
		}
		
		override public function get poly():Array
		{
			var polys:Array = new Array;
			/**
			 * child layers
			 */
			for( var k:int = 0; k < _children.length; k++){
				
				// we get the polygons of this specific child as an array
				var childPolys:Array = Layer(_children[k]).poly;
				
				// add them to the list
				if( childPolys ) polys = polys.concat( childPolys );
			}
			
			return polys;
		}
		
		
	}
}