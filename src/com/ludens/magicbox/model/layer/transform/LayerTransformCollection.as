package com.ludens.magicbox.model.layer.transform
{
	import com.ludens.controllers.ParserController;
	import com.ludens.magicbox.model.DataCollection;
	
	import flash.geom.Matrix;
	
	/**
	 * defines a collection of layer transformations
	 */
	public class LayerTransformCollection extends DataCollection
	{
		public function LayerTransformCollection(source:Array=null)
		{
			super(source);
		}
		
		
		
		public function getSVGText():String {
			
			var transforms:Array = new Array;
			
			
			for each( var transform:LayerTransform in this ){
				
				// get type
				var type:String = transform.type;
				
				if(type == 'translate'){
					// a simple translation instruction
					// parse x and y values
					transforms.push( "translate(" 
						+ transform.getParsedAttribute("x")
						+ "," 
						+ transform.getParsedAttribute("y")
						+ ")" );
				}
				
				if(type == 'rotate'){
					// a simple translation instruction
					// parse x and y values
					transforms.push( "rotate(" 
						+ transform.getParsedAttribute("angle")
						+ "," 
						+ transform.getParsedAttribute("cx")
						+ "," 
						+ transform.getParsedAttribute("cy")
						+ ")" );
				}
				
				if(type == 'scale'){
					// a simple translation instruction
					// parse x and y values
					transforms.push( "scale(" 
						+ transform.getParsedAttribute("sx")
						+ "," 
						+ transform.getParsedAttribute("sy")
						+ ")" );
				}
				
				// parse based on type
				
			}
			
			return transforms.join(" ");
		}
	
		/**
		 * convert this collection to a transformation matrix
		 */
		public function getMatrix():Matrix {
			
			var matrix:Matrix = new Matrix;
			
			for each( var transform:LayerTransform in this ){
				matrix.concat( transform.getMatrix() );
			}
			
			return matrix;
			
		}
	}
}