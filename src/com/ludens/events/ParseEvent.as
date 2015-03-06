package com.ludens.events
{
	import flash.events.Event;
	
	/**
	 * you can dispatch this event when you
	 * - update the context: use the CONTEXT_UPDATED
	 */
	public class ParseEvent extends Event
	{
		public static const CONTEXT_UPDATED:String = "contextUpdated";
		
		public function ParseEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}