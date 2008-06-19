package com.events 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import flash.events.Event;

	public class LogoutEvent extends CairngormEvent
	{
		public static const EVENT_LOGOUT:String = "EVENT_LOGOUT";
		
		public function LogoutEvent() 
		{
			super(EVENT_LOGOUT);
		}
		
		override public function clone():Event {
            return new LogoutEvent();
        }

	}	
}