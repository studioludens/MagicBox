package com.ludens.PackageHandler.events
{
	import flash.events.Event;
	import mx.events.FlexEvent;

	public class DescriptorEvent extends  FlexEvent
	{
		public static const ADD_NEW:String = "addNew";
		public static const DELETE:String = "delete";
		public static const EDIT:String = "edit";
		
		public var descriptor:XML;
		
		public function DescriptorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}