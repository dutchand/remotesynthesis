package com.events 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import flash.events.Event;

	public class GetTypesEvent extends CairngormEvent 
	{
		
		public static const EVENT_GET_TYPES : String = "EVENT_GET_TYPES";
		
		public function GetTypesEvent() 
		{
			super(EVENT_GET_TYPES);
		}
		override public function clone():Event {
            return new GetTypesEvent();
        }
	}	
}