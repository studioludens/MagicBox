package com.ludens.magicbox.model.layer
{
	import com.ludens.magicbox.parser.ParserContext;
	import com.ludens.magicbox.parser.LanguageParser;

	public class PolygonLayer extends Layer
	{
		public function PolygonLayer(xml:XML=null)
		{
			super(xml);
		}
		
		override public function getSVG( ):XML {
			if( _xmlDirty){
				createSVG( );
				createSVGAttributes( );
				createSVGTransforms( );
				
				_xmlDirty = false;
			}
			
			return _svg;
		}
	}
}