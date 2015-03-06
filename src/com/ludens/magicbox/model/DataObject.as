package com.ludens.magicbox.model
{
	import com.ludens.utils.Debug;
	
	import flash.events.EventDispatcher;
	
	import mx.utils.ObjectUtil;

	/**
	 * a generic data object that has functionality for exporting to XML and binding
	 */
	[Bindable]
	public class DataObject extends EventDispatcher
	{
		/**
		 * the (unique) id of the object
		 */
		public var id:String;
		
		/**
		 * dynamic value object class to hold the properties
		 */
		protected var VO:Object = {};
		
		
		/**
		 * dynamic value object to hold the primary property
		 * <item>propertyValue<item>
		 */
		public var content:String;
		
		/**
		 * the type of XML node this data object is derived from.
		 * can be used to dynamically create objects
		 */
		public var objectType:String;
		
		
		public function DataObject(id:String = null)
		{
			this.id = id;
		}
		
		//--------------------------------------
		//  PUBLIC Methods
		//--------------------------------------
		
		/**
		 * set a property of the value object
		 */
		public function setProperty( propertyName:String, propertyValue:Object ):void {
			VO[propertyName] = propertyValue;
			
			// TODO: probably do some event throwing here
		}
		
		/**
		 * get a specific property of the value object
		 */
		public function getProperty( propertyName:String ):* {
			return VO[propertyName];
		}
		
		/**
		 * see if a property has been set and has a value
		 */
		public function isPropertySet( propertyName:String ):Boolean {
			if( VO[propertyName] && String( VO[propertyName] ).length > 0 ) return true;
			else return false;
		}
		
		
		/**
		 * get the value object directly
		 * @private
		 */
		public function getVO():Object {
			return VO;
		}
		
		
		/**
		 * load a value object directly (makes a copy of the object)
		 **/
		public function loadVO(vo:Object):Object {
			// make a copy of the vo object and put it in the local VO
			VO = ObjectUtil.copy( vo );
			
			return this;
		}
		
		/**
		 * load an XML object
		 * - attributes will be properties of the Value Object
		 * - children will be stored in the childrenVO List
		 */
		public function loadXML( xml:XML ):DataObject {
			// check each property of the object
			
			for each( var attribute:XML in xml.attributes() ){
				//Debug.print("loadXML attribute: " + attribute.name() + " = " + attribute.valueOf(), this );
				VO[attribute.name().toString()] = attribute.valueOf();
			}
			
			// get the text value
			content = xml.text();
			objectType = xml.localName();
			id = getProperty('id');
			
			
			return this;
			
		}
		
		/**
		 * returns the item as a XML object
		 */
		public function toXML():XML {
			
			var ret:XML;
			
			if( this.id != null ){
				ret = new XML('<' + this.objectType + ' id="' + this.id + '"/>');
			} else {
				ret = new XML('<' + this.objectType + '/>');
			}
			
			// TODO: add all the properties
			return ret;
		}
		
		/**
		 * clone function
		 */
		public function clone():DataObject {
			return ObjectUtil.clone( this ) as DataObject;
			
		}
	}
}