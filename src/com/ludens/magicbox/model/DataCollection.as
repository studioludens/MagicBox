package com.ludens.magicbox.model
{
	import com.ludens.utils.ArrayCollectionUtil;
	
	import mx.collections.ArrayCollection;
	
	public class DataCollection extends ArrayCollection
	{
		public function DataCollection(source:Array=null)
		{
			super(source);
		}
		
		/**
		 * get an item by the default property: id
		 * 
		 * if no item has been founds, null will be returned
		 * 
		 */
		public function get( id:String ):DataObject {
			return getItemById( id );
		}
		
		/**
		 * get an item by the default property: id
		 * 
		 * if no item has been founds, null will be returned
		 * 
		 */
		public function getItemById( id:String ):DataObject {
			return getItemByProperty( "id", id );
		}
		
		/**
		 * get the first item with the specified property value
		 */
		public function getItemByProperty( propertyName:String, propertyValue:* ):DataObject {
			return ArrayCollectionUtil.getItemByProperty( this, propertyName, propertyValue ) as DataObject;
			
		}
		
		/**
		 * get all items that have the same type
		 */
		public function getAll( type:String ):DataCollection {
			// loop through the children
			
			var allItems:DataCollection = new DataCollection;
			
			
			// get all children with the same type recursively
			for each( var item:DataObject in source ){
				//var item:EPDataObject = this.source[item];
				if( item.objectType == type ) allItems.addItem( item );
			}
			
			return allItems;
		}
		
		/**
		 * add an item only if it does not exist already
		 */
		public function addUniqueItem( item:Object ):void {
			for each( var i:Object in source ){
				if( item == i ) return;
			}
			// if we're here, the item is not already in the collection, so add it
			addItem( item );
		}
		
		/**
		 * add items that do not already exist in the collection
		 */
		public function addUniqueAll( items:Object ):void {
			for each( var item:Object in items ){
				addUniqueItem( item );
			}
		}
		
		/**
		 * checks if the collection contains an item with a specific id
		 */
		public function containsId( id:String ):Boolean {
			for each( var i:DataObject in source ){
				if( i.id == id ) return true;
			}
			return false;
		}
		
		/**
		 * remove all items from the list that match the item object
		 * 
		 * TODO: test this function. will it still work with more items being removed?
		 */
		public function removeItem( item:Object ):void {
			for( var i:int = 0; i < length; i++){
				if( this.getItemAt( i ) == item ){
					// remove item
					this.removeItemAt( i );
				}
			}
		}
		
		
		
		/**
		 * used by the unique property
		 * removes all duplicate elements from the source array
		 */
		public function removeDuplicates():void {
			
			var newArray:Array = source.filter( function( e:Object, i:int, a:Array ):Boolean {
				return a.indexOf(e) == i;
			},source);
			
			this.source = newArray;
		}
		
		/**
		 * override the toString property
		 * will give a list of all id's of items in the data collection
		 * 
		 * like so: (5, 8, 30)
		 */
		public override function toString():String {
			var ret:String = "(";
			
			for each( var item:Object in this ){
				ret += (item as DataObject).id + ", ";
				
			}
			
			// replace the last 2 characters with )
			if( length > 0)
				ret = ret.slice(0, ret.length-2);
			
			ret += ")";
			
			return ret;
		}
		
		/**
		 * return this list as a simple xml list
		 * 
		 * 
		 */
		public function get xml( ):XMLList {
			
			var ret:XMLList = new XMLList();
			
			for each( var item:DataObject in this ){
				ret += item.toXML();
			}
			
			return ret;
		}
		
		/**
		 * loads XML into objects
		 */
		public function loadXML( xml:XMLList ):DataCollection {
			// TODO: implement this function
			
			trace("[DataCollection.loadXML] function not implemented!");
			return this;
		}
		
		/**
		 * clone function
		 */
		public function clone():DataCollection {
			var dc:DataCollection = new DataCollection;
			
			for each( var item:DataObject in this ){
				dc.addItem( item.clone() );
			}
			
			return dc;
			
		}
		
	}
}