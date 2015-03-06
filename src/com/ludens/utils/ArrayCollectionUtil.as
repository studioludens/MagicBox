package com.ludens.utils
{
	import mx.collections.ArrayCollection;

	public class ArrayCollectionUtil
	{
		/**
		 * find the index of the first item in the arraycollection that matches the property value
		 * and return it.
		 * 
		 * @returns -1 if no element is found
		 */
		public static function getItemIndexByProperty(array:ArrayCollection, property:String, value:String):Number
		{
			for (var i:Number = 0; i < array.length; i++)
			{
				var obj:Object = Object(array[i]);
				if (obj[property] == value)
					return i;
			}
			return -1;
		}
		
		/**
		 * find the first item in the arraycollection that matches the property value
		 * and return it.
		 * 
		 * @returns null if no element is found
		 */
		public static function getItemByProperty(array:ArrayCollection, property:String, value:String):Object
		{ 
			for (var i:Number = 0; i < array.length; i++)
			{
				var obj:Object = Object(array[i]);
				if (obj[property] == value)
					return obj;
			}
			return null;
		}
	}
}