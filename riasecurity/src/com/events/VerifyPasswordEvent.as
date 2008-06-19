package com.events 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import flash.events.Event;

	public class VerifyPasswordEvent extends CairngormEvent
	{
		public static const EVENT_VERIFY_PASSWORD:String = "EVENT_VERIFY_PASSWORD";
		
		public var email : String;
		public var password : String;
		
		public function VerifyPasswordEvent(email:String=null,password:String=null) 
		{
			super(EVENT_VERIFY_PASSWORD);
			
			this.email = email;
			this.password = password;
			
		}
		
		override public function clone():Event {
            return new VerifyPasswordEvent();
        }

	}	
}