package com.ludens.magicbox.model.layer.transform
{
	import com.lorentz.SVG.MatrixTransformer;
	import com.ludens.magicbox.model.DataObject;
	import com.ludens.magicbox.model.LayerAttribute;
	import com.ludens.magicbox.model.layer.Layer;
	
	import flash.geom.Matrix;

	/**
	 * describes a layer transformation
	 * 
	 * this is a layer itself, but shouldn't be seen as a full 'worthy' layer (i.e. removed from any view that shows a layer overview
	 * 
	 */
	[Bindable]
	public class LayerTransform extends Layer
	{
		/**
		 * transformation type
		 * 
		 * can be
		 * - translate
		 * - rotate
		 * - scale
		 * - matrix
		 * - skewx
		 * - skewy
		 */
		public function get type():String 									{	return getAttribute( 'type' ); }
		public function set type( value:String ):void						{	setAttribute('type', value); }
		
		/**
		 * angle
		 */
		public function get angle():String 									{	return getAttribute( 'angle' ); }
		public function set angle( value:String ):void						{	setAttribute('angle', value); }
		
		public function get cx():String 									{	return getAttribute( 'cx' ); }
		public function set cx( value:String ):void							{	setAttribute('cx', value); }
		
		public function get cy():String 									{	return getAttribute( 'cy' ); }
		public function set cy( value:String ):void							{	setAttribute('cy', value); }
		
		public function get sx():String 									{	return getAttribute( 'sx' ); }
		public function set sx( value:String ):void							{	setAttribute('sx', value); }
		
		public function get sy():String 									{	return getAttribute( 'sy' ); }
		public function set sy( value:String ):void							{	setAttribute('sy', value); }
		
		public override function get x():String 							{	return getAttribute( 'x' ); }
		public override function set x( value:String ):void					{	setAttribute('x', value); }
		
		public override function get y():String 							{	return getAttribute( 'y' ); }
		public override function set y( value:String ):void					{	setAttribute('y', value); }
		
		public function get skewX():String 									{	return getAttribute( 'angle' ); }
		public function set skewX( value:String ):void						{	setAttribute('angle', value); }
		
		public function get skewY():String 									{	return getAttribute( 'angle' ); }
		public function set skewY( value:String ):void						{	setAttribute('angle', value); }
		
		
		public function LayerTransform( xml:XML )
		{
			super(xml);
		}
		
		public override function getParsedAttribute(attributeName:String):String {
			var attr:String = super.getParsedAttribute( attributeName );
			if( attr && attr.length > 0 ) return attr;
			else return "0";
		}
		
		/**
		 * return a parsed attribute as a number
		 */
		public function attr( attributeName:String ):Number {
			return Number( getParsedAttribute( attributeName ) );
		}
		
		/** parse all the attributes of the layer
		 */
		protected override function createAttributes():void {
			
			for each( var attribute:XML in _xml.attributes()){
				
				// check if the attribute already exists
				var attributeName:String = attribute.name();
				
				var attr:LayerAttribute = new LayerAttribute( attribute.name(), attribute.valueOf() );
				attr.parseType = LayerAttribute.PARSE_AS_EXPRESSION;
				
				_attributes.addItem( attr ) ;
			}
		}
		
		/**
		 * returns a transformation matrix for this transformation
		 */
		
		public function getMatrix():Matrix
		{
			var m:Matrix = new Matrix;
			switch( type ) {
				case 'translate':
					m.translate( attr('x'), attr('y') );
					break;
				case 'rotate':
					MatrixTransformer.rotateAroundInternalPoint( m, attr('cx'), attr('cy'), attr('angle') );
					break;
				case 'scale':
					// check if the sy value is 0, if so, just use the sx value twice
					if( attr('sy') == 0 )
						m.scale( attr('sx'), attr('sx') );
					else
						m.scale( attr('sx'), attr('sy') );
					break;
				case 'matrix':
					m.a = attr('a');
					m.b = attr('b');
					m.c = attr('c');
					m.d = attr('d');
					m.tx = attr('e');
					m.ty = attr('f');
					break;
				case 'skewx':
					MatrixTransformer.setSkewX( m, attr('angle') );
					break;
				case 'skewy':
					MatrixTransformer.setSkewX( m, attr('angle') );
					break;
				default:
					return m;
			}
			
			return m;
		}
	}
}