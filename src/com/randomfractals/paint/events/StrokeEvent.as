package com.randomfractals.paint.events
{
	import flash.events.Event;

	public class StrokeEvent extends Event
	{
		public static const STROKE_CHANGE:String = "strokeChange";
		public static const LINE_CAP_CHANGE:String = "lineCapChange";
		public static const LINE_JOIN_CHANGE:String = "lineJoinChange";
		
		public function StrokeEvent(type:String) 
		{
      super(type, true);
    }

    override public function clone():Event 
    {
        return new StrokeEvent(type);
    }
	}
}