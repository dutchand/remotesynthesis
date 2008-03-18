package com.events 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import flash.events.Event;

	public class GetClassesEvent extends CairngormEvent 
	{
		public static const EVENT_GET_CLASSES : String = "EVENT_GET_CLASSES";
		
		public function GetClassesEvent() 
		{
			super(EVENT_GET_CLASSES);
		}
		override public function clone():Event {
            return new GetClassesEvent();
        }
	}	
}