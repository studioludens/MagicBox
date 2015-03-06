package com.ludens.magicbox.model.layer
{

	public class CircleLayer extends Layer
	{
		public function CircleLayer(xml:XML=null)
		{
			super(xml);
		}
		
		override public function getSVG( context:ParserContext, parser:LanguageParser ):XML {
			if( _xmlDirty){
				createSVG( context, parser );
				createSVGAttributes( context, parser );
				createSVGTransforms( context, parser );
				
				_xmlDirty = false;
			}
			
			return _svg;
		}
	}
}