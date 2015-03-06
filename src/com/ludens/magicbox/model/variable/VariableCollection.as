package com.ludens.magicbox.model.variable
{
	import com.ludens.magicbox.model.DataCollection;
	import com.ludens.magicbox.model.DataObject;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * a collection of variables
	 */
	public class VariableCollection extends DataCollection
	{
		public function VariableCollection(source:Array=null)
		{
			super(source);
		}
		
		public function get variableNames():Array {
			var ret:Array = new Array;
			
			for each( var variable:DataObject in this ){
				ret.push( Variable(variable).name );
			}
			
			return ret;
		}
		
		
		public override function loadXML( xml:XMLList ):DataCollection {
			
			for each( var item:XML in xml ){
				// create new items
				
				// new object
				
				this.addItem( Variable.fromXML( item ) );
			}
			
			return this;
			
		}
		
		/**
		 * the default variables
		 */
		public static function getDefault( ):VariableCollection {
			var c:VariableCollection = new VariableCollection;
			
			var var1:Variable = new Variable("width", "slider", 100, 10, 700 );
			var var2:Variable = new Variable("height", "slider", 100, 10, 700 );
			
			c.addItem( var1 );
			c.addItem( var2 );
			
			return c;
			
		}
		
		
	}
}