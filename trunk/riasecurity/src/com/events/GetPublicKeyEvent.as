package com.events 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import flash.events.Event;

	public class GetPublicKeyEvent extends CairngormEvent
	{
		public static const EVENT_GET_KEY:String = "EVENT_GET_KEY";
		
		public function GetPublicKeyEvent() 
		{
			super(EVENT_GET_KEY);
		}
		override public function clone():Event {
            return new GetPublicKeyEvent();
        }

	}	
}