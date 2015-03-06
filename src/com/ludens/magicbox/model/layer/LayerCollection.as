package com.ludens.magicbox.model.layer
{
	import com.ludens.magicbox.model.DataCollection;
	import com.ludens.magicbox.model.LayerFactory;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * this class describes a collection of layers
	 */
	public class LayerCollection extends DataCollection
	{
		public function LayerCollection(source:Array=null)
		{
			super(source);
		}
		
		/**
		 * load an xml object into this layer collection
		 */
		public override function loadXML( xml:XMLList ):DataCollection {
			
			for each( var item:XML in xml ){
				// create new items
				
				// new object
				
				this.addItem( LayerFactory.createFromXML( item ) );
			}
			
			return this;
			
		}
		
		public function removeItemRecursive( item:Layer ):void {
			for( var i:int = 0; i < length; i++){
				if( getItemAt( i ) == item ){
					// remove item
					removeItemAt( i );
				} else {
					// check the item's children
					Layer(getItemAt( i )).children.removeItemRecursive( item );
				}
			}
		}
		
		/**
		 * the default layer
		 * 
		 * is just an simple path layer
		 */
		public static function getDefault( ):LayerCollection {
			var c:LayerCollection = new LayerCollection;
			
			var layer1:Layer = LayerFactory.createFromType("path");
			
			c.addItem( layer1 );
			return c;
			
		}
		
		/**
		 * return this list as a simple xml list
		 * 
		 * 
		 */
		public override function get xml( ):XMLList {
			
			var ret:XMLList = new XMLList();
			
			for each( var item:Layer in this ){
				ret += item.toXML();
			}
			
			return ret;
		}
		
		
		
	}
}