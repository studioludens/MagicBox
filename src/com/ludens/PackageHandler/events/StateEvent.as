package com.ludens.PackageHandler.events
{
	import flash.events.Event;
	
	public class StateEvent extends Event
	{
		public static const REQUEST_SAVE:String = "requestSave";
		public static const REQUEST_LOAD:String = "requestLoad";
		
		public function StateEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}