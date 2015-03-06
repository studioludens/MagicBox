package com.ludens.magicbox.model.variable
{
	import com.ludens.magicbox.model.DataObject;
	import com.ludens.utils.BooleanUtil;

	/**
	 * this is the value object for an interface variable
	 */
	[Bindable]
	public class Variable extends DataObject
	{
		/**
		 * the name of the variable
		 */
		public function get name():String 				{	return getProperty("name");	}
		public function set name( value:String ):void	{	setProperty("name", value); }
		
		/**
		 * the title (description) of the variable
		 */
		public function get title():String 				{	return getProperty("title"); }
		public function set title( value:String ):void	{	setProperty("title", value); }
		
		/**
		 * the minimum value of the variable
		 */
		public function get min():Number 				{	return Number(getProperty("min"));	}
		public function set min( value:Number ):void	{	setProperty("min", value); 			}
		
		/**
		 * the maximum value of the variable
		 */
		public function get max():Number 				{	return Number(getProperty("max"));	}
		public function set max( value:Number ):void	{	setProperty("max", value); 			}
		
		/**
		 * the value of the variable
		 */
		public function get value():* 				{	return getProperty("value"); }
		public function set value( value:* ):void	{	setProperty("value", value); }
		
		/**
		 * the type of the variable
		 */
		public function get type():String 				{	return getProperty("type"); }
		public function set type( value:String ):void	{	setProperty("type", value); }
		
		/**
		 * description of the variable
		 */
		public function get description():String 				{	return getProperty("description"); }
		public function set description( value:String ):void	{	setProperty("description", value); }
		
		/**
		 * if the settings will be shown in the variable list
		 */
		public function get showSettings():Boolean 				{	return BooleanUtil.stringToBoolean(getProperty("showSettings")); }
		public function set showSettings( value:Boolean ):void	{	setProperty("showSettings", BooleanUtil.booleanToString(value)); }
		
		/**
		 * static constants
		 */
		public static const TYPE_EXPRESSION:String 		= "expression";
		public static const TYPE_SLIDER:String 			= "slider";
		public static const TYPE_STEPPER:String 		= "stepper";
		public static const TYPE_TEXT:String 			= "text";
		public static const TYPE_LIST:String 			= "list";
		
		
		
		public function Variable(name:String, type:String, value:* = 0, min:Number = 0, max:Number = 0, title:String = null, description:String = null)
		{
			this.objectType = "variable";
			this.name = name;
			this.type = type;
			this.value = value;
			this.min = min;
			this.max = max;
			this.title = title;
			this.description = description;
			this.showSettings = false;
			
		}
		
		/**
		 * Factory function
		 */
		public static function fromXML( xml:XML ):Variable {
			var v:Variable = new Variable("","");
			v.loadXML( xml );
			return v;
		}
		
		public override function toXML():XML {
			var ret:XML = super.toXML();
			ret.@name = name;
			ret.@type = type;
			ret.@value = String(value);
			ret.@min = String(min);
			ret.@max = String(max);
			ret.@title = title;
			ret.@showSettings = BooleanUtil.booleanToString( showSettings );
			ret.@description = description;
			
			return ret;
		}
		
		
	}
}