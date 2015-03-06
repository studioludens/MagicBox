package com.ludens.magicbox.model.layer
{
	import com.ludens.PackageHandler.view.layeroptions.LayerDisplaySettings;
	import com.ludens.magicbox.model.LayerFactory;
	import com.ludens.magicbox.parser.LanguageParser;
	import com.ludens.magicbox.parser.ParserContext;
	import com.ludens.utils.BooleanUtil;
	import com.ludens.utils.Debug;
	
	/**
	 * this layer implements an svg path layer
	 */
	public class PathLayer extends Layer
	{
		
		
		
		
		public function PathLayer(xml:XML=null)
		{
			super(xml);
		}
		
		/**
		 * Public properties
		 */
		
		
		
		/**
		 * Interface functions
		 */
		override public function get iconClass():Class {
			// TODO: return default class
			return LayerFactory.PathIcon;
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
				showData:		true
			});
		}
		
		
		override public function getSVG( ):XML {
			
			
			var recomputed:Boolean = false;
			
			if( _svgDirty){
				
				parseSVG();
				parseSVGTransforms();
				parseSVGAttributes();
				
				/** HACK: add m 0 0 to the data layer because illustrator chokes if it's not there **/
				_svg['@d'] = "m 0 0" + _svg['@d'];
				
				_svgDirty = false;
				recomputed = true;
			}
			
			//Debug.print("getSVG :" + _svg.toXMLString() + " dirty = " + recomputed, this );
			
			return _svg;
		}
		
		
		/**
		 * convert this Layer to serializable XML format
		 * 
		 * - for storing on disk
		 */
		public override function toXML():XML {
			var ret:XML = super.toXML();
			ret.@mb_d = d;
			
			
			return ret;
		}
		
		/**
		 * override the parseAttributes to do some checking for old versions
		 */
		protected override function createAttributes():void {
			super.createAttributes();
			
			// create static Data attribute if it doesn't exist
			if( !this.hasAttribute( "mb__staticData" ) ){
				this.setAttribute("mb__staticData","false");
			}
		}
		
		
		
	}
}