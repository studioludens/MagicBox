package com.ludens.magicbox.model.layer
{
	import com.ludens.PackageHandler.view.layeroptions.LayerDisplaySettings;
	import com.ludens.utils.ClipUtil;
	import com.ludens.utils.SVGPolyUtil;


	/**
	 * this type of layer implements 2D boolean functionality
	 * 
	 * WARNING: currently uses the GPCAS library which is only free for
	 * non-commercial projects!!!
	 * 
	 */
	[Bindable]
	public class BooleanLayer extends Layer implements IGroupLayer
	{
		
		/**
		 * type of boolean. can be
		 * 
		 * union
		 * subtract
		 * subtract
		 * xor
		 * 
		 * 
		 */
		public function get booleanType():String 							{	return getAttribute( 'mb__booleanType' ); }
		public function set booleanType( value:String ):void				{	setAttribute('mb__booleanType', value);   }
		
		
		public function BooleanLayer(xml:XML=null)
		{
			super(xml);
			
			_poly = new Array;
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
				showBoolean:	true
			});
		}
		
		/**
		 * we override the getSVG function to combine the polygons of the child layers
		 */
		
		
		protected override function parseSVG():void {
			
			// the return string
			_svg = <path/>;
			
			// give it an id if it has one
			_svg['@id'] = id;
		}
		
		private var _poly:Array;
		
		public override function get poly():Array {
			
			var polys:Array = new Array;
			/**
			 * child layers
			 */
			for( var k:int = 0; k < _children.length; k++){
				
				// we get the polygons of this specific child as an array
				var childPolys:Array = ClipUtil.arrayToPolys(Layer(_children[k]).poly);
				
				// add them to the list
				if( childPolys ) polys = polys.concat( childPolys );
			}
			
			// do a clipping operation
			return ClipUtil.clip( booleanType, polys );
			
		}
		
		
		protected override function parseSVGChildren( ):void {
			
			
			// and return the result, create an SVG path data from it
			var ret:String = SVGPolyUtil.polysToPath( poly );
			
			_svg['@d'] = ret;
		}
		
		
		
		
		private function getPathData():String {
			
			// get all of the polygons
			
			
			return "";
			
		}
	}
}