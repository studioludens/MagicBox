package com.ludens.PackageHandler.events
{
	import flash.events.Event;
	
	public class PathSelectionEvent extends Event
	{
		public static const CARET_CHANGED:String = "caretChanged";
		
		public function PathSelectionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}