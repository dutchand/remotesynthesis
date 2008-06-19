package com.events 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import flash.events.Event;

	public class VerifyTokenEvent extends CairngormEvent
	{
		public static const EVENT_VERIFY_TOKEN:String = "EVENT_VERIFY_TOKEN";
		
		
		public function VerifyTokenEvent() 
		{
			super(EVENT_VERIFY_TOKEN);
		}
		
		override public function clone():Event {
            return new VerifyTokenEvent();
        }

	}	
}