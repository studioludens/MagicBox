package com.ludens.PackageHandler.events
{
	import flash.events.Event;
	
	public class ValueChangeEvent extends Event
	{
		public static const CHANGE_VALUE:String = "changeValue";
		
		public function ValueChangeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}